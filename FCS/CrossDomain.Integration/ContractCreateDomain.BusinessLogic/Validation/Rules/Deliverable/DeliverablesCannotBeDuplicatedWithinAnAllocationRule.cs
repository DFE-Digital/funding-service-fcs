namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;
    using CrossDomain.Integration.Entities;

    /// <summary>
    /// Rule DBR-003
    /// </summary>
    public class DeliverablesCannotBeDuplicatedWithinAnAllocationRule : IRule<contractRequestType>
    {
        public string ErrorMessage
        {
            get { return ErrorMessages.DeliverableMoreThanOnceForAContractAllocation; }
        }

        public errorInfoTypeLevel ErrorLevel
        {
            get { return errorInfoTypeLevel.Deliverable; }
        }

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            List<string> correlationIds = new List<string>();

            if (itemToValidate.contract.fundingTypeCode != FundingTypes.ESF)
            {
                foreach (var allocation in itemToValidate.GetAllocations())
                {
                    var invalidDeliverableCodes = allocation.contractDeliverables.Select(d => d.deliverable.deliverableCode)
                            .GroupBy(n => n).Where(c => c.Count() > 1).Select(group => group.Key).ToList();

                    foreach (var deliverable in allocation.contractDeliverables.Where(d => invalidDeliverableCodes.Contains(d.deliverable.deliverableCode)))
                    {
                        correlationIds.Add(deliverable.correlationId);
                    }
                }
            }

            return correlationIds;
        }
    }
}
