namespace ContractCreateDomain.Endpoint.Infrastructure
{
    using ContractManagement.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public interface IFundingTypePeriodService
    {
        void EnrichContract(ExtendedContractType extendedContract, FundingTypeFundingPeriod fundingTypeFundingPeriod);
    }
}