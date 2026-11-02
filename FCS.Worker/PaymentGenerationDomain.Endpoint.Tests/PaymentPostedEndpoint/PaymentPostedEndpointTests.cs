namespace PaymentGenerationDomain.Endpoint.Tests.PaymentPostedEndpoint
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.PaymentPostedEndpoint;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class PaymentPostedEndpointTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PaymentPostedEndpoint_ShouldResolveHandler()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new PaymentGenerationDomain.Endpoint.PaymentPostedEndpoint.WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<IHandleMessages<PaymentPostedEvent>>().ImplementedBy<PaymentPostedEventHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<IHandleMessages<PaymentPostedEvent>>();
        }
    }
}
