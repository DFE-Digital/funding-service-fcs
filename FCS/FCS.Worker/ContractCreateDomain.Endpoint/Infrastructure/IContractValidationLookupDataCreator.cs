namespace ContractCreateDomain.Endpoint.Infrastructure
{
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IContractValidationLookupDataCreator
    {
        ContractValidationLookupData CreateLookupDataAndSetContractPresence(
            SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractRequestType contract,
            ConnectionInfo connectionInfo);
    }
}
