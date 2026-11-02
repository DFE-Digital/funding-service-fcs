namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// UDC-023. An Update Draft Amendment cannot delete an allocation from an existing Approved contract.
    /// </summary>
    public class UpdateDraftAmendmentCannotDeleteApprovedAllocationRule : IRule<contractRequestType>
    {
        public string ErrorMessage
        {
            get { return ValidationRuleErrorMessages.UpdateDraftAmendmentCannotDeleteApprovedAllocation; }
        }

        public errorInfoTypeLevel ErrorLevel
        {
            get { return errorInfoTypeLevel.Allocation; }
        }
        
        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            var failures = new List<string>();

            itemToValidate.contract.contracts.ForEach(c =>
            {
                failures.AddRange(
                    c.contractAllocations
                        .Where(a => a.CRMIntent == intent.DeleteDraftAmendment || a.CRMIntent == intent.DeleteDraft)
                        .Where(a => c.ApprovedAllocationValues.Any(aav => aav.ContractAllocationNumber.Equals(a.contractAllocationNumber, StringComparison.OrdinalIgnoreCase)))
                        .Select(a => a.correlationId));
            });

            return failures;
        }
    }
}