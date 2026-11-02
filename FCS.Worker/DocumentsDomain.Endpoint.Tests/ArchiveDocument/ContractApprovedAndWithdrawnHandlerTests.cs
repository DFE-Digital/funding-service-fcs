namespace DocumentsDomain.Endpoint.Tests.ArchiveDocument
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.ArchiveDocument;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class ContractApprovedAndWithdrawnHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractApprovedAndWithdrawnHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<ContractApprovedAndWithdrawnHandler>());
            container.BeginScope();

            // act
            container.Resolve<ContractApprovedAndWithdrawnHandler>();
        }
    }
}
