namespace ContractCreateDomain.Endpoint.Services
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IRelatedAllocationEnricher
    {
        Task EnrichWithRelatedAllocationsWhenAppropriate(Contract corpContract, ConnectionInfo connectionInfo);
        
        void EnrichWithRelatedAllocationsWhenAppropriate(ApprovedContractInfo contract);
    }
}