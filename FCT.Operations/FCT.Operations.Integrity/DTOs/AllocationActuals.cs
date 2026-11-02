namespace SFA.FCT.Operations.Integrity.DTOs
{
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDeliveryDomain.Common.Storage;

    public class AllocationActuals
    {
        public AllocationActuals(string azureStorageKey, string contractNumber, string allocationNumber, int versionNumber, IReadOnlyCollection<EnrichedReportedActual> enrichedReportedActuals)
        {
            AzureStorageKey = azureStorageKey;
            ContractNumber = contractNumber;
            AllocationNumber = allocationNumber;
            VersionNumber = versionNumber;
            EnrichedReportedActuals = enrichedReportedActuals;
        }

        public string AzureStorageKey { get; }

        public string ContractNumber { get; set; }

        public string AllocationNumber { get; set; }

        public int VersionNumber { get; set; }

        public IReadOnlyCollection<EnrichedReportedActual> EnrichedReportedActuals { get; }

        public decimal GetTotalActualValue()
        {
            return EnrichedReportedActuals.Sum(ra => (decimal) ra.ActualValue);
        }

        public long GetTotalActualVolume()
        {
            return EnrichedReportedActuals.Sum(ra => ra.ActualVolume);
        }
    }
}
