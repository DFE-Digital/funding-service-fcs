namespace SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim
{
    using System.Collections.Generic;

    [System.Diagnostics.CodeAnalysis.ExcludeFromCodeCoverage]
    public class ContractAllocation
    {
        public ContractAllocation()
        {
            DeliverableLines = new List<DeliverableLine>();
        }

        public string ContractAllocationNumber { get; set; }

        public string FundingStreamPeriodCode { get; set; }

        public decimal? PlannedValueAggregation { get; set; }

        public List<DeliverableLine> DeliverableLines { get; set; }
    }
}