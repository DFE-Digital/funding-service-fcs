namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using System.Linq;
    using Implementation.Persistence.Entities;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Entities;

    /// <summary>
    /// CABR-013
    /// </summary>
    public class AllocationTenderAwardReferenceMustBeUniqueOrUnchanged : IRule<contractRequestType>
    {
        private readonly IReadOnlyCollection<MatchingTenderAwardReferenceItem> _matchingTenderAwardReferenceItems;

        public AllocationTenderAwardReferenceMustBeUniqueOrUnchanged(IReadOnlyCollection<MatchingTenderAwardReferenceItem> matchingTenderAwardReferenceItems)
        {
            _matchingTenderAwardReferenceItems = matchingTenderAwardReferenceItems;
        }

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;

        public string ErrorMessage => ErrorMessages.TenderAwardReferenceMustBeUniqueOrUnchanged;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate.GetAllocations().Where(IsTenderAwardReferenceNotUniqueOrUnchanged).Select(a => a.correlationId);
        }

        private bool IsTenderAwardReferenceNotUniqueOrUnchanged(contractAllocation allocation)
        {
            if (ESFFundingStreams.FundingStreams.Contains(allocation.fundingStreamCode))
            {
                return
                    !_matchingTenderAwardReferenceItems.Any(m => m.AllocationNumber == allocation.contractAllocationNumber && m.TenderAwardReference == allocation.tenderAwardReference)
                    && (string.IsNullOrWhiteSpace(allocation.tenderAwardReference) || _matchingTenderAwardReferenceItems.Any(m => m.TenderAwardReference == allocation.tenderAwardReference));
            }

            return !string.IsNullOrWhiteSpace(allocation.tenderAwardReference);
        }
    }
}
