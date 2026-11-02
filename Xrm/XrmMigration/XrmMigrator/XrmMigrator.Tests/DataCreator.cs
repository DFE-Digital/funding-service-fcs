using Castle.MicroKernel.Registration;
using Castle.Windsor;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
using System.Linq;
using XrmMigrator.Tests.IoC;

namespace XrmMigrator.Tests
{
    [TestClass]
    public class DataCreator
    {
        private readonly IWindsorContainer _container;

        public DataCreator()
        {
            _container = Bootstrapper.CreateContainer();
            _container.Register(Component.For<IPaymentSchedulePolicyContext>().ImplementedBy<PaymentSchedulePolicyContext>());
            _container.Register(Component.For<IPaymentManagementPolicyContext>().ImplementedBy<PaymentManagementPolicyContext>());
        }

        [TestMethod]
        public void SaveDeliverablePeriodSubnominals()
        {
            var paymentSchedulePolicyContext = _container.Resolve<IPaymentSchedulePolicyContext>();
            var maxDeliverablePayments = 20;
            var maxdeliverableCodes = 2;
            for (var i = 1; i <= maxDeliverablePayments; i++)
            {
                for (var j = 1; j <= maxdeliverableCodes; j++)
                {
                    for (var k = 8; k <= 9; k++)
                    {
                        var deliverablePayment = new DeliverablePayment
                        {
                            AllocationNumber = i.ToString("AGE-#"),
                            DeliverableCode = j,
                            VersionNumber = 1,
                            Period = "2015" + k.ToString("D" + 2),
                            NetPaymentAmount = 100
                        };

                        paymentSchedulePolicyContext.DeliverablePayments.Add(deliverablePayment);
                    }
                }

                var allocation = new Allocation
                {
                    AllocationNumber = i.ToString("AGE-#"),
                    FundingStreamPeriodCode = "AGE1516",
                    VersionNumber = 1
                };

                paymentSchedulePolicyContext.Allocations.Add(allocation);

            }

            paymentSchedulePolicyContext.SaveChanges();
        }

        [TestMethod]
        public void ClearDeliverablePeriodSubnominals()
        {
            var paymentSchedulePolicyContext = _container.Resolve<IPaymentSchedulePolicyContext>();

            var deliverablePayments = paymentSchedulePolicyContext.DeliverablePayments.Where(x => x.AllocationNumber.StartsWith("AGE")).ToList();
            deliverablePayments.ForEach(x => paymentSchedulePolicyContext.DeliverablePayments.Remove(x));

            var allocations = paymentSchedulePolicyContext.Allocations.Where(x => x.AllocationNumber.StartsWith("AGE")).ToList();
            allocations.ForEach(x => paymentSchedulePolicyContext.Allocations.Remove(x));
           
            paymentSchedulePolicyContext.SaveChanges();

        }
    }
}
