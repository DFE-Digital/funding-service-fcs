namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using PaymentGenerationDomain.Integration.DataStore;

    public static class PaymentGenerationRepository
    {
        public static DateTime GetCensusEndDate(string fundingStreamPeriodCode, string calendarPeriod)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                var paymentTimeTable = context.PaymentTimetables.Find(fundingStreamPeriodCode, calendarPeriod);

                return paymentTimeTable.CensusEndDate;
            }
        }
    }
}
