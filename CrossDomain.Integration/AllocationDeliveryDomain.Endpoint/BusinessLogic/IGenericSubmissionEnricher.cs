namespace AllocationDeliveryDomain.Endpoint.BusinessLogic
{
    using System.Collections.Generic;

    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IGenericSubmissionEnricher
    {
        List<EnrichedReportedActual> AddMissingActualsWithZeroValues(
            IReadOnlyCollection<EnrichedReportedActual> submittedActuals, FundingStreamZeroisationBehaviour zeriosationBehaviour, ConnectionInfo connectionInfo);
    }
}
