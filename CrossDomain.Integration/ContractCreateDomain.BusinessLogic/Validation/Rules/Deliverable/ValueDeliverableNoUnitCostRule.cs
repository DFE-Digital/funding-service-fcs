namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities;
    using CrossDomain.Integration.Entities.ContractRequest;
    using Utils;

    /// <summary>
    /// DBR-014
    /// </summary>
    public class ValueDeliverableNoUnitCostRule : IRule<contractRequestType>
    {
        private readonly IDictionary<string, FSCDeliverableStructureDefinitionResponse> _deliverableStructureDefinition;

        public ValueDeliverableNoUnitCostRule(IDictionary<string, FSCDeliverableStructureDefinitionResponse> deliverableData)
        {
            _deliverableStructureDefinition = deliverableData;
        }

        public string ErrorMessage => ErrorMessages.DeliverableTypeValueWithSpecifiedUnitcost;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Deliverable;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            var correlationIds = new List<string>();

            foreach (var allocation in itemToValidate.GetAllocations())
            {
                var valueOnlyDeliverables = allocation.contractDeliverables.Where(cd => IsValueOnlyDeliverable(allocation.fundingStreamPeriodCode, cd)).ToList();
                var invalidDeliverables = valueOnlyDeliverables.Where(HasADeliverableGotAUnitCost).ToList();
                invalidDeliverables.ForEach(d => correlationIds.Add(d.correlationId));
            }

            return correlationIds;
        }

        private bool HasADeliverableGotAUnitCost(contractDeliverable contractDeliverable)
        {
            return contractDeliverable.unitCost != null;
        }

        private bool IsValueOnlyDeliverable(string fundingStreamPeriodCode, contractDeliverable deliverable)
        {
            return (DeliverableUtils.GetDeliverablePlanningUnit(_deliverableStructureDefinition[fundingStreamPeriodCode], deliverable) == "Value");
        }
    }
}