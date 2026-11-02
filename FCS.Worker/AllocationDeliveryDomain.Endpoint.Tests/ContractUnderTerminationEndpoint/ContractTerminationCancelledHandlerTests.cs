namespace AllocationDeliveryDomain.Endpoint.Tests.ContractUnderTerminationEndpoint
{
    using AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class ContractTerminationCancelledHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractTerminationCancelledHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<ContractTerminationCancelledHandler>().ImplementedBy<ContractTerminationCancelledHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<ContractTerminationCancelledHandler>();
        }
    }
}