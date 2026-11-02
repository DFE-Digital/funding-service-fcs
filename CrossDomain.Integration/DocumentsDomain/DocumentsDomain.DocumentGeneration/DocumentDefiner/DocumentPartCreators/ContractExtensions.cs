namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators
{
    internal static class ContractExtensions
    {
        public static ContractIntent GetIntent(this CrossDomain.Integration.Entities.CorporateContract.contractType contract)
        {
            if (contract.IsNewRevisedNewOrUpdateDraft)
            {
                return ContractIntent.IsNewRevisedNewOrUpdateDraft;
            }

            if (contract.IsAmendment)
            {
                return ContractIntent.IsAmendment;
            }

            if (contract.IsNewAmendment)
            {
                return ContractIntent.IsNewAmendment;
            }

            return ContractIntent.NotSet;
        }
    }
}
