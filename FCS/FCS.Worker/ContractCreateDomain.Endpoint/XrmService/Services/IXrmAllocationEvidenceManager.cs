namespace ContractCreateDomain.Endpoint.XrmService.Services
{
    using DTOs;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;

    public interface IXrmAllocationEvidenceManager
    {
        void AggregateDeliverablePeriodsIntoDeliverableInCrm(AllocationDto allocation);

        AllocationDto CopyPreviousDeliverablePeriodActualsInCrm(allocationType allocation);
    }
}
