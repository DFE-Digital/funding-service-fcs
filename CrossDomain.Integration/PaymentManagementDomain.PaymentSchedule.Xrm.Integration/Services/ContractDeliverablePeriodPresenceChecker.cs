namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Repositories;

    public class ContractDeliverablePeriodPresenceChecker : IContractDeliverablePeriodPresenceChecker
    {
        public bool AreAllDeliverablePeriodsWithinBoundsOfAllocationPresent(
            DateTime allocationStartDate,
            DateTime allocationEndDate,
            IEnumerable<DeliverablePeriodYear> existingContractDeliverablePeriods,
            CrossDomain.Integration.Entities.PaymentSchedule.Allocation paymentSchedule)
        {
            // we expect this list of periods to be on each deliverable in CRM
            IList<string> expectedPeriods = DateBetweenPeriodGenerator.GetPeriodsBetweenTwoDates(allocationStartDate, allocationEndDate);

            // for each payment schedule deliverable code should have a full set of periods in CRM
            IReadOnlyCollection<int> paymentScheduleDeliverableCodes = paymentSchedule.AllocationDeliverables.Select(ad => ad.DeliverableCode).ToList();

            return paymentScheduleDeliverableCodes.All(payScheduleDeliverableCode =>
            {
                IReadOnlyCollection<string> crmPeriodsForDeliverable
                = existingContractDeliverablePeriods.Where(
                    crmCdps => crmCdps.DeliverableCode == payScheduleDeliverableCode.ToString())
                    .Select(cdp => cdp.PeriodName).ToList();

                return expectedPeriods.All(expectedPeriod => crmPeriodsForDeliverable.Contains(expectedPeriod));
            });
        }
    }
}