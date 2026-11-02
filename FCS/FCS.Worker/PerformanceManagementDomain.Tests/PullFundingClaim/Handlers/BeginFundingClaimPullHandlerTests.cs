namespace PerformanceManagementDomain.Tests.PullFundingClaim.Handlers
{
    using System.Configuration;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.PullFundingClaim;
    using PerformanceManagementDomain.PullFundingClaim.Handlers;
    using PerformanceManagementDomain.PullFundingClaim.Services;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class BeginFundingClaimPullHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void BeginFundingClaimPullHandler_ShouldResolve_WhenUsingStub()
        {
            // arrange
            ConfigurationManager.AppSettings["DCT:FundingClaims:UseStub"] = "true";

            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<BeginFundingClaimPullHandler>().LifestyleScoped());

            container.BeginScope();

            // act, assert
            container.Resolve<BeginFundingClaimPullHandler>();
            Assert.AreEqual(typeof(FundingClaimsApiStubAdapter), container.Resolve<IFundingClaimsApiAdapter>().GetType());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void BeginFundingClaimPullHandler_ShouldResolve_WhenNotUsingStub()
        {
            // arrange
            ConfigurationManager.AppSettings["DCT:FundingClaims:UseStub"] = "false";

            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<BeginFundingClaimPullHandler>().LifestyleScoped());

            container.BeginScope();

            // act, assert
            container.Resolve<BeginFundingClaimPullHandler>();
            Assert.AreEqual(typeof(FundingClaimsApiAdapter), container.Resolve<IFundingClaimsApiAdapter>().GetType());
        }
    }
}
