namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO.ContractTermination
{
    using System;
    using System.Collections.Generic;

    public class ContractTerminationRequest
    {
        public ContractTerminationRequest()
        {
            Allocations = new List<AllocationTerminationRequest>();
        }

        public string User { get; set; }

        public string ContractNumber { get; set; }

        public int Version { get; set; }

        public int SubVersion { get; set; }

        public DateTime? DefaultStopNewStartsDate { get; set; }

        public DateTime? ContractTerminationDate { get; set; }

        public string TerminationReason { get; set; }

        public bool? InitiateAmendmentOnApproval { get; set; }

        public string TerminationComments { get; set; }

        public DateTime? ProvisionalTerminationDate { get; set; }

        public string ProvisionalTerminationReason { get; set; }

        public List<AllocationTerminationRequest> Allocations { get; set; }

        public class AllocationTerminationRequest
        {
            public string AllocationNumber { get; set; }

            public DateTime? AllocationStopNewStartsDate { get; set; }

            public DateTime? AllocationTerminationDate { get; set; }

            public DateTime? ProvisionalStopNewStartsDate { get; set; }

            public DateTime? ProvisionalFundingCessationDate { get; set; }
        }
    }
}
