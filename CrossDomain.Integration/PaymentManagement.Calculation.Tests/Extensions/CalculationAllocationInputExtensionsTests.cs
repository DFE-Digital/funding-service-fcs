namespace PaymentManagement.Calculation.Tests.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using Calculation.Dtos;
    using Calculation.Extensions;
    using Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class CalculationAllocationInputExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CalculationAllocationInputExtensions_ShouldTransform()
        {
            // arrange

            CalculationAllocationInput calculationAllocationInput = new CalculationAllocationInput(
                "AAC-1013",
                1,
                "FSP",
                new List<CalculationDeliverableInput>
                {
                    new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                    {
                        new CalculationDeliverablePeriodInput(202001, plannedValue: 100, plannedVolume:101),
                        new CalculationDeliverablePeriodInput(202002, plannedValue: 200, plannedVolume:201),
                    }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                    new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                    {
                        new CalculationDeliverablePeriodInput(202001, plannedValue: 300, plannedVolume:301),
                        new CalculationDeliverablePeriodInput(202002, plannedValue: 400, plannedVolume:401),
                    }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                    new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                    {
                        new CalculationDeliverablePeriodInput(202001, plannedValue: 500, plannedVolume:501),
                        new CalculationDeliverablePeriodInput(202002, plannedValue: 600, plannedVolume:601),
                    }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                },
                "ukprn",
                "orgId",
                "cn1", 
                new List<CappingGroup>());

            // act
            var paymentSchedule = calculationAllocationInput.ToPaymentSchedule();

            // assert
            Assert.AreEqual(calculationAllocationInput.ContractNumber, paymentSchedule.ContractNumber, "The contract number is not set");
            Assert.AreEqual(calculationAllocationInput.VersionNumber, paymentSchedule.VersionNumber, "The contract version is not set");
            Assert.AreEqual(calculationAllocationInput.FundingStreamPeriodCode, paymentSchedule.FundingStreamPeriodCode, "The FundingStreamPeriodCode is not set");
            Assert.AreEqual(calculationAllocationInput.AllocationNumber, paymentSchedule.AllocationNumber, "The AllocationNumber is not set");
            Assert.AreEqual(3, paymentSchedule.AllocationDeliverables.Count, "The number of deliverables is not correct");
            calculationAllocationInput.Deliverables.ToList().ForEach(d =>
            {
                d.DeliverablePeriods.ToList()
                    .ForEach(dp =>
                    {
                        var deliverable = paymentSchedule.AllocationDeliverables.Single(psd => psd.DeliverableCode == d.DeliverableCode)
                            .ScheduledPayments.Single(p => p.Period == dp.Period.ToString());
                        Assert.AreEqual(dp.PlannedValue, deliverable.PlannedValue, $"The PlannedValue is not correct for deliverableCode {d.DeliverableCode} and period {dp.Period}");
                        Assert.AreEqual(dp.PlannedVolume, deliverable.PlannedVolume, $"The PlannedVolume is not correct for deliverableCode {d.DeliverableCode} and period {dp.Period}");
                        Assert.AreEqual(0, deliverable.ProfilePaymentAmount, $"The ProfilePaymentAmount is not 0 for deliverableCode {d.DeliverableCode} and period {dp.Period}");
                        Assert.AreEqual(0, deliverable.BalancingPaymentAmount, $"The BalancingPaymentAmount is not 0 for deliverableCode {d.DeliverableCode} and period {dp.Period}");
                    });
                
            });
        }
    }
}
