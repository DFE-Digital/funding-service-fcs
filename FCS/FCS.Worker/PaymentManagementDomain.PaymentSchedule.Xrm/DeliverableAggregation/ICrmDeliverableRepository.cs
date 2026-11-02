namespace PaymentManagementDomain.PaymentSchedule.DeliverableAggregation
{
    using System.Collections.Generic;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Dtos;

    public interface ICrmDeliverableRepository
    {
        void UpdateDeliverablesInCrmForAllocation(string allocationNumber, int version, int subVersion,
            IReadOnlyCollection<DeliverableActual> deliverableActuals);
    }
}