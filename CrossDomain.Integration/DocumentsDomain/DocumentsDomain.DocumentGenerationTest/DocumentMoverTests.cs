namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using DocumentMover;
    using System.Collections.Generic;
    using System.Linq;
    using Common.Exceptions;
    using CrossDomain.Integration.Common.Exceptions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using DocumentDefiner;
    using DocumentLocationResolver;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Common.Storage;
    using FctFile = Common.Models.FctFile;
    using System;
    [TestClass]
    public class DocumentMoverTests
    {
        private Mock<IDocumentDefiner> _documentDefiner;
        private Mock<IDocumentLocationResolver> _documentLocationResolver;
        private Mock<IOffice365Adapter> _office365MockAdapter;
        private IDocumentMover _documentMover;
        private const string FileName = "11111_Main-1234_v1.pdf";
        private const string MergedDocumentListName = "Main-1516-Output-Merged Document";
        private const string PublishedDocumentListName = "Main-1516-Output-Documents for Publication";
        private const string AppendicesDocumentListName = "Main-1516-Input-Appendices";


        [TestInitialize]
        public void Initialize()
        {
           
            _documentDefiner = new Mock<IDocumentDefiner>();
            _documentLocationResolver = new Mock<IDocumentLocationResolver>();
            _office365MockAdapter = new Mock<IOffice365Adapter>();

            _documentMover = new DocumentMover(_documentLocationResolver.Object, 
                _office365MockAdapter.Object, _documentDefiner.Object);
        }
        
        [TestMethod, TestCategory("UnitTest")]
        public void DocumentMover_MoveContractSuccessfullWhenSkipDocumentMergeIsFalse()
        {
            // Arrange
            var contract = CreateTestContract();
            contract.SkipDocumentMerge = false;

            _documentDefiner.Setup(x => x.GetTargetFileName(contract.contracts.First())).Returns(new FctFile(string.Empty, FileName));
            _documentLocationResolver.Setup(x => x.GetLocationOfMergedDocument(contract.contracts.First())).Returns(MergedDocumentListName);
            _documentLocationResolver.Setup(x => x.GetLocationOfPublishedDocument(contract.contracts.First())).Returns(PublishedDocumentListName);

            _office365MockAdapter.Setup(m => m.MoveFile(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>())).Verifiable();

            // Act
            _documentMover.MoveContractDocumentToPublishLocation(contract);

            // Assert
            _office365MockAdapter.Verify(m => m.MoveFile(It.Is<string>(s => s == FileName), It.Is<string>(s => s == MergedDocumentListName), It.Is<string>(s => s == PublishedDocumentListName)),Times.Once);
        }
        

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentMover_ThrowsDocumentMoveException_WhenMergedDocumentNotFound()
        {
            var contract = CreateTestContract();

            _documentDefiner.Setup(x => x.GetTargetFileName(contract.contracts.First())).Returns(new FctFile(string.Empty, FileName));

            _documentLocationResolver.Setup(x => x.GetLocationOfMergedDocument(contract.contracts.First())).Returns(MergedDocumentListName);
            _documentLocationResolver.Setup(x => x.GetLocationOfPublishedDocument(contract.contracts.First())).Returns(PublishedDocumentListName);

            _office365MockAdapter.Setup(m => m.MoveFile(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>())).Throws(new FileNotFoundException("File not found"));

            try
            {
                _documentMover.MoveContractDocumentToPublishLocation(contract);
            }
            catch (DocumentMoveException e)
            {
                Assert.IsTrue(e.Message.Contains("11111"), "Error message does not contain UKPRN");
                Assert.IsTrue(e.Message.Contains("MAIN-1234"), "Error message does not contain contract number");

                return;
            }

            Assert.Fail("Exception was not thrown");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentMover_DoesContractDocumentAlreadyPublishedReturnsTrue()
        {
            var contract = CreateTestContract();

            _documentDefiner.Setup(x => x.GetTargetFileName(contract.contracts.First())).Returns(new FctFile(string.Empty, FileName));

            _documentLocationResolver.Setup(x => x.GetLocationOfMergedDocument(contract.contracts.First())).Returns(MergedDocumentListName);
            _documentLocationResolver.Setup(x => x.GetLocationOfPublishedDocument(contract.contracts.First())).Returns(PublishedDocumentListName);

            _office365MockAdapter.Setup(m => m.DoesFileExist(It.IsAny<string>(), It.IsAny<string>())).Returns(true);

            Assert.IsTrue(_documentMover.IsContractDocumentAlreadyPublished(contract),"Contract document already published")
            ;
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentMover_DoesContractDocumentAlreadyPublishedReturnsFalse()
        {
            var contract = CreateTestContract();

            _documentDefiner.Setup(x => x.GetTargetFileName(contract.contracts.First())).Returns(new FctFile(string.Empty, FileName));

            _documentLocationResolver.Setup(x => x.GetLocationOfMergedDocument(contract.contracts.First())).Returns(MergedDocumentListName);
            _documentLocationResolver.Setup(x => x.GetLocationOfPublishedDocument(contract.contracts.First())).Returns(PublishedDocumentListName);

            _office365MockAdapter.Setup(m => m.DoesFileExist(It.IsAny<string>(), It.IsAny<string>())).Returns(false);

            Assert.IsTrue(!_documentMover.IsContractDocumentAlreadyPublished(contract), "Contract document not  published")
            ;
        }

        [TestMethod, TestCategory("UnitTest"), ExpectedException(typeof(InvalidOperationException))]
        public void DocumentMover_ShouldThrowInvalidOperationExceptionWhenCalledWithChildContract()
        {
            contract contract = CreateTestContract();
            contract.hierarchyType = hierarchyType.CONTRACT;

            _documentMover.MoveContractDocumentToPublishLocation(contract);
        }

        [TestMethod, TestCategory("UnitTest"), ExpectedException(typeof(InvalidOperationException))]
        public void DocumentMover_ShouldThrowInvalidOperationExceptionWhenCalledWithMoreThanOneChildContract()
        {
            contract contract = CreateTestContract();
            contract.contracts.Add(new contractType());

            _documentMover.MoveContractDocumentToPublishLocation(contract);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentMover_MoveContractFromAppendicesWhenSkipDocumentationIsTrue()
        {
            // Arrange
            var contract = CreateTestContract();
            contract.contracts.First().SkipDocumentMerge = true;
            _documentDefiner.Setup(x => x.GetTargetFileName(contract.contracts.First())).Returns(new FctFile(string.Empty, FileName));
            _documentLocationResolver.Setup(x => x.GetLocationOfMergedDocument(contract.contracts.First())).Returns(MergedDocumentListName);
            _documentLocationResolver.Setup(x => x.GetLocationOfPublishedDocument(contract.contracts.First())).Returns(PublishedDocumentListName);
            _documentLocationResolver.Setup(x => x.GetLocationOfAppendices(contract.contracts.First())).Returns(AppendicesDocumentListName);

            _office365MockAdapter.Setup(m => m.MoveFile(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>())).Verifiable();

            // Act
            _documentMover.MoveContractDocumentToPublishLocation(contract);

            // Assert
            _office365MockAdapter.Verify(m => m.MoveFile(It.Is<string>(s => s == FileName), It.Is<string>(s => s == AppendicesDocumentListName), It.Is<string>(s => s == PublishedDocumentListName)), Times.Once);
        }

        private static contract CreateTestContract()
        {
            return new contract
            {
                contractNumber = "SFA-1234",
                fundingType = new fundingType { fundingTypeCode = "MAIN" },
                contracts = new List<contractType>
                {
                    new contract
                    {
                        contractNumber = "MAIN-1234",
                        contractVersionNumber = 1,
                        contractor = new contractor {ukprn = 11111},
                        period = new period { period1 = "1516" }
                    }
                },
                contractor = new contractor
                {
                    ukprn = 11111
                }
            };
        }
    }
}
