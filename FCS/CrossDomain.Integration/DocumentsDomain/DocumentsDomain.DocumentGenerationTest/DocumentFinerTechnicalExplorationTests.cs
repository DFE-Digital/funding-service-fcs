namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using System.Collections.Generic;
    using Common.Models;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Messages.Commands;
    using DataStore;
    using DataStore.Repositories;
    using DocumentDefiner;
    using DocumentDefiner.DocumentConfiguration;
    using DocumentDefiner.DocumentPartCreators.Appendix2;
    using Integration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using UnitTests.Common;

    [TestClass]
    public class DocumentFinerTechnicalExplorationTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void DocumentDefiner_ShouldGenerateAppendix2ForAllocations()
        {
            // arrange
            Mock<DocumentPartCreator> docCreatorMock = new Mock<DocumentPartCreator>(null, null);
            docCreatorMock.Setup(m => m.IsDocumentPartRequired(It.IsAny<contractType>())).Returns(true);
            docCreatorMock.Setup(m => m.SupplyDocumentGenerationRequest(It.IsAny<string>(), It.IsAny<contractType>(), It.IsAny<string>())).Returns(new Dictionary<string, DocumentGenerationRequest>()
            {
                {"100", new DocumentGenerationRequest()
                    {
                        TemplateContainer = "test-template-container",
                        TemplateFilename = "test-template-filename",
                        MergeData = null
                    }
                }
            });
            docCreatorMock.Setup(m => m.IsHeaderDocumentRequired).Returns(false);

            Mock<IDocumentPartFinder> partFinderMock = new Mock<IDocumentPartFinder>();

            var templateRepository = new TemplateRepository(new AzureStorageWrapper());
            var documentConfigurationSource = new DocumentConfigurationSource(
                new FundingStreamPeriodRepository(new DocumentsDomainDbContext()),
                new FspDeliverableRepository(new DocumentsDomainDbContext()),
                new FundingTypeFundingPeriodRepository(new DocumentsDomainDbContext()));

            var fundingStreamPeriodRepository = new FundingStreamPeriodRepository(new DocumentsDomainDbContext());

            partFinderMock.Setup(m => m.GetDocumentPartCreators(It.IsAny<contractType>())).Returns(new DocumentPartCreator[]
            {
                new Appendix2DocumentCreator(templateRepository, documentConfigurationSource, fundingStreamPeriodRepository)
            });

            contractType contract = GetContractTypeFromFile();
            IDocumentDefiner docDefiner = new DocumentDefiner(partFinderMock.Object);
            DocumentGenerationRequest[] request = docDefiner.GetDocumentParts("", contract);

            // act

            // assert
        }

        private contractType GetContractTypeFromFile()
        {
            return TestResource.FromJson<DocumentGenerationCommand>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests",
                "Resources.DocumentGenerationCommand.json").CorporateContract;
        }
    }
}
