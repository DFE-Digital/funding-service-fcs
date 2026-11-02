

namespace SFA.FCT.Operations.Maintenance.Endpoint.Repositories
{
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System;
    using System.Threading.Tasks;

    public interface ICrmReplicaRowDeleteRepository
    {
        Task DeleteContactDeliverablePeriodsForContractId(Guid contractId, ConnectionInfo connectionInfo);

        Task DeleteContactDeliverablesForContractId(Guid contractId, ConnectionInfo connectionInfo);

        Task DeleteContactAllocationsForContractId(Guid contractId, ConnectionInfo connectionInfo);

        Task DeleteContactForContractId(Guid contractId, ConnectionInfo connectionInfo);
    }
}
