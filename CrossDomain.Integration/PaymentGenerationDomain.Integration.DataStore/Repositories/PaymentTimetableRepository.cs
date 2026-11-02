namespace PaymentGenerationDomain.Integration.DataStore.Repositories
{
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class PaymentTimetableRepository : IPaymentTimetableRepository
    {
        public bool HasOutstandingPaymentTimetablesForFundingStreamPeriod(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentGenerationDbContext(connectionInfo))
            {
                return context.PaymentTimetables.Any(pt => pt.FundingStreamPeriodCode == fundingStreamPeriodCode && pt.Status == "NotStarted");
            }
        }
    }
}
