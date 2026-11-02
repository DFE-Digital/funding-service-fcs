namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Unit
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using CrossDomain.Integration.Entities.PaymentSchedule;
    using CrossDomain.Integration.Events;
    using Services;
    using UnitTests.Common;

    [TestClass]
    public class ContractAllocationActualsTypeTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationActualsTypeTransformer_CreateFromAllocationActualsType_ShouldReturnCorrectModelObject()
        {
            // Arrange
            AllocationActualsVerified contractAllocationActualType = TestResource.FromJson<AllocationActualsVerified>(
                "SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests",
                @"Resources.AllocationActualsVerified_NCSP-197.json");

            // Act
            Allocation result = ContractAllocationActualsTypeTransformer.ToPaymentScheduleAllocation(contractAllocationActualType.AllocationActuals);

            // Assert
            int totalNumberOfPeriods =
                result.AllocationDeliverables.Sum(ad => ad.ScheduledPayments.Count);

            Assert.AreEqual(7, result.AllocationDeliverables.Count);
            Assert.AreEqual(14, totalNumberOfPeriods);
            
            Assert.AreEqual("NCSP-197",result.AllocationNumber);
            Assert.AreEqual("NCS-197", result.ContractNumber);
            Assert.AreEqual(1 ,result.ContractVersionNumber);
            Assert.AreEqual("NCS-P1718", result.FundingStreamPeriodCode);
            Assert.AreEqual("ORG0017197", result.Organisation.MainOrganisationIdentifier);
            Assert.AreEqual(OrganisationIdentifierOrganisationIdentifierName.UKPRN, result.Organisation.OrganisationIdentifiers.Single().OrganisationIdentifierName);
            Assert.AreEqual("10017197", result.Organisation.OrganisationIdentifiers.Single().OrganisationId);

            AllocationDeliverable allocationDeliverableDel2 = result.AllocationDeliverables.SingleOrDefault(ad => ad.DeliverableCode == 2);
            Assert.IsNotNull(allocationDeliverableDel2, "AllocationDeliverable with a deliverable code of 2 does not exist when expected.");

            List<ScheduledPayment> scheduledPaymentsForDel2 = allocationDeliverableDel2.ScheduledPayments.OrderBy(sp => sp.Period).ToList();
            Assert.AreEqual(2, scheduledPaymentsForDel2.Count, $"AllocationDeliverable with a deliverable code of 2 had {scheduledPaymentsForDel2.Count} element/s when we expected 2.");

            Assert.AreEqual("201705", scheduledPaymentsForDel2.First().Period, "First element of scheduledPayments returned an incorrect Period.");
            Assert.AreEqual("CM", scheduledPaymentsForDel2.First().PeriodTypeCode, "First element of scheduledPayments returned an incorrect PeriodTypeCode.");
            Assert.AreEqual(45.0m, scheduledPaymentsForDel2.First().ActualValue, "First element of scheduledPayments returned an incorrect ActualValue.");
            Assert.AreEqual(0, scheduledPaymentsForDel2.First().ActualVolume, "First element of scheduledPayments returned an incorrect ActualVolume.");
                
            Assert.AreEqual("201706", scheduledPaymentsForDel2[1].Period, "Second element of scheduledPayments returned an incorrect Period.");
            Assert.AreEqual("CM", scheduledPaymentsForDel2[1].PeriodTypeCode, "Second element of scheduledPayments returned an incorrect PeriodTypeCode.");
            Assert.AreEqual(67.0m, scheduledPaymentsForDel2[1].ActualValue, "Second element of scheduledPayments returned an incorrect ActualValue.");
            Assert.AreEqual(0, scheduledPaymentsForDel2[1].ActualVolume, "Second element of scheduledPayments returned an incorrect ActualVolume.");
        }
    }
}