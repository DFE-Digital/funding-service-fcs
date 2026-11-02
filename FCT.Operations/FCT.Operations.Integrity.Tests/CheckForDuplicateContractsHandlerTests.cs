namespace FCT.Operations.Integrity.Tests
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Operations.Integrity.Handlers;
    using SFA.FCT.Operations.Integrity.IoC;
    using NServiceBus.Testing;
    using Moq;
    using SFA.FCT.Operations.Integrity.Repositories;
    using SFA.FCT.Operations.Integrity.Services;
    using SFA.FCS.Worker.Common;

    [TestClass]
    public class CheckForDuplicateContractsHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CheckForDuplicateContractsHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IFcsConfiguration>()));
            container.Register(Component.For<IHandleMessages<CheckForDuplicateContractsCommand>>()
                .ImplementedBy<CheckForDuplicateContractsHandler>());
            using (container.BeginScope())
            {
                container.Resolve<IHandleMessages<CheckForDuplicateContractsCommand>>();
            }
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void CheckForDuplicateContractsHandler_runHandler()
        {
            // Arrange
            var crmDuplicateContractService = new CrmDuplicateContractService(new CrmDuplicateContractRepository(new LocalConfig()), new DuplicateContractRepository(new LocalConfig()));

            var handler = new CheckForDuplicateContractsHandler(Mock.Of<ILogger>(), crmDuplicateContractService);

            // Act 
            handler.Handle(new CheckForDuplicateContractsCommand(), new TestableMessageHandlerContext()).Wait();

            var i = 1;
        }
    }
}