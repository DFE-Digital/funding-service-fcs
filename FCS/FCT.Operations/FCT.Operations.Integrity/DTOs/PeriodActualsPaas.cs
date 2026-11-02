namespace SFA.FCT.Operations.Integrity.DTOs
{
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDeliveryDomain.Common.Storage;

    public class PeriodActualsPaas
    {
        public PeriodActualsPaas(string key, string contractNumber, string allocationNumber, int versionNumber, string period, IReadOnlyCollection<EnrichedReportedActual> enrichedReportedActuals)
        {
            Key = key;
            ContractNumber = contractNumber;
            AllocationNumber = allocationNumber;
            VersionNumber = versionNumber;
            Period = period;
            EnrichedReportedActuals = enrichedReportedActuals;
        }

        public string Key { get; }

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