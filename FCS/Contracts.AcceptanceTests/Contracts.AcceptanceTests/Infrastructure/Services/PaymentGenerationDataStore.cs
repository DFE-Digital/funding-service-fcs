namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Services
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Data;
    using System.Data.SqlClient;
    using System.Linq;
    using DTO.PaymentGeneration;
    using MoreLinq;
    using PaymentGenerationDomain.Integration.DataStore;
    using PaymentGenerationDomain.Integration.DataStore.Model;

    public static class PaymentGenerationDataStore
    {
        private const string CalendarMonthPeriodTypeCode = "CM";
        
        public static DTO.PaymentGeneration.PaymentTimetable GetPaymentTimetable(FundingStreamPeriodCalendarPeriod fspCalendarPeriod)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                return
                    context.PaymentTimetables.Where(
                        x => x.FundingStreamPeriodCode == fspCalendarPeriod.FundingStreamPeriodCode
                             && x.CalendarPeriod == fspCalendarPeriod.CalendarPeriod)
                        .Select(x => new DTO.PaymentGeneration.PaymentTimetable
                        {
                            CalendarPeriod = x.CalendarPeriod,
                            FundingStreamPeriodCode = x.FundingStreamPeriodCode,
                            CalendarPeriodType = x.CalendarPeriodType,
                            CensusEndDate = x.CensusEndDate,
                            FinancialPeriod = x.FinancialPeriod,
                            FinancialPeriodType = x.FinancialPeriodType,
                            PaymentDueDate = x.PaymentDueDate,
                            PeriodStartDate = x.PeriodStartDate,
                            PeriodEndDate = x.PeriodEndDate,
                            LinkCodeSuffix = x.LinkCodeSuffix,
                            Status = x.Status
                        }).SingleOrDefault();
            }
        }

        public static bool UpdatePaymentTimetable(FundingStreamPeriodCalendarPeriod fspCalendarPeriod, string linkCodeSuffix, string status)
        {
            return UpdatePaymentTimetable(fspCalendarPeriod, linkCodeSuffix, status, null);
        }

        public static bool UpdatePaymentTimetable(FundingStreamPeriodCalendarPeriod fspCalendarPeriod, string linkCodeSuffix, string status, DateTime? censusEndDate)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                var timetable = context.PaymentTimetables.SingleOrDefault(
                    x => x.FundingStreamPeriodCode == fspCalendarPeriod.FundingStreamPeriodCode
                         && x.CalendarPeriod == fspCalendarPeriod.CalendarPeriod);

                if (timetable == null) return false;

                timetable.Status = status;
                timetable.LinkCodeSuffix = linkCodeSuffix;
                if (censusEndDate != null)
                {
                    timetable.CensusEndDate = censusEndDate.Value;
                }

                context.SaveChanges();

                return true;
            }
        }

        public static void DisableAllPaymentRuns()
        {
            using (var context = new PaymentGenerationDbContext())
            {
                context.PaymentTimetables.ToList().ForEach(pt => pt.Status = "DoNotRun");
                context.SaveChanges();
            }
        }

        public static List<DTO.PaymentGeneration.PaymentTimetableHistory> GetPaymentTimetableHistory(FundingStreamPeriodCalendarPeriod fspCalendarPeriod)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                return
                    context.PaymentTimetableHistories.Where(
                        x => x.FundingStreamPeriodCode == fspCalendarPeriod.FundingStreamPeriodCode
                             && x.CalendarPeriod == fspCalendarPeriod.CalendarPeriod)
                        .Select(x => new DTO.PaymentGeneration.PaymentTimetableHistory
                        {
                            CalendarPeriod = x.CalendarPeriod,
                            FundingStreamPeriodCode = x.FundingStreamPeriodCode,
                            HistoryTime = x.HistoryTime,
                            Description = x.Description
                        }).ToList();
            }
        }

        public static List<Payment> CreatePayments(IEnumerable<Payment> payments)
        {
            var subNomAggregations =
                payments.Select(payment => new SubnominalAggregation
                {
                    AllocationNumber = payment.AllocationNumber,
                    AggregatedValue = payment.AggregatedValue,
                    FundingStreamPeriodCode = payment.FundingStreamPeriodCode,
                    Ukprn = payment.Ukprn,
                    Period = payment.Period,
                    OrganisationId = payment.OrganisationId,
                    PeriodTypeCode = CalendarMonthPeriodTypeCode,
                    PostedFlag = false,
                    SubnominalCode = payment.SubnominalCode,
                    PaymentType = payment.SubnominalType,
                }).ToList();

            using (var context = new PaymentGenerationDbContext())
            {
                var dataTable = ToDataTable(subNomAggregations);
                var bulkCopy = new SqlBulkCopy(context.Database.Connection.ConnectionString);

                bulkCopy.ColumnMappings.Add("AllocationNumber", "AllocationNumber");
                bulkCopy.ColumnMappings.Add("Period", "Period");
                bulkCopy.ColumnMappings.Add("SubnominalCode", "SubnominalCode");
                bulkCopy.ColumnMappings.Add("PaymentType", "PaymentType");
                bulkCopy.ColumnMappings.Add("PeriodTypeCode", "PeriodTypeCode");
                bulkCopy.ColumnMappings.Add("OrganisationId", "OrganisationId");
                bulkCopy.ColumnMappings.Add("FundingStreamPeriodCode", "FundingStreamPeriodCode");
                bulkCopy.ColumnMappings.Add("Ukprn", "Ukprn");
                bulkCopy.ColumnMappings.Add("PostedFlag", "PostedFlag");
                bulkCopy.ColumnMappings.Add("AggregatedValue", "AggregatedValue");
                bulkCopy.ColumnMappings.Add("IsSelectedForPayment", "IsSelectedForPayment");

                bulkCopy.BatchSize = 4000;
                bulkCopy.DestinationTableName = "PaymentGeneration.SubnominalAggregation";
                bulkCopy.WriteToServer(dataTable);
                bulkCopy.SqlRowsCopied += (o, e) => { };

                context.SaveChanges();
            }

            return subNomAggregations.Select(x => new Payment
            {
                AllocationNumber = x.AllocationNumber,
                AggregatedValue = x.AggregatedValue,
                FundingStreamPeriodCode = x.FundingStreamPeriodCode,
                Ukprn = x.Ukprn,
                Period = x.Period,
                OrganisationId = x.OrganisationId,
                PeriodTypeCode = x.PeriodTypeCode,
                PostedFlag = x.PostedFlag,
                SubnominalCode = x.SubnominalCode,
                SubnominalType = x.PaymentType
            }).ToList();
        }

        public static void DeleteAllSubnominalAggregations()
        {
            using (var context = new PaymentGenerationDbContext())
            {
                context.Database.ExecuteSqlCommand("TRUNCATE TABLE PaymentGeneration.SubnominalAggregation");
            }
        }

        public static void ResetPaymentTimetable()
        {
            using (var context = new PaymentGenerationDbContext())
            {
                context.PaymentTimetables.ForEach(pt => pt.Status = "Completed");
                context.SaveChanges();
            }
        }

        private static DataTable ToDataTable<T>(IList<T> data)
        {
            var properties = TypeDescriptor.GetProperties(typeof(T));
            var table = new DataTable();

            foreach (PropertyDescriptor prop in properties)
            {
                table.Columns.Add(prop.Name, Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType);
            }

            foreach (T item in data)
            {
                DataRow row = table.NewRow();
                foreach (PropertyDescriptor prop in properties)
                {
                    row[prop.Name] = prop.GetValue(item) ?? DBNull.Value;
                }

                table.Rows.Add(row);
            }

            return table;
        }
    }
}
