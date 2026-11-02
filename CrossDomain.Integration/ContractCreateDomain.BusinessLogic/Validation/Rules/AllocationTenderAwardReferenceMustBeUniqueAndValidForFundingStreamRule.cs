namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.ContractRequest;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities;
    using Implementation.Persistence.Entities;

    /// <summary>
    /// CABR-013
    /// </summary>
    public class AllocationTenderAwardReferenceMustBeUniqueAndValidForFundingStreamRule : IRule<contractRequestType>
    {
        private readonly IReadOnlyCollection<MatchingTenderAwardReferenceItem> _matchingTenderAwardReferenceItems;

        public AllocationTenderAwardReferenceMustBeUniqueAndValidForFundingStreamRule(IReadOnlyCollection<MatchingTenderAwardReferenceItem> matchingTenderAwardReferenceItems)
        {
            _matchingTenderAwardReferenceItems = matchingTenderAwardReferenceItems;
        }

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;

        public string ErrorMessage => ErrorMessages.TenderAwardReferenceMustBeUnique;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            string contractNumber = itemToValidate.contract.contracts[0].contractNumber;

            return itemToValidate
                .GetAllocations()
                .Where(a => IsTenderAwardReferenceAlreadyInUseByDifferentAllocation(contractNumber, a.tenderAwardReference) || IsTenderAwardReferenceInvalidForFundingStream(a))
                .Select(a => a.correlationId);
        }

        private bool IsTenderAwardReferenceAlreadyInUseByDifferentAllocation(string importContractNumber, string importTenderAwardReference)
        {
            return _matchingTenderAwardReferenceItems.Any(m => (m.ContractNumber != importContractNumber) && (m.TenderAwardReference == importTenderAwardReference));
        }

        private static bool IsTenderAwardReferenceInvalidForFundingStream(contractAllocation allocation)
        {
            bool isEsfAllocation = ESFFundingStreams.FundingStreams.Contains(allocation.fundingStreamCode);
            bool isTenderAwardReferenceNullOrWhiteSpace = string.IsNullOrWhiteSpace(allocation.tenderAwardReference);

            return isEsfAllocation ? isTenderAwardReferenceNullOrWhiteSpace : !isTenderAwardReferenceNullOrWhiteSpace;
        }
    }
}
