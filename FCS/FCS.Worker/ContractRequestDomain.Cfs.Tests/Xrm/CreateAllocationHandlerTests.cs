namespace ContractRequestDomain.Cfs.Tests.Xrm
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractRequestDomain.Cfs.Commands;
    using ContractRequestDomain.Cfs.Xrm;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class CreateAllocationHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CreateAllocationHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<IHandleMessages<CreateAllocationCommand>>().ImplementedBy<CreateAllocationHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<IHandleMessages<CreateAllocationCommand>>();
        }
    }
}
