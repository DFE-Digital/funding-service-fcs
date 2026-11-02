namespace FundingAllocation.Tests.Endpoints.CheckForJobCompleteHandler
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using FundingAllocation.Endpoints.CheckForJobComplete;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class CheckForJobCompleteHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CheckForJobCompleteHandler_ShouldResolve()
        {
            var container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<CheckForJobCompleteHandler>());

            container.BeginScope();

            // act
            container.Resolve<CheckForJobCompleteHandler>();
        }
    }
}