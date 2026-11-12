namespace ADMonitoringDomain.Endpoint.Repositories
{
    extern alias Entities;
    using System.Collections.Generic;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IAllocationDeliverablePeriodActualAuditRepository
    {
        IReadOnlyCollection<AllocationDeliverablePeriodActualAudit> GetLatestCollectionReturn(string allocationNumber, ConnectionInfo connectionInfo);
    }
}