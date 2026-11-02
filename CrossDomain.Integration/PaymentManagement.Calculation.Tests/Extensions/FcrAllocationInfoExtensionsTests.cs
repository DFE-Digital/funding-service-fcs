namespace PaymentManagement.Calculation.Tests.Extensions
{
    using System.Linq;
    using Calculation.Dtos;
    using Calculation.Extensions;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.Infos;

    [TestClass]
    public class FcrAllocationInfoExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FcrAllocationInfoExtensions_ShouldTransformToCalculationAllocationInput()
        {
            // arrange
            const string contractNumber = "CONTRACT-1234";
            const int contractVersionNumber = 3;
            const int ukprn = 12345678;
            const string orgId = "ORG000123";

            AllocationInfo allocationInfo = new AllocationInfo
            {
                AllocationNumber = "ALLOC-1234",
                FundingStreamPeriodCode = "FSP1920"
            };

            DeliverablePeriodPaymentInfo[] deliverablePeriods =
            {
                new DeliverablePeriodPaymentInfo(201908, 1, 100m, null, null, null, 100m, null, 100m, null, null),
                new DeliverablePeriodPaymentInfo(201909, 1, 100m, null, null, null, 100m, null, 100m, null, null),
                new DeliverablePeriodPaymentInfo(201908, 2, 100m, null, null, null, 100m, null, 100m, null, null),
                new DeliverablePeriodPaymentInfo(201909, 2, 100m, null, null, null, 100m, null, 100m, null, null)
            };

            FspDeliverableInfo[] fspDeliverables =
            {
                new FspDeliverableInfo(1, true, null, 0, allowPayment: true),
                new FspDeliverableInfo(2, true, null, 0, allowPayment: true),
                new FspDeliverableInfo(3, false, null, 0, allowPayment: false),
                new FspDeliverableInfo(4, false, null, 0, allowPayment: false)
            };

            // act
            CalculationAllocationInput calculationAllocationInput = allocationInfo.ToCalculationAllocationInput(
                contractNumber, contractVersionNumber, ukprn, orgId, deliverablePeriods, fspDeliverables);

            // assert
            calculationAllocationInput.Should().NotBeNull("non-null instance should be returned");
            calculationAllocationInput.ContractNumber.Should().Be("CONTRACT-1234", "Contract Number should be transformed");
            calculationAllocationInput.AllocationNumber.Should().Be("ALLOC-1234", "Allocation Number should be transformed");
            calculationAllocationInput.VersionNumber.Should().Be(3, "Version Number should be transformed");
            calculationAllocationInput.FundingStreamPeriodCode.Should().Be("FSP1920", "Funding Stream Period Code should be transformed");
            calculationAllocationInput.Ukprn.Should().Be("12345678", "UKPRN should be transformed");
            calculationAllocationInput.OrgId.Should().Be("ORG000123", "Organisation Id should be transformed");
            calculationAllocationInput.Deliverables.Should().NotBeNull("Deliverables property should be transformed");
            calculationAllocationInput.Deliverables.Should().HaveCount(2, "all deliverables should be transformed");

            CalculationDeliverableInput deliverable1 = calculationAllocationInput.Deliverables.Single(d => d.DeliverableCode == 1);
            deliverable1.AllowProfile.Should().BeTrue("AllowProfile property should be set on deliverable from policy");
            deliverable1.AllowPayment.Should().BeTrue("AllowPayment property should be set on deliverable from policy");
            deliverable1.DeliverablePeriods.Should().HaveCount(2, "all deliverable periods should be transformed");

            CalculationDeliverablePeriodInput deliverablePeriod201908 = deliverable1.DeliverablePeriods.Single(dp => dp.Period == 201908);
            deliverablePeriod201908.ReconciliationPayment.Should().Be(100m, "reconciliation payment should be transformed");
            deliverablePeriod201908.NetPayment.Should().Be(100m, "net payment should be transformed");
            deliverablePeriod201908.ActualValue.Should().Be(100, "actual value should be transformed");
        }
    }
}
