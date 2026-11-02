namespace AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint.Repositories
{
    using System.Threading.Tasks;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IFundingStreamPeriodRepository
    {
        Task<FundingStreamPeriod> GetFundingStreamPeriod(ConnectionInfo connectionInfo, string fundingStreamPeriodCode);
    }
}