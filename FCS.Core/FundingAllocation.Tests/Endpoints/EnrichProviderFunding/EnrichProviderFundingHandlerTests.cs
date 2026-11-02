namespace FundingAllocation.Tests.Endpoints.EnrichProviderFunding
{
    using System.Data.SqlClient;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using DataStore.Model;
    using FundingAllocation.Endpoints.EnrichProviderFunding;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class EnrichProviderFundingHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void EnrichProviderFundingHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<EnrichProviderFundingHandler>());

            container.BeginScope();

            // act
            container.Resolve<EnrichProviderFundingHandler>();
        }

        [TestMethod, TestCategory("Exploratory")]
        public void EnrichProviderFundingHandler_ShouldLockFundingAllocationRow()
        {
            const string fundingId = "PSG-AY-2021-Payment-AcademyTrust-10000001-1_0";
            const string providerFundingId = "PSG-AY-2021-10000002-1_0";

            // arrange
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var handlerContext = new FundingAllocationContext(options);
            using var transaction = handlerContext.Database.BeginTransaction();

            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>().Instance(handlerContext))
                .Register(Component.For<EnrichProviderFundingHandler>());

            container.BeginScope();

            var handler = container.Resolve<EnrichProviderFundingHandler>();

            var command = new EnrichProviderFundingCommand
            {
                FundingId = fundingId,
                ProviderFundingId = providerFundingId
            };

            // act
            handler.Handle(command, new TestableMessageHandlerContext()).Wait();
        }

        [TestMethod, TestCategory("Exploratory")]
        public void SetUpData()
        {
            const string fundingId = "PSG-AY-2021-Payment-AcademyTrust-10000001-1_0";
            const string providerFundingId = "PSG-AY-2021-10000002-1_0";

            // arrange
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var arrangeContext = new FundingAllocationContext(options);

            arrangeContext.Database.ExecuteSqlRaw($"DELETE FROM FundingAllocation.FundingAllocation WHERE FundingId = '{fundingId}'");
            arrangeContext.FundingAllocations.Add(new FundingAllocation(
                fundingId, "", "", "",
                "", -1, -1, -1,
                1, 1));
            arrangeContext.ProviderFundingAllocations.Add(new ProviderFundingAllocation(providerFundingId, fundingId));

            arrangeContext.SaveChanges();
        }
    }
}
