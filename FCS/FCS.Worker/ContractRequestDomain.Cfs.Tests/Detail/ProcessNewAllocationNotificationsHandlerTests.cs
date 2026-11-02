namespace ContractRequestDomain.Cfs.Tests.Detail
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractRequestDomain.Cfs.Common.Commands;
    using ContractRequestDomain.Cfs.Detail;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class ProcessNewAllocationNotificationsHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ProcessNewAllocationNotificationsHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<IHandleMessages<ProcessNewAllocationNotificationsCommand>>().ImplementedBy<ProcessNewAllocationNotificationsHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<IHandleMessages<ProcessNewAllocationNotificationsCommand>>();
        }
    }
}
