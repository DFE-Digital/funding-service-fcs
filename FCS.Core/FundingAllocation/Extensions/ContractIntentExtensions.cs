namespace FundingAllocation.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public static class ContractIntentExtensions
    {
        private static readonly IEnumerable<ContractIntent> AmendmentIntents = new List<ContractIntent>
        {
            ContractIntent.UpdateDraftAmendment, ContractIntent.Amendment
        };

        private static readonly List<ContractIntent> IntentsThatDoNotRequireExistingContract = new List<ContractIntent>
        {
            ContractIntent.New
        };

        public static bool DoesNotRequiresExistingContractInfo(this ContractIntent contractIntent)
        {
            return IntentsThatDoNotRequireExistingContract.Contains(contractIntent);
        }

        public static bool IsAmendment(this ContractIntent contractIntent)
        {
            return AmendmentIntents.Contains(contractIntent);
        }
    }
}
