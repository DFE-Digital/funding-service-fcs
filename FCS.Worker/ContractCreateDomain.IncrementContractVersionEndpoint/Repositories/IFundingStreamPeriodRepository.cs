namespace ContractCreateDomain.IncrementContractVersionEndpoint.Repositories
{
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IFundingStreamPeriodRepository
    {
        Task<FundingStreamPeriod> Find(string fundingStreamPeriodCode, ConnectionInfo connectionInfo);
    }
}