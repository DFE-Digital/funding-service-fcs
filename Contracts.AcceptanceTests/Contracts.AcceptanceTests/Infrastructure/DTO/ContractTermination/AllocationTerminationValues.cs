namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO.ContractTermination
{
    using System;

    public class AllocationTerminationValues
    {
        public string AllocationNumber { get; set; }

        public int VersionNumber { get; set; }

        public int SubVersionNumber { get; set; }

        public DateTime? StopNewStartsDate { get; set; }

        public DateTime? TerminationDate { get; set; }

        public DateTime? FundingCessationDate { get; set; }

        public DateTime? ProvisionalStopNewStartsDate { get; set; }

        public DateTime? ProvisionalFundingCessationDate { get; set; }

        public string NewStartsSuspendedReason { get; set; }

        public string ProvisionalNewStartsSuspendedReason { get; set; }
    }
}
