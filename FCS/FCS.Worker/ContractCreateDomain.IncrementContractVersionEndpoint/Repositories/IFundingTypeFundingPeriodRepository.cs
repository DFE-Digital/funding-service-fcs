namespace ContractCreateDomain.IncrementContractVersionEndpoint.Repositories
{
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System.Threading.Tasks;

    public interface IFundingTypeFundingPeriodRepository
    {
        Task<bool> ShouldIncludeAllContractsOnSummaryOfFunding(string fundingTypeCode, string fundingPeriod, ConnectionInfo connectionInfo);
    }
}