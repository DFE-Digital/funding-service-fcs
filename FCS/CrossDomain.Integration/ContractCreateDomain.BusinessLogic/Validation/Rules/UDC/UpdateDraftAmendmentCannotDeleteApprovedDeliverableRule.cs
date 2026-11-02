namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// UDC-024. An Update Draft Amendment cannot delete a deliverable from an existing Approved contract.
    /// </summary>
    public class UpdateDraftAmendmentCannotDeleteApprovedDeliverableRule : IRule<contractRequestType>
    {
        public string ErrorMessage
        {
            get { return ValidationRuleErrorMessages.UpdateDraftAmendmentCannotDeleteApprovedDeliverable; }
        }

        public errorInfoTypeLevel ErrorLevel
        {
            get { return errorInfoTypeLevel.Deliverable; }
        }
        
        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            var failures = new List<string>();

            itemToValidate.contract.contracts.ForEach(c =>
            {
                c.contractAllocations.ForEach(a =>
                {
                    var approvedAllocation = c.ApprovedAllocationValues.SingleOrDefault(aav =>
                        aav.ContractAllocationNumber.Equals(a.contractAllocationNumber, StringComparison.OrdinalIgnoreCase));

                    if (approvedAllocation != null)
                    {
                        failures.AddRange(
                            a.contractDeliverables
                            .Where(d => d.CRMIntent == intent.DeleteDraftAmendment || d.CRMIntent == intent.DeleteDraft)
                            .Where(d => approvedAllocation.DeliverableCodes.Any(dc => dc == d.deliverable.deliverableCode))
                            .Select(d => d.correlationId));
                    }
                });
            });

            return failures;
        }
    }
}