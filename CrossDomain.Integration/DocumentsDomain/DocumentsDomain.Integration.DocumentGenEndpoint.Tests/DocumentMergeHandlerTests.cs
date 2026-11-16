
namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenEndpoint.Tests
{
    using Common;
    using Common.Exceptions;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Messages.Commands;
    //using Framework.Logging.Interfaces;
    using Microsoft.Extensions.Logging;
    using Framework.Logging.NullObjects;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.ContractDocumentMerger;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Common.Commands;
    using DocumentGenerationEndpoint.DocumentMergeEndpoint;
    using NServiceBus.Testing;

    [TestClass]
    public class DocumentMergeHandlerTests
    {
        private Mock<ILogger> _logger;
        private Mock<IContractDocumentManager> _contractDocumentManager;

        [TestInitialize]
        public void Initialise()
        {
            _logger = new Mock<ILogger>();
            _contractDocumentManager = new Mock<IContractDocumentManager>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_Handle_EnsureHandlerPassesContractObjectToMergerObject()
        {
            // Arrange
            DocumentMergeHandler handler = new DocumentMergeHandler(
                _contractDocumentManager.Object,
                _logger.Object);

            DocumentMergeCommand command = new DocumentMergeCommand();
            Contract mockContract = command.CorporateContract = CreateTestContract();
            command.ContractNumberToBeMerged = "CONTRACT1";

            var context = new TestableMessageHandlerContext();

            // Act
            handler.Handle(command, context).Wait();

            // Assert
            _contractDocumentManager.Verify(m => m.MergeContractDocuments(
                            It.Is<Contract>(c => c.contracts.Count == 1
                                                && c.contracts[0].contractNumber == command.ContractNumberToBeMerged)),
                            Times.Once, 
                            "MergeContractDocuments should be called once with a master contract that contains one child.");

            Assert.AreEqual(1, 
                context.SentMessages
                    .Select(m => m.Message)
                    .OfType<UpdateDocumentMergeStatusCommand>()
                    .Count(c =>
                        c.CorporateContract == mockContract && c.MergeStatus.IsMergeSuccessful == true && c.MergeStatus.ReasonForFailure == string.Empty),
                "Document merge success message sent is not in the correct format");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_Handle_EnsureDocumentMergeExceptionHandleCorrectly()
        {
            // Arrange
            DocumentMergeHandler handler = new DocumentMergeHandler(
                _contractDocumentManager.Object,
                _logger.Object);

            DocumentMergeCommand command = new DocumentMergeCommand();
            Contract mockContract = command.CorporateContract = CreateTestContract();
            command.ContractNumberToBeMerged = "CONTRACT1";

            string errorMessage = "Custom raised merge exception";
            DocumentMergeException exception = new DocumentMergeException(errorMessage);

            // Expect
            //_contractDocumentManager.Setup(c => c.MergeContractDocuments(command.CorporateContract)).Throws(exception).Verifiable();
            _contractDocumentManager.Setup(c => c.MergeContractDocuments(It.IsAny<Contract>())).Throws(exception).Verifiable();

            var context = new TestableMessageHandlerContext();

            // Act
            handler.Handle(command, context).Wait();

            // Assert
            _contractDocumentManager.Verify(c => c.MergeContractDocuments(It.IsAny<Contract>()), 
                                                    Times.Once, 
                                                    "MergeContractDocuments should be called once with contract passed in the command parameter.");

            _logger.Verify(l => l.LogError(
                                            DocumentsDomainLoggingEventId.ContractDocumentMergeError,
                                            exception,
                                            It.IsAny<string>()
                                            ),
                                            Times.Once,
                                            "Document merge error not logged");

            Assert.AreEqual(1,
                context.SentMessages
                    .Select(m => m.Message)
                    .OfType<UpdateDocumentMergeStatusCommand>()
                    .Count(c =>
                        c.CorporateContract == mockContract && c.MergeStatus.IsMergeSuccessful == false && c.MergeStatus.ReasonForFailure == errorMessage),
                "Document merge failure message sent is not in the correct format");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_Handle_EnsureDocumentMergeGenericExceptionHandleCorrectly()
        {
            // Arrange
            DocumentMergeHandler handler = new DocumentMergeHandler(
                _contractDocumentManager.Object,
                _logger.Object);

            DocumentMergeCommand command = new DocumentMergeCommand();
            Contract mockContract = command.CorporateContract = CreateTestContract();
            command.ContractNumberToBeMerged = "CONTRACT1";

            string errorMessage = "Non custom raised merge exception";
            Exception exception = new Exception(errorMessage);

            // Expect
            //_contractDocumentManager.Setup(c => c.MergeContractDocuments(command.CorporateContract)).Throws(exception).Verifiable();
            _contractDocumentManager.Setup(c => c.MergeContractDocuments(It.IsAny<Contract>())).Throws(exception).Verifiable();

            // Act
            string returnedErrorMessage = string.Empty;

            try
            {
                handler.Handle(command, new TestableMessageHandlerContext()).Wait();
            }
            catch (AggregateException ex)
            {
                returnedErrorMessage = ex.InnerException.Message;
            }

            // Assert
            Assert.AreEqual(errorMessage, returnedErrorMessage, "Error messsage for generic document merge exeption is not as expected.");

            _contractDocumentManager.Verify(c => c.MergeContractDocuments(It.IsAny<Contract>()),
                                            Times.Once,
                                            "MergeContractDocuments should be called once with contract passed in the command parameter.");

            _logger.Verify(l => l.LogError(
                                            DocumentsDomainLoggingEventId.ContractDocumentMergeError,
                                            exception,
                                            It.IsAny<string>()
                                            ),
                                            Times.Once,
                                            "Document merge error not logged");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentMergeHandler_ShouldSendAnUpdateDocumentMergeStatusCommandWithTheCorrectMergeStatus_WhenMergeIsSuccessfull()
        {
            // Arrange
            DocumentMergeHandler handler = new DocumentMergeHandler(
                _contractDocumentManager.Object,
                _logger.Object);

            DocumentMergeCommand command = new DocumentMergeCommand();
            Contract mockContract = command.CorporateContract = CreateTestContract();
            command.ContractNumberToBeMerged = "CONTRACT1";

            //_contractDocumentManager.Setup(c => c.MergeContractDocuments(command.CorporateContract));
            _contractDocumentManager.Setup(c => c.MergeContractDocuments(It.IsAny<Contract>()));

            var context = new TestableMessageHandlerContext();

            // Act
            handler.Handle(command, context).Wait();

            // Assert
            Assert.AreEqual(1,
                context.SentMessages
                    .Select(m => m.Message)
                    .OfType<UpdateDocumentMergeStatusCommand>()
                    .Count(x =>
                        x.CorporateContract == mockContract && x.MergeStatus.IsMergeSuccessful && x.MergeStatus.ReasonForFailure == string.Empty),
                "UpdateDocumentMergeStatusCommand was not sent with the correct parameters.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentMergeHandler_ShouldRejectDocumentMergeCommand_WhenContractNumberToBeMergedNotSet()
        {
            // Arrange
            DocumentMergeHandler handler = new DocumentMergeHandler(
                _contractDocumentManager.Object,
                _logger.Object);

            DocumentMergeCommand command = new DocumentMergeCommand();           
            command.CorporateContract = CreateTestContract();

            bool expectedExceptionThrown = false;

            // Act
            try
            {
                handler.Handle(command, new TestableMessageHandlerContext()).Wait();
            }
            catch (AggregateException ex) when(ex.InnerException is ArgumentException)
            {
                expectedExceptionThrown = true;
            }

            Assert.IsTrue(expectedExceptionThrown);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentMergeHandler_ShouldRejectDocumentMergeCommand_WhenContractNumberToBeMergedDoesNotMatchAChildContract()
        {
            // Arrange
            DocumentMergeHandler handler = new DocumentMergeHandler(
                _contractDocumentManager.Object,
                _logger.Object);

            DocumentMergeCommand command = new DocumentMergeCommand();
            command.CorporateContract = CreateTestContract();
            command.ContractNumberToBeMerged = "INVALID";

            bool expectedExceptionThrown = false;

            // Act
            try
            {
                handler.Handle(command, new TestableMessageHandlerContext()).Wait();
            }
            catch (AggregateException ex) when (ex.InnerException is InvalidOperationException)
            {
                expectedExceptionThrown = true;
            }

            Assert.IsTrue(expectedExceptionThrown);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentMergeHandler_ShouldRejectDocumentMergeCommand_WhenContractNumberToBeMergedIndicatesChildContractThatWithHierarchyTypeNotSetToContract()
        {
            // Arrange
            DocumentMergeHandler handler = new DocumentMergeHandler(
                _contractDocumentManager.Object,
                _logger.Object);

            DocumentMergeCommand command = new DocumentMergeCommand();
            command.CorporateContract = CreateTestContract();
            command.CorporateContract.contracts.Add(new Contract { contractNumber = "CONTRACT4", hierarchyType = hierarchyType.MASTERCONTRACT });
            command.ContractNumberToBeMerged = "CONTRACT4";

            bool expectedExceptionThrown = false;

            // Act
            try
            {
                handler.Handle(command, new TestableMessageHandlerContext()).Wait();
            }
            catch (AggregateException ex) when (ex.InnerException is InvalidOperationException)
            {
                expectedExceptionThrown = true;
            }

            Assert.IsTrue(expectedExceptionThrown);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentMergeHandler_ShouldRejectDocumentMergeCommand_WhenContractNumberToBeMergedIndicatesMultipleChildContracts()
        {
            // Arrange
            DocumentMergeHandler handler = new DocumentMergeHandler(
                _contractDocumentManager.Object,
                _logger.Object);

            DocumentMergeCommand command = new DocumentMergeCommand();
            command.CorporateContract = CreateTestContract();
            command.CorporateContract.contracts.Add(new Contract { contractNumber = "CONTRACT1", hierarchyType = hierarchyType.CONTRACT });
            command.ContractNumberToBeMerged = "CONTRACT1";

            bool expectedExceptionThrown = false;

            // Act
            try
            {
                handler.Handle(command, new TestableMessageHandlerContext()).Wait();
            }
            catch (AggregateException ex) when (ex.InnerException is InvalidOperationException)
            {
                expectedExceptionThrown = true;
            }

            Assert.IsTrue(expectedExceptionThrown);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentMergeHandler_ShouldRejectDocumentMergeCommand_WhenCorporateContractIsNotMasterContract()
        {
            // Arrange
            DocumentMergeHandler handler = new DocumentMergeHandler(
                _contractDocumentManager.Object,
                _logger.Object);

            DocumentMergeCommand command = new DocumentMergeCommand();
            command.CorporateContract = CreateTestContract();
            command.CorporateContract.hierarchyType = hierarchyType.CONTRACT;

            bool expectedExceptionThrown = false;

            // Act
            try
            {
                handler.Handle(command, new TestableMessageHandlerContext()).Wait();
            }
            catch (AggregateException ex) when (ex.InnerException is InvalidOperationException)
            {
                expectedExceptionThrown = true;
            }

            Assert.IsTrue(expectedExceptionThrown);
        }

        [TestCleanup]
        public void CleanUp()
        {
            _logger = null;
            _contractDocumentManager = null;
        }

        public Contract CreateTestContract()
        {
            var contract = new Contract();
            contract.hierarchyType = hierarchyType.MASTERCONTRACT;
            contract.contractNumber = "MASTER_CONTRACT";
            contract.contracts.AddRange(new List<Contract>{ 
                    new Contract
                    {
                        contractNumber = "CONTRACT1",
                        hierarchyType = hierarchyType.CONTRACT
                    },
                    new Contract
                    {
                        contractNumber = "CONTRACT2",
                        hierarchyType = hierarchyType.CONTRACT
                    },
                    new Contract
                    {
                        contractNumber = "CONTRACT3",
                        hierarchyType = hierarchyType.CONTRACT
                    }}
                );
            return contract;
        }
    }
}
