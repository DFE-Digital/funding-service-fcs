namespace SFA.FCT.Operations.Integrity.DTOs
{
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using System.Collections.Generic;

    public class OrganisationActualsPaas
    {
        public OrganisationActualsPaas(SummarisedActualOrgFspGroupKey key, IReadOnlyCollection<ReportedActual> reportedActuals)
        {
            Key = key;
            ReportedActuals = reportedActuals;
        }

        public SummarisedActualOrgFspGroupKey Key { get; }

        public IReadOnlyCollection<ReportedActual> ReportedActuals { get; set; }

        public IReadOnlyCollection<EnrichedReportedActual> EnrichedReportedActuals { get; set; }
    }
}