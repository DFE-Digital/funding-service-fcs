namespace ContractRequestDomain.Cfs.Tests
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Common.Events;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using SFA.FCT.Framework.Logging;
    using WindsorInstaller = ContractRequest.Cfs.AllocationCreated;

    [TestClass]
    public class CfsAllocationCreatedCompleteAllocationNotificationHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CompleteAllocationNotificationHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller.WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<IHandleMessages<AllocationCreatedEvent>>().ImplementedBy<WindsorInstaller.CompleteAllocationNotificationHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<IHandleMessages<AllocationCreatedEvent>>();
        }
    }
}