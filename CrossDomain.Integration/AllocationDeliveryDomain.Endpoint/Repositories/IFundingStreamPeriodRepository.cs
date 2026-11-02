namespace AllocationDeliveryDomain.Endpoint.Repositories
{
    using Optional;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IFundingStreamPeriodRepository
    {
        Option<FundingStreamPeriod> GetFundingStreamPeriod(string fundingStreamPeriodCode, ConnectionInfo connectionInfo);
    }
}