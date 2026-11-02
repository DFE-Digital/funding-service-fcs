namespace SFA.FCT.Operations.Integrity.DTOs
{
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDeliveryDomain.Common.Storage;

    public class PeriodActuals
    {
        public PeriodActuals(string azureStorageKey, string contractNumber, string allocationNumber, int versionNumber, string period, IReadOnlyCollection<EnrichedReportedActual> enrichedReportedActuals)
        {
            AzureStorageKey = azureStorageKey;
            ContractNumber = contractNumber;
            AllocationNumber = allocationNumber;
            VersionNumber = versionNumber;
            Period = period;
            EnrichedReportedActuals = enrichedReportedActuals;
        }

        public string AzureStorageKey { get; }

        public string ContractNumber { get; }

        public string AllocationNumber { get; }

        public int VersionNumber { get; }

        public string Period { get; }

        public IReadOnlyCollection<EnrichedReportedActual> EnrichedReportedActuals { get; }

        public decimal GetTotalActualValue()
        {
            return EnrichedReportedActuals.Sum(ra => (decimal)ra.ActualValue);
        }

        public long GetTotalActualVolume()
        {
            return EnrichedReportedActuals.Sum(ra => ra.ActualVolume);
        }
    }
}
