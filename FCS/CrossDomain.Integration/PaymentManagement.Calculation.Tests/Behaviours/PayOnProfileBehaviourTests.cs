namespace PaymentManagement.Calculation.Tests.Behaviours
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Calculation.Behaviours;
    using Calculation.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class PayOnProfileBehaviourTests
    {
        [TestMethod, TestCategory("UnitTest")] // example 1
        public void PayOnProfileBehaviour_ShouldCalculateForEarlyApproval() 
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 100, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 200, plannedVolume: 0),

                }, allowProfile : true, cappingApportionmentPriorityOrder: null, null, allowPayment:true),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0),
                }, allowProfile : false, cappingApportionmentPriorityOrder: null, null),
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());
            
            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                PayOnProfileBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 07, 2020));

            // assert
            inputDeliverables.Single(d => d.DeliverableCode == 1).DeliverablePeriods.ToList().ForEach(dp =>
            {
                var resultLine = calculationResultLines.Single(r => r.DeliverableCode == 1 && r.Period == dp.Period);
                Assert.AreEqual(dp.PlannedValue, resultLine.ProfileValue, $"The ProfilePayment for deliverable code 1 and period: {dp.Period} is not right");
            });
        }

        [TestMethod, TestCategory("UnitTest")] 
        public void PayOnProfileBehaviour_ShouldNotProduceProfileWhenDelivarableHasAllowProfileFalse()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 100, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 200, plannedVolume: 0),

                }, allowProfile : false, cappingApportionmentPriorityOrder: null, null),
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());

            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                PayOnProfileBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 07, 2020));

            // assert
            inputDeliverables.Single(d => d.DeliverableCode == 1).DeliverablePeriods.ToList().ForEach(dp =>
            {
                var resultLine = calculationResultLines.Single(r => r.DeliverableCode == 1 && r.Period == dp.Period);
                Assert.AreEqual(0, resultLine.ProfileValue, $"The ProfilePayment for deliverable code 1 and period: {dp.Period} is not right");
            });
        }

        [TestMethod, TestCategory("UnitTest")] // example 2
        public void PayOnProfileBehaviour_ShouldCalculateForInYearAmendment()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 150, plannedVolume: 0) {NetPayment = 100, ProfilePayment = 100},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 200, plannedVolume: 0) {NetPayment = 150, ProfilePayment = 150},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 200, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 200, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 200, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 200, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 200, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 200, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 200, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 200, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 200, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 250, plannedVolume: 0),

                }, allowProfile : true, cappingApportionmentPriorityOrder: null, null, allowPayment:true),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0),
                }, allowProfile : false, cappingApportionmentPriorityOrder: null, null),
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());
            Period currentPeriod = new Period(202010);
            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                PayOnProfileBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, currentPeriod.Month, currentPeriod.Year));

            // assert
            var deliverableOnPeriods = inputDeliverables.Single(d => d.DeliverableCode == 1).DeliverablePeriods;
            
            Assert.AreEqual(100, deliverableOnPeriods.Single(dp => dp.Period == 202008).ProfilePayment, $"The ProfilePayment for deliverable code 1 and period: 202008 is not right");
            Assert.AreEqual(150, deliverableOnPeriods.Single(dp => dp.Period == 202009).ProfilePayment, $"The ProfilePayment for deliverable code 1 and period: 202009 is not right");
            inputDeliverables.Single(d => d.DeliverableCode == 1).DeliverablePeriods.Where(dp => dp.Period >= 202010).ToList().ForEach(dp =>
            {
                var line = calculationResultLines.Single(r => r.DeliverableCode == 1 && r.Period == dp.Period);

                Assert.AreEqual(dp.PlannedValue, line.ProfileValue, $"The ProfileValue for deliverable code 1 and period: {dp.Period} is not right");
            });

            var resultLine = calculationResultLines.Single(r => r.DeliverableCode == 1 && r.Period == currentPeriod);
            Assert.AreEqual(100, resultLine.BalancingPaymentAmount, $"The BalancingPaymentAmount for deliverable code 1 and period: {currentPeriod} is not right");
            Assert.AreEqual(300, resultLine.NetPaymentAmount, $"The NetPaymentAmount for deliverable code 1 and period: {currentPeriod} is not right");
            inputDeliverables.Single(d => d.DeliverableCode == 1).DeliverablePeriods.Where(dp => dp.Period > 202010).ToList().ForEach(dp =>
            {
                var line = calculationResultLines.Single(r => r.DeliverableCode == 1 && r.Period == dp.Period);

                Assert.AreEqual(line.ProfileValue,  line.NetPaymentAmount, $"The NetPaymentAmount for deliverable code 1 and period: {dp.Period} is not right");
            });
        }

        [TestMethod, TestCategory("UnitTest")] // example 3
        public void PayOnProfileBehaviour_ShouldCalculateForPostYearAmendment()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 150, plannedVolume: 0) {NetPayment = 100, ProfilePayment = 100},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 250, plannedVolume: 0) {NetPayment = 150, ProfilePayment = 150},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 300, plannedVolume: 0) {NetPayment = 300, ProfilePayment = 200, BalancingPayment = 100},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 200, plannedVolume: 0) {NetPayment = 200, ProfilePayment = 200},
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 200, plannedVolume: 0) {NetPayment = 200, ProfilePayment = 200},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 200, plannedVolume: 0) {NetPayment = 200, ProfilePayment = 200},
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 200, plannedVolume: 0) {NetPayment = 200, ProfilePayment = 200},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 200, plannedVolume: 0) {NetPayment = 200, ProfilePayment = 200},
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 200, plannedVolume: 0) {NetPayment = 200, ProfilePayment = 200},
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 200, plannedVolume: 0) {NetPayment = 200, ProfilePayment = 200},
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 200, plannedVolume: 0) {NetPayment = 200, ProfilePayment = 200},
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 250, plannedVolume: 0) {NetPayment = 250, ProfilePayment = 250}

                }, allowProfile : true, cappingApportionmentPriorityOrder: null, null, allowPayment:true),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0),
                }, allowProfile : false, cappingApportionmentPriorityOrder: null, null),
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());
            Period currentPeriod = new Period(202109);
            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                PayOnProfileBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, currentPeriod.Month, currentPeriod.Year));

            // assert
            var resultLine = calculationResultLines.Single(r => r.DeliverableCode == 1 && r.Period == currentPeriod);
            Assert.AreEqual(150, resultLine.BalancingPaymentAmount, $"The BalancingPaymentAmount for deliverable code 1 and period: {currentPeriod} is not right");
            Assert.AreEqual(150, resultLine.NetPaymentAmount, $"The NetPaymentAmount for deliverable code 1 and period: {currentPeriod} is not right");
            var resultLineOct = calculationResultLines.Single(r => r.DeliverableCode == 1 && r.Period == 202010);
            Assert.AreEqual(100, resultLineOct.BalancingPaymentAmount, $"The BalancingPaymentAmount for deliverable code 1 and period: 202010 is not right");
            Assert.AreEqual(300, resultLineOct.NetPaymentAmount, $"The NetPaymentAmount for deliverable code 1 and period: 202010 is not right");
        }

        [TestMethod, TestCategory("UnitTest")] // example 4
        public void PayOnProfileBehaviour_ShouldCalculateForLateApproval()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 100, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 200, plannedVolume: 0),

                }, allowProfile : true, cappingApportionmentPriorityOrder: null, null, allowPayment:true),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0),
                }, allowProfile : false, cappingApportionmentPriorityOrder: null, null),
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());
            Period currentPeriod = new Period(202010);
            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                PayOnProfileBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, currentPeriod.Month, currentPeriod.Year));

            // assert
            inputDeliverables.Single(d => d.DeliverableCode == 1).DeliverablePeriods.Where(dp => dp.Period >= currentPeriod).ToList().ForEach(dp =>
            {
                var resultLine = calculationResultLines.Single(r => r.DeliverableCode == 1 && r.Period == dp.Period);
                Assert.AreEqual(dp.PlannedValue, resultLine.ProfileValue, $"The ProfilePayment for deliverable code 1 and period: {dp.Period} is not right");
            });

            var resultLineOct = calculationResultLines.Single(r => r.DeliverableCode == 1 && r.Period == currentPeriod);
            Assert.AreEqual(250, resultLineOct.BalancingPaymentAmount, $"The BalancingPaymentAmount for deliverable code 1 and period: {currentPeriod} is not right");
            Assert.AreEqual(400, resultLineOct.NetPaymentAmount, $"The NetPaymentAmount for deliverable code 1 and period: {currentPeriod} is not right");
        }

        [TestMethod, TestCategory("UnitTest")] // example 5
        public void PayOnProfileBehaviour_ShouldCalculateForShortContractAllocation()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 100, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 150, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 250, plannedVolume: 0),

                }, allowProfile : true, cappingApportionmentPriorityOrder: null, null, allowPayment:true),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                }, allowProfile : false, cappingApportionmentPriorityOrder: null, null),
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());
            Period currentPeriod = new Period(202101);
            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                PayOnProfileBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, currentPeriod.Month, currentPeriod.Year));

            // assert
            inputDeliverables.Single(d => d.DeliverableCode == 1).DeliverablePeriods.Where(dp => dp.Period >= currentPeriod).ToList().ForEach(dp =>
            {
                var resultLine = calculationResultLines.Single(r => r.DeliverableCode == 1 && r.Period == dp.Period);
                Assert.AreEqual(dp.PlannedValue, resultLine.ProfileValue, $"The ProfilePayment for deliverable code 1 and period: {dp.Period} is not right");
                Assert.AreEqual(dp.PlannedValue, resultLine.NetPaymentAmount, $"The NetPaymentAmount for deliverable code 1 and period: {dp.Period} is not right");
                Assert.AreEqual(0, resultLine.BalancingPaymentAmount.GetValueOrDefault(), $"The BalancingPaymentAmount for deliverable code 1 and period: {dp.Period} is not right");
            });
        }
    }
}
