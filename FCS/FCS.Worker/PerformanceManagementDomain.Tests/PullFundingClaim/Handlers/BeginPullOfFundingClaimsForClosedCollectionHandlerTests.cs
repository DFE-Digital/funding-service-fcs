namespace PerformanceManagementDomain.Tests.PullFundingClaim.Handlers
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.PullFundingClaim;
    using PerformanceManagementDomain.PullFundingClaim.Handlers;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class BeginPullOfFundingClaimsForClosedCollectionHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void BeginPullOfFundingClaimsForClosedCollectionHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<BeginPullOfFundingClaimsForClosedCollectionHandler>().LifestyleScoped());

            container.BeginScope();

            // act, assert
            container.Resolve<BeginPullOfFundingClaimsForClosedCollectionHandler>();
        }
    }
}
