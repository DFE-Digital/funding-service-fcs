namespace PaymentManagement.Calculation.Tests.Behaviours
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Calculation.Behaviours;
    using Calculation.Dtos;
    using Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;

    [TestClass]
    public class AllocationDurationDeliverableLineBehaviourTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDurationDeliverableLineBehaviour_ShouldCalculateReconciliationAndCappingPaymentsForMultipleDeliverableLines()
        {
            // arrange
            var inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(202001, 0, 10m){NetPayment = 10, PlannedValue = 10},
                    new CalculationDeliverablePeriodInput(202002, 0, 10m){NetPayment = 10, PlannedValue = 10},
                    new CalculationDeliverablePeriodInput(202003, 0, 10m){NetPayment = 10, PlannedValue = 10},
                    new CalculationDeliverablePeriodInput(202004, 0, 10m){NetPayment = 10, PlannedValue = 10},
                    new CalculationDeliverablePeriodInput(202005, 0, 15m){NetPayment = 0, PlannedValue = 10},
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(202001, 0, 20m){NetPayment = 20, PlannedValue = 20},
                    new CalculationDeliverablePeriodInput(202002, 0, 20m){NetPayment = 20, PlannedValue = 20},
                    new CalculationDeliverablePeriodInput(202003, 0, 20m){NetPayment = 20, PlannedValue = 20},
                    new CalculationDeliverablePeriodInput(202004, 0, 20m){NetPayment = 20, PlannedValue = 20},
                    new CalculationDeliverablePeriodInput(202005, 0, 35m){NetPayment = 0, PlannedValue = 20},
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
            };

            var currentPeriod = new CensusPeriodInfo(DateTime.MinValue, 5, 2020);
            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());

            // act
            var paymentSchedule = AllocationDurationDeliverableLineBehaviour.Calculate(input, currentPeriod);

            // assert
            Assert.IsNotNull(paymentSchedule, "Null value returned");

            var deliverable1CurrentPeriodScheduledPayment =
                paymentSchedule.Single(ps => ps.DeliverableCode == 1 && ps.Period == 202005);
                
            Assert.IsNotNull(deliverable1CurrentPeriodScheduledPayment, "Scheduled Payment for current period not returned");
            Assert.AreEqual(15m, deliverable1CurrentPeriodScheduledPayment.ReconciliationPaymentAmount, "Reconciliation payment amount is incorrect");
            Assert.AreEqual(-5m, deliverable1CurrentPeriodScheduledPayment.CappedPaymentAmount, "Capping payment amount is incorrect");

            deliverable1CurrentPeriodScheduledPayment = paymentSchedule.Single(ps => ps.DeliverableCode == 2 && ps.Period == 202005);
            
            Assert.IsNotNull(deliverable1CurrentPeriodScheduledPayment, "Scheduled Payment for current period not returned");
            Assert.AreEqual(35m, deliverable1CurrentPeriodScheduledPayment.ReconciliationPaymentAmount, "Reconciliation payment amount is incorrect");
            Assert.AreEqual(-15m, deliverable1CurrentPeriodScheduledPayment.CappedPaymentAmount, "Capping payment amount is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDurationDeliverableLineBehaviour_ShouldCalculateCappingPaymentOfZeroWhenCapIsPositive()
        {
            // arrange
            var inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(202001, 0, 10m){NetPayment = 10, PlannedValue = 10},
                    new CalculationDeliverablePeriodInput(202002, 0, 10m){NetPayment = 10, PlannedValue = 10},
                    new CalculationDeliverablePeriodInput(202003, 0, 10m){NetPayment = 10, PlannedValue = 10},
                    new CalculationDeliverablePeriodInput(202004, 0, 10m){NetPayment = 10, PlannedValue = 10},
                    new CalculationDeliverablePeriodInput(202005, 0, 1m){NetPayment = 0, PlannedValue = 10},
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
            };

            var currentPeriod = new CensusPeriodInfo(DateTime.MinValue, 5, 2020);

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());

            // act
            var paymentSchedule = AllocationDurationDeliverableLineBehaviour.Calculate(input, currentPeriod);

            // assert
            var deliverable1CurrentPeriodScheduledPayment =
                paymentSchedule.Single(ps => ps.DeliverableCode == 1 && ps.Period == 202005);

            Assert.AreEqual(0m, deliverable1CurrentPeriodScheduledPayment.CappedPaymentAmount, "Capping payment amount is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDurationDeliverableLineBehaviour_ShouldNotCalculateReconciliationAndCappingPaymentsForPreviousPeriods()
        {
            // arrange
            var inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(202001, 0, 10m){NetPayment = 10, PlannedValue = 10, CappedPayment = -400, ReconciliationPayment = 500},
                    new CalculationDeliverablePeriodInput(202002, 0, 10m){NetPayment = 10, PlannedValue = 10, CappedPayment = -400, ReconciliationPayment = 500},
                    new CalculationDeliverablePeriodInput(202003, 0, 10m){NetPayment = 10, PlannedValue = 10, CappedPayment = -400, ReconciliationPayment = 500},
                    new CalculationDeliverablePeriodInput(202004, 0, 10m){NetPayment = 10, PlannedValue = 10, CappedPayment = -400, ReconciliationPayment = 500},
                    new CalculationDeliverablePeriodInput(202005, 0, 15m){NetPayment = 10, PlannedValue = 10},
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
            };

            var currentPeriod = new CensusPeriodInfo(DateTime.MinValue, 5, 2020);
            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());

            // act
            var paymentSchedule = AllocationDurationDeliverableLineBehaviour.Calculate(input, currentPeriod);

            // assert
            Assert.IsNotNull(paymentSchedule, "Null value returned");

            var previousPeriods = new List<int> { 202001, 202002, 202003, 202004 };

            previousPeriods.ForEach(pp => Assert.AreEqual(500m,
                paymentSchedule.SingleOrDefault(ad => ad.DeliverableCode == 1 && ad.Period == pp)?.ReconciliationPaymentAmount,
                $"Reconciliation payment amount in previous period '{pp}' is incorrect"));

            previousPeriods.ForEach(pp => Assert.AreEqual(-400m,
                paymentSchedule.SingleOrDefault(ad => ad.DeliverableCode == 1 && ad.Period == pp)?.CappedPaymentAmount,
                $"Capping payment amount in previous period '{pp}' is incorrect"));

            Assert.AreEqual(15,
                paymentSchedule.SingleOrDefault(ad => ad.DeliverableCode == 1 && ad.Period == 202005)?.ReconciliationPaymentAmount,
                "Reconciliation payment in previous period '202005' is incorrect");

            Assert.AreEqual(-5,
                paymentSchedule.SingleOrDefault(ad => ad.DeliverableCode == 1 && ad.Period == 202005)?.CappedPaymentAmount,
                "Capping payment amount in previous period '202005' is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDurationDeliverableLineBehaviour_ShouldNotCrashWhenActualsIncludesPastPeriodsThatAreNotInDeliverablePeriodPaymentInfoCollection()
        {
            // arrange

            var inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(202002, 0, 10m){NetPayment = 0, PlannedValue = 10},
                    new CalculationDeliverablePeriodInput(202003, 0, 10m),
                    new CalculationDeliverablePeriodInput(202004, 0, 10m),
                    new CalculationDeliverablePeriodInput(202005, 0, 10m)
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
            };

            var currentPeriod = new CensusPeriodInfo(DateTime.MinValue, 5, 2020);
            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());

            // act
            var paymentSchedule = AllocationDurationDeliverableLineBehaviour.Calculate(input, currentPeriod);

            // assert
            Assert.IsNotNull(paymentSchedule, "Null value returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDurationDeliverableLineBehaviour_ShouldCreatePostYearEndPeriod()
        {
            // arrange
            var inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(202001, 0, 10m){NetPayment = 0, PlannedValue = 10, PlannedVolume = -400, CappedPayment = 500},
                    new CalculationDeliverablePeriodInput(202002, 0, 10m){NetPayment = 0, PlannedValue = 10, PlannedVolume = -400, CappedPayment = 500},
                    new CalculationDeliverablePeriodInput(202003, 0, 10m){NetPayment = 0, PlannedValue = 10, PlannedVolume = -400, CappedPayment = 500},
                    new CalculationDeliverablePeriodInput(202004, 0, 10m){NetPayment = 0, PlannedValue = 10, PlannedVolume = -400, CappedPayment = 500},
                    new CalculationDeliverablePeriodInput(202005, 0, 15m)
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
            };

            var currentPeriod = new CensusPeriodInfo(DateTime.MinValue, 6, 2020);
            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());

            // act
            var paymentSchedule = AllocationDurationDeliverableLineBehaviour.Calculate(input, currentPeriod);

            // assert
            Assert.IsNotNull(paymentSchedule, "Null value returned");

            Assert.AreEqual(6, paymentSchedule.Count, "the number of lines is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDurationDeliverableLineBehaviour_ShouldNotCreatePeriodBeforeYearStarts()
        {
            // arrange
            var inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(202001, 0, 10m){NetPayment = 0, PlannedValue = 10, PlannedVolume = -400, CappedPayment = 500},
                    new CalculationDeliverablePeriodInput(202002, 0, 10m){NetPayment = 0, PlannedValue = 10, PlannedVolume = -400, CappedPayment = 500},
                    new CalculationDeliverablePeriodInput(202003, 0, 10m){NetPayment = 0, PlannedValue = 10, PlannedVolume = -400, CappedPayment = 500},
                    new CalculationDeliverablePeriodInput(202004, 0, 10m){NetPayment = 0, PlannedValue = 10, PlannedVolume = -400, CappedPayment = 500},
                    new CalculationDeliverablePeriodInput(202005, 0, 15m)
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
            };

            var currentPeriod = new CensusPeriodInfo(DateTime.MinValue, 12, 2019);
            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());

            // act
            var paymentSchedule = AllocationDurationDeliverableLineBehaviour.Calculate(input, currentPeriod);

            // assert
            Assert.IsNotNull(paymentSchedule, "Null value returned");

            Assert.AreEqual(5, paymentSchedule.Count, "the number of lines is incorrect");
        }
    }
}
