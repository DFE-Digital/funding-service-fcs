namespace AllocationDeliveryDomain.Endpoint.BusinessLogic.Mapper
{
    using System.Collections.Generic;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IActualsAuditMapper
    {
        IEnumerable<AllocationDeliverablePeriodActualAudit> Map(IEnumerable<EnrichedReportedActual> enrichedActuals, ConnectionInfo connectionInfo);
    }
}