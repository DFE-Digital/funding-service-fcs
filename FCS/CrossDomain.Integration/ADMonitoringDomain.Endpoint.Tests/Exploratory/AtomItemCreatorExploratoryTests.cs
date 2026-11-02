namespace ADMonitoringDomain.Endpoint.Tests.Exploratory
{
    using BusinessLogic;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using CommonKeyVaultUtility;
    using DataStore;
    using Ioc;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentGenerationDomain.Integration.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using System.Linq;

    [TestClass]
    public class AtomItemCreatorExploratoryTests
    {
        [AssemblyInitialize]
        public static void Init(TestContext context)
        {
            TestDbContextFactory.InitializeForTests();
        }
        [TestMethod, TestCategory("DataDependentExploratory")]
        public void AtomItemCreator_GetDeliverables_ShouldReturnExpectedDeliverablesForLevyAllocation()
        {
            // must run AllocationDeliveryCommencedHandler_ShouldPopulateDeliverablePaymentTableForPayOnInstruction beforehand

            // arrange
          ////  IWindsorContainer container = Bootstrapper.CreateContainer(new LoggerFactory());
          //  container.Register(Component.For<IPaymentSchedulePolicyContext>().ImplementedBy<PaymentSchedulePolicyContext>().IsDefault());
          //  container.Register(Component.For<IMonitoringDeliverablesDbContext>().ImplementedBy<MonitoringDeliverablesDbContext>().IsDefault());
          //  container.Register(Component.For<IAllocationDeliveryMonitoringDbContext>().ImplementedBy<AllocationDeliveryMonitoringDbContext>().IsDefault());
          //  container.Register(Component.For<PaymentGenerationDbContext>().ImplementedBy<PaymentGenerationDbContext>().IsDefault());
          //  container.BeginScope();

          //  AtomItemCreator atomItemCreator = (AtomItemCreator)container.Resolve<IAtomItemCreator>();
          //  atomItemCreator.AllocationNumber = "ADCHANDLERALLOC1";
          //  atomItemCreator.ContractVersionNumber = 1;

          //  // act
          //  var deliverables = atomItemCreator.GetDeliverables();

          //  // assert
          //  Assert.AreEqual(12, deliverables.Count);
          //  Assert.IsNotNull(deliverables.SingleOrDefault(d => d.DeliverableCode == 1));
          //  Assert.IsNotNull(deliverables.SingleOrDefault(d => d.DeliverableCode == 2));
          //  Assert.IsNotNull(deliverables.SingleOrDefault(d => d.DeliverableCode == 3));
          //  Assert.IsNotNull(deliverables.SingleOrDefault(d => d.DeliverableCode == 4));
          //  Assert.IsNotNull(deliverables.SingleOrDefault(d => d.DeliverableCode == 5));
          //  Assert.IsNotNull(deliverables.SingleOrDefault(d => d.DeliverableCode == 6));
          //  Assert.IsNotNull(deliverables.SingleOrDefault(d => d.DeliverableCode == 7));
          //  Assert.IsNotNull(deliverables.SingleOrDefault(d => d.DeliverableCode == 8));
          //  Assert.IsNotNull(deliverables.SingleOrDefault(d => d.DeliverableCode == 9));
          //  Assert.IsNotNull(deliverables.SingleOrDefault(d => d.DeliverableCode == 10));
          //  Assert.IsNotNull(deliverables.SingleOrDefault(d => d.DeliverableCode == 11));
          //  Assert.IsNotNull(deliverables.SingleOrDefault(d => d.DeliverableCode == 12));
        }
    }
}
