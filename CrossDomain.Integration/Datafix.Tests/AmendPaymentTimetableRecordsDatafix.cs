namespace Datafix.Tests
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentGenerationDomain.Integration.DataStore;
    using PaymentGenerationDomain.BusinessLogic;

    [TestClass]
    public class AmendPaymentTimetableRecordsDatafix
    {
        [TestMethod, TestCategory("DataFix_R59a")]
        public void SetPaymentTimetableRecordsToCompletedForSomeNcsvPaymentPeriods()
        {
            using (var context = new PaymentGenerationDbContext())
            {
                const string fundingStreamPeriodCode = "NCS-DEV1819";
                IReadOnlyCollection<string> calendarPeriods = new List<string> {"201810", "201811", "201812"};

                context.PaymentTimetables
                    .Where(pt => pt.FundingStreamPeriodCode == fundingStreamPeriodCode && calendarPeriods.Contains(pt.CalendarPeriod))
                    .ToList()
                    .ForEach(paymentTimetableToBeUpdated => paymentTimetableToBeUpdated.Status = PaymentRunStatus.Completed);

                context.SaveChanges();
            }
        }
    }
}
