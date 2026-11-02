namespace PerformanceManagementDomain.Tests.PullFundingClaim.Handlers
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.PullFundingClaim.Handlers;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class UpdateExistingPeriodClaimTypeHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void BeginFundingClaimPullHandler_ShouldResolve_WhenUsingStub()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new PerformanceManagementDomain.PullFundingClaim.WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<UpdateExistingPeriodClaimTypeHandler>().LifestyleScoped());

            container.BeginScope();

            // act, assert
            container.Resolve<UpdateExistingPeriodClaimTypeHandler>();
        }
    }
}
