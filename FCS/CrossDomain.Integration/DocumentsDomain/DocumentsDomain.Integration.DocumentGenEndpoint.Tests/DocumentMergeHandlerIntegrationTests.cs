namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenEndpoint.Tests
{
    using System.Collections.Generic;
    using System.IO;
    using Aspose.Pdf;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using CrossDomain.Integration.Common.Storage;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Messages.Commands;
    using DocumentGeneration.ContractDocumentMerger;
    using DocumentGeneration.DocumentDefiner;
    using DocumentGeneration.DocumentLocationResolver;
    using DocumentGenerationEndpoint.DocumentMergeEndpoint;
    using Framework.Logging.Interfaces;
    using NServiceBus.Testing;

    [TestClass]
    public class DocumentMergeHandlerIntegrationTests
    {
        private Mock<ILogger> _logger;
        private IContractDocumentManager _contractDocumentManager;
        private IDocumentDefiner _docDefiner;
        private IDocumentLocationResolver _documentLocationResolver;
        private IOffice365Adapter _officeAdapter;
        private IPdfMerger _pdfMerger;

        private string _fundingTypeCode;
        private string _period;


        [TestInitialize]
        public void Initialise()
        {
            _logger = new Mock<ILogger>();
            _officeAdapter = new Office365StorageWrapper {Logger = _logger.Object};
            _pdfMerger = new PdfMerger();
            _documentLocationResolver = new DocumentLocationResolver {Logger = _logger.Object};
            _docDefiner = new DocumentDefiner(new DocumentPartFinder()) {Logger = _logger.Object};
            _contractDocumentManager = new ContractDocumentManager(_docDefiner, _documentLocationResolver,
                _officeAdapter, _pdfMerger);
            CleanUp();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Test_Handle_EnsureHandlerMergesDocumentation_AndUploadsMergedDoc()
        {
            _fundingTypeCode = "Main";
            _period = "1516";

            _officeAdapter.UploadFile("11111_Main-1234_v1.pdf", Properties.Resources._11111_Main_1234_v1,
                $"{_fundingTypeCode}-{_period}-Input-Appendices");
            _officeAdapter.UploadFile("11111_Main-1234_49.pdf", Properties.Resources._11111_Main_1234_49,
                $"{_fundingTypeCode}-{_period}-Input-Terms And Conditions");
            _officeAdapter.UploadFile("11111_Main-1234_51.pdf", Properties.Resources._11111_Main_1234_51,
                $"{_fundingTypeCode}-{_period}-Input-Terms And Conditions");

            var message = CreateDocumentMergeCommand();

            var handler = new DocumentMergeHandler(_contractDocumentManager, _logger.Object);

            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            Assert.IsTrue(_officeAdapter.DoesFileExist($"{_fundingTypeCode}-{_period}-Output-Merged Document",
                "11111_Main-1234_v1.pdf"));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Test_Handle_EnsureHandlerMergesDocumentation_AndIsAbleToOverwrite()
        {
            _fundingTypeCode = "Main";
            _period = "1516";

            _officeAdapter.UploadFile("11111_Main-1234_v1.pdf", Properties.Resources._11111_Main_1234_v1,
                $"{_fundingTypeCode}-{_period}-Input-Appendices");
            _officeAdapter.UploadFile("11111_Main-1234_51.pdf", Properties.Resources._11111_Main_1234_51,
                $"{_fundingTypeCode}-{_period}-Input-Terms And Conditions");

            var message = CreateDocumentMergeCommand();

            var handler = new DocumentMergeHandler(_contractDocumentManager, _logger.Object);

            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            AssertDocExistsWithNumberOfPages(2);

            _officeAdapter.UploadFile("11111_Main-1234_49.pdf", Properties.Resources._11111_Main_1234_49,
                $"{_fundingTypeCode}-{_period}-Input-Terms And Conditions");

            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            AssertDocExistsWithNumberOfPages(3);
        }

        private void AssertDocExistsWithNumberOfPages(int expectedNoOfPages)
        {
            Assert.IsTrue(_officeAdapter.DoesFileExist($"{_fundingTypeCode}-{_period}-Output-Merged Document",
                "11111_Main-1234_v1.pdf"));

            var docPreOverwrite =
                            new Document(
                                new MemoryStream(_officeAdapter.GetFileContents("11111_Main-1234_v1.pdf",
                                    $"{_fundingTypeCode}-{_period}-Output-Merged Document")));

            Assert.AreEqual(docPreOverwrite.Pages.Count, expectedNoOfPages);
        }

        private DocumentMergeCommand CreateDocumentMergeCommand()
        {
            return new DocumentMergeCommand
            {
                CorporateContract = new contract
                {
                    contractNumber = "Sfa-1234",
                    contractor = new contractor { ukprn = 11111 },
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "Main-1234",
                            period = new period {period1 = _period},
                            contractor = new contractor {ukprn = 11111},
                            contractVersionNumber = 1,
                            contractSubVersionNumber = 0,
                            fundingType = new fundingType
                            {
                                fundingTypeCode = _fundingTypeCode
                            },
                            hierarchyType = hierarchyType.CONTRACT
                        }
                    },
                    fundingType = new fundingType
                    {
                        fundingTypeCode = _fundingTypeCode
                    }
                },
                ContractNumberToBeMerged = "Main-1234"
            };
        }

        [TestCleanup]
        public void CleanUp()
        {
            _officeAdapter.DeleteFile("11111_Main-1234_v1.pdf", "MAIN-1516-Input-Appendices");
            _officeAdapter.DeleteFile("11111_Main-1234_49.pdf", "Main-1516-Input-Terms And Conditions");
            _officeAdapter.DeleteFile("11111_Main-1234_51.pdf", "Main-1516-Input-Terms And Conditions");
            _officeAdapter.DeleteFile("11111_Main-1234_v1.pdf", "Main-1516-Output-Merged Document");
        }
    }
}