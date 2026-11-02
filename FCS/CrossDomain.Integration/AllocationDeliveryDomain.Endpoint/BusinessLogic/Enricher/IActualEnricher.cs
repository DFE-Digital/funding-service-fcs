namespace AllocationDeliveryDomain.Endpoint.BusinessLogic.Enricher
{
    using System.Collections.Generic;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IActualEnricher
    {
        IEnumerable<EnrichedReportedActual> Enrich(IEnumerable<ReportedActual> actual, ConnectionInfo connectionInfo);
    }
}
