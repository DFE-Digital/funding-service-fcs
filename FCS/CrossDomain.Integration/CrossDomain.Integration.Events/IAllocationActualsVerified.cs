namespace SFA.FCT.CrossDomain.Integration.Events
{
    using Entities.AllocationActuals;

    public interface IAllocationActualsVerified
    {
        ContractAllocationActualsType AllocationActuals { get; set; }

        ActualsOrigin Origin { get; set; }
    }
}
