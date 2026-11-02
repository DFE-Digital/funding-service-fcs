namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO.ContractTermination
{
    using System;

    public class ModifyContractRequest
    {
        public string User { get; set; }

        public string ContractNumber { get; set; }

        public int Version { get; set; }

        public int SubVersion { get; set; }

        public DateTime DefaultStopNewStartsDate { get; set; }

        public string DefaultNewStartsSuspendedReason { get; set; }

        public string Comments { get; set; }
    }
}
