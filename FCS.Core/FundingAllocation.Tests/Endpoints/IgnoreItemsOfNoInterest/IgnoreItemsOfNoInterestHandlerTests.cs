namespace FundingAllocation.Tests.Endpoints.IgnoreItemsOfNoInterest
{
    using System.Collections.Generic;
    using System.Linq;
    using AutoFixture;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Dto;
    using FundingAllocation.Endpoints.CreateProvidersIfNecessaryReply.Services;
    using FundingAllocation.Endpoints.IgnoreItemsOfNoInterest;
    using FundingAllocation.Repositories;
    using FundingAllocation.Services;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class IgnoreItemsOfNoInterestHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void IgnoreItemsOfNoInterestHandler_ShouldResolve()
        {
            var container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<IgnoreItemsOfNoInterestHandler>());

            container.BeginScope();

            // act
            container.Resolve<IgnoreItemsOfNoInterestHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IgnoreItemsOfNoInterestHandler_ShouldOnlySendToContractControlWhenFaHasLinesOfInterest()
        {
            // arrange
            var fixture = new Fixture();
            Mock<IFundingAllocationRepository> fundingAllocationRepMock = new Mock<IFundingAllocationRepository>();
            Mock<ICfsToFcsCodeMappingService> cfsToFcsCodeMappingMock = new Mock<ICfsToFcsCodeMappingService>();
            cfsToFcsCodeMappingMock.Setup(m => m.GetContractItemsMappingResult(It.IsAny<ContractItemsMappingInput>()))
                .ReturnsAsync(fixture.Create<ContractItemsMappingResult>());

            var fa = fixture.Create<DataStore.Model.FundingAllocation>();
            fa.ProviderFundingAllocations.Add(fixture.Create<DataStore.Model.ProviderFundingAllocation>());
            fa.ProviderFundingAllocations.Single().ProviderFunding.FundingAllocationLines.ForEach(l => l.IsOfNoInterest = true);
            fundingAllocationRepMock.Setup(r => r.GetFundingAllocations(It.IsAny<IEnumerable<string>>())).ReturnsAsync(
                new List<FundingAllocation>
                {
                    fa
                });

            IgnoreItemsOfNoInterestHandler handler = new IgnoreItemsOfNoInterestHandler(
                Mock.Of<ILogger>(),
                Mock.Of<IFundingLineFilterService>(),
                cfsToFcsCodeMappingMock.Object,
                fundingAllocationRepMock.Object);

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            // act
            handler.Handle(new IgnoreItemsOfNoInterestCommand(), context).Wait();

            // assert
            var sentCheckForJobCompleteCommands = context.SentMessages
                .Select(m => m.Message)
                .OfType<CheckForJobCompleteCommand>()
                .ToList();
            sentCheckForJobCompleteCommands.Count.Should().Be(1);

            var sentCreateFundingAllocationInCrmCommands = context.SentMessages
                .Select(m => m.Message)
                .OfType<CreateFundingAllocationInCrmCommand>()
                .ToList();
            sentCreateFundingAllocationInCrmCommands.Count.Should().Be(0);
        }
    }
}
