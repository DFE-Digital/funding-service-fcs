namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Appendix_2
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore.Repositories;
    using DocumentDefiner.DocumentConfiguration;
    using DocumentDefiner.DocumentPartCreators.Appendix2;
    using Integration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    [TestClass]
    public class EsfRound1Appendix2DocumentCreatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void EsfRound1Appendix2DocumentPartCreator_IsDocumentPartRequired_ShouldReturnTrueForRound1()
        {
            // arrange
            Contract contract = new Contract
            {
                fundingType = new fundingType
                {
                    fundingTypeCode = "ESF"
                },
                contractNumber = "ESIF-2999"
            };

            EsfRound1Appendix2DocumentCreator creator = new EsfRound1Appendix2DocumentCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>());
            // act

            var isRequired = creator.IsDocumentPartRequired(contract);

            // assert
            Assert.AreEqual(true, isRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Appendix2DocumentCreator_IsDocumentPartRequired_ShouldReturnFalseForRound1()
        {
            // arrange
            Contract contract = new Contract
            {
                fundingType = new fundingType
                {
                    fundingTypeCode = "ESF"
                },
                contractNumber = "ESIF-2999",
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation()
                }
            };

            Mock<IDocumentConfigurationSource> docConfigurationSourceMock = new Mock<IDocumentConfigurationSource>();
            docConfigurationSourceMock.Setup(r =>
                    r.IsFundingAgreementRequiredForAllocation(It.IsAny<contractAllocationsContractAllocation>()))
                .Returns(true);

            Appendix2DocumentCreator creator = new Appendix2DocumentCreator(
                Mock.Of<ITemplateRepository>(),
                docConfigurationSourceMock.Object,
                Mock.Of<IFundingStreamPeriodRepository>());
            // act

            var isRequired = creator.IsDocumentPartRequired(contract);

            // assert
            Assert.AreEqual(false, isRequired);
        }
    }
}
