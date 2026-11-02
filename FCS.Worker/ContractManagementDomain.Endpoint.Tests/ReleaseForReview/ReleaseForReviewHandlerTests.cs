namespace ContractManagementDomain.Endpoint.Tests.ReleaseForReview
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using ContractManagementDomain.Endpoint.ReleaseForReview;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class ReleaseForReviewHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ReleaseForReviewHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<ReleaseForReviewHandler>().LifestyleScoped());
            container.BeginScope();

            // act
            container.Resolve<ReleaseForReviewHandler>();
        }
    }
}
