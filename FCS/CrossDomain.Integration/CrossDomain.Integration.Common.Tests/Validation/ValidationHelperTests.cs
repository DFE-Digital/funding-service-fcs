namespace CrossDomain.Integration.Common.Tests.Validation
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractManagementService.Common.Validation;
    using SFA.FCT.ContractManagementService.Common;
    using ValidationResult = SFA.FCT.ContractManagementService.Common.Validation.ValidationResult;

    [TestClass]
    public class ValidationHelperTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ValidationHelper_WhenAllMethodsFail_ShouldOnlyInvokeFirstMethod()
        {
            // Arrange
            bool otherMethodInvoked = false;
            MethodWithErrorResult failingMethod1 = new MethodWithErrorResult(mwe => new ValidationResult(false, "err"));
            MethodWithErrorResult failingMethod2 = new MethodWithErrorResult(mwe =>
            {
                otherMethodInvoked = true;
                return new ValidationResult(false,"err2");
            });

            List<MethodWithErrorResult> errorMethodWithErrorMessages = new List<MethodWithErrorResult> { failingMethod1, failingMethod2 };

            // Act
            string firstFailureMessageWhenValidationFails = ValidationHelper.GetFirstFailureMessageWhenValidationFails(errorMethodWithErrorMessages, new ContractIdentifier("test", 1, 0));

            // Assert
            Assert.AreEqual("err", firstFailureMessageWhenValidationFails);
            Assert.IsFalse(otherMethodInvoked);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ValidationHelper_WhensomeMethodsFail_ShouldReturnFirstFailureMessage()
        {
            // Arrange
            MethodWithErrorResult failingMethod1 = new MethodWithErrorResult(mwe => new ValidationResult(false, "err"));
            MethodWithErrorResult passingMethod = new MethodWithErrorResult(mwe => new ValidationResult(true, "err2"));
            MethodWithErrorResult failingMethod2 = new MethodWithErrorResult(mwe => new ValidationResult(false, "err2"));

            List<MethodWithErrorResult> errorMethodWithErrorMessages = new List<MethodWithErrorResult> { failingMethod1, failingMethod2, passingMethod };

            // Act
            string firstFailureMessageWhenValidationFails = ValidationHelper.GetFirstFailureMessageWhenValidationFails(errorMethodWithErrorMessages, new ContractIdentifier("test", 1, 0));

            // Assert
            Assert.AreEqual("err", firstFailureMessageWhenValidationFails);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ValidationHelper_WhenAllMethodsPass_ShouldReturnNull()
        {
            // Arrange

            MethodWithErrorResult passingMethod1 = new MethodWithErrorResult(mwe => new ValidationResult(true, ""));
            MethodWithErrorResult passingMethod2 = new MethodWithErrorResult(mwe => new ValidationResult(true, ""));

            List<MethodWithErrorResult> errorMethodWithErrorMessages = new List<MethodWithErrorResult> { passingMethod1, passingMethod2};

            // Act
            string firstFailureMessageWhenValidationFails = ValidationHelper.GetFirstFailureMessageWhenValidationFails(errorMethodWithErrorMessages, new ContractIdentifier("test", 1, 0));

            // Assert
            Assert.IsNull(firstFailureMessageWhenValidationFails);
        }
    }
}
