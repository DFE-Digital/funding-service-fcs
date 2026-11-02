namespace FundingAllocation.Tests.Endpoints.GetFundingAllocationsPage
{
    using System.Data.SqlClient;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using FundingAllocation.Endpoints.GetFundingAllocationsPage;
    using FundingAllocation.Repositories;
    using FundingAllocation.Services;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class GetFundingAllocationsPageHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void GetFundingAllocationsPageHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<GetFundingAllocationsPageHandler>());

            container.BeginScope();

            // act
            container.Resolve<GetFundingAllocationsPageHandler>();
        }

        [TestMethod, TestCategory("Exploratory")]
        public void GetFundingAllocationsPageHandler_Technical()
        {
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var context = new FundingAllocationContext(options);
            var handler = new GetFundingAllocationsPageHandler(
                Mock.Of<ILogger>(),
                new FundingNotificationApiTestImpl(AppConfiguration.Configuration()),
                new FundingAllocationRepository(context),
                new FundingAllocationPageControlRepository(context));

            handler.Handle(new GetFundingAllocationsPageCommand
            {
                PageNumber = 1,
                ReadId = 2
            }, new TestableMessageHandlerContext()).Wait();
        }
    }
}
