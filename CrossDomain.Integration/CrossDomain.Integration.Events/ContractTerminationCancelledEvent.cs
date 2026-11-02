namespace SFA.FCT.CrossDomain.Integration.Events
{
    using System.Collections.Generic;

    public class ContractTerminationCancelledEvent
    {
        public string ContractNumber { get; set; }

        public int VersionNumber { get; set; }

        public int SubVersionNumber { get; set; }

        public List<string> AllocationNumbers { get; set; } = new List<string>();

        public override string ToString()
        {
            return
                $"ContractNumber: {ContractNumber}, VersionNumber: {VersionNumber}, SubVersionNumber: {SubVersionNumber}, AllocationNumbers: {string.Join(", ", AllocationNumbers)}";

        }
    }
}
