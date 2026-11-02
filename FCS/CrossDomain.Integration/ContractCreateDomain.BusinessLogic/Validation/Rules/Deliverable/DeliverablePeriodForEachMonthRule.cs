namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// Rule DBR-004
    /// </summary>
    public class DeliverablePeriodForEachMonthRule : IRule<contractRequestType>
    {
        public string ErrorMessage
        {
            get { return ErrorMessages.DeliverablePeriodRecordMissing; }
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
                    DateTime startDate = allocation.startDate.Value;
                    while (startDate < allocation.endDate)
                    {
                        if (!deliverable.contractDeliverablePeriods.Any(dp => dp.period == startDate.Month && dp.year == startDate.Year))
                        {
                            correlationIds.Add(deliverable.correlationId);
                        }

                        startDate = startDate.AddMonths(1);
                    }
                }
            }

            return correlationIds;
        }
    }
}
