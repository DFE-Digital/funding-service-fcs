namespace ContractManagementDomain.Termination.Tests.Unit
{
    using System;
    using ContractManagementDomain.Termination.DTOs;
    using ContractManagementDomain.Termination.Infrastructure;
    using ContractManagementDomain.Termination.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractManagementService.Common;

    [TestClass]
    public class TerminateContractValidationServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void TerminateContractValidationService_Validate_ShouldReturnRejectionReasonWhenContractIsNotLatest()
        {
            // arrange
            const string validationFailReasonText = "a draft amendment exists";

            TerminateContractValidationService validationService = new TerminateContractValidationService();

            // act
            Either<RejectionReason, TerminateContractInfo> validationResult = validationService.Validate(new TerminateContractInfo(isLatest: false,
                contractTerminationDate: DateTime.Now,
                contractIdentifier: new ContractIdentifier("CN", 1, 1),
                hasOutStandingPayments: null,
                isMonthEndRunning: null,
                currentDate: DateTime.Now));

            // assert
            validationResult.Match(leftAction: l => Assert.IsNotNull(l, "We do not have a rejection reason"),
                                  rightAction: r => Assert.IsNull(r, "We have a positive"));

            validationResult.MatchLeft(r => Assert.AreEqual(RejectionReason.Why.IsNotLatest, r.WhyFailed, "The reason for failure is not correct"));
            validationResult.MatchLeft(r => Assert.AreEqual(validationFailReasonText, r.Text, "The validation fail reason text is not correct"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TerminateContractValidationService_Validate_ShouldReturnRejectionReason_WhenContractTerminationDateIsNotSet()
        {
            // arrange
            const string validationFailReasonText = "Contract Termination Date must be in the past";

            TerminateContractValidationService validationService = new TerminateContractValidationService();

            // act
            Either<RejectionReason, TerminateContractInfo> validationResult = validationService.Validate(new TerminateContractInfo(isLatest: true,
                contractTerminationDate: null,
                contractIdentifier: new ContractIdentifier("CN", 1, 1),
                hasOutStandingPayments: null,
                isMonthEndRunning: null,
                currentDate: DateTime.Now));

            // assert
            validationResult.Match(leftAction: l => Assert.IsNotNull(l, "We do not have a rejection reason"),
                                  rightAction: r => Assert.IsNull(r, "We have a positive"));

            validationResult.MatchLeft(r => Assert.AreEqual(RejectionReason.Why.TerminationDateIsNotValid, r.WhyFailed, "The reason for failure is not correct"));
            validationResult.MatchLeft(r => Assert.AreEqual(validationFailReasonText, r.Text, "The validation fail reason text is not correct"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TerminateContractValidationService_Validate_ShouldReturnRejectionReason_WhenContractTerminationDateIsTheSameAsToday()
        {
            // arrange
            const string validationFailReasonText = "Contract Termination Date must be in the past";

            TerminateContractValidationService validationService = new TerminateContractValidationService();
            DateTime now = DateTime.Now;

            // act
            Either<RejectionReason, TerminateContractInfo> validationResult = validationService.Validate(new TerminateContractInfo(isLatest: true,
                contractTerminationDate: now,
                contractIdentifier: new ContractIdentifier("CN", 1, 1),
                hasOutStandingPayments: ci => false,
                isMonthEndRunning: () => false,
                currentDate: now));

            // assert
            validationResult.Match(leftAction: l => Assert.IsNotNull(l, "We do not have a rejection reason"),
                                  rightAction: r => Assert.IsNull(r, "We have a positive"));

            validationResult.MatchLeft(r => Assert.AreEqual(RejectionReason.Why.TerminationDateIsNotValid, r.WhyFailed, "The reason for failure is not correct"));
            validationResult.MatchLeft(r => Assert.AreEqual(validationFailReasonText, r.Text, "The validation fail reason text is not correct"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TerminateContractValidationService_Validate_ShouldSucceed_WhenContractTerminationDateIsLessThanToday()
        {
            // arrange
            TerminateContractValidationService validationService = new TerminateContractValidationService();
            DateTime now = DateTime.Now;

            // act
            Either<RejectionReason, TerminateContractInfo> validationResult = validationService.Validate(new TerminateContractInfo(isLatest: true,
                contractTerminationDate: now.AddDays(-1),
                contractIdentifier: new ContractIdentifier("CN", 1, 1),
                hasOutStandingPayments: ci => false,
                isMonthEndRunning: () => false,
                currentDate: now));

            // assert
            validationResult.Match(leftAction: l => Assert.IsNull(l, "We have a rejection reason"),
                                  rightAction: r => Assert.IsNotNull(r, "We do not have a positive"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TerminateContractValidationService_Validate_ShouldReturnRejectionReason_WhenHasOutStandingPayments()
        {
            // arrange
            const string validationFailReasonText = "outstanding payments exist";

            TerminateContractValidationService validationService = new TerminateContractValidationService();

            // act
            Either<RejectionReason, TerminateContractInfo> validationResult = validationService.Validate(new TerminateContractInfo(isLatest: true,
                contractTerminationDate: DateTime.Now.AddDays(-1), 
                contractIdentifier: new ContractIdentifier("CN", 1, 1),
                hasOutStandingPayments: ci => true,
                isMonthEndRunning: null,
                currentDate: DateTime.Now));

            // assert
            validationResult.Match(leftAction: l => Assert.IsNotNull(l, "We do not have a rejection reason"),
                                  rightAction: r => Assert.IsNull(r, "We have a positive"));

            validationResult.MatchLeft(r => Assert.AreEqual(RejectionReason.Why.HasOutstandingPayments, r.WhyFailed, "The reason for failure is not correct"));
            validationResult.MatchLeft(r => Assert.AreEqual(validationFailReasonText, r.Text, "The validation fail reason text is not correct"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TerminateContractValidationService_Validate_ShouldReturnRejectionReason_WhenMonthEndIsRunning()
        {
            // arrange
            const string validationFailReasonText = "month-end processing is in progress - please try again later";

            TerminateContractValidationService validationService = new TerminateContractValidationService();

            // act
            Either<RejectionReason, TerminateContractInfo> validationResult = validationService.Validate(new TerminateContractInfo(isLatest: true,
                contractTerminationDate: DateTime.Now.AddDays(-1),
                contractIdentifier: new ContractIdentifier("CN", 1, 1),
                hasOutStandingPayments: ci => false,
                isMonthEndRunning: () => true,
                currentDate: DateTime.Now));

            // assert
            validationResult.Match(leftAction: l => Assert.IsNotNull(l, "We do not have a rejection reason"),
                                  rightAction: r => Assert.IsNull(r, "We have a positive"));

            validationResult.MatchLeft(r => Assert.AreEqual(RejectionReason.Why.DuringMonthEnd, r.WhyFailed, "The reason for failure is not correct"));
            validationResult.MatchLeft(r => Assert.AreEqual(validationFailReasonText, r.Text, "The validation fail reason text is not correct"));
        }
    }
}
