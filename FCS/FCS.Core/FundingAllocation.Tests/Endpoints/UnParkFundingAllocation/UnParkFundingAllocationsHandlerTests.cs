using System;
namespace FundingAllocation.Tests.Endpoints.UnParkFundingAllocation
{
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using FundingAllocation.Endpoints.UnParkFundingAllocation;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class UnParkFundingAllocationsHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void UnParkFundingAllocationsHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<UnParkFundingAllocationsHandler>());
            
            container.BeginScope();

            // act
            container.Resolve<UnParkFundingAllocationsHandler>();
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void UnParkFundingAllocationsHandler_Technical()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>().Instance(new FundingAllocationContext(DbContextOptions)))
                .Register(Component.For<UnParkFundingAllocationsHandler>());

            container.BeginScope();

            // act
            var handler = container.Resolve<UnParkFundingAllocationsHandler>();
            handler.Handle(new UnParkFundingAllocationsCommand
            {
                FundingAllocationIds = new List<string>
                {
                    "1619-AS-2021-Contract-LocalAuthority-10014025-2_5"
                }
            }, null).Wait();
        }

        private DbContextOptions<FundingAllocationContext> DbContextOptions => new DbContextOptionsBuilder<FundingAllocationContext>()
            .UseSqlServer(new SqlConnection(AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"]))
            .Options;
    }
}
