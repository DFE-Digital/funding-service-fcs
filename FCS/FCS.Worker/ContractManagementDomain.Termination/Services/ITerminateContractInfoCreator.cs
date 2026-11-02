namespace ContractManagementDomain.Termination.Services
{
    using ContractManagementDomain.Termination.DTOs;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ITerminateContractInfoCreator
    {
        TerminateContractInfo CreateTerminateContractInfo(ContractIdentifier contractIdentifier, ConnectionInfo connectionInfo);
    }
}