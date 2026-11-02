namespace ContractManagementDomain.Endpoint.Tests.ConfirmPublicationToProvider
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.ConfirmPublicationToProvider;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class DocumentMoveResponseHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DocumentMoveResponseHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<DocumentMoveResponseHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<DocumentMoveResponseHandler>();
        }
    }
}
