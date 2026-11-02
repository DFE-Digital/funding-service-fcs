namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Test.Integration
{
    using System.Linq;
    using AllocationDeliveryDomain.Common.DataStore;
    using AllocationDeliveryDomain.Common.DataStore.Model;
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using Framework.Logging;
    using Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using PolicyCache.DataStore;
    using PolicyCache.DataStore.Model;
    using Services;

    [TestClass]
    public class DeliverableToSubnominalServiceTests
    {
        private const string ContractNumberTest = "CN";
        private const string AllocationNumberTest = "AN";
        private const RegionType RegionTypeTest = RegionType.LessDeveloped;
        private const decimal InvestmentPriorityTest = 5.5M;
        private const string FundingStreamPeriodEsfTest = "ESF1420";
        private const string FundingStreamPeriodNonEsfTest = "Non Esf FSP";
        private const string SubnominalCodeTest = "12345678";
        private const int DeliverableCodeTest = 1;

        [TestInitialize]
        public void Setup()
        {
            SetupIoC();

            CleanUp();

            // esf
            AddTestRowToEsfAllocationData();
            AddTestRowToPolicyFundingStreamPeriodSubnominal();

            // non esf
            AddTestRowToPolicyFundingStreamPeriod();
            AddTestRowsToPolicyDeliverable();
            AddTestRowsToPolicyDeliverableToSubnominals();
        }

        [TestCleanup]
        public void CleanUp()
        {
            // esf
            RemoveTestRowFromEsfAllocationData();
            RemoveTestRowFromPolicyFundingStreamPeriodSubnominal();

            // non esf
            RemoveTestRowsFromPolicyDeliverableToSubnominals();
            RemoveTestRowsFromPolicyDeliverable();
            RemoveTestRowFromPolicyFundingStreamPeriod();
        }

        private void RemoveTestRowsFromPolicyDeliverable()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyDeliverables.Where(
                    sub => sub.FundingStreamPeriod == FundingStreamPeriodNonEsfTest)
                    .ForEach(row => context.PolicyDeliverables.Remove(row));

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverableToSubnominalService_ShouldResolveIDeliverableToSubnominalService()
        {
            // act
            IDeliverableToSubnominalService service = Container.Resolve<IDeliverableToSubnominalService>();

            // assert
            Assert.IsNotNull(service);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverableToSubnominalService_ShouldGetCorrectEsfSubnominalCodeForEsfFundingStreamPeriod()
        {
            // arrange
            IDeliverableToSubnominalService service = Container.Resolve<IDeliverableToSubnominalService>();

            // act
            SubnominalValue subnominalValue = service.GetSubnominalValue(FundingStreamPeriodEsfTest, DeliverableCodeTest, AllocationNumberTest, ContractNumberTest);

            // assert
            Assert.AreEqual(int.Parse(SubnominalCodeTest), subnominalValue.Reconciliation, "The Reconciliation value has not been set correctly");
            Assert.AreEqual(int.Parse(SubnominalCodeTest), subnominalValue.Capping, "The Capping value has not been set correctly");
            Assert.AreEqual(0, subnominalValue.Profile, "The Profile value should not be set for Esf");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverableToSubnominalService_ShouldGetCorrectNonnEsfSubnominalCodeForNonEsfFundingStreamPeriod()
        {
            // arrange
            IDeliverableToSubnominalService service = Container.Resolve<IDeliverableToSubnominalService>();

            // act
            SubnominalValue subnominalValueForDeliverableCode1 = service.GetSubnominalValue(FundingStreamPeriodNonEsfTest, 1, AllocationNumberTest, ContractNumberTest);
            SubnominalValue subnominalValueForDeliverableCode2 = service.GetSubnominalValue(FundingStreamPeriodNonEsfTest, 2, AllocationNumberTest, ContractNumberTest);

            // assert
            Assert.AreEqual(2201060, subnominalValueForDeliverableCode1.Reconciliation, "The Reconciliation value has not been set correctly for deliverableCode 1");
            Assert.AreEqual(2201060, subnominalValueForDeliverableCode1.Capping, "The Capping value has not been set correctly for deliverableCode 1");
            Assert.AreEqual(0, subnominalValueForDeliverableCode1.Profile, "The Profile value should not be set for Esf for deliverableCode 1");

            Assert.AreEqual(2201071, subnominalValueForDeliverableCode2.Reconciliation, "The Reconciliation value has not been set correctly for deliverableCode 2");
            Assert.AreEqual(2201071, subnominalValueForDeliverableCode2.Capping, "The Capping value has not been set correctly for deliverableCode 2");
            Assert.AreEqual(0, subnominalValueForDeliverableCode2.Profile, "The Profile value should not be set for Esf for deliverableCode 2");
        }
        
        private IWindsorContainer Container { get; set; }

        private void SetupIoC()
        {
            ILoggerFactory factory = new LoggerFactory();

            Container =
                new WindsorContainer().Install(
                    new SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation.IoC.WindsorInstaller(factory));
            Container.BeginScope();
        }

        private void AddTestRowToEsfAllocationData()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.ESFAllocationData.Add(new EsfAllocationData
                {
                    ContractNumber = ContractNumberTest,
                    ContractAllocationNumber = AllocationNumberTest,
                    RegionType = RegionTypeTest.ToString(),
                    InvestmentPriority = InvestmentPriorityTest.ToString()
                });

                context.SaveChanges();
            }
        }

        private void RemoveTestRowFromEsfAllocationData()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.ESFAllocationData.Where(esf => esf.ContractNumber == ContractNumberTest &&
                esf.ContractAllocationNumber == AllocationNumberTest).ForEach(esf => context.ESFAllocationData.Remove(esf));

                context.SaveChanges();
            }
        }

        private void AddTestRowToPolicyFundingStreamPeriodSubnominal()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.ESFRegionInvestmentPriorities.Add(
                    new ESFRegionInvestmentPriority(RegionTypeTest, InvestmentPriorityTest, SubnominalCodeTest));

                context.SaveChanges();
            }
        }

        private void RemoveTestRowFromPolicyFundingStreamPeriodSubnominal()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.ESFRegionInvestmentPriorities.Where(sub => sub.RegionType == RegionTypeTest.ToString() && sub.InvestmentPriority == InvestmentPriorityTest)
                    .ForEach(row => context.ESFRegionInvestmentPriorities.Remove(row));

                context.SaveChanges();
            }
        }

        private void AddTestRowsToPolicyDeliverableToSubnominals()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyDeliverableToSubnominals.Add(
                    new PolicyDeliverableToSubnominals
                    {
                        FundingStreamPeriod = FundingStreamPeriodNonEsfTest,
                        PaymentType = PaymentType.Capping,
                        DeliverableCode = 1,
                        SubnominalCode = 2201060
                    });
                context.PolicyDeliverableToSubnominals.Add(
                   new PolicyDeliverableToSubnominals
                   {
                       FundingStreamPeriod = FundingStreamPeriodNonEsfTest,
                       PaymentType = PaymentType.Reconciliation,
                       DeliverableCode = 1,
                       SubnominalCode = 2201060
                   });
                context.PolicyDeliverableToSubnominals.Add(
                    new PolicyDeliverableToSubnominals
                    {
                        FundingStreamPeriod = FundingStreamPeriodNonEsfTest,
                        PaymentType = PaymentType.Capping,
                        DeliverableCode = 2,
                        SubnominalCode = 2201071
                    });
                context.PolicyDeliverableToSubnominals.Add(
                   new PolicyDeliverableToSubnominals
                   {
                       FundingStreamPeriod = FundingStreamPeriodNonEsfTest,
                       PaymentType = PaymentType.Reconciliation,
                       DeliverableCode = 2,
                       SubnominalCode = 2201071
                   });

                context.SaveChanges();
            }
        }

        private void RemoveTestRowsFromPolicyDeliverableToSubnominals()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyDeliverableToSubnominals.Where(
                    sub => sub.FundingStreamPeriod == FundingStreamPeriodNonEsfTest)
                    .ForEach(row => context.PolicyDeliverableToSubnominals.Remove(row));

                context.SaveChanges();
            }
        }

        private void AddTestRowToPolicyFundingStreamPeriod()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyFundingStreamPeriods.Add(new PolicyFundingStreamPeriod
                {
                    FundingStreamPeriod = FundingStreamPeriodNonEsfTest,
                    PaymentMethod = PaymentMethod.NoPay
                });

                context.SaveChanges();
            }
        }

        private void RemoveTestRowFromPolicyFundingStreamPeriod()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyFundingStreamPeriods.Where(
                    sub => sub.FundingStreamPeriod == FundingStreamPeriodNonEsfTest)
                    .ForEach(row => context.PolicyFundingStreamPeriods.Remove(row));

                context.SaveChanges();
            }
        }

        private void AddTestRowsToPolicyDeliverable()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyDeliverables.Add(new PolicyDeliverable
                {
                    FundingStreamPeriod = FundingStreamPeriodNonEsfTest,
                    DeliverableCode = 1
                });
                context.PolicyDeliverables.Add(new PolicyDeliverable
                {
                    FundingStreamPeriod = FundingStreamPeriodNonEsfTest,
                    DeliverableCode = 2
                });

                context.SaveChanges();
            }
        }
    }
}
