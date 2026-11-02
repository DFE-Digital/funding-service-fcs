namespace ContractRequestDomain.Cfs.Release.Services
{
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IContractNumberEnricher
    {
        void EnrichWithContractAndAllocationNumbers(ExtendedContractType masterContract, ConnectionInfo connectionInfo);
    }
}