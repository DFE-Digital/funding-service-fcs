namespace ContractManagementDomain.Termination.Services
{
    using ContractManagementDomain.Termination.DTOs;
    using ContractManagementDomain.Termination.Infrastructure;

    public interface ITerminateContractValidationService
    {
        Either<RejectionReason, TerminateContractInfo> Validate(TerminateContractInfo terminateContractInfo);
    }
}