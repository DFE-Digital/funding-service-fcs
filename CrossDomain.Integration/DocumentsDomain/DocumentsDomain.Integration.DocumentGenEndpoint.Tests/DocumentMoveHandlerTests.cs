namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenEndpoint.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Common.Commands;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Events;
    using CrossDomain.Integration.Messages.Commands;
    using DocumentGeneration;
    using DocumentGenerationEndpoint.DocumentMoveEndpoint;
    // using Framework.Logging.Interfaces;
    using Microsoft.Extensions.Logging;
    using Framework.Logging.NullObjects;    
    using Common.Exceptions;
    using CrossDomain.Integration.Entities.ContractApproval;
    using CrossDomain.Integration.Messages.Messages;
    using NServiceBus.Testing;

    [TestClass]
    public class DocumentMoveHandlerTests
    {
        private Mock<ILogger> _logger;
        private Mock<IDocumentMover> _documentMoverMock;

        [TestInitialize]
        public void Initialise()
        {
            _logger = new Mock<ILogger>();
            _documentMoverMock = new Mock<IDocumentMover>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentMoveHandler_PerformsMoveDocumentAndPublishEventWhenDocNotAlreadyPublished()
        {
            // arrange
            var testDate = new DateTime(2016, 1, 14);
            var dateMock = new Mock<IDate>();

            dateMock.Setup(x => x.GetCalculationDate()).Returns(testDate);
            

            var contract = new contractType
            {
                contractNumber = "MAIN-123",
                hierarchyType = hierarchyType.CONTRACT
            };

            var masterContract = new Contract
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    contract
                }
            };

            _documentMoverMock.Setup(x => x.IsContractDocumentAlreadyPublished(It.IsAny<Contract>())).Returns(false);

            var handler = new DocumentMoveHandler(_documentMoverMock.Object, null)
            {
                Date = dateMock.Object
            };

            var context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new DocumentMoveCommand
            {
                CorporateContract = masterContract,
                ContractNumberToBeMoved = "MAIN-123",
                ContractApprovalType = ContractApprovalType.Electronic
            }, context).Wait();

            _documentMoverMock.Verify(x => x.MoveContractDocumentToPublishLocation(It.IsAny<Contract>()), Times.Once, $"{nameof(IDocumentMover)} was not called");

            List<DocumentMoveResponse> responses =
                context.RepliedMessages
                    .Select(m => m.Message)
                    .OfType<DocumentMoveResponse>()
                    .ToList();

            Assert.AreEqual(1, responses.Count, "The expected reply message was not sent");
            
            DocumentMoveResponse response = responses.Single();
            Assert.AreEqual(response.CorporateContract, masterContract, "The contract replied is not the one same as the one passed in");
            Assert.IsTrue(response.IsMoveComplete, "The contract has not been moved");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentMoveHandler_PerformsMoveDocumentAndPublishEventWhenDocAlreadyPublished()
        {
            // arrange
            var testDate = new DateTime(2016, 1, 14);
            var dateMock = new Mock<IDate>();

            dateMock.Setup(x => x.GetCalculationDate()).Returns(testDate);


            var contract = new contractType
            {
                contractNumber = "MAIN-123",
                hierarchyType = hierarchyType.CONTRACT
            };

            var masterContract = new Contract
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    contract
                }
            };

            _documentMoverMock.Setup(x => x.IsContractDocumentAlreadyPublished(It.IsAny<Contract>())).Returns(true);

            var handler = new DocumentMoveHandler(_documentMoverMock.Object, null)
            {
                Date = dateMock.Object
            };

            var context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new DocumentMoveCommand
            {
                CorporateContract = masterContract,
                ContractNumberToBeMoved = "MAIN-123",
                ContractApprovalType = ContractApprovalType.Electronic
            }, context).Wait();

            // assert
            _documentMoverMock.Verify(x => x.MoveContractDocumentToPublishLocation(It.IsAny<Contract>()), Times.Never, $"{nameof(IDocumentMover)} was called");

            List<DocumentMoveResponse> responses =
                context.RepliedMessages
                    .Select(m => m.Message)
                    .OfType<DocumentMoveResponse>()
                    .ToList();

            Assert.AreEqual(1, responses.Count, "The type replied is not correct");

            DocumentMoveResponse response = responses.Single();
            Assert.AreEqual(response.CorporateContract, masterContract, "The contract replied is not the one same as the one passed in");
            Assert.IsTrue(response.IsMoveComplete, "If contract document already published, then IsMovecomplete should return true allowing contract status to be published and entry added to feed");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentMoveHandler_LogsAndThrowsErrorWhenNoContractInMessageAndDoesNotPerformMoveDocumentOrPublishEvent()
        {
            // arrange
            var handler = new DocumentMoveHandler(_documentMoverMock.Object, null)
            {
                Logger = _logger.Object
            };

            var masterContract = new Contract
            {
                contracts = new List<contractType>()
            };

            var context = new TestableMessageHandlerContext();

            try
            {
                // act
                handler.Handle(new DocumentMoveCommand
                {
                    CorporateContract = masterContract,
                    ContractApprovalType = ContractApprovalType.Electronic
                }, context).Wait();
            }
            catch (AggregateException ex)
            {
                // assert
                Exception e = ex.InnerException;

                Assert.IsTrue(e is ArgumentNullException);
                _logger.Verify(x => x.LogError(It.IsAny<int>(), e, e.Message), Times.Once, "Error was not logged");

                _documentMoverMock.Verify(x => x.MoveContractDocumentToPublishLocation(It.IsAny<Contract>()), Times.Never, $"{nameof(IDocumentMover)} was called");

                Assert.AreEqual(0,
                    context.PublishedMessages
                        .Select(m => m.Message)
                        .OfType<ContractReadyToPublishEvent>()
                        .Count(),
                    $"{nameof(ContractReadyToPublishEvent)} was published");

                return;
            }

            Assert.Fail("Exception was not thrown.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentMoveHandler_CatchesDocumentMoveException_AndPublishesFailureEvent()
        {
            // arrange
            var handler = new DocumentMoveHandler(_documentMoverMock.Object, null)
            {
                Logger = _logger.Object
            };

            var masterContract = new Contract
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "contract1",
                        hierarchyType = hierarchyType.CONTRACT
                    }
                }
            };

            const string reason = "Merged document does not exist.";

            _documentMoverMock
                .Setup(x => x.MoveContractDocumentToPublishLocation(It.IsAny<Contract>()))
                .Throws(new DocumentMoveException(reason));

            var context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new DocumentMoveCommand
            {
                CorporateContract = masterContract,
                ContractNumberToBeMoved = "contract1",
                ContractApprovalType = ContractApprovalType.Electronic
            }, context).Wait();

            // assert
            Assert.AreEqual(1,
                context.SentMessages
                        .Select(m => m.Message)
                        .OfType<UpdateContractPublishedToProviderFailedCommand>()
                        .Count(e => e.ReasonForFailure == reason),
                $"{nameof(UpdateContractPublishedToProviderFailedCommand)} was not sent with reason");
            Assert.AreEqual(0,
                context.PublishedMessages
                    .Select(m => m.Message)
                    .OfType<ContractReadyToPublishEvent>()
                    .Count(),
                $"{nameof(ContractReadyToPublishEvent)} was published");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentMoveHandler_ShouldRejectDocumentMergeCommand_WhenContractNumberToBeMergedNotSet()
        {
            // Arrange
            var handler = new DocumentMoveHandler(_documentMoverMock.Object, null)
            {
                Logger = _logger.Object
            };

            var command = new DocumentMoveCommand
            {
                CorporateContract = CreateTestContract(),
                ContractApprovalType = ContractApprovalType.Electronic
            };

            bool expectedExceptionThrown = false;

            // Act
            try
            {
                handler.Handle(command, new TestableMessageHandlerContext()).Wait();
            }
            catch (AggregateException e) when (e.InnerException is ArgumentException)
            {
                expectedExceptionThrown = true;
            }

            // Assert
            Assert.IsTrue(expectedExceptionThrown);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentMoveHandler_ShouldRejectDocumentMergeCommand_WhenContractNumberToBeMergedDoesNotMatchAChildContract()
        {
            // Arrange
            var handler = new DocumentMoveHandler(_documentMoverMock.Object,null)
            {
                Logger = _logger.Object
            };

            var command = new DocumentMoveCommand
            {
                CorporateContract = CreateTestContract(),
                ContractNumberToBeMoved = "INVALID",
                ContractApprovalType = ContractApprovalType.Electronic
            };

            bool expectedExceptionThrown = false;

            // Act
            try
            {
                handler.Handle(command, new TestableMessageHandlerContext()).Wait();
            }
            catch (AggregateException e) when (e.InnerException is InvalidOperationException)
            {
                expectedExceptionThrown = true;
            }

            Assert.IsTrue(expectedExceptionThrown);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentMoveHandler_ShouldRejectDocumentMergeCommand_WhenContractNumberToBeMergedIndicatesChildContractThatWithHierarchyTypeNotSetToContract()
        {
            // Arrange
            var handler = new DocumentMoveHandler(_documentMoverMock.Object, null)
            {
                Logger = _logger.Object
            };

            var command = new DocumentMoveCommand
            {
                CorporateContract = CreateTestContract(),
                ContractApprovalType = ContractApprovalType.Electronic
            };
            command.CorporateContract.contracts.Add(new Contract { contractNumber = "CONTRACT4", hierarchyType = hierarchyType.MASTERCONTRACT });
            command.ContractNumberToBeMoved = "CONTRACT4";

            bool expectedExceptionThrown = false;

            // Act
            try
            {
                handler.Handle(command, new TestableMessageHandlerContext()).Wait();
            }
            catch (AggregateException e) when (e.InnerException is InvalidOperationException)
            {
                expectedExceptionThrown = true;
            }

            Assert.IsTrue(expectedExceptionThrown);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentMoveHandler_ShouldRejectDocumentMergeCommand_WhenContractNumberToBeMergedIndicatesMultipleChildContracts()
        {
            // Arrange
            var handler = new DocumentMoveHandler(_documentMoverMock.Object, null)
            {
                Logger = _logger.Object
            };

            var command = new DocumentMoveCommand
            {
                CorporateContract = CreateTestContract(),
                ContractApprovalType = ContractApprovalType.Electronic
            };
            command.CorporateContract.contracts.Add(new Contract { contractNumber = "CONTRACT1", hierarchyType = hierarchyType.CONTRACT });
            command.ContractNumberToBeMoved = "CONTRACT1";

            bool expectedExceptionThrown = false;

            // Act
            try
            {
                handler.Handle(command, new TestableMessageHandlerContext()).Wait();
            }
            catch (AggregateException e) when (e.InnerException is InvalidOperationException)
            {
                expectedExceptionThrown = true;
            }

            Assert.IsTrue(expectedExceptionThrown);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentMoveHandler_ShouldRejectDocumentMergeCommand_WhenCorporateContractIsNotMasterContract()
        {
            // Arrange
            var handler = new DocumentMoveHandler(_documentMoverMock.Object, null)
            {
                Logger = _logger.Object
            };

            var command = new DocumentMoveCommand
            {
                CorporateContract = CreateTestContract(),
                ContractApprovalType = ContractApprovalType.Electronic
            };
            command.CorporateContract.hierarchyType = hierarchyType.CONTRACT;

            bool expectedExceptionThrown = false;

            // Act
            try
            {
                handler.Handle(command, new TestableMessageHandlerContext()).Wait();
            }
            catch (AggregateException e) when(e.InnerException is InvalidOperationException)
            {
                expectedExceptionThrown = true;
            }

            Assert.IsTrue(expectedExceptionThrown);
        }

        public Contract CreateTestContract()
        {
            var contract = new Contract
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contractNumber = "MASTER_CONTRACT",
                contracts = new List<contractType>
                {
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
                    }
                }
            };

            return contract;
        }
    }
}
