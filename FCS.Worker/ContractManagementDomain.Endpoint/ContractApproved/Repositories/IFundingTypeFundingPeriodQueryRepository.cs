namespace ContractManagementDomain.Endpoint.ContractApproved.Repositories
{
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IFundingTypeFundingPeriodRepository
    {
        Task<FundingTypeFundingPeriod> Get(string fundingTypeCode, string fundingPeriodName, ConnectionInfo connectionInfo);
    }
}
