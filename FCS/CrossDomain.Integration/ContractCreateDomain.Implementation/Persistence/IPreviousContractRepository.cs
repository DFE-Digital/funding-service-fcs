namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using Implementation.Entities;
    using Optional;

    public interface IPreviousContractRepository
    {
        Option<PreviousContract> GetLastApprovedContract(string contractNumber);

        Option<PreviousContract> GetLatestContract(string contractNumber);
    }
}
