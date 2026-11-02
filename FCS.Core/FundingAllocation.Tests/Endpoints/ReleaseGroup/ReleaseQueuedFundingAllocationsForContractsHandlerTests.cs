namespace FundingAllocation.Tests.Endpoints.ReleaseGroup
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using FundingAllocation.Endpoints.ReleaseGroup;
    using FundingAllocation.Endpoints.ReleaseGroup.Handlers;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ReleaseQueuedFundingAllocationsForContractsHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationReleaseGroupHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<ReleaseQueuedFundingAllocationsForContractsHandler>());

            container.BeginScope();

            // act
            var handler = container.Resolve<ReleaseQueuedFundingAllocationsForContractsHandler>();
        }
    }
}
