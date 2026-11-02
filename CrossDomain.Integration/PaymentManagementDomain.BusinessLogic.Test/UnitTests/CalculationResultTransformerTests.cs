namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Test.UnitTests
{
    using System.Collections.Generic;
    using System.Linq;
    using FundingClaimReconciliation.Dto;
    using PaymentSchedule.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Allocation = CrossDomain.Integration.Entities.PaymentSchedule.Allocation;

    [TestClass]
    public class CalculationResultTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CalculationResultTransformer_TransformDeliverablePeriodResultsToPaymentScheduleAllocation()
        {
            // Arrange
            string testAllocationNumber = "ALLOC-01";
            List<DeliverablePeriodResult> deliverablePeriodResults = CreateDeliverablePeriodResults(testAllocationNumber);
            string testFsp = "CL1516";

            var organisationIdentifier = new OrganisationIdentifer
            {
                AllocationNumber = testAllocationNumber,
                MainOrganisationIdentifier = "ORG0001",
                OrganisationId = "123456",
                VersionNumber = 1,
                OrganisationIdentifierName = OrganisationIdentifierName.UKPRN
            };

            // Act
            Allocation paymentScheduleAllocation = CalculationResultTransformer.TransformDeliverablePeriodResultsToPaymentScheduleAllocation(deliverablePeriodResults, testFsp, organisationIdentifier);

            // Assert
            Assert.AreEqual(testAllocationNumber, paymentScheduleAllocation.AllocationNumber);
            Assert.AreEqual(2, paymentScheduleAllocation.AllocationDeliverables.Count);
            Assert.IsNotNull(paymentScheduleAllocation.AllocationDeliverables.SingleOrDefault(ad => ad.DeliverableCode == 1));
            Assert.IsNotNull(paymentScheduleAllocation.AllocationDeliverables.SingleOrDefault(ad => ad.DeliverableCode == 2));

            //Reconciliation on del 1
            var del1PeriodToTest = paymentScheduleAllocation.AllocationDeliverables[0].ScheduledPayments.Single(sp => sp.Period == "201610");
            Assert.AreEqual(1000m, del1PeriodToTest.ReconciliationPaymentAmount);
            Assert.AreEqual(0m, del1PeriodToTest.BalancingPaymentAmount);
            Assert.AreEqual(0m, del1PeriodToTest.CappedPaymentAmount);
            Assert.AreEqual(0m, del1PeriodToTest.ProfilePaymentAmount);
            Assert.AreEqual(0m, del1PeriodToTest.PlannedValue);
            Assert.AreEqual(organisationIdentifier.MainOrganisationIdentifier, paymentScheduleAllocation.Organisation.MainOrganisationIdentifier);
        }

        private List<DeliverablePeriodResult> CreateDeliverablePeriodResults(string allocationNumber)
        {
            return new List<DeliverablePeriodResult>
            {
                CreateDeliverablePeriodResult(allocationNumber, 100m, 100m, 1, 2015, 08, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 100m, 100m, 1, 2015, 09, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 100m, 100m, 1, 2015, 10, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 100m, 100m, 1, 2015, 11, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 100m, 100m, 1, 2015, 12, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 100m, 100m, 1, 2016, 01, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 100m, 100m, 1, 2016, 02, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 100m, 100m, 1, 2016, 03, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 100m, 100m, 1, 2016, 04, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 100m, 100m, 1, 2016, 05, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 100m, 100m, 1, 2016, 06, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 100m, 100m, 1, 2016, 07, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 0m, 0m, 1, 2016, 10, 1000m),
                CreateDeliverablePeriodResult(allocationNumber, 200m, 200m, 2, 2015, 08, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 200m, 200m, 2, 2015, 09, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 200m, 200m, 2, 2015, 10, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 200m, 200m, 2, 2015, 11, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 200m, 200m, 2, 2015, 12, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 200m, 200m, 2, 2016, 01, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 200m, 200m, 2, 2016, 02, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 200m, 200m, 2, 2016, 03, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 200m, 200m, 2, 2016, 04, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 200m, 200m, 2, 2016, 05, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 200m, 200m, 2, 2016, 06, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 200m, 200m, 2, 2016, 07, 0m),
                CreateDeliverablePeriodResult(allocationNumber, 0m, 0m, 2, 2016, 10, 2000m)
            };
        }

        private static DeliverablePeriodResult CreateDeliverablePeriodResult(string allocationNumber, decimal plannedValue, decimal profilePaymentValue, int deliverableCode, int year, int period, decimal reconciliationValue)
        {
            return new DeliverablePeriodResult
            {
                ContractNumber = "ContractNumber",
                AllocationNumber = allocationNumber,
                ContractVersionNumber = 1,
                DeliverableCode = deliverableCode,
                Period = period,
                Year = year,
                ActualValue = 0m,
                ProfileValue = plannedValue,
                ProfilePaymentValue = profilePaymentValue,
                CappingPaymentValue = 0m,
                BalancingPaymentValue = 0m,
                ReconciliationPaymentValue = reconciliationValue,
                DeliverablePeriodId = null,
                YearToDateValue = null
            };
        }
    }
}
