namespace PaymentGenerationDomain.BusinessLogic
{
    extern alias Entities;

    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using Integration.DataStore;
    using Integration.DataStore.Model;
    using Integration.DataStore.Dtos;
    using Integration.DataStore.Repositories;
    using Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class DataAccessManager : IDataAccessManager
    {
        private readonly ISubnominalAggregationRepository _subnominalAggregationRepository;
        private readonly ILogger _logger;

        public DataAccessManager(ISubnominalAggregationRepository subnominalAggregationRepository, ILogger logger)
        {
            _subnominalAggregationRepository = subnominalAggregationRepository;
            _logger = logger;
        }

        public IReadOnlyCollection<PaymentTimetable> GetPaymentTimetableByDateAndStatus(DateTime date, string status, ConnectionInfo connectionInfo)
        {
            _logger.LogInformation(PaymentGenerationDomainLoggingEventId.DataAccessManagerDiagnosticInfo, 
                "Getting Payment Timetable for date: {0} and status: {1}", date, status);

            using (var context = new PaymentGenerationDbContext(connectionInfo))
            {
                return context.PaymentTimetables.Where(x => x.CensusEndDate <= date && x.Status == status)
                    .Include(pt => pt.FundingStreamPeriod).ToList();
            }
        }

        public void UpdateTimetableStatusForPaymentRun(
            string fundingStreamPeriodCode,
            string calendarPeriod,
            ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentGenerationDbContext(connectionInfo))
            {
                //// Update Timetable Status
                var existingTimetable = context.PaymentTimetables.Single(x =>
                    x.FundingStreamPeriodCode == fundingStreamPeriodCode
                    && x.CalendarPeriod == calendarPeriod);

                existingTimetable.Status = PaymentRunStatus.Started;
                var historyToAdd = new PaymentTimetableHistory
                {
                    FundingStreamPeriodCode = fundingStreamPeriodCode,
                    CalendarPeriod = calendarPeriod,
                    HistoryTime = DateTime.Now,
                    Description = "Payment timetable status changed to " + PaymentRunStatus.Started
                };
                context.PaymentTimetableHistories.Add(historyToAdd);

                context.SaveChanges();
            }
        }

