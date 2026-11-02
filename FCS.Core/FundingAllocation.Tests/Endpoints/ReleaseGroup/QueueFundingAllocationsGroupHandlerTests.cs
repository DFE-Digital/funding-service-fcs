namespace FundingAllocation.Tests.Endpoints.ReleaseGroup
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using FundingAllocation.Endpoints.ReleaseGroup.Handlers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;
    using WindsorInstaller = FundingAllocation.Endpoints.ReleaseGroup.WindsorInstaller;

    [TestClass]
    public class QueueFundingAllocationsGroupHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void QueueFundingAllocationsGroupHandler_ShouldResolve()
        {
            // arrange
            var container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), AppConfiguration.Configuration()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<QueueFundingAllocationsGroupHandler>());

            container.BeginScope();

            // act
            container.Resolve<QueueFundingAllocationsGroupHandler>();
        }
    }
}
