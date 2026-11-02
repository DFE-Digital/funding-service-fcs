namespace SFA.FCT.CrossDomain.Integration.Events
{
    using System.Collections.Generic;

    public class ContractTerminatedEvent
    {
        public ContractTerminatedEvent()
        {
            AllocationNumbers = new List<string>();
        }

        public string ContractNumber { get; set; }

        public int VersionNumber { get; set; }

        public int SubVersionNumber { get; set; }

        public List<string> AllocationNumbers { get; set; }

        public override string ToString()
        {
            return
                $"ContractNumber: {ContractNumber}, VersionNumber: {VersionNumber}, SubVersionNumber: {SubVersionNumber}";
        }
    }
}