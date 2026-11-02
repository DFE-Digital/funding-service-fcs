namespace ContractManagementDomain.Termination.Repositories
{
    using ContractManagementDomain.Termination.DTOs;

    public interface ICrmTerminationContractRepository
    {
        SimpleContractTerminationInfo GetSimpleContractTerminationInfo(string contractNumber, int version,
            int subVersion);
    }
}