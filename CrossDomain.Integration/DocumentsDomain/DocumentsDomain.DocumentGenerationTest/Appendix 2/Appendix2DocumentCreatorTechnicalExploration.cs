namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Appendix_2
{
    using System;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Messages.Commands;
    using DataStore;
    using DataStore.Repositories;
    using DocumentDefiner.DocumentConfiguration;
    using DocumentDefiner.DocumentPartCreators.Appendix2;
    using Integration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using UnitTests.Common;

    [TestClass]
    public class Appendix2DocumentCreatorTechnicalExploration
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void Appendix2DocumentCreator_ShouldCall_SupplyDocumentGenerationRequest_WithoutError()
        {
            using (var context = new DocumentsDomainDbContext())
            {
                Appendix2DocumentCreator creator = new Appendix2DocumentCreator(Mock.Of<ITemplateRepository>(),
                    new DocumentConfigurationSource(
                        new FundingStreamPeriodRepository(context), 
                        new FspDeliverableRepository(context), new FundingTypeFundingPeriodRepository(context)),
                        new FundingStreamPeriodRepository(context));

                contractType contract = GetContractFromMessageInFile();

                var x = creator.SupplyDocumentGenerationRequest("", contract, "");
            }
            
        }

        private contractType GetContractFromMessageInFile()
        {
            return TestResource.FromJson<DocumentGenerationCommand>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests",
                "Resources.DocGenCommandDeliveryOrg.json").CorporateContract;
        }
    }
}
