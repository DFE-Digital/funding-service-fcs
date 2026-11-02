namespace AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IAllocationDeliverablePeriodActualAuditRepository
    {
        Task <IReadOnlyCollection<AllocationDeliverablePeriodActualAudit>> GetLatestCollectionReturn(ConnectionInfo connectionInfo, string allocationNumber);
    }
}