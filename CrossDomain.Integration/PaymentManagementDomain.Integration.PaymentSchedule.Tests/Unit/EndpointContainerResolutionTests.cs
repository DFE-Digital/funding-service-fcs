namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Unit
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using Framework.Logging;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;

    [TestClass]
    public class EndpointContainerResolutionTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PublishedPayableFcrRepository_ShouldResolveFromPaymentScheduleEndpointContainer()
        {
            using (IWindsorContainer container = new WindsorContainer().Install(new PaymentSchedule.IoC.WindsorInstaller(new LoggerFactory())))
            using (container.BeginScope())
            {
                IPublishedPayableFcrAllocationRepository publishedPayableFcrAllocationRepository = container.Resolve<IPublishedPayableFcrAllocationRepository>();
                Assert.IsInstanceOfType(publishedPayableFcrAllocationRepository, typeof(IPublishedPayableFcrAllocationRepository));
            }
        }
    }
}
