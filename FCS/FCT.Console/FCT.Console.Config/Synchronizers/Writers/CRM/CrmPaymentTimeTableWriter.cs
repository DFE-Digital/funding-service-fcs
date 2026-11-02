namespace FCT.Console.Config.Synchronizers.Writers.CRM
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using System;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using System.Globalization;

    public class CrmPaymentTimeTableWriter : CrmConfigWriter<PaymentTimetablesSheetType, sfa_paymenttimetable>
    {
        private IDictionary<string, sfa_fundingstreamperiod> _allFundingStreamPeriods = new Dictionary<string, sfa_fundingstreamperiod>();

        private IDictionary<string, sfa_fundingstreamperiod> AllFundingStreamPeriods
        {
            get
            {
                if (!_allFundingStreamPeriods.Any())
                {
                    _allFundingStreamPeriods = GetAllFundingStreamPeriods();
                }

                return _allFundingStreamPeriods;
            }
        }
        protected override void UpdateMatchingEntity(PaymentTimetablesSheetType row, sfa_paymenttimetable matchingPaymentTimeTableEntry)
        {
            matchingPaymentTimeTableEntry.sfa_censusenddate = row.CensusEndDate;
            matchingPaymentTimeTableEntry.sfa_paymentduedate = row.DueDate;
            matchingPaymentTimeTableEntry.sfa_financialperiod = Convert.ToInt32(row.FinancialPeriod);
            matchingPaymentTimeTableEntry.sfa_financialperiodtype = row.FinancialPeriodType;
            matchingPaymentTimeTableEntry.sfa_periodstartdate = row.PeriodStartDate;
            matchingPaymentTimeTableEntry.sfa_periodenddate = row.PeriodEndDate;
            
        }

        protected override sfa_paymenttimetable CreateEntity(PaymentTimetablesSheetType paymentTimeTableSheet)
        {
            return new sfa_paymenttimetable()
            {
                sfa_name = GetBusinessKey(paymentTimeTableSheet.FundingStreamPeriodCode,paymentTimeTableSheet.CalendarPeriodType,paymentTimeTableSheet.CalendarPeriod ),
                sfa_fundingstreamperiod = GetFundingStreamPeriodFromCrm(paymentTimeTableSheet.FundingStreamPeriodCode),
                sfa_calendarperiod = Convert.ToInt32(paymentTimeTableSheet.CalendarPeriod),
                sfa_calendarperiodtype = paymentTimeTableSheet.CalendarPeriodType,
                sfa_censusenddate = paymentTimeTableSheet.CensusEndDate,
                sfa_financialperiod = Convert.ToInt32(paymentTimeTableSheet.FinancialPeriod),
                sfa_financialperiodtype = paymentTimeTableSheet.FinancialPeriodType,
                sfa_paymentduedate = paymentTimeTableSheet.DueDate,
                sfa_periodstartdate = paymentTimeTableSheet.PeriodStartDate,
                sfa_periodenddate = paymentTimeTableSheet.PeriodEndDate,
                sfa_period = GetFormattedPeriod(paymentTimeTableSheet.CalendarPeriod)
            };
        }

        protected override IEnumerable<sfa_paymenttimetable> GetMatchingEntities(XrmServiceContext crmContext, PaymentTimetablesSheetType row)
        {
            if (AllFundingStreamPeriods.ContainsKey(row.FundingStreamPeriodCode)) // cannot look for rows where FSP not present in CRM (CRM payment timetable entity should already be deleted in such instances)
            {
                //match based on FSP Code and Calendar Period and CalendarPeriodType )
                return from d in crmContext.sfa_paymenttimetableSet
                       where d.sfa_fundingstreamperiod.Id == AllFundingStreamPeriods[row.FundingStreamPeriodCode].ToEntityReference().Id
                       && d.sfa_calendarperiod == Convert.ToInt32(row.CalendarPeriod)
                       && d.sfa_calendarperiodtype == row.CalendarPeriodType
                       select d;
            }

            return Enumerable.Empty<sfa_paymenttimetable>();
         }

        private string GetBusinessKey(string fspCode,string calendarType, string calendarPeriod)
        {
            return fspCode + ":" + calendarType + ":" + calendarPeriod;
        }


        private string GetFormattedPeriod(string calendarPeriod)
        {
            string monthName = new DateTime(2010, Convert.ToInt32(calendarPeriod.Substring(4, 2)), 1).ToString("MMM",
                           CultureInfo.InvariantCulture);

            string formattedDate = monthName + "-" + calendarPeriod.Substring(2, 2);

            return formattedDate;
        }

        private EntityReference GetFundingStreamPeriodFromCrm(string fundingStreamPeriodCode)
        {
            return AllFundingStreamPeriods[fundingStreamPeriodCode].ToEntityReference();
        }

        private IDictionary<string, sfa_fundingstreamperiod> GetAllFundingStreamPeriods()
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                IReadOnlyCollection<sfa_fundingstreamperiod> fundingStreamPeriods = GetCrmFundingStreamPeriods(crmContext);

                fundingStreamPeriods.ForEach(fsp => _allFundingStreamPeriods.Add(fsp.sfa_fundingstreamperiodcode, fsp));

                return _allFundingStreamPeriods;
            }
               
        }

        private IReadOnlyCollection<sfa_fundingstreamperiod> GetCrmFundingStreamPeriods(XrmServiceContext crmContext)
        {
            return (from fsp in crmContext.sfa_fundingstreamperiodSet
                    select fsp).ToList();
        }

    }
}

