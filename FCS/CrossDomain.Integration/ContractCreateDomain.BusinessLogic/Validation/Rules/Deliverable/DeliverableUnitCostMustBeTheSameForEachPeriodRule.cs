namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable
{
    using System.Linq;
    using System.Collections.Generic;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using Utils;

    /// <summary>
    /// Rule DBR-010
    /// </summary>
    public class DeliverableUnitCostMustBeTheSameForEachPeriodRule : IRule<contractRequestType>
    {
        private readonly IDictionary<string, FSCDeliverableStructureDefinitionResponse> _deliverableStructureDefinition;

        public DeliverableUnitCostMustBeTheSameForEachPeriodRule(IDictionary<string, FSCDeliverableStructureDefinitionResponse> deliverableData)
        {
            _deliverableStructureDefinition = deliverableData;
        }

        public string ErrorMessage => ErrorMessages.DeliverableUnitCostsDoNotMatch;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Deliverable;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            List<string> correlationIds = new List<string>();

            IEnumerable<contractDeliverable> valueAndVolumeDeliverables = itemToValidate.GetAllocations()
                .SelectMany(a => a.contractDeliverables.Where(cd => IsValueAndVolumeDeliverable(a.fundingStreamPeriodCode, cd)));

            foreach (var deliverable in valueAndVolumeDeliverables)
            {
                decimal? firstUnitCost = deliverable.contractDeliverablePeriods.First().unitCost;

                if (deliverable.contractDeliverablePeriods.Skip(1).Any(dp => dp.unitCost != firstUnitCost))
                    correlationIds.Add(deliverable.correlationId);
            }            

            return correlationIds;
        }

        private bool IsValueAndVolumeDeliverable(string fundingStreamPeriodCode, contractDeliverable deliverable)
        {
            return DeliverableUtils.GetDeliverablePlanningUnit(_deliverableStructureDefinition[fundingStreamPeriodCode], deliverable) == "Volume and Value";
        }
    }
}
