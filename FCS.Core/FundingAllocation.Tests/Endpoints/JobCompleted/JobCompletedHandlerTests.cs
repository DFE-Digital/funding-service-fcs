namespace FundingAllocation.Tests.Endpoints.JobCompleted
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using FundingAllocation.Endpoints.JobCompleted;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Collections.Generic;
    using FundingAllocation.Repositories;
    using FundingAllocation.Services;
    using FundingAllocation.DataStore.Model;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;

    [TestClass]
    public class JobCompletedHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void JobCompletedHandler_ShouldResolve()
        {
            // arrange
            var container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<JobCompletedHandler>());

            container.BeginScope();

            // act
            container.Resolve<JobCompletedHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void JobCompletedHandler_ShouldSetFundingAllocationStatusAndSubStatusToParkedPendingAndAwaitingProvider()
        {
            // arrange
            const string fundingId1 = "fundingId1";
            const string fundingId2 = "fundingId2";
            var fundingIdList = new List<string> { fundingId1, fundingId2 };
            const int notRelevantInt = -1;
            const bool notRelevantBool = false;
            const string notRelevantString = "";
            var notRelevantIntList = new List<int>();

            var mockFundingAllocationRepository = new Mock<IFundingAllocationRepository>();
            mockFundingAllocationRepository.Setup(m => m.GetAllFundingIdsAwaitingProviderNotInCurrentRead(It.IsAny<int>()))
                .ReturnsAsync(fundingIdList);

            var createProvidersIfNecessaryCommand1 = new CreateProvidersIfNecessaryCommand(fundingId1, notRelevantIntList, notRelevantBool, notRelevantInt, notRelevantBool, notRelevantString);
            var createProvidersIfNecessaryCommand2 = new CreateProvidersIfNecessaryCommand(fundingId2, notRelevantIntList, notRelevantBool, notRelevantInt, notRelevantBool, notRelevantString);
            var mockValidationOrchestrator = new Mock<IValidationOrchestrator>();
            mockValidationOrchestrator.Setup(m => m.ValidateAndProcessProviderNotFound(It.IsAny<IReadOnlyCollection<string>>()))
                .ReturnsAsync(new List<CreateProvidersIfNecessaryCommand> {createProvidersIfNecessaryCommand1, createProvidersIfNecessaryCommand2});

            var handler = new JobCompletedHandler(Mock.Of<IJobCompleteRepository>(),
                Mock.Of<IFundingIdService>(),
                mockValidationOrchestrator.Object,
                Mock.Of<ILogger>(),
                mockFundingAllocationRepository.Object);

            var context = new TestableMessageHandlerContext();

            var command = new JobCompletedCommand(notRelevantInt);

            // act
            handler.Handle(command, context).Wait();

            // assert
            mockFundingAllocationRepository.Verify(r => r.SetFundingAllocationStatusSubStatus(fundingIdList,
                FundingAllocationStatus.ParkedPending, FundingAllocationSubStatus.ProviderCheck), Times.Exactly(1));
        }
    }
}
