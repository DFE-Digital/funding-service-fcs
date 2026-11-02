namespace SFA.FCT.CrossDomain.Integration.Events
{
    using Entities.AllocationActuals;

    public enum ActualsOrigin
    {
        NotSet,
        ActualsVerified,
        ActualsUpdated
    }

    public class AllocationActualsVerified : IAllocationActualsVerified
    {
        public ContractAllocationActualsType AllocationActuals { get; set; }

        public ActualsOrigin Origin { get; set; }
    }
}
