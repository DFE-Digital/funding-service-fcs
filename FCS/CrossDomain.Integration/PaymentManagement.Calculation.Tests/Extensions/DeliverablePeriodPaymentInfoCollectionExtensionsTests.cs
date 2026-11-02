namespace PaymentManagement.Calculation.Tests.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using Calculation.Dtos;
    using Calculation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;

    [TestClass]
    public class DeliverablePeriodPaymentInfoCollectionExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePeriodPaymentInfoCollectionExtensions_ShouldCreatePaymentSchedule()
        {
            // arrange
            List<DeliverablePeriodPaymentInfo> deliverablePeriodPaymentInfos = new List<DeliverablePeriodPaymentInfo>
            {
                new DeliverablePeriodPaymentInfo(202008, 1, 10, 11, 12, 13, 14, 15, 16,
                    17, 18),
                new DeliverablePeriodPaymentInfo(202009, 1, 10, 11, 12, 13, 14, 15, 16,
                    17, 18),
                new DeliverablePeriodPaymentInfo(202008, 2, 10, 11, 12, 13, 14, 15, 16,
                    17, 18),
                new DeliverablePeriodPaymentInfo(202009, 2, 10, 11, 12, 13, 14, 15, 16,
                    17, 18),
            };

            var allocationType = new allocationType
            {
                contractReference = new contractReferenceType
                {
                    contractNumber = "CN1",
                    contractVersionNumber = 1
                },
                contractorReference = new organisationReferenceType
                {
                    organisationIdentifier = "orgId",
                    alternativeOrganisationIdentifiers = new List<alternativeOrganisationIdentifierType>
                    {
                        new alternativeOrganisationIdentifierType
                        {
                            OrganisationIdentifier = "12345678",
                            OrganisationIdentifierName = alternativeOrganisationIdentifierTypeOrganisationIdentifierName
                                .UKPROVIDERREFERENCENUMBER
                        }
                    }
                }
            };

            // act
            var paymentSchedule = deliverablePeriodPaymentInfos.ToPaymentSchedule(allocationType);

            // assert

            Assert.AreEqual(allocationType.contractReference.contractNumber, paymentSchedule.ContractNumber, "The contract number is not correct");
            Assert.AreEqual(allocationType.contractReference.contractVersionNumber, paymentSchedule.VersionNumber, "The VersionNumber is not correct");
            Assert.AreEqual(allocationType.contractAllocationNumber, paymentSchedule.AllocationNumber, "The AllocationNumber is not correct");
            Assert.AreEqual(2, paymentSchedule.AllocationDeliverables.Count, "The number of deliverables is not correct");
            Assert.IsTrue(deliverablePeriodPaymentInfos.Select(dpp => dpp.DeliverableCode)
                    .All(dc => paymentSchedule.AllocationDeliverables.Select(d => d.DeliverableCode).Contains(dc)),
                "All the deliverable codes are not present");

            deliverablePeriodPaymentInfos.ForEach(dppi =>
                {
                    ScheduledPayment scheduledPayment = paymentSchedule.AllocationDeliverables.Single(d => d.DeliverableCode == dppi.DeliverableCode).ScheduledPayments.Single(dp => dp.Period == dppi.Period.ToString());
                    Assert.AreEqual(dppi.ActualValue, scheduledPayment.ActualValue, $"The actual value is not correct period: {dppi.Period}, deliverable code: {dppi.DeliverableCode}");
                    Assert.AreEqual(dppi.ActualVolume, scheduledPayment.ActualVolume, $"The ActualVolume is not correct period: {dppi.Period}, deliverable code: {dppi.DeliverableCode}");
                    Assert.AreEqual(dppi.BalancingPaymentAmount, scheduledPayment.BalancingPaymentAmount, $"The BalancingPaymentAmount is not correct period: {dppi.Period}, deliverable code: {dppi.DeliverableCode}");
                    Assert.AreEqual(dppi.CappedPaymentAmount, scheduledPayment.CappedPaymentAmount, $"The CappedPaymentAmount is not correct period: {dppi.Period}, deliverable code: {dppi.DeliverableCode}");
                    Assert.AreEqual(dppi.NetPaymentAmount, scheduledPayment.NetPaymentAmount, $"The NetPaymentAmount is not correct period: {dppi.Period}, deliverable code: {dppi.DeliverableCode}");
                    Assert.AreEqual(dppi.ProfilePaymentAmount, scheduledPayment.ProfilePaymentAmount, $"The ProfilePaymentAmount is not correct period: {dppi.Period}, deliverable code: {dppi.DeliverableCode}");
                    Assert.AreEqual(dppi.ReconciliationPaymentAmount, scheduledPayment.ReconciliationPaymentAmount, $"The ReconciliationPaymentAmount is not correct period: {dppi.Period}, deliverable code: {dppi.DeliverableCode}");
                    Assert.AreEqual(dppi.PlannedValue, scheduledPayment.PlannedValue, $"The PlannedValue is not correct period: {dppi.Period}, deliverable code: {dppi.DeliverableCode}");
                    Assert.AreEqual("CM", scheduledPayment.PeriodTypeCode, $"The PeriodTypeCode is not correct period: {dppi.Period}, deliverable code: {dppi.DeliverableCode}");
                });
        }
    }
}
