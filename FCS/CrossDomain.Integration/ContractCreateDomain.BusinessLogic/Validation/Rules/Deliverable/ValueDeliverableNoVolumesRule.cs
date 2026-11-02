namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities;
    using CrossDomain.Integration.Entities.ContractRequest;
    using Utils;

    /// <summary>
    /// DBR-013
    /// </summary>
    public class ValueDeliverableNoVolumesRule : IRule<contractRequestType>
    {
        private readonly IDictionary<string, FSCDeliverableStructureDefinitionResponse> _deliverableStructureDefinition;

        public ValueDeliverableNoVolumesRule(IDictionary<string, FSCDeliverableStructureDefinitionResponse> deliverableData)
        {
            _deliverableStructureDefinition = deliverableData;
        }

        public string ErrorMessage => ErrorMessages.DeliverableTypeValueWithSpecifiedVolumes;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Deliverable;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            var correlationIds = new List<string>();

            // this rule is *not* esf specific. it needs to apply to all allocations

            foreach (var allocation in itemToValidate.GetAllocations())
            {
                foreach (var deliverable in allocation.contractDeliverables)
                {
                    if (DeliverableUtils.GetDeliverablePlanningUnit(_deliverableStructureDefinition[allocation.fundingStreamPeriodCode], deliverable) == "Value"
                        && deliverable.contractDeliverablePeriods.Any(p => p.plannedVolume != null))
                    {
                        correlationIds.Add(deliverable.correlationId);
                    }
                }
            }

            return correlationIds;
        }
    }
}
