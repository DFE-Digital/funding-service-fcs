namespace ContractCreateDomain.Endpoint.Services.DTOs
{
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    public class CrmAllocationAndImportAllocation
    {
        public CrmAllocationAndImportAllocation(CrmAllocation crmAllocation, contractAllocation importAllocation)
        {
            CrmAllocation = crmAllocation;
            ImportAllocation = importAllocation;
        }

        public CrmAllocation CrmAllocation { get; }

        public contractAllocation ImportAllocation { get; }
    }
}
