namespace ContractManagement.Cfs.Tests.ContractCreate
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Cfs.ContractCreate;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class DocumentGenerationCompleteHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DocumentGenerationCompleteHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<IHandleMessages<DocumentGenerationComplete>>().ImplementedBy<DocumentGenerationCompleteHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<IHandleMessages<DocumentGenerationComplete>>();
        }
    }
}