        public void UpdateTimetableStatusForFailedPaymentRun(
            string fundingStreamPeriodCode,
            string calendarPeriod,
            ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentGenerationDbContext(connectionInfo))
            {
                // Get timetable based on FSP code and period
                var existingTimetable = context.PaymentTimetables.Single(x =>
                    x.FundingStreamPeriodCode == fundingStreamPeriodCode && x.CalendarPeriod == calendarPeriod);

                existingTimetable.Status = PaymentRunStatus.Failed;

                var historyToAdd = new PaymentTimetableHistory
                {
                    FundingStreamPeriodCode = existingTimetable.FundingStreamPeriodCode,
                    CalendarPeriod = calendarPeriod,
                    HistoryTime = DateTime.Now,
                    Description = "Payment timetable status changed to " + PaymentRunStatus.Failed
                };

                context.PaymentTimetableHistories.Add(historyToAdd);

                context.SaveChanges();
            }
        }

        public string GetFundingStreamPeriodCodeFromShortCode(
            string fundingStreamShortCode,
            DateTime periodStartDate,
            DateTime periodEndDate,
            ConnectionInfo connectionInfo)
        {
            _logger.LogInformation(PaymentGenerationDomainLoggingEventId.DataAccessManagerDiagnosticInfo,
                "Getting fsp code for Finance Short Code: {0}, Start date: {1} and End date: {2}", 
                fundingStreamShortCode, periodStartDate, periodEndDate);

            using (var context = new PaymentGenerationDbContext(connectionInfo))
            {
                return context.FundingStreamPeriods.Single(x =>
                    x.FundingStream.FinanceShortCode == fundingStreamShortCode
                    && x.StartDate == periodStartDate
                    && x.EndDate == periodEndDate).Code;
            }
        }

        public void UpdateTimetableForCompletedPaymentRun(
            string fundingStreamPeriodCode,
            string calendarPeriod,
            string linkCode,
            ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentGenerationDbContext(connectionInfo))
            {
                // Get timetable using FSP and Period.
                var existingTimetable = context.PaymentTimetables.Single(x =>
                    x.FundingStreamPeriodCode == fundingStreamPeriodCode && x.CalendarPeriod == calendarPeriod);

                // Update status
                existingTimetable.Status = PaymentRunStatus.Completed;

                var historiesToAdd = new List<PaymentTimetableHistory>();

                // Only increment linkCode and Write History if linkCode is not null or empty
                if (!string.IsNullOrEmpty(linkCode))
                {
                    // Increment character suffix
                    var linkCodeSuffix = ((char)(linkCode.ToArray()[linkCode.Length - 1] + 1)).ToString();
                    if (linkCodeSuffix.ToCharArray()[0] > 90)
                    {
                        throw new FormatException("Link Code character suffix exceeds Z.");
                    }

                    existingTimetable.LinkCodeSuffix = linkCodeSuffix;

                    historiesToAdd.Add(new PaymentTimetableHistory
                    {
                        FundingStreamPeriodCode = existingTimetable.FundingStreamPeriodCode,
                        CalendarPeriod = calendarPeriod,
                        HistoryTime = DateTime.Now,
                        Description = "Link Code suffix changed to " + linkCodeSuffix
                    });
                }

                historiesToAdd.Add(new PaymentTimetableHistory
                {
                    FundingStreamPeriodCode = existingTimetable.FundingStreamPeriodCode,
                    CalendarPeriod = calendarPeriod,
                    HistoryTime = DateTime.Now,
                    Description = "Payment timetable status changed to " + PaymentRunStatus.Completed
                });
                
                context.PaymentTimetableHistories.AddRange(historiesToAdd);

                context.SaveChanges();
            }
        }

        public void AddOrUpdateSubnominalAggregations(List<SubnominalAggregation> subnominalAggregations, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentGenerationDbContext(connectionInfo))
            {
                foreach (var subnominalAggregation in subnominalAggregations)
                {
                    var existingRecord = GetSingleSubnominalAggregation(subnominalAggregation, connectionInfo);

                    if (existingRecord != null)
                    {
                        // Only update if the record was not previously posted
                        if (existingRecord.PostedFlag != true)
                        {
                            existingRecord.AggregatedValue = subnominalAggregation.AggregatedValue;
                            existingRecord.AllocationVersionNumber = subnominalAggregation.AllocationVersionNumber;
                        }
                    }
                    else
                    {
                        context.SubnominalAggregations.Add(subnominalAggregation);
                    }
                }

                context.SaveChanges();
            }
        }

        public IReadOnlyCollection<SubnominalAggregationDto> UpdateAndGetPaymentsForPaymentRun(
            string fundingStreamPeriodCode,
            string calendarPeriod,
            ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentGenerationDbContext(connectionInfo))
            {
                _logger.LogInformation(PaymentGenerationDomainLoggingEventId.DataAccessManagerDiagnosticInfo,
                    "Executing stored proc UpdateAndSelectSubnominalAggregationByFSPCodeAndPeriod for fsp Code: {0} and period: {1}",
                    fundingStreamPeriodCode, calendarPeriod);

                int recordsUpdated =
                    context.Database.ExecuteSqlCommand(
                        "EXEC PaymentGeneration.UpdateAndSelectSubnominalAggregationByFSPCodeAndPeriod @p0, @p1",
                        fundingStreamPeriodCode,
                        calendarPeriod);

                return _subnominalAggregationRepository
                    .GetSubnominalAggregationsForPaymentByFspAndPeriod(fundingStreamPeriodCode, calendarPeriod, connectionInfo);
            }
        }

        public IReadOnlyCollection<SubnominalAggregation> UpdatePaymentsToPostedForPaymentRun(
            string fundingStreamPeriodCode,
            string calendarPeriod,
            ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentGenerationDbContext(connectionInfo))
            {
                _logger.LogInformation(PaymentGenerationDomainLoggingEventId.DataAccessManagerDiagnosticInfo,
                "Executing stored proc UpdatePaymentsToPostedForPaymentRun for fsp Code: {0} and period: {1}",
                fundingStreamPeriodCode, calendarPeriod);

                context.Database.ExecuteSqlCommand(
                    "EXEC PaymentGeneration.UpdatePaymentsToPostedForPaymentRun @p0,@p1",
                    fundingStreamPeriodCode, calendarPeriod);

                var aggregations = context.SubnominalAggregations
                    .Where(x => x.FundingStreamPeriodCode == fundingStreamPeriodCode
                                && x.Period == calendarPeriod
                                && x.AggregatedValue != 0
                                && x.IsSelectedForPayment)
                    .Include(sa => sa.FundingStreamPeriod)
                    .Include(sa => sa.FundingStreamPeriod.FundingStream)
                    .Include(sa => sa.Subnominal);

                return aggregations.ToList();
            }
        }

        public IReadOnlyCollection<SubnominalAggregation> GetPaymentsForPaymentRun(
            string fundingStreamPeriodCode,
            string calendarPeriod,
            ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentGenerationDbContext(connectionInfo))
            {
                return context.SubnominalAggregations.Where(
                    x => x.FundingStreamPeriodCode == fundingStreamPeriodCode
                         && x.Period == calendarPeriod && x.AggregatedValue != 0)
                        .ToList();
            }
        }

        public bool IsPaymentPosted(string subnominalCode, AggregationPaymentType paymentType, string allocationNumber, string fundingStreamPeriodCode, string calendarPeriod,
            ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentGenerationDbContext(connectionInfo))
            {
                var paymentPosted = false;
                var subnominalAggregate = context.SubnominalAggregations.FirstOrDefault(
                    sa => sa.FundingStreamPeriodCode == fundingStreamPeriodCode &&
                          sa.AllocationNumber == allocationNumber
                          && sa.Period == calendarPeriod
                          && sa.PaymentType == paymentType.ToString()
                          && sa.SubnominalCode == subnominalCode);

                if (subnominalAggregate != null)
                {
                    paymentPosted = subnominalAggregate.PostedFlag;
                }

                return paymentPosted;
            }
        }

        public virtual SubnominalAggregation GetSingleSubnominalAggregation(SubnominalAggregation subnominalAggregation, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentGenerationDbContext(connectionInfo))
            {
                return
                    context.SubnominalAggregations.SingleOrDefault(
                    x => x.AllocationNumber == subnominalAggregation.AllocationNumber
                         && x.Period == subnominalAggregation.Period
                         && x.SubnominalCode == subnominalAggregation.SubnominalCode
                         && x.PaymentType == subnominalAggregation.PaymentType);
            }
        }

        public string GetCalendarPeriodForPaymentTimetableFspAndCensusEndDate(
            string fundingStreamPeriodCode,
            DateTime censusEndDate, 
            ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentGenerationDbContext(connectionInfo))
            {
                return
                    context.PaymentTimetables.Single(
                        x => x.FundingStreamPeriodCode == fundingStreamPeriodCode && x.CensusEndDate == censusEndDate)
                        .CalendarPeriod;
            }
        }
    }
}