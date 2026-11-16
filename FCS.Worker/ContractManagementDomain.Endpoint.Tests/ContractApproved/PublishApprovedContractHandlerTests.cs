namespace ContractManagementDomain.Endpoint.Tests.ContractApproved
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.ContractApproved;
    using Endpoint.ContractApproved.Services;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class PublishApprovedContractHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PublishApprovedContractHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<PublishApprovedContractHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<PublishApprovedContractHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PublishApprovedContractHandler_ShouldNotPublishApprovedEventWhenApprovedContractAlreadyExistsAndAtomItemCreationResultIsAlreadyPresent()
        {
            // arrange
            Mock<IApprovedContractAtomFeedItemCreationService> contractAtomFeedItemCreationServiceMock = new Mock<IApprovedContractAtomFeedItemCreationService>();
            contractAtomFeedItemCreationServiceMock
                .Setup(s => s.AddApprovedContract(It.IsAny<Contract>(), It.IsAny<Guid>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(AtomItemCreationResult.AlreadyPresent);

            Mock<IContractsManager> contractsManagerMock = new Mock<IContractsManager>();
            contractsManagerMock
                .Setup(c => c.GetCorporateContract(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new Contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType()
                    }
                });

            PublishApprovedContractHandler handler = new PublishApprovedContractHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                contractsManagerMock.Object,
                contractAtomFeedItemCreationServiceMock.Object,
                Mock.Of<IApprovedContractPopulateCacheService>());

            PublishApprovedContractCommand command = new PublishApprovedContractCommand
            {
                ContractNumber = "XX",
                MasterContractNumber = "YY"
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, context).Wait();

            // assert
            Assert.AreEqual(0, context.PublishedMessages.Length, "Events have been published");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PublishApprovedContractHandler_ShouldPublishApprovedEventWhenApprovedContractDoesNotAlreadyExistAndAtomItemCreationResultIsAdded()
        {
            // arrange
            Mock<IApprovedContractAtomFeedItemCreationService> contractAtomFeedItemCreationServiceMock = new Mock<IApprovedContractAtomFeedItemCreationService>();
            contractAtomFeedItemCreationServiceMock
                .Setup(s => s.AddApprovedContract(It.IsAny<Contract>(), It.IsAny<Guid>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(AtomItemCreationResult.Added);

            Mock<IContractsManager> contractsManagerMock = new Mock<IContractsManager>();
            contractsManagerMock
                .Setup(c => c.GetCorporateContract(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new Contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType()
                    }
                });

            PublishApprovedContractHandler handler = new PublishApprovedContractHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                contractsManagerMock.Object,
                contractAtomFeedItemCreationServiceMock.Object,
                Mock.Of<IApprovedContractPopulateCacheService>());

            PublishApprovedContractCommand command = new PublishApprovedContractCommand
            {
                ContractNumber = "XX",
                MasterContractNumber = "YY"
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, context).Wait();

            // assert
            Assert.AreEqual(1, context.PublishedMessages.Select(pm => pm.Message).OfType<ContractApprovedEvent>().Count(), "Events have not been published");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PublishApprovedContractHandler_ShouldPublishApprovedEventWhenApprovedContractAlreadyExistsAndAtomItemCreationResultIsAlreadyPresentWithSameMessageId()
        {
            // arrange
            Mock<IApprovedContractAtomFeedItemCreationService> contractAtomFeedItemCreationServiceMock = new Mock<IApprovedContractAtomFeedItemCreationService>();
            contractAtomFeedItemCreationServiceMock
                .Setup(s => s.AddApprovedContract(It.IsAny<Contract>(), It.IsAny<Guid>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(AtomItemCreationResult.AlreadyPresentWithSameFeedItemId);

            Mock<IContractsManager> contractsManagerMock = new Mock<IContractsManager>();
            contractsManagerMock
                .Setup(c => c.GetCorporateContract(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new Contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType()
                    }
                });

            PublishApprovedContractHandler handler = new PublishApprovedContractHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                contractsManagerMock.Object,
                contractAtomFeedItemCreationServiceMock.Object,
                Mock.Of<IApprovedContractPopulateCacheService>());

            PublishApprovedContractCommand command = new PublishApprovedContractCommand
            {
                ContractNumber = "XX",
                MasterContractNumber = "YY"
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, context).Wait();

            // assert
            Assert.AreEqual(1, context.PublishedMessages.Select(pm => pm.Message).OfType<ContractApprovedEvent>().Count(), "Events have not been published");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PublishApprovedContractHandler_ShouldAddApprovedContractIfAtomItemAdded()
        {
            // arrange
            Mock<IApprovedContractAtomFeedItemCreationService> contractAtomFeedItemCreationServiceMock = new Mock<IApprovedContractAtomFeedItemCreationService>();
            contractAtomFeedItemCreationServiceMock
                .Setup(s => s.AddApprovedContract(It.IsAny<Contract>(), It.IsAny<Guid>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(AtomItemCreationResult.Added);

            Mock<IContractsManager> contractsManagerMock = new Mock<IContractsManager>();
            contractsManagerMock
                .Setup(c => c.GetCorporateContract(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new Contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType()
                    }
                });

            Mock<IApprovedContractPopulateCacheService> approvedContractService = new Mock<IApprovedContractPopulateCacheService>();

            PublishApprovedContractHandler handler = new PublishApprovedContractHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                contractsManagerMock.Object,
                contractAtomFeedItemCreationServiceMock.Object,
                approvedContractService.Object);

            PublishApprovedContractCommand command = new PublishApprovedContractCommand
            {
                ContractNumber = "XX",
                MasterContractNumber = "YY"
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, context).Wait();

            // assert
            approvedContractService.Verify(s => s.UpdateApprovedContractCache(
                It.IsAny<Contract>(),
                It.IsAny<string>(),
                It.IsAny<ConnectionInfo>()), Times.Once, "failed to call UpdateApprovedContractCache");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PublishApprovedContractHandler_ShouldNotAddApprovedContractIfAtomItemNotAdded()
        {
            // arrange
            Mock<IApprovedContractAtomFeedItemCreationService> contractAtomFeedItemCreationServiceMock = new Mock<IApprovedContractAtomFeedItemCreationService>();
            contractAtomFeedItemCreationServiceMock
                .Setup(s => s.AddApprovedContract(It.IsAny<Contract>(), It.IsAny<Guid>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(AtomItemCreationResult.AlreadyPresentWithSameFeedItemId);

            Mock<IContractsManager> contractsManagerMock = new Mock<IContractsManager>();
            contractsManagerMock
                .Setup(c => c.GetCorporateContract(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new Contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType()
                    }
                });

            Mock<IApprovedContractPopulateCacheService> approvedContractService = new Mock<IApprovedContractPopulateCacheService>();

            PublishApprovedContractHandler handler = new PublishApprovedContractHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                contractsManagerMock.Object,
                contractAtomFeedItemCreationServiceMock.Object,
                approvedContractService.Object);

            PublishApprovedContractCommand command = new PublishApprovedContractCommand
            {
                ContractNumber = "XX",
                MasterContractNumber = "YY"
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, context).Wait();

            // assert
            approvedContractService.Verify(s => s.UpdateApprovedContractCache(
                It.IsAny<Contract>(),
                It.IsAny<string>(),
                It.IsAny<ConnectionInfo>()), Times.Never, "should not have called UpdateApprovedContractCache");
        }
    }
}
