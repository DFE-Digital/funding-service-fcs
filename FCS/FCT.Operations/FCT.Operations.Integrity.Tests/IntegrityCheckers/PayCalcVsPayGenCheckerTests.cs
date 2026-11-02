namespace FCT.Operations.Integrity.Tests.IntegrityCheckers
{
    using System.Collections.Generic;
    using ContractManagement.DataStore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Operations.Integrity.DTOs;
    using SFA.FCT.Operations.Integrity.IntegrityCheckers;
    using SFA.FCT.Operations.Integrity.Repositories;
    using SFA.FCT.Operations.Integrity.Services;

    [TestClass]
    public class PayCalcVsPayGenCheckerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PayCalcVsPayGenChecker_ShouldReturnExpectedDifferences()
        {
            // arrange
            Mock<IPaasDeliverablePaymentLazyRepository> paasDeliverablePaymentLazyRepositoryMock = new Mock<IPaasDeliverablePaymentLazyRepository>();
            paasDeliverablePaymentLazyRepositoryMock
                .Setup(m => m.GetDeliverablePaymentsNotPaidExternally())
                .Returns(new[]
                {
                    new DeliverablePaymentWithFsp
                    {
                        AllocationNumber = "NO-DIFFERENCE",
                        Period = "201901",
                        DeliverableCode = 1,
                        BalancingPaymentAmount = 100m,
                        CappedPaymentAmount = -100m,
                        ProfilePaymentAmount = 100m,
                        ReconciliationPaymentAmount = 100m
                    },
                    new DeliverablePaymentWithFsp
                    {
                        AllocationNumber = "NO-DIFFERENCE",
                        Period = "201901",
                        DeliverableCode = 2,
                        BalancingPaymentAmount = 100m,
                        CappedPaymentAmount = -100m,
                        ProfilePaymentAmount = 100m,
                        ReconciliationPaymentAmount = 100m
                    },
                    new DeliverablePaymentWithFsp
                    {
                        AllocationNumber = "DIFFERENCE IN VALUES",
                        Period = "201901",
                        DeliverableCode = 1,
                        BalancingPaymentAmount = 100m,
                        CappedPaymentAmount = -100m,
                        ProfilePaymentAmount = 100m,
                        ReconciliationPaymentAmount = 100m
                    },
                    new DeliverablePaymentWithFsp
                    {
                        AllocationNumber = "DIFFERENCE IN VALUES",
                        Period = "201901",
                        DeliverableCode = 2,
                        BalancingPaymentAmount = 0,
                        CappedPaymentAmount = 0,
                        ProfilePaymentAmount = 0,
                        ReconciliationPaymentAmount = 0
                    },
                    new DeliverablePaymentWithFsp
                    {
                        AllocationNumber = "DELIVERABLEPAYMENT ONLY",
                        Period = "201901",
                        DeliverableCode = 2,
                        BalancingPaymentAmount = 100m,
                        CappedPaymentAmount = 0,
                        ProfilePaymentAmount = 0,
                        ReconciliationPaymentAmount = 0
                    }
                });

            Mock<IPaasSubnominalAggregationRepository> paasSubnominalAggregationRepositoryMock = new Mock<IPaasSubnominalAggregationRepository>();
            paasSubnominalAggregationRepositoryMock
                .Setup(m => m.GetSubnominalAggregationsForOpenContracts(It.IsAny<IReadOnlyCollection<string>>()))
                .Returns(new[]
                {
                    new SubnominalAggregationInfo
                    {
                        AllocationNumber = "NO-DIFFERENCE",
                        Period = "201901",
                        AggregatedValue = 400m
                    },
                    new SubnominalAggregationInfo
                    {
                        AllocationNumber = "DIFFERENCE IN VALUES",
                        Period = "201901",
                        AggregatedValue = 201m
                    },
                    new SubnominalAggregationInfo
                    {
                        AllocationNumber = "SUBNOMINALAGGREGATION ONLY",
                        Period = "201901",
                        AggregatedValue = 100m
                    }
                });

            PayCalcVsPayGenChecker checker = new PayCalcVsPayGenChecker(
                paasDeliverablePaymentLazyRepositoryMock.Object,
                paasSubnominalAggregationRepositoryMock.Object,
                Mock.Of<IPaasFundingStreamPeriodRepository>());

            // act
            IntegrityCheckResult result = checker.CheckValues();

            // assert
            Assert.IsTrue(result.FoundIssues, "No issues returned");
            Assert.IsTrue(result.IssuesCsv.Contains("DIFFERENCE IN VALUES,201901,200,201"), "Difference in values not detected");
            Assert.IsTrue(result.IssuesCsv.Contains("DELIVERABLEPAYMENT ONLY,201901,100,"), "DeliverablePayment only not detected");
            Assert.IsTrue(result.IssuesCsv.Contains("SUBNOMINALAGGREGATION ONLY,201901,,100"), "SubnominalAggregation only not detected");
        }

        [TestMethod, TestCategory("DataDependentDOAT")]
        public void PayCalcVsPayGenChecker_ShouldReturnExpectedResultFromDoat()
        {
            using (ContractManagementDbContext contractManagementDbContext = new ContractManagementDbContext())
            {
                PayCalcVsPayGenChecker checker = new PayCalcVsPayGenChecker(
                    new PaasDeliverablePaymentLazyRepository(contractManagementDbContext.Database.Connection, Mock.Of<ILogger>()),
                    new PaasSubnominalAggregationRepository(contractManagementDbContext.Database.Connection),
                    new PaasFundingStreamPeriodRepository(null));

                IntegrityCheckResult result = checker.CheckValues();

                Assert.IsFalse(result.FoundIssues, result.IssuesCsv);
            }
        }
    }
}
