namespace FundingAllocation.Tests.Endpoints.CheckForMissingProvidersPostReadComplete
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using FundingAllocation.Endpoints.CheckForMissingProvidersPostReadComplete;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class CheckForMissingProvidersPostReadCompleteHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CheckForMissingProvidersPostReadCompleteHandler_ShouldResolve()
        {
            var container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<CheckForMissingProvidersPostReadCompleteHandler>());

            container.BeginScope();

            // act
            container.Resolve<CheckForMissingProvidersPostReadCompleteHandler>();
        }
    }
}
