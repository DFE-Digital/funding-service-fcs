namespace SFA.FCT.Operations.Maintenance.Endpoint.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;

    public interface ICrmReplicaRepository
    {
        Task<IReadOnlyCollection<ContractReplicationFailure>> GetContractReplicationFailures();
    }
}