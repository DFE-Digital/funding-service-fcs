namespace PaymentManagementDomain.PaymentSchedule.DeliverableAggregation
{
    extern alias IntegrationEntities;
    using System.Collections.Generic;
    using IntegrationEntities::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Dtos;

    public interface IAggregateDeliverablesService
    {
        IReadOnlyCollection<DeliverableActual> GetAggregatedDeliverablesForAllocation(string allocationNumber,
            int version, string fundingStreamPeriodCode, ConnectionInfo connectionInfo);
    }
}