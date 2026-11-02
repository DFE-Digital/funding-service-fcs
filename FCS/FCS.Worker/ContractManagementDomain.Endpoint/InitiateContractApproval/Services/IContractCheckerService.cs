namespace ContractManagementDomain.Endpoint.InitiateContractApproval.Services
{
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IContractCheckerService
    {
        ContractCheckerServiceResult GetContractCheckerServiceResult(string contractNumber, int versionNumber, string fundingStreamPeriodCode, ConnectionInfo connectionInfo);
    }
}