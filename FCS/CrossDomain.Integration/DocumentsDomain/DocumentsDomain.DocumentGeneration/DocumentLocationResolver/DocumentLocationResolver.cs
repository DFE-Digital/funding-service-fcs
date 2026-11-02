namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentLocationResolver
{
    using static CrossDomain.Integration.Common.CommonUtil;
    using CrossDomain.Integration.Entities.CorporateContract;
    using Framework.Logging.Interfaces;
    using Framework.Logging.NullObjects;

    public class DocumentLocationResolver : IDocumentLocationResolver
    {
        public DocumentLocationResolver()
        {
            Logger = new LoggerNullObject();
        }

        public ILogger Logger { get; set; }

        public string GetLocationOfAppendices(contractType contract)
        {
            return ResolveTokenisedListName(ContractAppendicesFolderName, contract);
        }

        public string GetLocationOfTermsAndConditions(contractType contract)
        {
            return ResolveTokenisedListName(ContractTermsAndConditionsFolderName, contract);
        }

        public string GetLocationOfMergedDocument(contractType contract)
        {
            return ResolveTokenisedListName(ContractMergedDocumentFolderName, contract);
        }

        public string GetLocationOfPublishedDocument(contractType contract)
        {
            return ResolveTokenisedListName(ContractPublishedDocumentFolderName, contract);
        }
       
        private string ResolveTokenisedListName(string tokenisedListName, contractType contract)
        {
            string listName = tokenisedListName.Replace("{FundingType}", contract.fundingType.fundingTypeCode);

            listName = listName.Replace("{Period}", contract.period.period1);

            return listName;
        }
    }
}
