namespace SFA.FCT.Operations.Integrity.Repositories
{
    using DTOs;
    using System.Collections.Generic;

    public interface IDuplicateContractRepository
    {
        IReadOnlyCollection<DuplicateContract> GetDuplicatedContracts();

        void RefreshDuplicatedContracts(IReadOnlyCollection<DuplicateContract> duplicatedContracts);
    }
}