namespace AllocationDeliveryDomain.Endpoint.Tests.PaymentInstructionValidation
{
    using System;
    using System.Linq;
    using Endpoint.PaymentInstructionValidation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common;

    [TestClass]
    public class PaymentInstructionValidatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PaymentInstructionValidator_Validate_ShouldPassWhenValid()
        {
            // arrange
            Mock<IDate> dateProvider = new Mock<IDate>();
            dateProvider.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2017, 09, 01));
            PaymentInstructionValidator paymentInstructionValidator = new PaymentInstructionValidator(dateProvider.Object);

            EnrichedReportedActual paymentInstruction = new EnrichedReportedActual
            {
                ContractAllocationNumber = "LEVY-1",
                AllocationStartDate = new DateTime(2017, 05, 01),
                EnrichedDeliverableCode = "1",
                Period = "201708"
            };
            dateProvider.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2017, 09, 01));

            // act
            paymentInstructionValidator.Validate(paymentInstruction);

            // assert
            Assert.IsTrue(paymentInstruction.IsValid, "Payment Instruction was marked as not valid.");
            Assert.IsFalse(paymentInstruction.ValidationErrors.Any(), "Validation errors were populated.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentInstructionValidator_Validate_ShouldFailWhenAllocationNumberIsNull()
        {
            // arrange
            Mock<IDate> dateProvider = new Mock<IDate>();
            dateProvider.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2017, 09, 01));
            PaymentInstructionValidator paymentInstructionValidator = new PaymentInstructionValidator(dateProvider.Object);

            EnrichedReportedActual paymentInstruction = new EnrichedReportedActual
            {
                ContractAllocationNumber = null,
                AllocationStartDate = new DateTime(2017, 05, 01),
                EnrichedDeliverableCode = "1",
                Period = "201708"
            };
            dateProvider.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2017, 09, 01));

            // act
            paymentInstructionValidator.Validate(paymentInstruction);

            // assert
            Assert.IsFalse(paymentInstruction.IsValid, "Payment Instruction was marked as valid.");
            Assert.IsTrue(paymentInstruction.ValidationErrors.Any(), "Validation errors were not populated.");
            Assert.AreEqual("No contract allocation number found", paymentInstruction.ValidationErrors.Single(), "Validation error was not correct.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentInstructionValidator_Validate_ShouldFailWhenEnrichedDeliverableCodeIsNull()
        {
            // arrange
            Mock<IDate> dateProvider = new Mock<IDate>();
            dateProvider.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2017, 09, 01));
            PaymentInstructionValidator paymentInstructionValidator = new PaymentInstructionValidator(dateProvider.Object);

            EnrichedReportedActual paymentInstruction = new EnrichedReportedActual
            {
                ContractAllocationNumber = "LEVY-1",
                AllocationStartDate = new DateTime(2017, 05, 01),
                EnrichedDeliverableCode = null,
                Period = "201708"
            };
            dateProvider.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2017, 09, 01));

            // act
            paymentInstructionValidator.Validate(paymentInstruction);

            // assert
            Assert.IsFalse(paymentInstruction.IsValid, "Payment Instruction was marked as valid.");
            Assert.IsTrue(paymentInstruction.ValidationErrors.Any(), "Validation errors were not populated.");
            Assert.AreEqual("No deliverable code found", paymentInstruction.ValidationErrors.Single(), "Validation error was not correct.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentInstructionValidator_Validate_ShouldPassWhenPeriodIsSameAsAllocationStartMonth()
        {
            // arrange
            Mock<IDate> dateProvider = new Mock<IDate>();
            dateProvider.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2017, 09, 01));
            PaymentInstructionValidator paymentInstructionValidator = new PaymentInstructionValidator(dateProvider.Object);

            EnrichedReportedActual paymentInstruction = new EnrichedReportedActual
            {
                ContractAllocationNumber = "LEVY-1",
                AllocationStartDate = new DateTime(2017, 05, 01),
                EnrichedDeliverableCode = "1",
                Period = "201705"
            };
            dateProvider.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2017, 06, 01));

            // act
            paymentInstructionValidator.Validate(paymentInstruction);

            // assert
            Assert.IsTrue(paymentInstruction.IsValid, "Payment Instruction was not marked as valid.");
            Assert.IsFalse(paymentInstruction.ValidationErrors.Any(), "Validation errors were populated.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentInstructionValidator_Validate_ShouldPassWhenPeriodAfterAllocationStartMonth()
        {
            // arrange
            Mock<IDate> dateProvider = new Mock<IDate>();
            dateProvider.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2017, 09, 01));
            PaymentInstructionValidator paymentInstructionValidator = new PaymentInstructionValidator(dateProvider.Object);

            EnrichedReportedActual paymentInstruction = new EnrichedReportedActual
            {
                ContractAllocationNumber = "LEVY-1",
                AllocationStartDate = new DateTime(2017, 05, 01),
                EnrichedDeliverableCode = "1",
                Period = "201706"
            };
            dateProvider.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2017, 07, 01));

            // act
            paymentInstructionValidator.Validate(paymentInstruction);

            // assert
            Assert.IsTrue(paymentInstruction.IsValid, "Payment Instruction was not marked as valid.");
            Assert.IsFalse(paymentInstruction.ValidationErrors.Any(), "Validation errors were populated.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentInstructionValidator_Validate_ShouldFailWhenPeriodBeforeAllocationStartMonth()
        {
            // arrange
            Mock<IDate> dateProvider = new Mock<IDate>();
            dateProvider.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2017, 09, 01));
            PaymentInstructionValidator paymentInstructionValidator = new PaymentInstructionValidator(dateProvider.Object);

            EnrichedReportedActual paymentInstruction = new EnrichedReportedActual
            {
                ContractAllocationNumber = "LEVY-1",
                AllocationStartDate = new DateTime(2017, 05, 01),
                EnrichedDeliverableCode = "1",
                Period = "201704"
            };
            dateProvider.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2017, 05, 01));

            // act
            paymentInstructionValidator.Validate(paymentInstruction);

            // assert
            Assert.IsFalse(paymentInstruction.IsValid, "Payment Instruction was marked as valid.");
            Assert.IsTrue(paymentInstruction.ValidationErrors.Any(), "Validation errors were not populated.");
            Assert.AreEqual("Period is prior to allocation start date", paymentInstruction.ValidationErrors.Single(), "Validation error was not correct.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentInstructionValidator_Validate_ShouldFailWhenPeriodBeforePreviousCalendarMonth()
        {
            // arrange
            Mock<IDate> dateProvider = new Mock<IDate>();
            dateProvider.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2017, 09, 01));
            PaymentInstructionValidator paymentInstructionValidator = new PaymentInstructionValidator(dateProvider.Object);

            EnrichedReportedActual paymentInstruction = new EnrichedReportedActual
            {
                ContractAllocationNumber = "LEVY-1",
                AllocationStartDate = new DateTime(2017, 05, 01),
                EnrichedDeliverableCode = "1",
                Period = "201707"
            };
            dateProvider.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2017, 09, 01));

            // act
            paymentInstructionValidator.Validate(paymentInstruction);

            // assert
            Assert.IsFalse(paymentInstruction.IsValid, "Payment Instruction was marked as valid.");
            Assert.IsTrue(paymentInstruction.ValidationErrors.Any(), "Validation errors were not populated.");
            Assert.AreEqual("Period is not previous calendar month", paymentInstruction.ValidationErrors.Single(), "Validation error was not correct.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentInstructionValidator_Validate_ShouldFailWhenPeriodAfterPreviousCalendarMonth()
        {
            // arrange
            Mock<IDate> dateProvider = new Mock<IDate>();
            dateProvider.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2017, 09, 01));
            PaymentInstructionValidator paymentInstructionValidator = new PaymentInstructionValidator(dateProvider.Object);

            EnrichedReportedActual paymentInstruction = new EnrichedReportedActual
            {
                ContractAllocationNumber = "LEVY-1",
                AllocationStartDate = new DateTime(2017, 05, 01),
                EnrichedDeliverableCode = "1",
                Period = "201709"
            };
            dateProvider.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2017, 09, 01));

            // act
            paymentInstructionValidator.Validate(paymentInstruction);

            // assert
            Assert.IsFalse(paymentInstruction.IsValid, "Payment Instruction was marked as valid.");
            Assert.IsTrue(paymentInstruction.ValidationErrors.Any(), "Validation errors were not populated.");
            Assert.AreEqual("Period is not previous calendar month", paymentInstruction.ValidationErrors.Single(), "Validation error was not correct.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentInstructionValidator_Validate_ShouldPassWhenPeriodIsPreviousCalendarMonth()
        {
            // arrange
            Mock<IDate> dateProvider = new Mock<IDate>();
            dateProvider.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2017, 09, 01));
            PaymentInstructionValidator paymentInstructionValidator = new PaymentInstructionValidator(dateProvider.Object);

            EnrichedReportedActual paymentInstruction = new EnrichedReportedActual
            {
                ContractAllocationNumber = "LEVY-1",
                AllocationStartDate = new DateTime(2017, 05, 01),
                EnrichedDeliverableCode = "1",
                Period = "201710"
            };
            dateProvider.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2017, 11, 06));

            // act
            paymentInstructionValidator.Validate(paymentInstruction);

            // assert
            Assert.IsTrue(paymentInstruction.IsValid, "Payment Instruction was not marked as valid.");
            Assert.IsFalse(paymentInstruction.ValidationErrors.Any(), "Validation errors were populated.");
        }
    }
}