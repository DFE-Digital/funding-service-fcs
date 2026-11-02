namespace ContractCreateDomain.Endpoint.Services
{
    using DTOs;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    public interface ICheckForAllocationChangeService
    {
        void UpdateAllocationsThatHaveChangedOrBeenAdded(CrmContract crmContract, contractType importContract);
    }
}