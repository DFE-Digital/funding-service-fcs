namespace OrganisationDomain.Endpoint.Tests.Xrm
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.Xrm;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class CreateProviderUpdatedNotificationHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CreateProviderUpdatedNotificationHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<CreateProviderUpdatedNotificationHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<CreateProviderUpdatedNotificationHandler>();
        }
    }
}
