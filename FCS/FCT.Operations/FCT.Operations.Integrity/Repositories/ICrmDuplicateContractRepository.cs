
namespace SFA.FCT.Operations.Integrity.Repositories
{
    using System.Collections.Generic;
    using DTOs;

    public interface ICrmDuplicateContractRepository
    {
        IReadOnlyCollection<DuplicateContract> GetDuplicatedContracts();
    }
}