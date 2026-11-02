namespace AllocationDeliveryDomain.Endpoint.Tests.PaymentInstructionValidation
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Endpoint.PaymentInstructionValidation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentInstruction;

    [TestClass]
    public class ReportedPaymentInstructionTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ReportedPaymentInstructionTransformer_TransformToPaymentInstructionAudit_ShouldReturnCorrectlyTransformedPaymentInstructions()
        {
            // arrange
            EnrichedReportedActual enrichedPaymentInstruction = new EnrichedReportedActual
            {
                CollectionType = "APPS",
                CollectionReturnCode = "APPS01",
                OrganisationId = "ORG000123456",
                PeriodTypeCode = "CM",
                Period = "201705",
                FundingStreamPeriodCode = "LEVY1799",
                ContractAllocationNumber = "LEVY-1000",
                EnrichedDeliverableCode = "5",
                ActualVolume = 0,
                ActualValue = 1234.56,
                Ukprn = "123456",
                ContractNumber = "APPLEVY-1000",
                ContractVersion = 1,
                ContractSubVersion = 2,
                AllocationStartDate = new DateTime(2017, 05, 01)
            };

            Mock<IDate> dateProviderMock = new Mock<IDate>();
            dateProviderMock.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2017, 04, 01));

            // act
            PaymentInstructionAudit paymentInstructionAudit =
                ReportedPaymentInstructionTransformer.TransformToPaymentInstructionAudit(enrichedPaymentInstruction, dateProviderMock.Object);

            // assert
            Assert.AreEqual("APPS", paymentInstructionAudit.CollectionType, "Incorrect CollectionType transformed.");
            Assert.AreEqual("APPS01", paymentInstructionAudit.CollectionReturnCode, "Incorrect CollectionReturnCode transformed.");
            Assert.AreEqual("ORG000123456", paymentInstructionAudit.OrganisationId, "Incorrect OrganisationId transformed.");
            Assert.AreEqual("201705", paymentInstructionAudit.Period, "Incorrect Period transformed.");
            Assert.AreEqual("LEVY1799", paymentInstructionAudit.FundingStreamPeriodCode, "Incorrect FundingStreamPeriodCode transformed.");
            Assert.AreEqual("LEVY-1000", paymentInstructionAudit.ContractAllocationNumber, "Incorrect ContractAllocationNumber transformed.");
            Assert.AreEqual(5, paymentInstructionAudit.DeliverableCode, "Incorrect DeliverableCode transformed.");
            Assert.AreEqual(1234.56M, paymentInstructionAudit.PaymentValue, "Incorrect PaymentValue transformed.");
            Assert.AreEqual("123456", paymentInstructionAudit.Ukprn, "Incorrect Ukprn transformed.");
            Assert.AreEqual("APPLEVY-1000", paymentInstructionAudit.ContractNumber, "Incorrect ContractNumber transformed.");
            Assert.AreEqual(1, paymentInstructionAudit.ContractVersion, "Incorrect ContractVersion transformed.");
            Assert.AreEqual(2, paymentInstructionAudit.ContractSubVersion, "Incorrect ContractSubVersion transformed.");
            Assert.AreEqual(new DateTime(2017, 05, 01), paymentInstructionAudit.AllocationStartDate, "Incorrect AllocationStartDate transformed.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReportedPaymentInstructionTransformer_TransformToPaymentInstructionEvent_ShouldReturnCorrectlyTransformedPaymentInstructionsSplitByAllocation()
        {
            // arrange
            EnrichedReportedActual[] enrichedPaymentInstructions =
            {
                new EnrichedReportedActual
                {
                    CollectionType = "APPS",
                    CollectionReturnCode = "APPS01",
                    OrganisationId = "ORG000123456",
                    PeriodTypeCode = "CM",
                    Period = "201705",
                    FundingStreamPeriodCode = "LEVY1799",
                    ContractAllocationNumber = "LEVY-1000",
                    EnrichedDeliverableCode = "1",
                    ActualVolume = 0,
                    ActualValue = 1234.56,
                    Ukprn = "123456",
                    ContractNumber = "APPLEVY-1000",
                    ContractVersion = 1,
                    ContractSubVersion = 2,
                    AllocationStartDate = new DateTime(2017, 05, 01),
                    AllocationEndDate = DateTime.MinValue
                },
                new EnrichedReportedActual
                {
                    CollectionType = "APPS",
                    CollectionReturnCode = "APPS01",
                    OrganisationId = "ORG000123456",
                    PeriodTypeCode = "CM",
                    Period = "201705",
                    FundingStreamPeriodCode = "LEVY1799",
                    ContractAllocationNumber = "LEVY-1000",
                    EnrichedDeliverableCode = "2",
                    ActualVolume = 0,
                    ActualValue = 9876.54,
                    Ukprn = "123456",
                    ContractNumber = "APPLEVY-1000",
                    ContractVersion = 1,
                    ContractSubVersion = 2,
                    AllocationStartDate = new DateTime(2017, 05, 01),
                    AllocationEndDate = DateTime.MinValue
                },
                new EnrichedReportedActual
                {
                    CollectionType = "APPS",
                    CollectionReturnCode = "APPS01",
                    OrganisationId = "ORG000654321",
                    PeriodTypeCode = "CM",
                    Period = "201705",
                    FundingStreamPeriodCode = "LEVY1799",
                    ContractAllocationNumber = "LEVY-1001",
                    EnrichedDeliverableCode = "1",
                    ActualVolume = 0,
                    ActualValue = 6543.21,
                    Ukprn = "654321",
                    ContractNumber = "APPLEVY-1001",
                    ContractVersion = 2,
                    ContractSubVersion = 2,
                    AllocationStartDate = new DateTime(2017, 05, 01),
                    AllocationEndDate = DateTime.MinValue
                }
            };

            // act
            IReadOnlyCollection<AllocationPaymentInstruction> allocationPaymentInstructions =
                ReportedPaymentInstructionTransformer.TransformToAllocationPaymentInstructions(enrichedPaymentInstructions);

            // assert
            Assert.AreEqual(2, allocationPaymentInstructions.Count, "Incorrect number of results returned.");

            Assert.IsNotNull(allocationPaymentInstructions.SingleOrDefault(pi => pi.AllocationNumber == "LEVY-1000"), "Allocation LEVY-1000 was not transformed.");

            AllocationPaymentInstruction allocationPaymentInstruction1000 = allocationPaymentInstructions.Single(pi => pi.AllocationNumber == "LEVY-1000");
            Assert.AreEqual("LEVY-1000", allocationPaymentInstruction1000.AllocationNumber, "Incorrect AllocationNumber transformed.");
            Assert.AreEqual(1, allocationPaymentInstruction1000.VersionNumber, "Incorrect VersionNumber transformed.");
            Assert.AreEqual("APPLEVY-1000", allocationPaymentInstruction1000.ContractNumber, "Incorrect ContractNumber transformed.");
            Assert.AreEqual("LEVY1799", allocationPaymentInstruction1000.FundingStreamPeriodCode, "Incorrect FundingStreamPeriodCode transformed.");
            Assert.AreEqual("ORG000123456", allocationPaymentInstruction1000.OrganisationId, "Incorrect OrganisationId transformed.");
            Assert.AreEqual(123456, allocationPaymentInstruction1000.Ukprn, "Incorrect Ukprn transformed.");
            Assert.AreEqual(new DateTime(2017, 05, 01), allocationPaymentInstruction1000.AllocationStartDate, "Incorrect AllocationStartDate transformed.");
            Assert.IsNull(allocationPaymentInstruction1000.AllocationEndDate, "Incorrect AllocationEndDate transformed.");
            Assert.AreEqual(2, allocationPaymentInstruction1000.DeliverablePaymentInstructions.Count(), "Incorrect number of deliverables transformed.");

            DeliverablePaymentInstruction allocation1000Deliverable1 = allocationPaymentInstruction1000.DeliverablePaymentInstructions.Single(d => d.DeliverableCode == 1);
            Assert.AreEqual(1, allocation1000Deliverable1.DeliverableCode, "Incorrect DeliverableCode transformed.");
            Assert.AreEqual("201705", allocation1000Deliverable1.Period, "Incorrect Period transformed.");
            Assert.AreEqual("CM", allocation1000Deliverable1.PeriodTypeCode, "Incorrect PeriodTypeCode transformed.");
            Assert.AreEqual(1234.56M, allocation1000Deliverable1.PaymentValue, "Incorrect PaymentValue transformed.");

            DeliverablePaymentInstruction allocation1000Deliverable2 = allocationPaymentInstruction1000.DeliverablePaymentInstructions.Single(d => d.DeliverableCode == 2);
            Assert.AreEqual(2, allocation1000Deliverable2.DeliverableCode, "Incorrect DeliverableCode transformed.");
            Assert.AreEqual("201705", allocation1000Deliverable2.Period, "Incorrect Period transformed.");
            Assert.AreEqual("CM", allocation1000Deliverable2.PeriodTypeCode, "Incorrect PeriodTypeCode transformed.");
            Assert.AreEqual(9876.54M, allocation1000Deliverable2.PaymentValue, "Incorrect PaymentValue transformed.");

            Assert.IsNotNull(allocationPaymentInstructions.SingleOrDefault(pi => pi.AllocationNumber == "LEVY-1001"), "Allocation LEVY-1001 was not transformed.");

            AllocationPaymentInstruction allocationPaymentInstruction1001 = allocationPaymentInstructions.Single(pi => pi.AllocationNumber == "LEVY-1001");
            Assert.AreEqual("LEVY-1001", allocationPaymentInstruction1001.AllocationNumber, "Incorrect AllocationNumber transformed.");
            Assert.AreEqual(2, allocationPaymentInstruction1001.VersionNumber, "Incorrect VersionNumber transformed.");
            Assert.AreEqual("APPLEVY-1001", allocationPaymentInstruction1001.ContractNumber, "Incorrect ContractNumber transformed.");
            Assert.AreEqual("LEVY1799", allocationPaymentInstruction1001.FundingStreamPeriodCode, "Incorrect FundingStreamPeriodCode transformed.");
            Assert.AreEqual("ORG000654321", allocationPaymentInstruction1001.OrganisationId, "Incorrect OrganisationId transformed.");
            Assert.AreEqual(654321, allocationPaymentInstruction1001.Ukprn, "Incorrect Ukprn transformed.");
            Assert.AreEqual(new DateTime(2017, 05, 01), allocationPaymentInstruction1001.AllocationStartDate, "Incorrect AllocationStartDate transformed.");
            Assert.IsNull(allocationPaymentInstruction1001.AllocationEndDate, "Incorrect AllocationEndDate transformed.");
            Assert.AreEqual(1, allocationPaymentInstruction1001.DeliverablePaymentInstructions.Count(), "Incorrect number of deliverables transformed.");

            DeliverablePaymentInstruction allocation1001Deliverable1 = allocationPaymentInstruction1001.DeliverablePaymentInstructions.Single(d => d.DeliverableCode == 1);
            Assert.AreEqual(1, allocation1001Deliverable1.DeliverableCode, "Incorrect DeliverableCode transformed.");
            Assert.AreEqual("201705", allocation1001Deliverable1.Period, "Incorrect Period transformed.");
            Assert.AreEqual("CM", allocation1001Deliverable1.PeriodTypeCode, "Incorrect PeriodTypeCode transformed.");
            Assert.AreEqual(6543.21M, allocation1001Deliverable1.PaymentValue, "Incorrect PaymentValue transformed.");
        }
    }
}