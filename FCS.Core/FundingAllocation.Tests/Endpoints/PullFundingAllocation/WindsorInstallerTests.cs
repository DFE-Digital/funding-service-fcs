namespace FundingAllocation.Tests.Endpoints.PullFundingAllocation
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using FundingAllocation.Endpoints.PullFundingAllocation;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class WindsorInstallerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void WindsorInstaller_ShouldResolvePullFundingAllocationsHandler()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<PullFundingAllocationsHandler>());

            container.BeginScope();

            // act
            container.Resolve<PullFundingAllocationsHandler>();
        }
    }
}
