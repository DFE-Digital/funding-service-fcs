namespace ContractCreateDomain.IncrementContractVersionEndpoint.Repositories
{
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IFundingTypeFundingPeriodQueryRepository
    {
        Task<FundingTypeFundingPeriod> Get(string fundingTypeCode, string fundingPeriod, ConnectionInfo connectionInfo);
    }
}