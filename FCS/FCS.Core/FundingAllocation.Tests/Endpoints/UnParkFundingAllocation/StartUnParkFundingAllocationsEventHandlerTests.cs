namespace FundingAllocation.Tests.Endpoints.UnParkFundingAllocation
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using FundingAllocation.Endpoints.UnParkFundingAllocation;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class StartUnParkFundingAllocationsEventHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CheckReleaseGroupsCanBeReleasedHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<StartUnParkFundingAllocationsEventHandler>());


            container.BeginScope();

            // act
            container.Resolve<StartUnParkFundingAllocationsEventHandler>();
        }
    }
}
