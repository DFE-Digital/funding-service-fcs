namespace ContractManagementDomain.Termination.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using System.Data.SqlClient;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractManagement.DataStore.Model;
    using Services;
    using DTOs;
    using FluentAssertions;
    using Handlers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using contract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.Contract;
    using contractAllocationsContractAllocation = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractAllocationsContractAllocation;
    using contractType = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractType;


    [TestClass]
    public class UpdateContractTerminationDetailsHandlerTests
    {
       
        [TestMethod]
        [TestCategory("UnitTest")]
        public void UpdateContractTerminationDetailsHandler_ShouldOnlySetServiceResponseIfAtomItemCreationResultIsAddedOrAlreadyPresent()
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
                    It.IsAny<Action<contract>>(),
                    It.IsAny<string>(),
                    It.IsAny<AtomItemType>()))
                .Returns(new UpdateSubStatusAndAddContractToFeedResult(
                    AtomItemCreationResult.Added,
                    new contract()))
                .Returns(new UpdateSubStatusAndAddContractToFeedResult(
                    AtomItemCreationResult.AlreadyPresentWithSameFeedItemId,
                    new contract()))
                .Returns(new UpdateSubStatusAndAddContractToFeedResult(
                    AtomItemCreationResult.AlreadyPresent,
                    new contract()));

            var sentMessages = new List<object>();

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

            var handler = new UpdateContractTerminationDetailsHandler(
                Mock.Of<ILogger>(),
                sessionConnectionFactoryMock.Object,
                terminateContractFeedServiceMock.Object);

            UpdateContractTerminationDetailsCommand command =
                new UpdateContractTerminationDetailsCommand
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
                2,
                sentMessages.Count,
                "The wrong number of messages were sent");

            Assert.IsInstanceOfType(
                sentMessages[0],
                typeof(SetContractTerminationToCompleteInCrmCommand),
                "The sent message is the wrong type");
        }



        [TestMethod]
        [TestCategory("UnitTest")]
        public void UpdateContractTerminationDetailsHandler_ShouldPublishOneContractPlacedUnderTerminationForUpdatedDetailsEvent()
        {
            // arrange
            Mock<ISessionConnectionFactory> sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
            sessionConnectionFactoryMock.Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateDefault);

            Mock<ITerminateContractFeedService> terminateContractFeedServiceMock = new Mock<ITerminateContractFeedService>();
            terminateContractFeedServiceMock.Setup(m => m.UpdateContractAndAddToFeed(
                    It.IsAny<ConnectionInfo>(),
                    It.IsAny<ContractIdentifier>(),
                    It.IsAny<Action<contract>>(),
                    It.IsAny<string>(),
                    It.IsAny<AtomItemType>()))
                .Returns(new UpdateSubStatusAndAddContractToFeedResult(
                    AtomItemCreationResult.Added,
                    new contract()));

            var handler = new UpdateContractTerminationDetailsHandler(
                Mock.Of<ILogger>(),
                sessionConnectionFactoryMock.Object,
                terminateContractFeedServiceMock.Object);

            UpdateContractTerminationDetailsCommand command =
                new UpdateContractTerminationDetailsCommand
                {
                    ContractNumber = "ABC-1223",
                    VersionNumber = 1,
                    SubVersionNumber = 0
                };

            var publishedMessages = new List<object>();

            var contextMock = new Mock<IMessageHandlerContext>();

            contextMock.Setup(x => x.Publish(
                    It.IsAny<object>(),
                    It.IsAny<PublishOptions>()))
                .Callback<object, PublishOptions>((message, options) =>
                {
                    publishedMessages.Add(message);
                })
                .Returns(Task.CompletedTask);

            // act
            handler.Handle(command, contextMock.Object).Wait();

            // assert
            Assert.AreEqual(
                1,
                publishedMessages.Count,
                "Incorrect number of published events");

            Assert.IsInstanceOfType(
                publishedMessages[0],
                typeof(ContractPlacedUnderTerminationForUpdatedDetailsEvent),
                "ContractPlacedUnderTerminationForUpdatedDetailsEvent was not published");
        }


        [TestMethod]
        [TestCategory("UnitTest")]
        public void UpdateContractTerminationDetailsHandler_ShouldNotPublishContractPlacedUnderTerminationForUpdatedDetailsEvent()
        {
            // arrange
            Mock<ISessionConnectionFactory> sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();

            sessionConnectionFactoryMock.Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateDefault);

            Mock<ITerminateContractFeedService> terminateContractFeedServiceMock =
                new Mock<ITerminateContractFeedService>();

            terminateContractFeedServiceMock.Setup(m => m.UpdateContractAndAddToFeed(
                    It.IsAny<ConnectionInfo>(),
                    It.IsAny<ContractIdentifier>(),
                    It.IsAny<Action<contract>>(),
                    It.IsAny<string>(),
                    It.IsAny<AtomItemType>()))
                .Returns(
                    new UpdateSubStatusAndAddContractToFeedResult(
                        AtomItemCreationResult.AlreadyPresentWithSameFeedItemId,
                        corporateContract: null));

            var handler = new UpdateContractTerminationDetailsHandler(
                Mock.Of<ILogger>(),
                sessionConnectionFactoryMock.Object,
                terminateContractFeedServiceMock.Object);

            UpdateContractTerminationDetailsCommand command =
                new UpdateContractTerminationDetailsCommand
                {
                    ContractNumber = "ABC-1223",
                    VersionNumber = 1,
                    SubVersionNumber = 0
                };

            var publishedMessages = new List<object>();

            var contextMock = new Mock<IMessageHandlerContext>();

            contextMock.Setup(x => x.Publish(
                    It.IsAny<object>(),
                    It.IsAny<PublishOptions>()))
                .Callback<object, PublishOptions>((message, options) =>
                {
                    publishedMessages.Add(message);
                })
                .Returns(Task.CompletedTask);

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
        public void UpdateContractTerminationDetailsHandler_ShouldPublishAnEventWithSomeTerminationAllocationsWhenOnlySomeTerminatinoDatesHaveADate()
        {
            // arrange
            contract corporateContract = new contract
            {
                contracts = new List<contractType>
        {
            new contractType
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
                    It.IsAny<Action<contract>>(),
                    It.IsAny<string>(),
                    It.IsAny<AtomItemType>()))
                .Returns(
                    new UpdateSubStatusAndAddContractToFeedResult(
                        AtomItemCreationResult.Added,
                        corporateContract));

            var handler = new UpdateContractTerminationDetailsHandler(
                Mock.Of<ILogger>(),
                sessionConnectionFactoryMock.Object,
                terminateContractFeedServiceMock.Object);

            UpdateContractTerminationDetailsCommand command =
                new UpdateContractTerminationDetailsCommand
                {
                    ContractNumber = "ABC-1223",
                    VersionNumber = 1,
                    SubVersionNumber = 0
                };

            var publishedMessages = new List<object>();

            var contextMock = new Mock<IMessageHandlerContext>();

            contextMock.Setup(x => x.Publish(
                    It.IsAny<object>(),
                    It.IsAny<PublishOptions>()))
                .Callback<object, PublishOptions>((message, options) =>
                {
                    publishedMessages.Add(message);
                })
                .Returns(Task.CompletedTask);

            // act
            handler.Handle(command, contextMock.Object).Wait();

            // assert
            Assert.AreEqual(
                1,
                publishedMessages.Count,
                "Incorrect number of published events");

            Assert.IsInstanceOfType(
                publishedMessages[0],
                typeof(ContractPlacedUnderTerminationForUpdatedDetailsEvent),
                "ContractPlacedUnderTerminationForUpdatedDetailsEvent was not published");

            var contractPlacedUnderTerminationForUpdatedDetailsEvent =
                (ContractPlacedUnderTerminationForUpdatedDetailsEvent)
                    publishedMessages[0];

            Assert.AreEqual(
                1,
                contractPlacedUnderTerminationForUpdatedDetailsEvent.TerminationAllocations.Count,
                "Incorrect number of termination allocations in the raised event");
        }



        [TestMethod]
        [TestCategory("UnitTest")]
        public void UpdateContractTerminationDetailsHandler_ShouldPublishAnEventWithWithNoTerminationAllocationsWhenAllTerminatinoDatesAreNull()
        {
            // arrange
            contract corporateContract = new contract
            {
                contracts = new List<contractType>
        {
            new contractType
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
                    It.IsAny<Action<contract>>(),
                    It.IsAny<string>(),
                    It.IsAny<AtomItemType>()))
                .Returns(
                    new UpdateSubStatusAndAddContractToFeedResult(
                        AtomItemCreationResult.Added,
                        corporateContract));

            var handler = new UpdateContractTerminationDetailsHandler(
                Mock.Of<ILogger>(),
                sessionConnectionFactoryMock.Object,
                terminateContractFeedServiceMock.Object);

            UpdateContractTerminationDetailsCommand command =
                new UpdateContractTerminationDetailsCommand
                {
                    ContractNumber = "ABC-1223",
                    VersionNumber = 1,
                    SubVersionNumber = 0
                };

            var publishedMessages = new List<object>();

            var contextMock = new Mock<IMessageHandlerContext>();

            contextMock
                .Setup(x => x.Publish(
                    It.IsAny<object>(),
                    It.IsAny<PublishOptions>()))
                .Callback<object, PublishOptions>((message, options) =>
                {
                    publishedMessages.Add(message);
                })
                .Returns(Task.CompletedTask);

            // act
            handler.Handle(command, contextMock.Object).Wait();

            // assert
            Assert.AreEqual(
                1,
                publishedMessages.Count,
                "Incorrect number of published events");

            Assert.IsInstanceOfType(
                publishedMessages[0],
                typeof(ContractPlacedUnderTerminationForUpdatedDetailsEvent),
                "ContractPlacedUnderTerminationForUpdatedDetailsEvent was not published");

            var contractPlacedUnderTerminationForUpdatedDetailsEvent =
                (ContractPlacedUnderTerminationForUpdatedDetailsEvent)
                    publishedMessages[0];

            Assert.AreEqual(
                0,
                contractPlacedUnderTerminationForUpdatedDetailsEvent.TerminationAllocations.Count,
                "Incorrect number of termination allocations in the raised event");
        }


        [TestMethod, TestCategory("UnitTest")]
        public void UpdateContractTerminationDetailsHandler_ShouldResolve()
        {
            Assert.IsNotNull(GetUpdateContractTerminationDetailsHandlerFromContainer());
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void UpdateContractTerminationDetailsHandler_ShouldWork()
        {
            var handler = GetUpdateContractTerminationDetailsHandlerFromContainer();

            //JsonConvert.DeserializeObject<UpdateContractTerminationDetailsCommand>()
            Mock<IMessageHandlerContext> contextMock = new Mock<IMessageHandlerContext>();
            contextMock.SetupGet(m => m.MessageId).Returns("8137B48B-4125-4E65-8C1C-ADE200AD5415");
            Mock<ISessionConnectionFactory> sessionMock = new Mock<ISessionConnectionFactory>();
            SqlConnection connection = new SqlConnection("");
            sessionMock.Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(new ConnectionInfo(null, connection));

           // handler._sessionConnectionFactory = sessionMock.Object;
            handler.Handle(new UpdateContractTerminationDetailsCommand
            {
                ContractNumber = "MAIN-736",
                VersionNumber = 1,
                SubVersionNumber = 0
            }, contextMock.Object).Wait();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UpdateContractTerminationDetailsHandler_SerialXmlShouldContainTerminationAttr()
        {
            // arrange
            SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.Contract contractSchema = new SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.Contract();
            contractSchema.contracts.Add(new SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contractType()
            {
                TerminationContractAttrs = new TerminationContractAttrsCT
                {
                    terminationDate = null
                },
                contractAllocations = new List<SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contractAllocationsContractAllocation>
                {
                    new SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contractAllocationsContractAllocation
                    {
                        allocationTerminationAttrs = new TerminationAllocationAttrsCT
                        {
                            fundingCessationDate = DateTime.Now
                        }
                    }
                }
            });

            // act
            var xml = contractSchema.SerializeToXml();

            // assert
            xml.IndexOf("TerminationContractAttrs", StringComparison.Ordinal).Should().NotBe(-1);
        }

        private static UpdateContractTerminationDetailsHandler GetUpdateContractTerminationDetailsHandlerFromContainer()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new ContractManagementDomain.Termination.WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<ContractManagementDomain.Termination.Handlers.UpdateContractTerminationDetailsHandler>().ImplementedBy<UpdateContractTerminationDetailsHandler>());

            container.BeginScope();

            return container.Resolve<UpdateContractTerminationDetailsHandler>();
        }
    }
}