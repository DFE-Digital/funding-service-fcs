namespace SFA.FCT.CrossDomain.Integration.Entities.CorporateContract
{
    using System;
    using System.Collections.Generic;

    [Serializable]
    [System.Diagnostics.CodeAnalysis.ExcludeFromCodeCoverage]
    public class ApprovedContractAllocationInfo
    {
        public string ContractAllocationNumber { get; set; }

        public string FundingStreamPeriodCode { get; set; }

        public decimal PlannedValueEnvelope1 { get; set; }

        public decimal PlannedValueEnvelope2 { get; set; }

        public decimal TotalPlannedValue { get; set; }

        public List<ApprovedContractDeliverableInfo> Deliverables { get; set; } = new List<ApprovedContractDeliverableInfo>();
    }
}