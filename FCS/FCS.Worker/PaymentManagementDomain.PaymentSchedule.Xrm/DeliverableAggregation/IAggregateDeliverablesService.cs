namespace PaymentManagementDomain.PaymentSchedule.DeliverableAggregation
{
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Dtos;

    public interface IAggregateDeliverablesService
    {
        IReadOnlyCollection<DeliverableActual> GetAggregatedDeliverablesForAllocation(string allocationNumber,
            int version, string fundingStreamPeriodCode, ConnectionInfo connectionInfo);
    }
}