namespace ContractManagement.Cfs.ContractCreate.Services
{
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IFundingTypeFundingPeriodEnrichmentService
    {
        void EnrichContract(ConnectionInfo connectionInfo, ExtendedContractType extendedContract);
    }
}