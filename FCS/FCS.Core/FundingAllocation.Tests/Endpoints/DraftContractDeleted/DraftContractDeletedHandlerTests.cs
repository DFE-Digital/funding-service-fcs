namespace FundingAllocation.Tests.Endpoints.DraftContractDeleted
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using FluentAssertions;
    using FundingAllocation.Dto;
    using FundingAllocation.Repositories;
    using FundingAllocation.Endpoints.DraftContractDeleted;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;

    [TestClass]
    public class DraftContractDeletedHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DraftContractDeletedHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<DraftContractDeletedHandler>());

            container.BeginScope();

            // act
            container.Resolve<DraftContractDeletedHandler>();
        }


        [TestMethod, TestCategory("UnitTest")]
        public void DraftContractDeletedHandler_ShouldSendAllFundingAllocationsAndReleaseQueuedForTheContract()
        {
            // Arrange
            var actualContractNumber = "contractNumber";
            var actualContractVersionNumber = 33;
            var actualContractSubVersionNumber = 55;

            var expectedNumberOfFundingAllocations = 3;

            IReadOnlyCollection<FundingAllocationInfo> actualFundingAllocations = Enumerable.Range(1, expectedNumberOfFundingAllocations)
                .Select(i => new FundingAllocationInfo($"FundingId{i}", $"CrmEntityId1{i}"))
                .ToList();

            var repository = new Mock<IContractRepository>();

            repository.Setup(r => r.GetFundingAllocationInfosInContractControl(actualContractNumber, actualContractVersionNumber))
                .Returns(Task.FromResult(actualFundingAllocations));

            var messageHandlerContext = new Mock<IMessageHandlerContext>();

            var actualReturnToSchedulingSentCommands = new List<ReturnToSchedulingFundingAllocationCommand>();
            messageHandlerContext.Setup(ctx => ctx.Send(It.IsAny<ReturnToSchedulingFundingAllocationCommand>(), It.IsAny<SendOptions>()))
                .Callback<object, SendOptions>((ob, so) =>
                    actualReturnToSchedulingSentCommands.Add(ob as ReturnToSchedulingFundingAllocationCommand));

            var actualReleaseQueuedSentCommands = new List<ReleaseQueuedFundingAllocationsForContractsCommand>();
            messageHandlerContext.Setup(ctx => ctx.Send(It.IsAny<ReleaseQueuedFundingAllocationsForContractsCommand>(), It.IsAny<SendOptions>()))
                .Callback<object, SendOptions>((ob, so) =>
                    actualReleaseQueuedSentCommands.Add(ob as ReleaseQueuedFundingAllocationsForContractsCommand));

            var draftContractDeletedEvent = new DraftContractDeletedEvent()
            {
                ContractNumber = actualContractNumber,
                VersionNumber = actualContractVersionNumber,
                SubVersionNumber = actualContractSubVersionNumber
            };

            var target = new DraftContractDeletedHandler(Mock.Of<ILogger>(), repository.Object, Mock.Of<IFundingAllocationRepository>());

            // Act
            target.Handle(draftContractDeletedEvent, messageHandlerContext.Object).Wait();

            // Assert
            actualReturnToSchedulingSentCommands.Count.Should().Be(expectedNumberOfFundingAllocations);

            actualFundingAllocations.ToList().ForEach(fundingAllocation =>
            {
                actualReturnToSchedulingSentCommands.Should()
                    .Contain(command => command.FundingId == fundingAllocation.FundingId &&
                                        command.CrmEntityId == fundingAllocation.CrmEntityId);
            });

            var expectedContractIdentity = new ContractIdentity(
                draftContractDeletedEvent.ContractNumber,
                draftContractDeletedEvent.VersionNumber,
                draftContractDeletedEvent.SubVersionNumber);

            actualReleaseQueuedSentCommands.Count.Should().Be(1);
            actualReleaseQueuedSentCommands.First().ContractIdentities.Single().Should().BeEquivalentTo(expectedContractIdentity);
        }
    }
}