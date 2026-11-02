namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Services
{
    using System;
    using System.Collections.Generic;
    using Repositories;

    public interface IContractDeliverablePeriodPresenceChecker
    {
        bool AreAllDeliverablePeriodsWithinBoundsOfAllocationPresent(
            DateTime allocationStartDate,
            DateTime allocationEndDate,
            IEnumerable<DeliverablePeriodYear> existingContractDeliverablePeriods,
            CrossDomain.Integration.Entities.PaymentSchedule.Allocation paymentSchedule);
    }
}
