namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using DocumentDefiner.DocumentPartCreators;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore.Repositories;
    using DocumentDefiner.DocumentConfiguration;
    using Integration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using System;
    using System.Collections.Generic;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Common.Models;
    using ContractManagement.DataStore;
    using DataStore;
    using DataStore.Models;
    using DocumentGeneration.Services;
    using Framework.Logging;
    using IoC;

    [TestClass]
    public class Schedule3DocumentPartCreatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void Schedule3DocumentPartCreator_IsDocumentPartRequired_ShouldReturnTrueWhenFundingTypeIsEdskAndIsNewRevisedNewOrUpdateDraftIsTrue()
        {
            // arrange
            Schedule3DocumentPartCreator creator = new Schedule3DocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IContractDocumentTemplateRepository>(),
                Mock.Of<ITemplateVersionChecker>());

            // act
            bool isDocumentPartRequired = creator.IsDocumentPartRequired(new contractType
            {
                IsNewRevisedNewOrUpdateDraft = true,
                fundingType = new fundingType
                {
                    fundingTypeCode = "EDSK",
                }
            });

            // assert
            Assert.IsTrue(isDocumentPartRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Schedule3DocumentPartCreator_SupplyDocumentGenerationRequest_ShouldReturnDocumentGenerationRequestWithOne()
        {
            // arrange
            var documentTemplateRepositoryMock = new Mock<IFspGroupDocumentTemplateRepository>();
            documentTemplateRepositoryMock
                .Setup(m => m.GetByKeyOrUseDefaultForContractType(It.IsAny<string>(), It.IsAny<string>(),
                    It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FspGroupDocumentTemplate(string.Empty, string.Empty, string.Empty,
                    string.Empty, string.Empty, string.Empty));

            var templateRepositoryMock = new Mock<ITemplateRepository>();
            templateRepositoryMock
                .Setup(m => m.GetNameOfTemplateActiveOnDate(string.Empty, string.Empty,
                    DateTime.Now))
                .Returns(string.Empty);

            var templateVersionCheckerMock = new Mock<ITemplateVersionChecker>();
            templateVersionCheckerMock
                .Setup(c => c.ShouldIncludeTemplate(It.IsAny<string>(), It.IsAny<DateTime?>(), It.IsAny<bool>()))
                .Returns(true);

            var contractDocumentTemplateRepositoryMock = new Mock<IContractDocumentTemplateRepository>();
            contractDocumentTemplateRepositoryMock.Setup(m => m.GetByKey(
                    It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new ContractDocumentTemplate("", "", "", "", ""));

            var creator = new Schedule3DocumentPartCreator(
                templateRepositoryMock.Object,
                Mock.Of<IDocumentConfigurationSource>(),
                contractDocumentTemplateRepositoryMock.Object,
                templateVersionCheckerMock.Object);

            // act
            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests =
                creator.SupplyDocumentGenerationRequest(
                    string.Empty, new contractType(), string.Empty);

            // assert
            Assert.IsNotNull(documentGenerationRequests, "Unexpected null result returned");
            Assert.AreEqual(1, documentGenerationRequests.Count,
                "Unexpected number of DocumentGenerationRequest instances returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Schedule3DocumentPartCreator_SupplyDocumentGenerationRequest_ShouldReturnDocumentGenerationRequestWithNone()
        {
            // arrange
            var documentTemplateRepositoryMock = new Mock<IFspGroupDocumentTemplateRepository>();
            documentTemplateRepositoryMock
                .Setup(m => m.GetByKeyOrUseDefaultForContractType(It.IsAny<string>(), It.IsAny<string>(),
                    It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FspGroupDocumentTemplate(string.Empty, string.Empty, string.Empty,
                    string.Empty, string.Empty, string.Empty));

            var templateRepositoryMock = new Mock<ITemplateRepository>();
            templateRepositoryMock
                .Setup(m => m.GetNameOfTemplateActiveOnDate(string.Empty, string.Empty,
                    DateTime.Now))
                .Returns(string.Empty);

            var templateVersionCheckerMock = new Mock<ITemplateVersionChecker>();
            templateVersionCheckerMock
                .Setup(c => c.ShouldIncludeTemplate(It.IsAny<string>(), It.IsAny<DateTime?>(), It.IsAny<bool>()))
                .Returns(false);

            var contractDocumentTemplateRepositoryMock = new Mock<IContractDocumentTemplateRepository>();
            contractDocumentTemplateRepositoryMock.Setup(m => m.GetByKey(
                    It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new ContractDocumentTemplate("", "", "", "", ""));

            var creator = new Schedule3DocumentPartCreator(
                templateRepositoryMock.Object,
                Mock.Of<IDocumentConfigurationSource>(),
                contractDocumentTemplateRepositoryMock.Object,
                templateVersionCheckerMock.Object);

            // act
            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests =
                creator.SupplyDocumentGenerationRequest(
                    string.Empty, new contractType(), string.Empty);

            // assert
            Assert.IsNotNull(documentGenerationRequests, "Unexpected null result returned");
            Assert.AreEqual(0, documentGenerationRequests.Count,
                "Unexpected number of DocumentGenerationRequest instances returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Schedule3DocumentPartCreator_IsDocumentPartRequired_ShouldReturnTrueWhenPeriodIsNot1920AndVariation()
        {
            // arrange

            Schedule3DocumentPartCreator creator = new Schedule3DocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IContractDocumentTemplateRepository>(),
                Mock.Of<ITemplateVersionChecker>());

            // act
            bool isRequired = creator.IsDocumentPartRequired(new contractType
                {
                    fundingType = new fundingType
                    {
                        fundingTypeCode = "EDSK"
                    },
                    IsNewRevisedNewOrUpdateDraft = false,
                    period = new Period
                    {
                        period1 = "2021"
                    },
                    IsVariation = true
                });

            // assert
            Assert.IsTrue(isRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Schedule3DocumentPartCreator_IsDocumentPartRequired_ShouldFalseTrueWhenPeriodIsNot1920AndVariation()
        {
            // arrange

            Schedule3DocumentPartCreator creator = new Schedule3DocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IContractDocumentTemplateRepository>(),
                Mock.Of<ITemplateVersionChecker>());

            // act
            bool isRequired = creator.IsDocumentPartRequired(new contractType
            {
                fundingType = new fundingType
                {
                    fundingTypeCode = "EDSK"
                },
                IsNewRevisedNewOrUpdateDraft = false,
                period = new Period
                {
                    period1 = "2021"
                },
                IsVariation = false
            });

            // assert
            Assert.IsFalse(isRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Schedule3DocumentPartCreator_ShouldResolve()
        {
            IWindsorContainer container = WindsorInstallerForDocumentGenerator.Container;
            container.BeginScope();

            // act
            var docPartCreator = container.Resolve<Schedule3DocumentPartCreator>();

            Assert.IsNotNull(docPartCreator);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Schedule3DocumentPartCreator_IsDocumentPartRequired_ShouldReturnTrueWhenFundingTypeIsDadaAndIsNewRevisedNewOrUpdateDraftIsTrue()
        {
            // arrange
            Schedule3DocumentPartCreator creator = new Schedule3DocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IContractDocumentTemplateRepository>(),
                Mock.Of<ITemplateVersionChecker>());

            // act
            bool isDocumentPartRequired = creator.IsDocumentPartRequired(new contractType
            {
                fundingType = new fundingType
                {
                    fundingTypeCode = "DADA",
                },
                period = new Period
                {
                    period1 = "2021"
                },
                IsNewRevisedNewOrUpdateDraft = true,
            });

            // assert
            Assert.IsTrue(isDocumentPartRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Schedule3DocumentPartCreator_IsDocumentPartRequired_ShouldReturnTrueWhenFundingTypeIsDadaAndIsVariationAmendment()
        {
            // arrange
            Schedule3DocumentPartCreator creator = new Schedule3DocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IContractDocumentTemplateRepository>(),
                Mock.Of<ITemplateVersionChecker>());

            // act
            bool isDocumentPartRequired = creator.IsDocumentPartRequired(new contractType
            {
                fundingType = new fundingType
                {
                    fundingTypeCode = "DADA",
                },
                period = new Period
                {
                    period1 = "2021"
                },
                IsAmendment = true,
                IsVariation = true,
            });

            // assert
            Assert.IsTrue(isDocumentPartRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Schedule3DocumentPartCreator_IsDocumentPartRequired_ShouldReturnFalseWhenFundingTypeIsDadaAndIsNotificationAmendment()
        {
            // arrange

            Schedule3DocumentPartCreator creator = new Schedule3DocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IContractDocumentTemplateRepository>(),
                Mock.Of<ITemplateVersionChecker>());

            // act
            bool isRequired = creator.IsDocumentPartRequired(new contractType
            {
                fundingType = new fundingType
                {
                    fundingTypeCode = "DADA",
                },
                period = new Period
                {
                    period1 = "2021"
                },
                IsAmendment = true,
                IsVariation = false,
            });

            // assert
            Assert.IsFalse(isRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Schedule3DocumentPartCreator_IsDocumentPartRequired_ShouldReturnTrueWhenFundingTypeIs19TRN2020()
        {
            // arrange

            Schedule3DocumentPartCreator creator = new Schedule3DocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IContractDocumentTemplateRepository>(),
                Mock.Of<ITemplateVersionChecker>());

            // act
            bool isRequired = creator.IsDocumentPartRequired(new contractType
            {
                fundingType = new fundingType
                {
                    fundingTypeCode = "19TRN2020",
                },
                IsNewRevisedNewOrUpdateDraft = true
            });

            // assert
            Assert.IsTrue(isRequired);
        }
    }
}