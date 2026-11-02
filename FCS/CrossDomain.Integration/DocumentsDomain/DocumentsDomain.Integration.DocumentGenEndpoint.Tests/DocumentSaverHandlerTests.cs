namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenEndpoint.Tests
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using DocumentGenerationEndpoint.DocumentSaverEndpoint;
    using DocumentGenerationEndpoint.IoC;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class DocumentSaverHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DocumentSaverHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer().Install(new WindsorInstallerForDocumentSaver(new LoggerFactory()));

            container.Register(Component.For<DocumentSaverHandler>());
            container.BeginScope();

            // Act
            var handler = container.Resolve<DocumentSaverHandler>();

            // Assert
            Assert.IsNotNull(handler);
        }
    }
}
