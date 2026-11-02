namespace AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation.Services
{
    using System;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;

    public interface IMonitoringDeliverablesForAllocationService
    {
        void PopulateMissingValidDeliverables(IReadOnlyCollection<ReportedActual> actuals,
            Action<MonitoringDeliverableAddedPostApprovalEvent> raiseMonitoringDeliverableAddedPostApprovalEvent, 
            ConnectionInfo connectionInfo);
    }
}