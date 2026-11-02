namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// Rule DBR-007
    /// </summary>
    public class DeliverableMultipleRecordsPerPeriodRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.DeliverableMultiplesRecordsForTheSamePeriod;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Deliverable;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate.GetDeliverables().Where(
                    deliverable => deliverable.contractDeliverablePeriods.GroupBy(d => new {d.period, d.year}).Any(c => c.Count() > 1))
                .Select(deliverable => deliverable.correlationId);
        }
    }
}