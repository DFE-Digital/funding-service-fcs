namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities;
    using CrossDomain.Integration.Entities.ContractRequest;
    using Utils;

    /// <summary>
    /// Rule DBR-002
    /// </summary>
    public class DeliverableNotValidForFundingStreamPeriodRule : IRule<contractRequestType>
    {
        private IDictionary<string, FSCDeliverableStructureDefinitionResponse> _deliverableStructureDefinition;

        public DeliverableNotValidForFundingStreamPeriodRule(IDictionary<string, FSCDeliverableStructureDefinitionResponse> deliverableData)
        {
            _deliverableStructureDefinition = deliverableData;
        }

        public string ErrorMessage
        {
            get { return ErrorMessages.DeliverableNotValidForFundingStreamPeriod; }
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
                    if (!DeliverableUtils.IsValidDeliverableForFundingStreamPeriod(_deliverableStructureDefinition.FirstOrDefault(d => d.Key == allocation.fundingStreamPeriodCode).Value, deliverable))
                    {
                        correlationIds.Add(deliverable.correlationId);
                    }
                }
            }

            return correlationIds;
        }
    }
}
