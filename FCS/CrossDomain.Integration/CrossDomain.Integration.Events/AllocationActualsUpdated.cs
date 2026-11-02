namespace SFA.FCT.CrossDomain.Integration.Events
{
    using Entities.AllocationActuals;

    public class AllocationActualsUpdated
    {
        public ContractAllocationActualsType AllocationActuals { get; set; }
    }
}
