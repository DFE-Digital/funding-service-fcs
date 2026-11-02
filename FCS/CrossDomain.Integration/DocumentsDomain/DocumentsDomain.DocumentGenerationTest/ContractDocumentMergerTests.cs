namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using System.Linq;
    using System;
    using System.Collections.Generic;
    using Common;
    using Common.Exceptions;
    using ContractDocumentMerger;
    using CrossDomain.Integration.Common.Storage;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DocumentDefiner;
    using DocumentLocationResolver;
    using Moq;
    using Framework.Logging.Interfaces;
    using FctFile = Common.Models.FctFile;
    using CrossDomain.Integration.Common;

    [TestClass]
    public class ContractDocumentMergerTests
    {
        private Mock<IOffice365Adapter> _mockOfficeAdapter;
        private Mock<IDocumentDefiner> _mockDocDefiner;
        private Mock<IDocumentLocationResolver> _mockDocumentLocationResolver;
        private Mock<ILogger> _mockLogger;
        private Mock<IPdfMerger> _mockPdfMerger;
        private ContractDocumentManager _documentManager;
        private string _fileName = "11111_Main-1234_v1.pdf";
        private string _tncFileFilter = "11111_Main-1234";
        private string _fileNameWithoutExtensionAndVersion = "11111_Main-1234";
        private string _appendicesListName = "Main-1516-Input-Appendices";
        private string _tsAndCsListName = "Main-1516-Input-Terms And Conditions";
        private static string _mergedDocumentListName = "Main-1516-Output-Merged Document";
        
        [TestInitialize]
        public void TestInitialise()
        {
            _mockOfficeAdapter = new Mock<IOffice365Adapter>();
            _mockDocDefiner = new Mock<IDocumentDefiner>();
            _mockLogger = new Mock<ILogger>();
            _mockPdfMerger = new Mock<IPdfMerger>();
            _mockDocumentLocationResolver = new Mock<IDocumentLocationResolver>();
            _documentManager = new ContractDocumentManager(_mockDocDefiner.Object, _mockDocumentLocationResolver.Object,
                _mockOfficeAdapter.Object, _mockPdfMerger.Object)
            { Logger = _mockLogger.Object };
        }

        [TestMethod, TestCategory("UnitTest")]
        public void WhenMergeIsCalled_AndAppedicesExist_GetFileContentsIsCalled_WithCorrectParameters()
        {
            var contract = CreateTestContract();

            _mockDocDefiner.Setup(x => x.GetTargetFileName(contract.contracts.First())).Returns(new FctFile(string.Empty, _fileName));
            _mockDocDefiner.Setup(x => x.GetTnCFileNameFilter(contract.contracts.First())).Returns(_tncFileFilter);
            _mockDocumentLocationResolver.Setup(x => x.GetLocationOfAppendices(contract.contracts.First())).Returns(_appendicesListName);
            _mockDocumentLocationResolver.Setup(x => x.GetLocationOfTermsAndConditions(contract.contracts.First())).Returns(_tsAndCsListName);
            _mockDocumentLocationResolver.Setup(x => x.GetLocationOfMergedDocument(contract.contracts.First())).Returns(_mergedDocumentListName);

            _mockOfficeAdapter.Setup(x => x.GetFileContents(_fileName, _appendicesListName)).Returns(new byte[1]);

            _mockOfficeAdapter.Setup(x => x.GetFilesByFileNameStartText(_tsAndCsListName, _fileNameWithoutExtensionAndVersion))
                .Returns(new Dictionary<string, byte[]>
                {
                    {$"{_fileNameWithoutExtensionAndVersion}_49.pdf", new byte[1]}
                });
            _mockPdfMerger.Setup(x => x.MergeDocumentation(It.IsAny<List<KeyValuePair<int, byte[]>>>())).Returns(new byte[1]);

            _documentManager.MergeContractDocuments(contract);

            _mockOfficeAdapter.Verify(x => x.GetFileContents(_fileName, _appendicesListName), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MergeContractDocuments_ShouldGetFileFromCorrectLocationWhenTheMasterAndChildHaveDifferentFundingTypes()
        {
            const string childContractFundingType = "Loans";
            const string childContractPeriod = "1718";
            contract contract = new contract
            {
                fundingType = new fundingType {fundingTypeCode = "24+Loans"},
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        fundingType = new fundingType {fundingTypeCode = childContractFundingType},
                        period = new period {period1 = childContractPeriod}
                    }
                }
            };

            _mockDocDefiner.Setup(x => x.GetTargetFileName(contract.contracts.First())).Returns(new FctFile(string.Empty, _fileName));
            _mockDocDefiner.Setup(x => x.GetTnCFileNameFilter(contract.contracts.First())).Returns(_tncFileFilter);

            _documentManager = new ContractDocumentManager(_mockDocDefiner.Object, new DocumentLocationResolver(), 
                _mockOfficeAdapter.Object, _mockPdfMerger.Object);

            _mockOfficeAdapter.Setup(x => x.GetFileContents(_fileName, _appendicesListName)).Returns(new byte[1]);

            _mockOfficeAdapter.Setup(x => x.GetFilesByFileNameStartText(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new Dictionary<string, byte[]>
                {
                    {$"{_fileNameWithoutExtensionAndVersion}_49.pdf", new byte[1]}
                });
            _mockPdfMerger.Setup(x => x.MergeDocumentation(It.IsAny<List<KeyValuePair<int, byte[]>>>())).Returns(new byte[1]);

            // act
            _documentManager.MergeContractDocuments(contract);

            // assert
            _mockOfficeAdapter.Verify(x => x.GetFileContents(_fileName, $"{childContractFundingType}-{childContractPeriod}-Input-Appendices"), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void WhenMergeIsCalled_AndAppedicesExistButTsAndCsDont_ExceptionIsThrown_WithCorrectMessage()
        {
            var contract = CreateTestContract();

            _mockDocDefiner.Setup(x => x.GetTargetFileName(contract.contracts.First())).Returns(new FctFile(string.Empty, _fileName));
            _mockDocDefiner.Setup(x => x.GetTnCFileNameFilter(contract.contracts.First())).Returns(_tncFileFilter);
            _mockDocumentLocationResolver.Setup(x => x.GetLocationOfAppendices(contract.contracts.First())).Returns(_appendicesListName);
            _mockDocumentLocationResolver.Setup(x => x.GetLocationOfTermsAndConditions(contract.contracts.First())).Returns(_tsAndCsListName);
            _mockDocumentLocationResolver.Setup(x => x.GetLocationOfMergedDocument(contract.contracts.First())).Returns(_mergedDocumentListName);

            _mockOfficeAdapter.Setup(x => x.GetFileContents(_fileName, _appendicesListName)).Returns(new byte[1]);

            _mockOfficeAdapter.Setup(x => x.GetFilesByFileNameStartText(_tsAndCsListName, _fileNameWithoutExtensionAndVersion))
                .Returns(new Dictionary<string, byte[]>());

            _mockPdfMerger.Setup(x => x.MergeDocumentation(It.IsAny<List<KeyValuePair<int, byte[]>>>())).Returns(new byte[1]);
            try
            {
                _documentManager.MergeContractDocuments(contract);
            }
            catch (DocumentMergeException exception)
            {
                var expectedTnCMissingFilesErrorMessage =
                   DocumentMergeReasonForError.DocumentMergeFormattedErrorMessage(
                       DocumentMergeReasonForError.DocumentNotUploaded, contract.contracts.First().contractor.ukprn.ToString(),
                       contract.contracts.First().contractNumber);
                Assert.AreEqual(expectedTnCMissingFilesErrorMessage, exception.Message, "Incorrect exception message thrown");
            }

        }

        [TestMethod, TestCategory("UnitTest")]
        public void WhenMergeIsCalled_AndAppedicesAndTsAndCsExist_UploadFileIsCalled_WithCorrectParameters()
        {
            var contract = CreateTestContract();

            _mockDocDefiner.Setup(x => x.GetTargetFileName(contract.contracts.First())).Returns(new FctFile(string.Empty, _fileName));
            _mockDocDefiner.Setup(x => x.GetTnCFileNameFilter(contract.contracts.First())).Returns(_tncFileFilter);
            _mockDocumentLocationResolver.Setup(x => x.GetLocationOfAppendices(contract.contracts.First())).Returns(_appendicesListName);
            _mockDocumentLocationResolver.Setup(x => x.GetLocationOfTermsAndConditions(contract.contracts.First())).Returns(_tsAndCsListName);
            _mockDocumentLocationResolver.Setup(x => x.GetLocationOfMergedDocument(contract.contracts.First())).Returns(_mergedDocumentListName);
            _mockOfficeAdapter.Setup(x => x.GetFileContents(_fileName, _appendicesListName)).Returns(new byte[1]);

            _mockOfficeAdapter.Setup(
                x => x.GetFilesByFileNameStartText(_tsAndCsListName, _fileNameWithoutExtensionAndVersion))
                .Returns(new Dictionary<string, byte[]> { { _fileNameWithoutExtensionAndVersion + "_49.pdf", new byte[1]} });

            _mockPdfMerger.Setup(x => x.MergeDocumentation(It.IsAny<List<KeyValuePair<int, byte[]>>>()))
                .Returns(new byte[1]);

            _documentManager.MergeContractDocuments(contract);

            _mockOfficeAdapter.Verify(x => x.UploadFileWithOverwrite(_fileName, It.IsAny<byte[]>(), _mergedDocumentListName));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void WhenMergeIsCalled_AndAppedicesExistButTsAndCsExistwithPageNo50_ExceptionIsThrown()
        {
            var contract = CreateTestContract();

            _mockDocDefiner.Setup(x => x.GetTargetFileName(contract.contracts.First())).Returns(new FctFile(string.Empty, _fileName));
            _mockDocDefiner.Setup(x => x.GetTnCFileNameFilter(contract.contracts.First())).Returns(_tncFileFilter);
            _mockDocumentLocationResolver.Setup(x => x.GetLocationOfAppendices(contract.contracts.First())).Returns(_appendicesListName);
            _mockDocumentLocationResolver.Setup(x => x.GetLocationOfTermsAndConditions(contract.contracts.First())).Returns(_tsAndCsListName);
            _mockDocumentLocationResolver.Setup(x => x.GetLocationOfMergedDocument(contract.contracts.First())).Returns(_mergedDocumentListName);

            _mockOfficeAdapter.Setup(x => x.GetFileContents(_fileName, _appendicesListName)).Returns(new byte[1]);

            var tsnCs = new Dictionary<string, byte[]>
            {
                {_tncFileFilter + "_50.pdf", null}
            };
            _mockOfficeAdapter.Setup(x => x.GetFilesByFileNameStartText(_tsAndCsListName, _fileNameWithoutExtensionAndVersion))
                .Returns(tsnCs);

            _mockPdfMerger.Setup(x => x.MergeDocumentation(It.IsAny<List<KeyValuePair<int, byte[]>>>())).Returns(new byte[1]);

            // Check DocumentMergeException is thrown as a T's and C's document exists with page number 50.
            try
            {
                _documentManager.MergeContractDocuments(contract);
            }
            catch (DocumentMergeException exception)
            {
                var expectedErrorMessage =
                    DocumentMergeReasonForError.DocumentMergeFormattedErrorMessage(
                        DocumentMergeReasonForError.DocumentIncorrectOrderNumber50, contract.contracts.First().contractor.ukprn.ToString(),
                        contract.contracts.First().contractNumber);
                Assert.AreEqual(expectedErrorMessage, exception.Message);
            }

            _mockPdfMerger.Verify(x => x.MergeDocumentation(It.IsAny<List<KeyValuePair<int, byte[]>>>()), Times.Never, "The function to merge the documents should not be called");
            _mockOfficeAdapter.Verify(x => x.UploadFile(_fileName, It.IsAny<byte[]>(), _mergedDocumentListName), Times.Never, "The function to upload the merged document should not be called");
        }

        private static contract CreateTestContract()
        {
            return new contract
            {
                contractNumber = "Sfa-1234",
                contracts = new List<contractType>
                {
                    new contract
                    {
                        contractNumber = "Main-1234",
                        contractVersionNumber = 1,
                        contractor = new contractor {ukprn = 11111}
                    }
                },
                contractor = new contractor
                {
                    ukprn = 11111
                }
            };
        }

        [TestMethod, TestCategory("UnitTest"), ExpectedException(typeof(InvalidOperationException))]
        public void WhenMergeIsCalledWithNullContract_DocumentMergeFails_WithInvalidOperationException()
        {
            _documentManager.MergeContractDocuments(null);
        }

        [TestMethod, TestCategory("UnitTest"), ExpectedException(typeof(InvalidOperationException))]
        public void WhenMergeIsCalledWithMasterContract_ButNoChildContracts_DocumentMergeFails_WithInvalidOperationException()
        {
            _documentManager.MergeContractDocuments(new contract
            {
                contracts = new List<contractType>(),
                contractNumber = "SFA-1234"
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void WhenMergeIsCalled_LogInformationAndRethrow_IfOffice365WrapperThrowsException()
        {
            var contractDocument = new contract
            {
                contractNumber = "SFA-1234",
                contracts =
                    new List<contractType> { new contractType { contractNumber = "Main-1234", contractVersionNumber = 1 } },
                contractor = new contractor { ukprn = 11111 }
            };

            var expectedEx = new Exception("Office 365 is broken");

            _mockDocDefiner.Setup(x => x.GetTargetFileName(contractDocument.contracts.First())).Returns(new FctFile("", _fileName));
            _mockDocumentLocationResolver.Setup(x => x.GetLocationOfAppendices(contractDocument.contracts.First()))
                .Returns(_appendicesListName);
            _mockOfficeAdapter.Setup(x => x.GetFileContents(_fileName, _appendicesListName)).Throws(expectedEx);
            try
            {
                _documentManager.MergeContractDocuments(contractDocument);
            }
            catch(Exception ex)
            {
                _mockLogger.Verify(x => x.LogError(DocumentsDomainLoggingEventId.ContractDocumentMergeError,
                    $"Error accessing appendices file: {_fileName}", expectedEx));
                _mockLogger.Verify(x => x.LogError(DocumentsDomainLoggingEventId.ContractDocumentMergeError,
                   $"{nameof(ContractDocumentManager)} merging failed for contract:{contractDocument.contracts[0].contractNumber} because {ex.Message}"));
            }

        }

        [TestMethod, TestCategory("UnitTest"), ExpectedException(typeof(InvalidOperationException))]
        public void ContractDocumentManager_ShouldThrowInvalidOperationExceptionWhenCalledWithChildContract()
        {
            contract contract = CreateTestContract();
            contract.hierarchyType = hierarchyType.CONTRACT;

            _documentManager.MergeContractDocuments(contract);
        }

        [TestMethod, TestCategory("UnitTest"), ExpectedException(typeof(InvalidOperationException))]
        public void ContractDocumentManager_ShouldThrowInvalidOperationExceptionWhenCalledWithMoreThanOneChildContract()
        {
            contract contract = CreateTestContract();
            contract.contracts.Add(new contractType());

            _documentManager.MergeContractDocuments(contract);
        }
    }
}
