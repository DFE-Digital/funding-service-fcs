namespace FundingAllocation.Tests.Endpoints.ContractWithdrawn
{
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using FluentAssertions;
    using FundingAllocation.Dto;
    using FundingAllocation.Endpoints.ContractWithdrawn;
    using FundingAllocation.Repositories;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ContractWithdrawnHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractWithdrawnHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<ContractWithdrawnHandler>());

            container.BeginScope();

            // act
            container.Resolve<ContractWithdrawnHandler>();
        }


        [TestMethod, TestCategory("UnitTest")]
        public void ContractWithdrawnHandler_ShouldSendAllFundingAllocationsAndReleaseQueuedForTheContract()
        {
            // Arrange
            var actualContractNumber = "contractNumber";
            var actualContractVersionNumber = 33;
            var actualContractSubVersionNumber = 55;

            var expectedNumberOfFundingAllocations = 3;
            
            var actualFundingAllocations = Enumerable.Range(1, expectedNumberOfFundingAllocations)
                .Select(i => new FundingAllocationInfo($"FundingId{i}", $"CrmEntityId1{i}"))
                .ToList();

            var repository = new Mock<IContractRepository>();

            repository.Setup(r => r.GetFundingAllocationInfosInContractControl(actualContractNumber, actualContractVersionNumber))
                .ReturnsAsync(actualFundingAllocations);

            var messageHandlerContext = new Mock<IMessageHandlerContext>();


            var actualReturnToSchedulingSentCommands = new List<ReturnToSchedulingFundingAllocationCommand>();
            messageHandlerContext.Setup(ctx => ctx.Send(It.IsAny<ReturnToSchedulingFundingAllocationCommand>(), It.IsAny<SendOptions>()))
                .Callback<object, SendOptions>((ob, so) =>
                    actualReturnToSchedulingSentCommands.Add(ob as ReturnToSchedulingFundingAllocationCommand));

            var actualReleaseQueuedSentCommands = new List<ReleaseQueuedFundingAllocationsForContractsCommand>();
            messageHandlerContext.Setup(ctx => ctx.Send(It.IsAny<ReleaseQueuedFundingAllocationsForContractsCommand>(), It.IsAny<SendOptions>()))
                .Callback<object, SendOptions>((ob, so) =>
                    actualReleaseQueuedSentCommands.Add(ob as ReleaseQueuedFundingAllocationsForContractsCommand));

            var contractWithdrawnEvent = new ContractWithdrawnEvent()
            {
                CorporateContract = new Contract
                {
                   contracts = new List<contractType>
                   {
                       new contractType
                       {
                           contractNumber = actualContractNumber,
                           contractVersionNumber = actualContractVersionNumber,
                           contractSubVersionNumber = actualContractSubVersionNumber
                       }
                   }
                }
            };

            var target = new ContractWithdrawnHandler(Mock.Of<ILogger>(), repository.Object, Mock.Of<IFundingAllocationRepository>());

            // Act
            target.Handle(contractWithdrawnEvent, messageHandlerContext.Object).Wait();

            // Assert
            actualReturnToSchedulingSentCommands.Count.Should().Be(expectedNumberOfFundingAllocations);

            actualFundingAllocations.ToList().ForEach(fundingAllocation =>
            {
                actualReturnToSchedulingSentCommands.Should()
                    .Contain(command => command.FundingId == fundingAllocation.FundingId &&
                                        command.CrmEntityId == fundingAllocation.CrmEntityId);
            });

            var expectedContractIdentity = new ContractIdentity(
                actualContractNumber,
                actualContractVersionNumber,
                actualContractSubVersionNumber);

            actualReleaseQueuedSentCommands.Count.Should().Be(1);
            actualReleaseQueuedSentCommands.First().ContractIdentities.Single().Should().BeEquivalentTo(expectedContractIdentity);
        }

        private DbContextOptions<FundingAllocationContext> DbContextOptions => new DbContextOptionsBuilder<FundingAllocationContext>()
            .UseSqlServer(new SqlConnection(AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"]))
            .Options;
    }
}