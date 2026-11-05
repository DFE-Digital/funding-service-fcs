namespace PaymentManagement.Calculation.Tests.Repositories
{
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentManagement.Calculation.Repositories;

    [TestClass]
    public class DeliverablePaymentRepositoryContainerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePaymentRepository_ResolvesFromContainerWithoutRegisteringContextFactory()
        {
            using (var container = new WindsorContainer())
            {
                container.Register(Component.For<IDeliverablePaymentRepository>().ImplementedBy<DeliverablePaymentRepository>().LifestyleSingleton());

                var resolved = container.Resolve<IDeliverablePaymentRepository>();

                Assert.IsInstanceOfType(resolved, typeof(DeliverablePaymentRepository));
            }
        }
    }
}
