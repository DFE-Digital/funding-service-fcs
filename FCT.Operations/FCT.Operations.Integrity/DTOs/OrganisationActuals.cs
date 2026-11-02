namespace SFA.FCT.Operations.Integrity.DTOs
{
    using System.Collections.Generic;
    using AllocationDeliveryDomain.Common.Storage;

    public class OrganisationActuals
    {
        public OrganisationActuals(string azureStorageKey, IReadOnlyCollection<ReportedActual> reportedActuals)
        {
            AzureStorageKey = azureStorageKey;
            ReportedActuals = reportedActuals;
        }

        public string AzureStorageKey { get; }

        public IReadOnlyCollection<ReportedActual> ReportedActuals { get; set; }

        public IReadOnlyCollection<EnrichedReportedActual> EnrichedReportedActuals { get; set; }
    }
}
