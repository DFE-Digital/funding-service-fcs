namespace FundingAllocation.Tests.Endpoints
{
    using System.Data.SqlClient;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using Dapper;
    using FluentAssertions;
    using FundingAllocation.Endpoints.PullFundingAllocation;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using FundingAllocation.Endpoints.GetFundingAllocationsPage;
    using FundingAllocation.Endpoints.EnrichProviderFunding;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;

    [TestClass]
    public class CfsIntegrationTechnicalExplorationTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void CfsIntegrationTechnicalExploration_ReadOneFundingAllocationWhichHasNotYetBeenRead()
        {
            ConfigureAppConfiguration();
            ClearDownPaasTables();

            ProcessHandlersToPopulatePaas();
            GetFundingAllocationCount().Should().Be(57);

            RemoveLastPulledFundingAllocationFromPaas();
            GetFundingAllocationCount().Should().Be(56);
            
            ProcessHandlersToPopulatePaas();
            GetFundingAllocationCount().Should().Be(57);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void CfsIntegrationTechnicalExploration_ReadMultipleFundingAllocationsWhichHasNotYetBeenRead()
        {
            // Multiple allocations on the feed which have not yet been read
            ConfigureAppConfiguration();
            ClearDownPaasTables();

            ProcessHandlersToPopulatePaas();
            GetFundingAllocationCount().Should().Be(57);

            RemoveMultiplePulledFundingAllocationsFromPaas();
            GetFundingAllocationCount().Should().Be(30);

            ProcessHandlersToPopulatePaas();
            GetFundingAllocationCount().Should().Be(57);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void CfsIntegrationTechnicalExploration_NoFurtherAllocationsOnTheFeed_AllHaveBeenRead()
        {
            ConfigureAppConfiguration();
            ClearDownPaasTables();

            ProcessHandlersToPopulatePaas();
            GetFundingAllocationCount().Should().Be(57);

            ProcessHandlersToPopulatePaas();
            GetFundingAllocationCount().Should().Be(57);
        }

        private static void ConfigureAppConfiguration()
        {
            var appConfiguration = AppConfiguration.Configuration();

            appConfiguration["Cfs:ShouldUseStub"] = "false";
            appConfiguration["Cfs:AADInstance"] = "https://login.microsoftonline.com/{0}";
            appConfiguration["Cfs:ClientSecret"] = "<INSERT CLIENT SECRET>";
            appConfiguration["Cfs:ClientId"] = "2aa50637-ee68-4ae1-887f-920511f8e95c";
            appConfiguration["Cfs:Tenant"] = "fad277c9-c60a-4da1-b5f3-b3b8b34a82f9";
            appConfiguration["Cfs:Scope"] = "https://calculatefundingserviceapipreprod/.default";
            appConfiguration["Cfs:RootUrl"] = "https://app-t1sb-external-v2.azurewebsites.net";
        }

        private static FundingAllocationContext CreateFundingAllocationContext()
        {
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;
            return new FundingAllocationContext(options);
        }

        private static void ProcessHandlersToPopulatePaas()
        {
            // PullFundingAllocationsCommand
            var pullFundingAllocationsHandler = CreatePullFundingAllocationsHandler();
            var pullFundingAllocationsHandlerContext = new TestableMessageHandlerContext();
            pullFundingAllocationsHandler.Handle(new PullFundingAllocationsCommand(), pullFundingAllocationsHandlerContext).Wait();

            var getFundingAllocationsPageCommands = pullFundingAllocationsHandlerContext.SentMessages
                .Select(m => m.Message)
                .OfType<GetFundingAllocationsPageCommand>()
                .ToList();

            // GetFundingAllocationsPageCommand
            var getFundingAllocationsPageHandlerDbContext = CreateFundingAllocationContext();
            var getFundingAllocationsPageHandler = CreateGetFundingAllocationsPageHandler(getFundingAllocationsPageHandlerDbContext);
            var getFundingAllocationsPageHandlerContext = new TestableMessageHandlerContext();
            getFundingAllocationsPageCommands.ForEach(gfapc =>
            {
                getFundingAllocationsPageHandlerDbContext.Database.BeginTransaction();
                getFundingAllocationsPageHandler.Handle(gfapc, getFundingAllocationsPageHandlerContext).Wait();
                getFundingAllocationsPageHandlerDbContext.Database.CommitTransaction();
            });

            var enrichFundingAllocationCommands = getFundingAllocationsPageHandlerContext.SentMessages
                .Select(m => m.Message)
                .OfType<EnrichFundingAllocationCommand>()
                .ToList();

            // EnrichFundingAllocationCommand
            var enrichFundingAllocationHandler = CreateEnrichFundingAllocationHandler();
            var enrichFundingAllocationHandlerContext = new TestableMessageHandlerContext();
            enrichFundingAllocationCommands.ForEach(efac =>
            {
                enrichFundingAllocationHandler.Handle(efac, enrichFundingAllocationHandlerContext).Wait();
            });

            var enrichProviderFundingCommands = enrichFundingAllocationHandlerContext.SentMessages
                .Select(m => m.Message)
                .OfType<EnrichProviderFundingCommand>()
                .ToList();

            // EnrichProviderFundingCommand
            var enrichProviderFundingHandler = CreateEnrichProviderFundingHandler();
            var enrichProviderFundingHandlerContext = new TestableMessageHandlerContext();

            enrichProviderFundingCommands.ForEach(epfc =>
            {
                enrichProviderFundingHandler.Handle(epfc, enrichProviderFundingHandlerContext).Wait();
            });

            var createFundingAllocationInCrmCommands = enrichProviderFundingHandlerContext.SentMessages
                .Select(m => m.Message)
                .OfType<CreateFundingAllocationInCrmCommand>()
                .ToList();
        }

        private static PullFundingAllocationsHandler CreatePullFundingAllocationsHandler()
        {
            var container = new WindsorContainer()
                .Install(new FundingAllocation.Endpoints.PullFundingAllocation.WindsorInstaller(Mock.Of<ILogger>(), AppConfiguration.Configuration()))
                .Register(Component.For<FundingAllocationContext>().Instance(CreateFundingAllocationContext()))
                .Register(Component.For<PullFundingAllocationsHandler>());
            container.BeginScope();

            return container.Resolve<PullFundingAllocationsHandler>();
        }

        private static GetFundingAllocationsPageHandler CreateGetFundingAllocationsPageHandler(FundingAllocationContext fundingAllocationContext)
        {
            var container = new WindsorContainer()
                .Install(new FundingAllocation.Endpoints.GetFundingAllocationsPage.WindsorInstaller(Mock.Of<ILogger>(), AppConfiguration.Configuration()))
                .Register(Component.For<FundingAllocationContext>().Instance(fundingAllocationContext))
                .Register(Component.For<GetFundingAllocationsPageHandler>());
            container.BeginScope();

            return container.Resolve<GetFundingAllocationsPageHandler>();
        }

        private static EnrichFundingAllocationHandler CreateEnrichFundingAllocationHandler()
        {
            var container = new WindsorContainer()
                .Install(new FundingAllocation.Endpoints.EnrichProviderFunding.WindsorInstaller(Mock.Of<ILogger>(), AppConfiguration.Configuration()))
                .Register(Component.For<FundingAllocationContext>().Instance(CreateFundingAllocationContext()))
                .Register(Component.For<EnrichFundingAllocationHandler>());
            container.BeginScope();

            return container.Resolve<EnrichFundingAllocationHandler>();
        }

        private static EnrichProviderFundingHandler CreateEnrichProviderFundingHandler()
        {
            var container = new WindsorContainer()
                .Install(new FundingAllocation.Endpoints.EnrichProviderFunding.WindsorInstaller(Mock.Of<ILogger>(), AppConfiguration.Configuration()))
                .Register(Component.For<FundingAllocationContext>().Instance(CreateFundingAllocationContext()))
                .Register(Component.For<EnrichProviderFundingHandler>());
            container.BeginScope();

            return container.Resolve<EnrichProviderFundingHandler>();
        }

        private static void ClearDownPaasTables()
        {
            using var fundingAllocationContext = CreateFundingAllocationContext();

            fundingAllocationContext.Database.ExecuteSqlRaw("DELETE FROM [FundingAllocation].[FundingAllocationPageControl]");
            fundingAllocationContext.Database.ExecuteSqlRaw("DELETE FROM [FundingAllocation].[FundingAllocationProfilePeriod]");
            fundingAllocationContext.Database.ExecuteSqlRaw("DELETE FROM [FundingAllocation].[FundingAllocationLine]");
            fundingAllocationContext.Database.ExecuteSqlRaw("DELETE FROM [FundingAllocation].[FundingAllocation]");
            fundingAllocationContext.Database.ExecuteSqlRaw("DELETE FROM [FundingAllocation].[ProcessedMessage]");
        }

        private static void RemoveLastPulledFundingAllocationFromPaas()
        {
            using var fundingAllocationContext = CreateFundingAllocationContext();

            fundingAllocationContext.Database.ExecuteSqlRaw(@"
                DELETE FROM [FundingAllocation].[FundingAllocation] 
                WHERE PositionInPage = 57");
            fundingAllocationContext.Database.ExecuteSqlRaw(@"
                UPDATE [FundingAllocation].[FundingAllocationPageControl]
                SET LatestBookmarkOnPage = 
                (SELECT TOP 1 fundingId FROM [FundingAllocation].[FundingAllocation] 
                ORDER BY PageNumber desc, PositionInPage desc)");
        }
        
        private static void RemoveMultiplePulledFundingAllocationsFromPaas()
        {
            using var fundingAllocationContext = CreateFundingAllocationContext();

            fundingAllocationContext.Database.ExecuteSqlRaw(@"
                DELETE FROM [FundingAllocation].[FundingAllocation] 
                WHERE PositionInPage > 30");
            fundingAllocationContext.Database.ExecuteSqlRaw(@"
                UPDATE [FundingAllocation].[FundingAllocationPageControl]
                SET LatestBookmarkOnPage = 
                (SELECT TOP 1 fundingId FROM [FundingAllocation].[FundingAllocation] 
                ORDER BY PageNumber desc, PositionInPage desc)");
        }

        private static int GetFundingAllocationCount()
        {
            using var fundingAllocationContext = CreateFundingAllocationContext();

            return fundingAllocationContext.Database.GetDbConnection().ExecuteScalar<int>(
                "SELECT COUNT(*) FROM FundingAllocation.FundingAllocation");
        }
    }
}