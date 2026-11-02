namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Test.UnitTests
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Services;
    using CrossDomain.Integration.Entities.PaymentInstruction;
    using Model = PaymentSchedule.DataStore.Model;
    using PaymentSchedule = CrossDomain.Integration.Entities.PaymentSchedule;

    [TestClass]
    public class AllocationPaymentInstructionTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AllocationPaymentInstructionTransformer_ToPaymentSchedule_ShouldReturnCorrectlyTransformedPaymentSchedule()
        {
            // arrange
            AllocationPaymentInstruction allocationPaymentInstruction = new AllocationPaymentInstruction
            {
                AllocationNumber = "LEVY-2000",
                VersionNumber = 2,
                ContractNumber = "APPLEVY-1000",
                FundingStreamPeriodCode = "LEVY1799",
                OrganisationId = "ORG12345",
                Ukprn = 12345,
                DeliverablePaymentInstructions = new List<DeliverablePaymentInstruction>
                {
                    new DeliverablePaymentInstruction
                    {
                        DeliverableCode = 1,
                        Period = "201705",
                        PeriodTypeCode = "CM",
                        PaymentValue = 1234.56M
                    },
                    new DeliverablePaymentInstruction
                    {
                        DeliverableCode = 2,
                        Period = "201705",
                        PeriodTypeCode = "CM",
                        PaymentValue = 2345.67M
                    },
                    new DeliverablePaymentInstruction
                    {
                        DeliverableCode = 3,
                        Period = "201705",
                        PeriodTypeCode = "CM",
                        PaymentValue = 3456.78M
                    }
                }
            };

            // act
            PaymentSchedule.Allocation paymentSchedule = AllocationPaymentInstructionTransformer.ToPaymentSchedule(allocationPaymentInstruction);

            // assert
            Assert.IsNotNull(paymentSchedule, "Returned payment schedule was null.");

            Assert.AreEqual("LEVY-2000", paymentSchedule.AllocationNumber, "AllocationNumber was not transformed.");
            Assert.AreEqual("APPLEVY-1000", paymentSchedule.ContractNumber, "ContractNumber was not transformed.");
            Assert.AreEqual(2, paymentSchedule.VersionNumber, "VersionNumber was not transformed.");
            Assert.AreEqual(2, paymentSchedule.ContractVersionNumber, "ContractVersionNumber was not transformed.");
            Assert.AreEqual("LEVY1799", paymentSchedule.FundingStreamPeriodCode, "ContractNumber was not transformed.");
            Assert.IsNotNull(paymentSchedule.Organisation, "Organisation was not transformed.");
            Assert.AreEqual("ORG12345", paymentSchedule.Organisation.MainOrganisationIdentifier, "MainOrganisationIdentifier was not transformed.");
            Assert.AreEqual(1, paymentSchedule.Organisation.OrganisationIdentifiers.Count, "OrganisationId was not transformed.");
            Assert.AreEqual(1, paymentSchedule.Organisation.OrganisationIdentifiers.Count, "OrganisationIdentifiers was not transformed.");
            Assert.AreEqual("12345", paymentSchedule.Organisation.OrganisationIdentifiers.Single().OrganisationId, "Ukprn was not transformed.");
            Assert.AreEqual(PaymentSchedule.OrganisationIdentifierOrganisationIdentifierName.UKPRN, paymentSchedule.Organisation.OrganisationIdentifiers.Single().OrganisationIdentifierName, "OrganisationIdentifierName was not transformed.");

            Assert.AreEqual(3, paymentSchedule.AllocationDeliverables.Count, "Incorrect number of deliverables transformed.");

            PaymentSchedule.AllocationDeliverable deliverable1 = paymentSchedule.AllocationDeliverables.SingleOrDefault(d => d.DeliverableCode == 1);
            Assert.IsNotNull(deliverable1, "First deliverable was not transformed.");
            Assert.AreEqual(1, deliverable1.ScheduledPayments.Count, "Incorrect number of payments transformed for first deliverable.");
            PaymentSchedule.ScheduledPayment deliverable1Period2017 = deliverable1.ScheduledPayments.SingleOrDefault(dp => dp.Period == "201705");
            Assert.IsNotNull(deliverable1Period2017, "First deliverable payment was not transformed.");
            Assert.AreEqual("CM", deliverable1Period2017.PeriodTypeCode, "First deliverable payment PeriodTypeCode was not transformed.");
            Assert.AreEqual(1234.56M, deliverable1Period2017.ReconciliationPaymentAmount, "First deliverable payment ReconciliationPaymentAmount was not transformed.");
            Assert.AreEqual(1234.56M, deliverable1Period2017.NetPaymentAmount, "First deliverable payment NetPaymentAmount was not transformed.");

            PaymentSchedule.AllocationDeliverable deliverable2 = paymentSchedule.AllocationDeliverables.SingleOrDefault(d => d.DeliverableCode == 2);
            Assert.IsNotNull(deliverable2, "Second deliverable was not transformed.");
            Assert.AreEqual(1, deliverable2.ScheduledPayments.Count, "Incorrect number of payments transformed for Second deliverable.");
            PaymentSchedule.ScheduledPayment deliverable2Period2017 = deliverable2.ScheduledPayments.SingleOrDefault(dp => dp.Period == "201705");
            Assert.IsNotNull(deliverable2Period2017, "Second deliverable payment was not transformed.");
            Assert.AreEqual("CM", deliverable2Period2017.PeriodTypeCode, "Second deliverable payment PeriodTypeCode was not transformed.");
            Assert.AreEqual(2345.67M, deliverable2Period2017.ReconciliationPaymentAmount, "Second deliverable payment ReconciliationPaymentAmount was not transformed.");
            Assert.AreEqual(2345.67M, deliverable2Period2017.NetPaymentAmount, "Second deliverable payment NetPaymentAmount was not transformed.");

            PaymentSchedule.AllocationDeliverable deliverable3 = paymentSchedule.AllocationDeliverables.SingleOrDefault(d => d.DeliverableCode == 3);
            Assert.IsNotNull(deliverable3, "Third deliverable was not transformed.");
            Assert.AreEqual(1, deliverable3.ScheduledPayments.Count, "Incorrect number of payments transformed for Third deliverable.");
            PaymentSchedule.ScheduledPayment deliverable3Period2017 = deliverable3.ScheduledPayments.SingleOrDefault(dp => dp.Period == "201705");
            Assert.IsNotNull(deliverable3Period2017, "Third deliverable payment was not transformed.");
            Assert.AreEqual("CM", deliverable3Period2017.PeriodTypeCode, "Third deliverable payment PeriodTypeCode was not transformed.");
            Assert.AreEqual(3456.78M, deliverable3Period2017.ReconciliationPaymentAmount, "Third deliverable payment ReconciliationPaymentAmount was not transformed.");
            Assert.AreEqual(3456.78M, deliverable3Period2017.NetPaymentAmount, "Third deliverable payment NetPaymentAmount was not transformed.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationPaymentInstructionTransformer_ToDeliverablePayments_ShouldReturnCorrectlyTransformedDeliverablePayments()
        {
            // arrange
            AllocationPaymentInstruction allocationPaymentInstruction = new AllocationPaymentInstruction
            {
                AllocationNumber = "LEVY-2000",
                VersionNumber = 2,
                ContractNumber = "APPLEVY-1000",
                FundingStreamPeriodCode = "LEVY1799",
                OrganisationId = "ORG12345",
                Ukprn = 12345,
                DeliverablePaymentInstructions = new List<DeliverablePaymentInstruction>
                {
                    new DeliverablePaymentInstruction
                    {
                        DeliverableCode = 1,
                        Period = "201705",
                        PeriodTypeCode = "CM",
                        PaymentValue = 1234.56M
                    },
                    new DeliverablePaymentInstruction
                    {
                        DeliverableCode = 2,
                        Period = "201705",
                        PeriodTypeCode = "CM",
                        PaymentValue = 2345.67M
                    },
                    new DeliverablePaymentInstruction
                    {
                        DeliverableCode = 3,
                        Period = "201705",
                        PeriodTypeCode = "CM",
                        PaymentValue = 3456.78M
                    }
                }
            };

            // act
            IReadOnlyCollection<Model.DeliverablePayment> deliverablePayments = AllocationPaymentInstructionTransformer.ToDeliverablePayments(allocationPaymentInstruction);

            // assert
            Assert.IsNotNull(deliverablePayments, "Returned collection was null.");
            Assert.AreEqual(3, deliverablePayments.Count, "Unexpected number of entities returned.");

            Model.DeliverablePayment deliverablePayment1 = deliverablePayments.SingleOrDefault(dp => dp.DeliverableCode == 1);
            Assert.IsNotNull(deliverablePayment1, "Deliverable 1 not returned.");
            Assert.AreEqual("201705", deliverablePayment1.Period, "Deliverable 1 Period was not transformed correctly.");
            Assert.AreEqual(Model.PeriodTypeCode.CM, deliverablePayment1.PeriodTypeCode, "Deliverable 1 PeriodTypeCode was not transformed correctly.");
            Assert.AreEqual(1234.56M, deliverablePayment1.ReconciliationPaymentAmount, "Deliverable 1 ReconciliationPaymentAmount was not transformed correctly.");
            Assert.AreEqual(1234.56M, deliverablePayment1.NetPaymentAmount, "Deliverable 1 NetPaymentAmount was not transformed correctly.");
            Assert.AreEqual(0, deliverablePayment1.PlannedVolume, "Deliverable 1 PlannedVolumne was not transformed correctly.");
            Assert.AreEqual(0M, deliverablePayment1.PlannedValue, "Deliverable 1 PlannedValue was not transformed correctly.");
            Assert.AreEqual(0M, deliverablePayment1.ProfilePaymentAmount, "Deliverable 1 ProfilePaymentAmount was not transformed correctly.");
            Assert.AreEqual(0M, deliverablePayment1.CappedPaymentAmount, "Deliverable 1 CappedPaymentAmount was not transformed correctly.");
            Assert.AreEqual(0M, deliverablePayment1.BalancingPaymentAmount, "Deliverable 1 BalancingPaymentAmount was not transformed correctly.");
            Assert.AreEqual(0M, deliverablePayment1.ActualValue, "Deliverable 1 ActualValue was not transformed correctly.");
            Assert.IsNull(deliverablePayment1.ActualVolume, "Deliverable 1 ActualVolumne was not transformed correctly.");
            Assert.IsNull(deliverablePayment1.CollectionReturnCode, "Deliverable 1 CollectionReturnCode was not transformed correctly.");

            Model.DeliverablePayment deliverablePayment2 = deliverablePayments.SingleOrDefault(dp => dp.DeliverableCode == 2);
            Assert.IsNotNull(deliverablePayment2, "Deliverable 2 not returned.");
            Assert.AreEqual("201705", deliverablePayment2.Period, "Deliverable 2 Period was not transformed correctly.");
            Assert.AreEqual(Model.PeriodTypeCode.CM, deliverablePayment2.PeriodTypeCode, "Deliverable 2 PeriodTypeCode was not transformed correctly.");
            Assert.AreEqual(2345.67M, deliverablePayment2.ReconciliationPaymentAmount, "Deliverable 2 ReconciliationPaymentAmount was not transformed correctly.");
            Assert.AreEqual(2345.67M, deliverablePayment2.NetPaymentAmount, "Deliverable 2 NetPaymentAmount was not transformed correctly.");
            Assert.AreEqual(0, deliverablePayment2.PlannedVolume, "Deliverable 2 PlannedVolumne was not transformed correctly.");
            Assert.AreEqual(0M, deliverablePayment2.PlannedValue, "Deliverable 2 PlannedValue was not transformed correctly.");
            Assert.AreEqual(0M, deliverablePayment2.ProfilePaymentAmount, "Deliverable 2 ProfilePaymentAmount was not transformed correctly.");
            Assert.AreEqual(0M, deliverablePayment2.CappedPaymentAmount, "Deliverable 2 CappedPaymentAmount was not transformed correctly.");
            Assert.AreEqual(0M, deliverablePayment2.BalancingPaymentAmount, "Deliverable 2 BalancingPaymentAmount was not transformed correctly.");
            Assert.AreEqual(0M, deliverablePayment2.ActualValue, "Deliverable 2 ActualValue was not transformed correctly.");
            Assert.IsNull(deliverablePayment2.ActualVolume, "Deliverable 2 ActualVolumne was not transformed correctly.");
            Assert.IsNull(deliverablePayment2.CollectionReturnCode, "Deliverable 2 CollectionReturnCode was not transformed correctly.");

            Model.DeliverablePayment deliverablePayment3 = deliverablePayments.SingleOrDefault(dp => dp.DeliverableCode == 3);
            Assert.IsNotNull(deliverablePayment3, "Deliverable 3 not returned.");
            Assert.AreEqual("201705", deliverablePayment3.Period, "Deliverable 3 Period was not transformed correctly.");
            Assert.AreEqual(Model.PeriodTypeCode.CM, deliverablePayment3.PeriodTypeCode, "Deliverable 3 PeriodTypeCode was not transformed correctly.");
            Assert.AreEqual(3456.78M, deliverablePayment3.ReconciliationPaymentAmount, "Deliverable 3 ReconciliationPaymentAmount was not transformed correctly.");
            Assert.AreEqual(3456.78M, deliverablePayment3.NetPaymentAmount, "Deliverable 3 NetPaymentAmount was not transformed correctly.");
            Assert.AreEqual(0, deliverablePayment3.PlannedVolume, "Deliverable 3 PlannedVolumne was not transformed correctly.");
            Assert.AreEqual(0M, deliverablePayment3.PlannedValue, "Deliverable 3 PlannedValue was not transformed correctly.");
            Assert.AreEqual(0M, deliverablePayment3.ProfilePaymentAmount, "Deliverable 3 ProfilePaymentAmount was not transformed correctly.");
            Assert.AreEqual(0M, deliverablePayment3.CappedPaymentAmount, "Deliverable 3 CappedPaymentAmount was not transformed correctly.");
            Assert.AreEqual(0M, deliverablePayment3.BalancingPaymentAmount, "Deliverable 3 BalancingPaymentAmount was not transformed correctly.");
            Assert.AreEqual(0M, deliverablePayment3.ActualValue, "Deliverable 3 ActualValue was not transformed correctly.");
            Assert.IsNull(deliverablePayment3.ActualVolume, "Deliverable 3 ActualVolumne was not transformed correctly.");
            Assert.IsNull(deliverablePayment3.CollectionReturnCode, "Deliverable 3 CollectionReturnCode was not transformed correctly.");
        }
    }
}
