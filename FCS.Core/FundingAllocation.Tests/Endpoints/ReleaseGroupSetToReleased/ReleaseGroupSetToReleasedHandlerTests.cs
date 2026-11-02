namespace FundingAllocation.Tests.Endpoints.ReleaseGroupSetReleased
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using FundingAllocation.Endpoints.ReleaseGroupSetToReleased;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ReleaseGroupSetReleasedHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ReleaseGroupSetReleasedHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<ReleaseGroupSetToReleasedHandler>());

            container.BeginScope();

            // act
            container.Resolve<ReleaseGroupSetToReleasedHandler>();
        }
    }
}