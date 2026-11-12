namespace ContractManagementDomain.Termination.Tests
{
    using System;
    using System.Collections.Generic;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractManagement.DataStore.Model;
    using Services;
    using DTOs;
    using Handlers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using NServiceBus.Testing;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ApproveContractTerminationInitiationHandlerTests
    {

        [TestMethod]
        [TestCategory("UnitTest")]
        public void ApproveContractTerminationInitiationHandler_ShouldOnlySetServiceResponseIfAtomItemCreationResultIsAddedOrAlreadyPresent()
        {
            // arrange
            Mock<ISessionConnectionFactory> sessionConnectionFactoryMock =
                new Mock<ISessionConnectionFactory>();

            sessionConnectionFactoryMock
                .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateDefault);

            Mock<ITerminateContractFeedService> terminateContractFeedServiceMock =
                new Mock<ITerminateContractFeedService>();

            terminateContractFeedServiceMock
                .SetupSequence(m => m.UpdateContractAndAddToFeed(
                    It.IsAny<ConnectionInfo>(),
                    It.IsAny<ContractIdentifier>(),
                    It.IsAny<Action<Contract>>(),
                    It.IsAny<string>(),
                    It.IsAny<AtomItemType>()))
                .Returns(new UpdateSubStatusAndAddContractToFeedResult(
                    AtomItemCreationResult.Added,
                    new Contract()))
                .Returns(new UpdateSubStatusAndAddContractToFeedResult(
                    AtomItemCreationResult.AlreadyPresentWithSameFeedItemId,
                    new Contract()))
                .Returns(new UpdateSubStatusAndAddContractToFeedResult(
                    AtomItemCreationResult.AlreadyPresent,
                    new Contract()));

            var sentMessages = new List<object>();
            var publishedMessages = new List<object>();

            var contextMock =
                CreateContextMock(sentMessages, publishedMessages);

            var handler = new ApproveContractTerminationInitiationHandler(
                Mock.Of<ILogger>(),
                sessionConnectionFactoryMock.Object,
                terminateContractFeedServiceMock.Object);

            ApproveContractTerminationInitiationCommand command =
                new ApproveContractTerminationInitiationCommand
                {
                    ContractNumber = "ABC-1223",
                    VersionNumber = 1,
                    SubVersionNumber = 0
                };

            // act
            handler.Handle(command, contextMock.Object).Wait();
            handler.Handle(command, contextMock.Object).Wait();
            handler.Handle(command, contextMock.Object).Wait();

            // assert
            Assert.AreEqual(
                4,
                sentMessages.Count,
                "The wrong number of messages were sent");

            Assert.IsTrue(
                sentMessages[0] is SetContractTerminationToCompleteInCrmCommand,
                "1st SetContractTerminationToCompleteInCrmCommand sent message was expected");

            Assert.IsTrue(
                sentMessages[1] is ReleaseQueuedFundingAllocationsForContractsCommand,
                "1st ReleaseQueuedFundingAllocationsForContractsCommand sent message was expected");

            Assert.IsTrue(
                sentMessages[2] is SetContractTerminationToCompleteInCrmCommand,
                "2nd SetContractTerminationToCompleteInCrmCommand sent message was expected");

            Assert.IsTrue(
                sentMessages[3] is ReleaseQueuedFundingAllocationsForContractsCommand,
                "2nd ReleaseQueuedFundingAllocationsForContractsCommand sent message was expected");
        }


        [TestMethod]
        [TestCategory("UnitTest")]
        public void ApproveContractTerminationInitiationHandler_ShouldPublishOneContractPlacedUnderTerminationForApproveInitiationEvent()
        {
            // arrange
            Mock<ISessionConnectionFactory> sessionConnectionFactoryMock =
                new Mock<ISessionConnectionFactory>();

            sessionConnectionFactoryMock
                .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateDefault);

            Mock<ITerminateContractFeedService> terminateContractFeedServiceMock =
                new Mock<ITerminateContractFeedService>();

            terminateContractFeedServiceMock
                .Setup(m => m.UpdateContractAndAddToFeed(
                    It.IsAny<ConnectionInfo>(),
                    It.IsAny<ContractIdentifier>(),
                    It.IsAny<Action<Contract>>(),
                    It.IsAny<string>(),
                    It.IsAny<AtomItemType>()))
                .Returns(
                    new UpdateSubStatusAndAddContractToFeedResult(
                        AtomItemCreationResult.Added,
                        new Contract()));

            var handler = new ApproveContractTerminationInitiationHandler(
                Mock.Of<ILogger>(),
                sessionConnectionFactoryMock.Object,
                terminateContractFeedServiceMock.Object);

            ApproveContractTerminationInitiationCommand command =
                new ApproveContractTerminationInitiationCommand
                {
                    ContractNumber = "ABC-1223",
                    VersionNumber = 1,
                    SubVersionNumber = 0
                };

            var sentMessages = new List<object>();
            var publishedMessages = new List<object>();

            var contextMock =
                CreateContextMock(sentMessages, publishedMessages);

            // act
            handler.Handle(command, contextMock.Object).Wait();

            // assert
            Assert.AreEqual(
                1,
                publishedMessages.Count,
                "Incorrect number of published events");

            Assert.IsInstanceOfType(
                publishedMessages[0],
                typeof(ContractPlacedUnderTerminationForApproveInitiationEvent),
                "ContractPlacedUnderTerminationForApproveInitiationEvent was not published");
        }


        [TestMethod]
        [TestCategory("UnitTest")]
        public void ApproveContractTerminationInitiationHandler_ShouldNotPublishContractPlacedUnderTerminationForApproveInitiationEvent()
        {
            // arrange
            Mock<ISessionConnectionFactory> sessionConnectionFactoryMock =
                new Mock<ISessionConnectionFactory>();

            sessionConnectionFactoryMock
                .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateDefault);

            Mock<ITerminateContractFeedService> terminateContractFeedServiceMock =
                new Mock<ITerminateContractFeedService>();

            terminateContractFeedServiceMock
                .Setup(m => m.UpdateContractAndAddToFeed(
                    It.IsAny<ConnectionInfo>(),
                    It.IsAny<ContractIdentifier>(),
                    It.IsAny<Action<Contract>>(),
                    It.IsAny<string>(),
                    It.IsAny<AtomItemType>()))
                .Returns(
                    new UpdateSubStatusAndAddContractToFeedResult(
                        AtomItemCreationResult.AlreadyPresentWithSameFeedItemId,
                        corporateContract: null));

            var handler = new ApproveContractTerminationInitiationHandler(
                Mock.Of<ILogger>(),
                sessionConnectionFactoryMock.Object,
                terminateContractFeedServiceMock.Object);

            ApproveContractTerminationInitiationCommand command =
                new ApproveContractTerminationInitiationCommand
                {
                    ContractNumber = "ABC-1223",
                    VersionNumber = 1,
                    SubVersionNumber = 0
                };

            var sentMessages = new List<object>();
            var publishedMessages = new List<object>();

            var contextMock =
                CreateContextMock(sentMessages, publishedMessages);

            // act
            handler.Handle(command, contextMock.Object).Wait();

            // assert
            Assert.AreEqual(
                0,
                publishedMessages.Count,
                "No events should have been published");
        }



        [TestMethod]
        [TestCategory("UnitTest")]
        public void ApproveContractTerminationInitiationHandler_ShouldPublishAnEventWithAllTerminationAllocationsWhenAllTerminatinoDatesHaveADate()
        {
            // arrange
            Contract corporateContract = new Contract
            {
                contracts = new List<contractType>
        {
            new Contract
            {
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        FundingCessationDate = DateTime.Now.Date
                    },
                    new contractAllocationsContractAllocation
                    {
                        FundingCessationDate = DateTime.Now.Date
                    },
                    new contractAllocationsContractAllocation
                    {
                        FundingCessationDate = DateTime.Now.Date
                    }
                }
            }
        }
            };

            Mock<ISessionConnectionFactory> sessionConnectionFactoryMock =
                new Mock<ISessionConnectionFactory>();

            sessionConnectionFactoryMock
                .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateDefault);

            Mock<ITerminateContractFeedService> terminateContractFeedServiceMock =
                new Mock<ITerminateContractFeedService>();

            terminateContractFeedServiceMock
                .Setup(m => m.UpdateContractAndAddToFeed(
                    It.IsAny<ConnectionInfo>(),
                    It.IsAny<ContractIdentifier>(),
                    It.IsAny<Action<Contract>>(),
                    It.IsAny<string>(),
                    It.IsAny<AtomItemType>()))
                .Returns(
                    new UpdateSubStatusAndAddContractToFeedResult(
                        AtomItemCreationResult.Added,
                        corporateContract));

            var handler = new ApproveContractTerminationInitiationHandler(
                Mock.Of<ILogger>(),
                sessionConnectionFactoryMock.Object,
                terminateContractFeedServiceMock.Object);

            ApproveContractTerminationInitiationCommand command =
                new ApproveContractTerminationInitiationCommand
                {
                    ContractNumber = "ABC-1223",
                    VersionNumber = 1,
                    SubVersionNumber = 0
                };

            var sentMessages = new List<object>();
            var publishedMessages = new List<object>();

            var contextMock =
                CreateContextMock(sentMessages, publishedMessages);

            // act
            handler.Handle(command, contextMock.Object).Wait();

            // assert
            Assert.AreEqual(
                1,
                publishedMessages.Count,
                "Incorrect number of published events");

            Assert.IsInstanceOfType(
                publishedMessages[0],
                typeof(ContractPlacedUnderTerminationForApproveInitiationEvent),
                "ContractPlacedUnderTerminationForApproveInitiationEvent was not published");

            var contractPlacedUnderTerminationForApproveInitiationEvent =
                (ContractPlacedUnderTerminationForApproveInitiationEvent)
                    publishedMessages[0];

            Assert.AreEqual(
                3,
                contractPlacedUnderTerminationForApproveInitiationEvent.TerminationAllocations.Count,
                "Incorrect number of termination allocations in the raised event");
        }


        [TestMethod]
        [TestCategory("UnitTest")]
        public void ApproveContractTerminationInitiationHandler_ShouldPublishAnEventWithSomeTerminationAllocationsWhenOnlySomeTerminatinoDatesHaveADate()
        {
            // arrange
            Contract corporateContract = new Contract
            {
                contracts = new List<contractType>
        {
            new Contract
            {
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        FundingCessationDate = DateTime.Now.Date
                    },
                    new contractAllocationsContractAllocation
                    {
                        FundingCessationDate = null
                    },
                    new contractAllocationsContractAllocation
                    {
                        FundingCessationDate = null
                    }
                }
            }
        }
            };

            Mock<ISessionConnectionFactory> sessionConnectionFactoryMock =
                new Mock<ISessionConnectionFactory>();

            sessionConnectionFactoryMock
                .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateDefault);

            Mock<ITerminateContractFeedService> terminateContractFeedServiceMock =
                new Mock<ITerminateContractFeedService>();

            terminateContractFeedServiceMock
                .Setup(m => m.UpdateContractAndAddToFeed(
                    It.IsAny<ConnectionInfo>(),
                    It.IsAny<ContractIdentifier>(),
                    It.IsAny<Action<Contract>>(),
                    It.IsAny<string>(),
                    It.IsAny<AtomItemType>()))
                .Returns(
                    new UpdateSubStatusAndAddContractToFeedResult(
                        AtomItemCreationResult.Added,
                        corporateContract));

            var handler = new ApproveContractTerminationInitiationHandler(
                Mock.Of<ILogger>(),
                sessionConnectionFactoryMock.Object,
                terminateContractFeedServiceMock.Object);

            ApproveContractTerminationInitiationCommand command =
                new ApproveContractTerminationInitiationCommand
                {
                    ContractNumber = "ABC-1223",
                    VersionNumber = 1,
                    SubVersionNumber = 0
                };

            var sentMessages = new List<object>();
            var publishedMessages = new List<object>();

            var contextMock =
                CreateContextMock(sentMessages, publishedMessages);

            // act
            handler.Handle(command, contextMock.Object).Wait();

            // assert
            Assert.AreEqual(
                1,
                publishedMessages.Count,
                "Incorrect number of published events");

            Assert.IsInstanceOfType(
                publishedMessages[0],
                typeof(ContractPlacedUnderTerminationForApproveInitiationEvent),
                "ContractPlacedUnderTerminationForApproveInitiationEvent was not published");

            var contractPlacedUnderTerminationForApproveInitiationEvent =
                (ContractPlacedUnderTerminationForApproveInitiationEvent)
                    publishedMessages[0];

            Assert.AreEqual(
                1,
                contractPlacedUnderTerminationForApproveInitiationEvent.TerminationAllocations.Count,
                "Incorrect number of termination allocations in the raised event");
        }



        [TestMethod]
        [TestCategory("UnitTest")]
        public void ApproveContractTerminationInitiationHandler_ShouldPublishAnEventWithWithNoTerminationAllocationsWhenAllTerminatinoDatesAreNull()
        {
            // arrange
            Contract corporateContract = new Contract
            {
                contracts = new List<contractType>
        {
            new Contract
            {
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        FundingCessationDate = null
                    },
                    new contractAllocationsContractAllocation
                    {
                        FundingCessationDate = null
                    },
                    new contractAllocationsContractAllocation
                    {
                        FundingCessationDate = null
                    }
                }
            }
        }
            };

            Mock<ISessionConnectionFactory> sessionConnectionFactoryMock =
                new Mock<ISessionConnectionFactory>();

            sessionConnectionFactoryMock
                .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateDefault);

            Mock<ITerminateContractFeedService> terminateContractFeedServiceMock =
                new Mock<ITerminateContractFeedService>();

            terminateContractFeedServiceMock
                .Setup(m => m.UpdateContractAndAddToFeed(
                    It.IsAny<ConnectionInfo>(),
                    It.IsAny<ContractIdentifier>(),
                    It.IsAny<Action<Contract>>(),
                    It.IsAny<string>(),
                    It.IsAny<AtomItemType>()))
                .Returns(
                    new UpdateSubStatusAndAddContractToFeedResult(
                        AtomItemCreationResult.Added,
                        corporateContract));

            var handler = new ApproveContractTerminationInitiationHandler(
                Mock.Of<ILogger>(),
                sessionConnectionFactoryMock.Object,
                terminateContractFeedServiceMock.Object);

            ApproveContractTerminationInitiationCommand command =
                new ApproveContractTerminationInitiationCommand
                {
                    ContractNumber = "ABC-1223",
                    VersionNumber = 1,
                    SubVersionNumber = 0
                };

            var sentMessages = new List<object>();
            var publishedMessages = new List<object>();

            var contextMock =
                CreateContextMock(sentMessages, publishedMessages);

            // act
            handler.Handle(command, contextMock.Object).Wait();

            // assert
            Assert.AreEqual(
                1,
                publishedMessages.Count,
                "Incorrect number of published events");

            Assert.IsInstanceOfType(
                publishedMessages[0],
                typeof(ContractPlacedUnderTerminationForApproveInitiationEvent),
                "ContractPlacedUnderTerminationForApproveInitiationEvent was not published");

            var contractPlacedUnderTerminationForApproveInitiationEvent =
                (ContractPlacedUnderTerminationForApproveInitiationEvent)
                    publishedMessages[0];

            Assert.AreEqual(
                0,
                contractPlacedUnderTerminationForApproveInitiationEvent.TerminationAllocations.Count,
                "Incorrect number of termination allocations in the raised event");
        }


        [TestMethod, TestCategory("UnitTest")]
        public void ApproveContractTerminationInitiationHandler_ShouldResolve()
        {
            var container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory()));
            container.Register(Component.For<IHandleMessages<ApproveContractTerminationInitiationCommand>>()
                .ImplementedBy<ApproveContractTerminationInitiationHandler>().LifestyleScoped());

            container.BeginScope();

            var handler = container.Resolve<IHandleMessages<ApproveContractTerminationInitiationCommand>>();

            Assert.IsNotNull(handler,
                "Handler did not resolve");
        }


        private static Mock<IMessageHandlerContext> CreateContextMock(
            List<object> sentMessages,
            List<object> publishedMessages)
        {
            var contextMock = new Mock<IMessageHandlerContext>();

            contextMock
                .Setup(x => x.Send(
                    It.IsAny<object>(),
                    It.IsAny<SendOptions>()))
                .Callback<object, SendOptions>((message, options) =>
                {
                    sentMessages.Add(message);
                })
                .Returns(Task.CompletedTask);

            contextMock
                .Setup(x => x.Publish(
                    It.IsAny<object>(),
                    It.IsAny<PublishOptions>()))
                .Callback<object, PublishOptions>((message, options) =>
                {
                    publishedMessages.Add(message);
                })
                .Returns(Task.CompletedTask);

            return contextMock;
        }

    }
}
