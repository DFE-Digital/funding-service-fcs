namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities;
    using CrossDomain.Integration.Entities.ContractRequest;
    using Utils;

    /// <summary>
    /// Rule DBR-017
    /// </summary>
    public class ValueAndVolumeDeliverableUnitCostRequiredRule : IRule<contractRequestType>
    {
        private readonly IDictionary<string, FSCDeliverableStructureDefinitionResponse> _deliverableStructureDefinition;

        public ValueAndVolumeDeliverableUnitCostRequiredRule(IDictionary<string, FSCDeliverableStructureDefinitionResponse> deliverableData)
        {
            _deliverableStructureDefinition = deliverableData;
        }

        public string ErrorMessage => ErrorMessages.DeliverableTypeValueAndVolumeRequiredUnitCost;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Deliverable;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            var valueAndVolumeDeliverables = itemToValidate.GetAllocations()
                .SelectMany(
                    a => a.contractDeliverables.Where(cd => IsValueAndVolumeDeliverable(a.fundingStreamPeriodCode, cd)));

            return valueAndVolumeDeliverables.Where(d => d.unitCost == null)
                .Select(d => d.correlationId).ToList();
        }

        private bool IsValueAndVolumeDeliverable(string fundingStreamPeriodCode, contractDeliverable deliverable)
        {
            return (DeliverableUtils.GetDeliverablePlanningUnit(_deliverableStructureDefinition[fundingStreamPeriodCode], deliverable) == "Volume and Value");
        }
    }
}
