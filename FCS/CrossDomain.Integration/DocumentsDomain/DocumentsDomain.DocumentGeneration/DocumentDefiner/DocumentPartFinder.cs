namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DocumentPartCreators.Appendix1;
    using IoC;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Appendix2;

    public class DocumentPartFinder : IDocumentPartFinder
    {
        private static readonly IReadOnlyCollection<string> FundingTypeCodesForSOFOnlyConsideration = new List<string> { "EDSK" };
        private static readonly IReadOnlyCollection<string> FundingStreamCodesForSOFOnlyConsideration = new List<string> { "SBPS" };
        public DocumentPartCreator[] GetDocumentPartCreators(contractType contract)
        {
            if (ShouldWeOnlyProduceEdskSummaryOfFunding(contract))
            {
                return new DocumentPartCreator[] { WindsorInstallerForDocumentGenerator.Container.Resolve<EdskSummaryOfFundingDocumentPartCreator>() };
            }
            else if (ShouldWeOnlyProduceEdskSummaryOfFundingAndFA(contract))
            {
                return new DocumentPartCreator[] { WindsorInstallerForDocumentGenerator.Container.Resolve<EdskSummaryOfFundingDocumentPartCreator>() ,
                WindsorInstallerForDocumentGenerator.Container.Resolve<Appendix2DocumentCreator>() };
            }
            return WindsorInstallerForDocumentGenerator.Container.ResolveAll<DocumentPartCreator>();
        }

        public IDocumentHeaderCreator[] GetDocumentHeaderCreators()
        {
            return WindsorInstallerForDocumentGenerator.Container.ResolveAll<IDocumentHeaderCreator>();
        }

        private static bool ShouldWeOnlyProduceEdskSummaryOfFunding(contractType contract)
        {
            return FundingTypeCodesForSOFOnlyConsideration.Contains(contract.fundingType.fundingTypeCode) &&
                   contract.IsNonFinancialAmendment.GetValueOrDefault() &&
                   (contract.IsPeriod("1920") || contract.IsNotification);

        }
        private static bool ShouldWeOnlyProduceEdskSummaryOfFundingAndFA(contractType contract)
        {
            if (contract.contractAllocations.Any())
            {
                return FundingTypeCodesForSOFOnlyConsideration.Contains(contract.fundingType.fundingTypeCode) &&
                      FundingStreamCodesForSOFOnlyConsideration.Contains(contract.contractAllocations.FirstOrDefault().fundingStream.fundingStreamCode);
            }
            return false;
        }
    }
}
