namespace SFA.FCT.CrossDomain.Integration.Events
{
    using System;
    using System.Collections.Generic;

    public class ContractClosedEvent
    {
        public ContractClosedEvent()
        {
            AllocationNumbers = new List<string>();
        }

        public string ContractNumber { get; set; }

        public List<string> AllocationNumbers { get; set; }

        public int VersionNumber { get; set; }

        public int SubVersionNumber { get; set; }

        public DateTime ClosureDate { get; set; }

        public bool IsContractOpenEnded { get; set; }
    }
}
