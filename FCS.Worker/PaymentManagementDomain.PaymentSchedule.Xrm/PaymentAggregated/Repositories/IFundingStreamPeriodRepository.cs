namespace PaymentManagementDomain.PaymentSchedule.PaymentAggregated.Repositories
{
    using Microsoft.Xrm.Sdk;

    public interface IFundingStreamPeriodRepository
    {
        EntityReference GetFundingStreamPeriod(string fundingStreamPeriodCode);
    }
}
