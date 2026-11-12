namespace ContractManagementDomain.Endpoint.Tests.DeleteContract
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.DeleteContract;
    using Endpoint.DeleteContract.Repositories;
    using FluentAssertions;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Bespoke;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Collections.Generic;
    using System.Linq;

    [TestClass]
    public class DeleteDraftContractItemsCommandHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DeleteDraftContractItemsCommandHandler_ShouldResolveAllDependencies()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory(Mock.Of<ICloudEnvironment>())))
                .Register(Component.For<DeleteDraftContractItemsCommandHandler>());

            container.BeginScope();

            // act
            container.Resolve<DeleteDraftContractItemsCommandHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeleteDraftContractItemsCommandHandler_ShouldRemoveCreatedContractEntitiesFromStorage_WhenIsSingleContractWhichIsNotSupersededDraft()
        {
            const string contractNumber = "TEST-1234";
            const int contractVersionNumber = 2;

            // arrange
            var crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            crmContractRepositoryMock
                .Setup(m => m.IsSingleContractWhichIsNotSupersededDraft(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(true);

            var createdContractRepositoryMock = new Mock<ICreatedContractRepository>();
            createdContractRepositoryMock
                .Setup(m => m.GetAllContractsForVersion(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new List<ContractIdentifier>());

            var handler = new DeleteDraftContractItemsCommandHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                crmContractRepositoryMock.Object,
                createdContractRepositoryMock.Object);

            var command = new DeleteDraftContractItemsCommand
            {
                ContractNumber = contractNumber,
                VersionNumber = contractVersionNumber
            };

            // act
            handler.Handle(command, new TestableMessageHandlerContext()).Wait();

            // assert
            createdContractRepositoryMock.Verify(
                m => m.RemoveAllForContractVersion(contractNumber, contractVersionNumber, It.IsAny<ConnectionInfo>()),
                Times.Once,
                "Call to remove CreatedContract entities was not made");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeleteDraftContractItemsCommandHandler_ShouldPublishSomeDraftContractDeletedEvents_WhenThereAreAssociatedContractsWithDifferentSubVersions()
        {
            const string contractNumber = "TEST-1234";
            const int contractVersionNumber = 2;

            // arrange
            var crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            crmContractRepositoryMock
                .Setup(m => m.IsSingleContractWhichIsNotSupersededDraft(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(true);

            var expectedContractIdentifiers = new List<ContractIdentifier>()
            {
                new ContractIdentifier(contractNumber, contractVersionNumber, 10),
                new ContractIdentifier(contractNumber, contractVersionNumber, 20)
            };

            var createdContractRepositoryMock = new Mock<ICreatedContractRepository>();
            createdContractRepositoryMock
                .Setup(m => m.GetAllContractsForVersion(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                    .ReturnsAsync(expectedContractIdentifiers);

            var handler = new DeleteDraftContractItemsCommandHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                crmContractRepositoryMock.Object,
                createdContractRepositoryMock.Object);

            var command = new DeleteDraftContractItemsCommand
            {
                ContractNumber = contractNumber,
                VersionNumber = contractVersionNumber
            };

            var handlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, handlerContext).Wait();

            // assert
            List<DraftContractDeletedEvent> actualPublishedEvents = handlerContext.PublishedMessages
                .Select(m => m.Message)
                .OfType<DraftContractDeletedEvent>()
                .ToList();

            actualPublishedEvents.Count.Should().Be(expectedContractIdentifiers.Count);

            expectedContractIdentifiers.ForEach(contractIdentifier =>
            {
                actualPublishedEvents.Should()
                    .Contain(e => e.ContractNumber == contractNumber &&
                                                            e.VersionNumber == contractVersionNumber &&
                                                            e.SubVersionNumber == contractIdentifier.SubVersionNumber);
            });
        }
    }
}
