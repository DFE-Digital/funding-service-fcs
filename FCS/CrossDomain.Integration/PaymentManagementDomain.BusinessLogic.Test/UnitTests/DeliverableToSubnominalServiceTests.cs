namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Test.UnitTests
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using AllocationDeliveryDomain.Common.DataStore;
    using AllocationDeliveryDomain.Common.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PolicyCache.DataStore;
    using PolicyCache.DataStore.Model;
    using Services;

    [TestClass]
    public class DeliverableToSubnominalServiceTests
    {
        private const string ContractNumberTest = "CN";
        private const string ContractAllocationNumberTest = "AN";
        private const RegionType RegionTypeTest = RegionType.LessDeveloped;
        private const string FundingStreamPeriodEsfTest = "ESF1420";
        private const string FundingStreamPeriodNonEsfTest = "16-18APPS1516";
        private const int DeliverableCodeTest = 1;
        private const int SubnominalCodeTest = 12345678;
        private const int SubnominalCodeCappingTest = 12345678;
        private const int SubnominalCodeReconcilliationTest = 8;
        private const int SubnominalCodeProfileTest = 678;

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableToSubnominalService_ShouldGetSubnominalCodeFromEsfAreaWhenEsfFundingStreamPeriod()
        {
            // arrange
            Mock<IPaymentManagementPolicyContext> paymentManagementPolicyContextMock = new Mock<IPaymentManagementPolicyContext>();
            paymentManagementPolicyContextMock.Setup(p => p.ESFRegionInvestmentPriorities)
                .Returns(CreatePolicyFundingStreamPeriodSubnominals());

            Mock<IMonitoringDeliverablesDbContext> monitoringDeliverablesDbContextMock = new Mock<IMonitoringDeliverablesDbContext>();
            monitoringDeliverablesDbContextMock.Setup(m => m.ESFAllocationData).Returns(CreateESFAllocationData());

            DeliverableToSubnominalService service = new DeliverableToSubnominalService(paymentManagementPolicyContextMock.Object, monitoringDeliverablesDbContextMock.Object);
            
            // act
            SubnominalValue subnominalValue = service.GetSubnominalValue(fundingStreamPeriodCode: FundingStreamPeriodEsfTest,
                deliverableCode: DeliverableCodeTest,
                contractAllocationNumber: ContractAllocationNumberTest,
                contractNumber: ContractNumberTest);

            // assert
            Assert.AreEqual(SubnominalCodeTest, subnominalValue.Capping, "The capping values are not equal");
            Assert.AreEqual(SubnominalCodeTest, subnominalValue.Reconciliation, "The Reconciliation values are not equal");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableToSubnominalService_ShouldGetSubnominalCodesForNonEsfFundingStreamPeriod()
        {
            // arrange
            Mock<IPaymentManagementPolicyContext> paymentManagementPolicyContextMock = new Mock<IPaymentManagementPolicyContext>();
            paymentManagementPolicyContextMock.Setup(p => p.ESFRegionInvestmentPriorities)
                .Returns(CreatePolicyFundingStreamPeriodSubnominals());

            paymentManagementPolicyContextMock.Setup(p => p.PolicyDeliverableToSubnominals)
                .Returns(CreatePolicyDeliverableToSubnominals());

            Mock<IMonitoringDeliverablesDbContext> monitoringDeliverablesDbContextMock = new Mock<IMonitoringDeliverablesDbContext>();
            monitoringDeliverablesDbContextMock.Setup(m => m.ESFAllocationData).Returns(CreateESFAllocationData());

            DeliverableToSubnominalService service = new DeliverableToSubnominalService(paymentManagementPolicyContextMock.Object, monitoringDeliverablesDbContextMock.Object);

            // act
            SubnominalValue subnominalValue = service.GetSubnominalValue(fundingStreamPeriodCode: FundingStreamPeriodNonEsfTest,
                deliverableCode: DeliverableCodeTest,
                contractAllocationNumber: ContractAllocationNumberTest,
                contractNumber: ContractNumberTest);

            // assert
            Assert.AreEqual(SubnominalCodeCappingTest, subnominalValue.Capping, "The capping values are not equal");
            Assert.AreEqual(SubnominalCodeProfileTest, subnominalValue.Profile, "The Profile values are not equal");
            Assert.AreEqual(SubnominalCodeReconcilliationTest, subnominalValue.Reconciliation, "The Reconciliation values are not equal");
        }

        private IDbSet<PolicyDeliverableToSubnominals> CreatePolicyDeliverableToSubnominals()
        {
            return EfHelper.GetQueryableMockDbSet(
            new List<PolicyDeliverableToSubnominals>
            {
                new PolicyDeliverableToSubnominals
                {
                    FundingStreamPeriod = FundingStreamPeriodNonEsfTest,
                    DeliverableCode = DeliverableCodeTest,
                    SubnominalCode = SubnominalCodeCappingTest,
                    PaymentType = PaymentType.Capping
                },
                new PolicyDeliverableToSubnominals
                {
                    FundingStreamPeriod = FundingStreamPeriodNonEsfTest,
                    DeliverableCode = DeliverableCodeTest,
                    SubnominalCode = SubnominalCodeProfileTest,
                    PaymentType = PaymentType.Profile
                },
                new PolicyDeliverableToSubnominals
                {
                    FundingStreamPeriod = FundingStreamPeriodNonEsfTest,
                    DeliverableCode = DeliverableCodeTest,
                    SubnominalCode = SubnominalCodeReconcilliationTest,
                    PaymentType = PaymentType.Reconciliation
                },

            }.ToArray());
        }

        private DbSet<EsfAllocationData> CreateESFAllocationData()
        {
            return EfHelper.GetQueryableMockDbSet(
            new List<EsfAllocationData>
            {
                new EsfAllocationData
                {
                    ContractNumber = ContractNumberTest,
                    ContractAllocationNumber = ContractAllocationNumberTest,
                    InvestmentPriority = "1.1 some stuff",
                    RegionType = RegionTypeTest.ToString()
                } 

            }.ToArray());
        }

        private IDbSet<ESFRegionInvestmentPriority> CreatePolicyFundingStreamPeriodSubnominals()
        {
            return EfHelper.GetQueryableMockDbSet(
             new List<ESFRegionInvestmentPriority>
            {
                new ESFRegionInvestmentPriority(RegionType.MoreDeveloped, 1.1m, 98765.ToString()),
                new ESFRegionInvestmentPriority(RegionTypeTest, 1.1m, SubnominalCodeTest.ToString()),
                new ESFRegionInvestmentPriority(RegionType.Transition, 1.1m, 987654321.ToString()),

            }.ToArray());
        }
    }
}
