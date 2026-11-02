namespace ContractManagementDomain.Endpoint.ContractClosure.Services
{
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IValidationService
    {
        string GetFirstFailureMessageForInitiateContractClosure(ContractIdentifier contractIdentity, ConnectionInfo connectionInfo);

        string GetFirstFailureMessageForApproveContractClosure(ContractIdentifier contractIdentity, ConnectionInfo connectionInfo);
    }
}
