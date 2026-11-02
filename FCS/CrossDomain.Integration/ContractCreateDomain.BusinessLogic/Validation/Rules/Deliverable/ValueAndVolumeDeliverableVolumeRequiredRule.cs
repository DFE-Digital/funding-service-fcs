namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable
{
    using System.Collections.Generic;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities;
    using CrossDomain.Integration.Entities.ContractRequest;
    using Utils;
    using System.Linq;

    /// <summary>
    /// Rule DBR-016
    /// </summary>
    public class ValueAndVolumeDeliverableVolumeRequiredRule : IRule<contractRequestType>
    {
        private IDictionary<string, FSCDeliverableStructureDefinitionResponse> _deliverableStructureDefinition;

        public ValueAndVolumeDeliverableVolumeRequiredRule(IDictionary<string, FSCDeliverableStructureDefinitionResponse> deliverableData)
        {
            _deliverableStructureDefinition = deliverableData;
        }

        public string ErrorMessage
        {
            get { return ErrorMessages.DeliverableTypeValueAndVolumeRequiredVolume; }
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
                foreach (var deliverable in allocation.contractDeliverables.Where(cd=>IsValueAndVolumeDeliverable(allocation.fundingStreamPeriodCode, cd)))
                {
                    var invalidDeliverablePeriods = deliverable.contractDeliverablePeriods.Where(cdp => cdp.plannedVolume == null).ToList();
                    invalidDeliverablePeriods.ForEach(cdp => correlationIds.Add(cdp.correlationId));
                }
            }

            return correlationIds;
        }

        private bool IsValueAndVolumeDeliverable(string fundingStreamPeriodCode, contractDeliverable deliverable)
        {
            return (DeliverableUtils.GetDeliverablePlanningUnit(_deliverableStructureDefinition[fundingStreamPeriodCode], deliverable) == "Volume and Value");
        }
    }
}
