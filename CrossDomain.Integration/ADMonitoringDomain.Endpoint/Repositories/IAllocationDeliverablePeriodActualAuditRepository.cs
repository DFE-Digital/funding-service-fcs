namespace ADMonitoringDomain.Endpoint.Repositories
{
    using System.Collections.Generic;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IAllocationDeliverablePeriodActualAuditRepository
    {
        IReadOnlyCollection<AllocationDeliverablePeriodActualAudit> GetLatestCollectionReturn(string allocationNumber, ConnectionInfo connectionInfo);
    }
}