
namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using System;
    using System.Collections.Generic;
    using Aspose.Words;
    using FluentAssertions;
    using Common.Commands;
    using Common.Models;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DocumentCreator;
    using DocumentDefiner;
    using DocumentDefiner.DocumentConfiguration;
    using DocumentMerger;
    using DocumentLocationResolver;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using ContractManagement.DataStore.Repositories;

    [TestClass]
    public class DocumentGeneratorTest
    {
        private Mock<ICorporateContractValidator> _corporateContractValidatorMock = null;
        private Mock<IDocumentDefiner> _documentDefiner = null;
        private Mock<IDocumentCreator> _documentCreator = null;
        private Mock<IDocumentMerger> _documentMerger = null;
        private Mock<IDocumentLocationResolver> _documentLocationResolver = null;
        private Mock<IDocumentConfigurationSource> _documentConfigurationSource;
        private Mock<IFundingTypeFundingPeriodQueryRepository> _fundingTypeFundingPeriodQueryRepository;
        private IDocumentGenerator _documentGenerator = null;

        [TestInitialize]
        public void Initialize()
        {
            _corporateContractValidatorMock = new Mock<ICorporateContractValidator>();
            _corporateContractValidatorMock.Setup(m => m.Validate(It.IsAny<Contract>())).Returns<string>(null).Verifiable();

            _documentDefiner = new Mock<IDocumentDefiner>();
            _documentCreator = new Mock<IDocumentCreator>();
            _documentMerger = new Mock<IDocumentMerger>();
            _documentLocationResolver = new Mock<IDocumentLocationResolver>();
            _fundingTypeFundingPeriodQueryRepository = new Mock<IFundingTypeFundingPeriodQueryRepository>();

            _documentGenerator = new DocumentGenerator(
                _corporateContractValidatorMock.Object,
                _documentDefiner.Object,
                _documentCreator.Object,
                _documentMerger.Object,
                _documentLocationResolver.Object,
                _fundingTypeFundingPeriodQueryRepository.Object);
        }

        [TestMethod]
        [TestCategory("UnitTest")]
        public void TestDocumentGeneratorWithFailedValidation()
        {
            const string failedValidationString = "Failed Validation";

            var masterContract = new Contract
            {
                contracts = new List<contractType>
        {
            new Contract()
        }
            };

            _corporateContractValidatorMock
                .Setup(m => m.Validate(It.IsAny<Contract>()))
                .Returns(failedValidationString);

            Action act = () => _documentGenerator.GenerateDocument("", masterContract, "");

            act.Should()
               .Throw<ArgumentException>()
               .WithMessage(failedValidationString);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentGenerator_CreatesDocument_WithOneDocumentPartInDocument()
        {
            _documentDefiner.Setup(m => m.GetDocumentParts(It.IsAny<string>(), It.IsAny<contractType>())).Returns(new DocumentGenerationRequest[]
            {
                new DocumentGenerationRequest()
                {
                    MergeData = new DocumentGenerationRequestMergeData(),
                    TemplateContainer = "template-container",
                    TemplateFilename = "template-filename"
                }
            }).Verifiable();

            _documentDefiner.Setup(m => m.GetTargetFileName(It.IsAny<Contract>())).Returns(new FctFile("target-container", "target-filename")).Verifiable();

            _documentDefiner.Setup(m => m.GetContractDetails(It.IsAny<Contract>())).Returns(new ContractIdentificationDetails()
            {
                UKPRN = 1,
                ContractNumber = "SFA-1234",
                ContractVersionNumber = 99
            });

            _documentCreator.Setup(m => m.CreateDocument(It.IsAny<DocumentGenerationRequest>()))
                .Returns((DocumentGenerationRequest request) =>
                    new Document())
                .Verifiable();

            _documentMerger.Setup(m => m.MergeDocuments(It.IsAny<DocumentConvertRequest>()))
                .Returns((DocumentConvertRequest request) => new byte[1])
                .Verifiable();

            var fundingTypeFundingPeriod = new ContractManagement.DataStore.Model.FundingTypeFundingPeriod()
            {
                FundingTypeCode = "LEVY",
                FundingPeriodName = "LEVY1799",
                DocumentsRequired = true
            };

            _fundingTypeFundingPeriodQueryRepository.Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>())).Returns(fundingTypeFundingPeriod);

            Contract masterContract = new Contract()
            {
                contracts = new List<contractType>()
                {
                    new Contract()
                }
            };

            DocumentSaveCommand details = _documentGenerator.GenerateDocument("", masterContract, "");

            Assert.AreEqual("1", details.UKPRN);
            Assert.AreEqual("SFA-1234", details.ContractNumber);
            Assert.AreEqual(99, details.ContractVersionNumber);
            _documentDefiner.Verify(m => m.GetDocumentParts(It.IsAny<string>(), It.IsAny<contractType>()), Times.Once);
            _documentDefiner.Verify(m => m.GetTargetFileName(It.IsAny<Contract>()), Times.Once);
            _documentCreator.Verify(m => m.CreateDocument(It.IsAny<DocumentGenerationRequest>()), Times.Once);
            _documentMerger.Verify(m => m.MergeDocuments(It.IsAny<DocumentConvertRequest>()), Times.Once);

        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentCreator_DoesNotCreateADocumen_WhenNoDocumentPartsAreSelected()
        {
            // Arrange
            _documentDefiner
                .Setup(m => m.GetContractDetails(It.IsAny<Contract>()))
                .Returns<Contract>(m => new ContractIdentificationDetails() { ContractNumber = "SFA-1234", ContractVersionNumber = 1, UKPRN = 12345678 })
                .Verifiable();

            _documentDefiner
                .Setup(m => m.GetDocumentParts(It.IsAny<string>(), It.IsAny<contractType>()))
                .Returns(new DocumentGenerationRequest[0])
                .Verifiable();

            _documentMerger
                .Setup(m => m.MergeDocuments(It.IsAny<DocumentConvertRequest>()))
                .Returns(new byte[0])
                .Verifiable();

            var fundingTypeFundingPeriod = new ContractManagement.DataStore.Model.FundingTypeFundingPeriod()
            {
                FundingTypeCode = "LEVY",
                FundingPeriodName = "LEVY1799",
                DocumentsRequired = true
            };

            _fundingTypeFundingPeriodQueryRepository.Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>())).Returns(fundingTypeFundingPeriod).Verifiable();

            Contract masterContract = new Contract()
            {
                contracts = new List<contractType>()
                {
                    new Contract() { period = new Period() }
                }
            };

            DocumentSaveCommand details = _documentGenerator.GenerateDocument("", masterContract, "");

            // Assert
            _fundingTypeFundingPeriodQueryRepository.Verify(m => m.Get(It.IsAny<string>(), It.IsAny<string>()), Times.Once);
            _documentDefiner.Verify(m => m.GetDocumentParts(It.IsAny<string>(), It.IsAny<contractType>()), Times.Once);
            _documentMerger.Verify(m => m.MergeDocuments(It.IsAny<DocumentConvertRequest>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentCreator_DoesNotGenerateADocument_WhenNotRequired()
        {
            // Arrange
            _documentDefiner
                .Setup(m => m.GetContractDetails(It.IsAny<Contract>()))
                .Returns<Contract>(m => new ContractIdentificationDetails()
                {
                    ContractNumber = "EOP-1234",
                    ContractVersionNumber = 1,
                    UKPRN = 12345678
                })
                .Verifiable();

            _documentDefiner
                .Setup(m => m.GetDocumentParts(It.IsAny<string>(), It.IsAny<contractType>()))
                .Returns(new DocumentGenerationRequest[0])
                .Verifiable();

            _documentMerger
                .Setup(m => m.MergeDocuments(It.IsAny<DocumentConvertRequest>()))
                .Returns(new byte[0])
                .Verifiable();

            var fundingTypeFundingPeriod = new ContractManagement.DataStore.Model.FundingTypeFundingPeriod()
            {
                FundingTypeCode = "LEVY",
                FundingPeriodName = "LEVY1799",
                DocumentsRequired = false
            };

            _fundingTypeFundingPeriodQueryRepository.Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>())).Returns(fundingTypeFundingPeriod).Verifiable();

            Contract masterContract = new Contract()
            {
                contracts = new List<contractType>()
                {
                    new Contract() { period = new Period() }
                }
            };

            var details = _documentGenerator.GenerateDocument("", masterContract, "");

            // Assert
            _fundingTypeFundingPeriodQueryRepository.Verify(m => m.Get(It.IsAny<string>(), It.IsAny<string>()), Times.Once);
            _documentDefiner.Verify(m => m.GetDocumentParts(It.IsAny<string>(), It.IsAny<contractType>()), Times.Never);
            _documentMerger.Verify(m => m.MergeDocuments(It.IsAny<DocumentConvertRequest>()), Times.Never);

            Assert.IsNull(details, "Document should be null");
        }
    }
}