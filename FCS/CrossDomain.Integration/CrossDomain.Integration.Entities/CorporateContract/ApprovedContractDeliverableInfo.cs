namespace SFA.FCT.CrossDomain.Integration.Entities.CorporateContract
{
    using System;

    [Serializable]
    public class ApprovedContractDeliverableInfo
    {
        public int DeliverableCode { get; set; }

        public decimal TotalPlannedValue { get; set; }

        public decimal? PlannedValueEnvelope1 { get; set; }

        public decimal? PlannedValueEnvelope2 { get; set; }
    }
}