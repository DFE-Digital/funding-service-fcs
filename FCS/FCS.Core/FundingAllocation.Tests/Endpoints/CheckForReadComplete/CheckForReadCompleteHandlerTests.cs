namespace FundingAllocation.Tests.Endpoints.CheckForReadComplete
{
    using System.Collections.Generic;
    using FundingAllocation.Dto;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using FundingAllocation.DataStore.Model;
    using FundingAllocation.Endpoints.CheckForReadComplete;
    using FundingAllocation.Repositories;
    using FundingAllocation.Services;
    using Microsoft.Data.SqlClient;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class CheckForReadCompleteHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CheckForReadCompleteHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<CheckForReadCompleteHandler>());

            container.BeginScope();

            // act
            container.Resolve<CheckForReadCompleteHandler>();
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void CheckForReadCompleteHandler_TechnicalExploration()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<CheckForReadCompleteHandler>());

            container.BeginScope();

            // act
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var context = new FundingAllocationContext(options);
            var fundingAllocationRep = new FundingAllocationRepository(context);
            CheckForReadCompleteHandler handler = new CheckForReadCompleteHandler(
                Mock.Of<ILogger>(), new FeedReadRepository(context),new FundingIdService(new FundingAllocationRepository(context)),
                new FundingAllocationRepository(context),
                new ValidationOrchestrator(
                    new PreContractControlService(fundingAllocationRep,
                    new NonMaterialCheckService(fundingAllocationRep),
                    GetConfigValidationService(context)),
                Mock.Of<ICheckForReadCompleteNotificationService>(),
                    Mock.Of<ILogger>()));
            handler.Handle(new CheckForReadCompleteCommand
            {
                FundingAllocationId = "1619-AY-2021-Contract-LocalAuthority-10014025-2_5"
            }, null).Wait();
        }

//        [TestMethod, TestCategory("UnitTest")]
        public void CheckForReadCompleteHandler_ShouldSetFundingAllocationStatusAndSubStatusToParkedPendingAndAwaitingProvider()
        {
            // arrange
            const string fundingId = "fundingId";
            var fundingIdList = new List<string> {fundingId};
            const int notRelevantInt = -1;
            const bool notRelevantBool = false;
            const string notRelevantString = "";
            var notRelevantStringList = new List<string>();
            var notRelevantIntList = new List<int>();

            var mockFeedReadRepository = new Mock<IFeedReadRepository>();
            mockFeedReadRepository.Setup(m => m.IsReadComplete(It.IsAny<string>()))
                .ReturnsAsync(new CheckForReadCompleteResult(true, notRelevantInt));
            mockFeedReadRepository.Setup(m => m.SetToCompleteIfNotAlready(It.IsAny<int>()))
                .ReturnsAsync(true);

            var mockFundingIdService = new Mock<IFundingIdService>();
            mockFundingIdService.Setup(m => m.GetFundingIdsForLatestVersions(It.IsAny<int>()))
                .ReturnsAsync((lastestFundingIds: fundingIdList, supersededFundingIds: notRelevantStringList));

            var createProvidersIfNecessaryCommand = new CreateProvidersIfNecessaryCommand(fundingId, notRelevantIntList, 
                notRelevantBool, notRelevantInt, notRelevantBool, notRelevantString);

            var mockValidationOrchestrator = new Mock<IValidationOrchestrator>();
            mockValidationOrchestrator.Setup(m => m.ValidateAndProcess(It.IsAny<IReadOnlyCollection<string>>(), It.IsAny<int>()))
                .ReturnsAsync((new List<CreateProvidersIfNecessaryCommand> {createProvidersIfNecessaryCommand}, new List<SetBatchToDiscardedCommand>()));

            var mockFundingAllocationRepository = new Mock<IFundingAllocationRepository>();

            var handler = new CheckForReadCompleteHandler(Mock.Of<ILogger>(),
                mockFeedReadRepository.Object,
                mockFundingIdService.Object,
                mockFundingAllocationRepository.Object,
                mockValidationOrchestrator.Object);

            var context = new TestableMessageHandlerContext();

            var command = new CheckForReadCompleteCommand {FundingAllocationId = fundingId};

            // act
            handler.Handle(command, context).Wait();

            // assert
            mockFundingAllocationRepository.Verify(r => r.SetFundingAllocationStatusSubStatus(fundingIdList,
                FundingAllocationStatus.ParkedPending, FundingAllocationSubStatus.ProviderCheck), Times.Once);
        }

        private IConfigValidationService GetConfigValidationService(FundingAllocationContext context)
        {
            return new ConfigValidationService(new ProviderCategoryRepository(context),new AllocationFundingStreamConfigRepository(context),new ContractTypeRepository(context), new AllocationLineConfigRepository(context));
        }
    }
}
