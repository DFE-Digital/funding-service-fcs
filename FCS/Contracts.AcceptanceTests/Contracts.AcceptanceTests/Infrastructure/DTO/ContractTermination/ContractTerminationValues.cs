namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO.ContractTermination
{
    using System;

    public class ContractTerminationValues
    {
        public string ContractNumber { get; set; }

        public int VersionNumber { get; set; }

        public int SubVersionNumber { get; set; }

        public DateTime? TerminationDate { get; set; }

        public bool? InitiateAmendmentOnApproval { get; set; }

        public string TerminationReason { get; set; }

        public string TerminationComments { get; set; }

        public DateTime? ProvisionalTerminationDate { get; set; }

        public string ProvisionalTerminationReason { get; set; }

        public string ProvisionalTerminationComments { get; set; }

        public DateTime? DefaultStopNewStartsDate { get; set; }

        public DateTime? ProvisionalStopNewStartsDate { get; set; }

        public string DefaultNewStartsSuspendedReason { get; set; }

        public string ProvisionalNewStartsSuspendedReason { get; set; }
    }
}
