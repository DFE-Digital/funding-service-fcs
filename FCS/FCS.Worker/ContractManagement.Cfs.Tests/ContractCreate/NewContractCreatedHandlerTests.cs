namespace ContractManagement.Cfs.Tests.ContractCreate
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractManagement.Cfs.ContractCreate;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class NewContractCreatedHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void NewContractCreatedHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<IHandleMessages<NewContractCreated>>().ImplementedBy<NewContractCreatedHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<IHandleMessages<NewContractCreated>>();
        }
    }
}