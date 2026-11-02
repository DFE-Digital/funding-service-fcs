namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories
{
    using System;
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.Xrm;
    using Microsoft.Xrm.Sdk;

    public interface ICrmDeliverablePeriodRepository
    {
        IReadOnlyCollection<DeliverablePeriodInfo> GetDeliverablePeriods(Guid allocationId);

        void InsertDeliverablePeriod(sfa_contractdeliverableperiod basedOnContractDeliverablePeriod, EntityReference deliverableToRelateTo);

        IReadOnlyCollection<DeliverablePeriodYear> GetDeliverablePeriodYears(Guid crmAllocation);
    }
}