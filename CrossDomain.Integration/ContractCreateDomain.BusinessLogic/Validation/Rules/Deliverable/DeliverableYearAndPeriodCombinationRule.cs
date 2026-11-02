namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable
{
    using System;
    using System.Collections.Generic;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// Rule DBR-005
    /// </summary>
    public class DeliverableYearAndPeriodCombinationRule : IRule<contractRequestType>
    {
        public string ErrorMessage
        {
            get { return ErrorMessages.DeliverableYearAndPeriodCombinationInvalid; }
        }

        public errorInfoTypeLevel ErrorLevel
        {
            get { return errorInfoTypeLevel.Deliverable; }
        }

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            List<string> correlationIds = new List<string>();

            foreach (var allocation in itemToValidate.GetAllocations())
            {
                foreach (var deliverable in allocation.contractDeliverables)
                {
                    foreach (var deliverablePeriod in deliverable.contractDeliverablePeriods)
                    {
                        DateTime deliverablePeriodDate = new DateTime(deliverablePeriod.year, deliverablePeriod.period, 1);
                        DateTime allocationStartDate = new DateTime(allocation.startDate.Value.Year, allocation.startDate.Value.Month, 1);
                        DateTime allocationEndDate = new DateTime(allocation.endDate.Value.Year, allocation.endDate.Value.Month, 1);

                        if (deliverablePeriodDate < allocationStartDate 
                            || deliverablePeriodDate > allocationEndDate)
                        {
                            correlationIds.Add(deliverable.correlationId);
                        }
                    }
                }
            }

            return correlationIds;
        }
    }
}
