namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable
{
    using System.Collections.Generic;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities;
    using CrossDomain.Integration.Entities.ContractRequest;
    using Utils;
    using System.Linq;

    /// <summary>
    /// Rule DBR-018
    /// </summary>
    public class ValueAndVolumeDeliverableNoValueRule : IRule<contractRequestType>
    {
        private const string SkillsBootcampFundingType = "SB";
        private const string SBDFundingType = "SBD";
        private IDictionary<string, FSCDeliverableStructureDefinitionResponse> _deliverableStructureDefinition;

        public ValueAndVolumeDeliverableNoValueRule(IDictionary<string, FSCDeliverableStructureDefinitionResponse> deliverableData)
        {
            _deliverableStructureDefinition = deliverableData;
        }

        public string ErrorMessage
        {
            get { return ErrorMessages.DeliverableTypeValueAndVolumeNoValue; }
        }

        public errorInfoTypeLevel ErrorLevel
        {
            get { return errorInfoTypeLevel.Deliverable; }
        }

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            List<string> correlationIds = new List<string>();

            if (itemToValidate.contract.fundingTypeCode == SkillsBootcampFundingType || itemToValidate.contract.fundingTypeCode == SBDFundingType)
            {
                return correlationIds;
            }

            foreach (var allocation in itemToValidate.GetAllocations())
            {
                foreach (var deliverable in allocation.contractDeliverables.Where(cd => IsValueAndVolumeDeliverable(allocation.fundingStreamPeriodCode, cd)))
                {
                    foreach (var deliverablePeriod in deliverable.contractDeliverablePeriods.Where(HasDeliverablePeriodGotAPlannedValue))
                    {
                        if (deliverable.unitCost * deliverablePeriod.plannedVolume != deliverablePeriod.plannedValue)
                        {
                            correlationIds.Add(deliverablePeriod.correlationId);
                        }
                    }
                }
            }

            return correlationIds;
        }

        private bool HasDeliverablePeriodGotAPlannedValue(contractDeliverablePeriodType contractDeliverablePeriod)
        {
            return contractDeliverablePeriod.plannedValue != null;
        }

        private bool IsValueAndVolumeDeliverable(string fundingStreamPeriodCode, contractDeliverable deliverable)
        {
            return (DeliverableUtils.GetDeliverablePlanningUnit(_deliverableStructureDefinition[fundingStreamPeriodCode], deliverable) == "Volume and Value");
        }
    }
}
