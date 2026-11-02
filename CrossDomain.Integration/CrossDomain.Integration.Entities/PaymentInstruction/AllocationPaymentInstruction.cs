namespace SFA.FCT.CrossDomain.Integration.Entities.PaymentInstruction
{
    using System;
    using System.Collections.Generic;

    public class AllocationPaymentInstruction
    {
        public AllocationPaymentInstruction()
        {
            DeliverablePaymentInstructions = new List<DeliverablePaymentInstruction>();
        }

        public string AllocationNumber { get; set; }

        public int VersionNumber { get; set; }

        public string FundingStreamPeriodCode { get; set; }

        public string ContractNumber { get; set; }

        public string OrganisationId { get; set; }

        public int Ukprn { get; set; }

        public DateTime AllocationStartDate { get; set; }

        public DateTime? AllocationEndDate { get; set; }

        public IEnumerable<DeliverablePaymentInstruction> DeliverablePaymentInstructions { get; set; }
    }
}
