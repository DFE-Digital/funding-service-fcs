namespace AllocationDeliveryDomain.Endpoint.BusinessLogic
{
    using System.Collections.Generic;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ICurrentViewActualsComponent
    {
        List<EnrichedReportedActual> UpdateCurrentViewActualsReturningFullSetOfEnrichedActuals(List<EnrichedReportedActual> enrichedReportedActuals, ConnectionInfo connectionInfo);
    }
}