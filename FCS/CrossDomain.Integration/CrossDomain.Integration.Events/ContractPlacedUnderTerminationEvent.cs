namespace SFA.FCT.CrossDomain.Integration.Events
{
    using Entities.ContractTermination;
    using System.Collections.Generic;

    public abstract class ContractPlacedUnderTerminationEvent
    {
        protected ContractPlacedUnderTerminationEvent()
        {
            TerminationAllocations = new List<TerminationAllocation>();
        }

        public string ContractNumber { get; set; }

        public int VersionNumber { get; set; }

        public int SubVersionNumber { get; set; }

        public List<TerminationAllocation> TerminationAllocations { get; set; }

        public override string ToString()
        {
            return $"ContractNumber: {ContractNumber}, VersionNumber: {VersionNumber}, SubVersionNumber: {SubVersionNumber}, Number Of Allocations: {TerminationAllocations?.Count}";
        }
    }
}