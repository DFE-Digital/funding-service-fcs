namespace SFA.FCT.ContractManagementService.Test.UnitTests
{
    using System;
    using Common;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ContractAmendmentInformationTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractAmendmentInformation_IsValid_ShouldReturnTrueIfIsValid()
        {
            var variation = new ContractAmendmentInformation
            {
                ContractNumber = "ABC-123",
                VersionNumber = 1,
                SubVersionNumber = 0,
                AmendmentType = "VARIATION"
            };

            var notification = new ContractAmendmentInformation
            {
                ContractNumber = "ABC-123",
                VersionNumber = 1,
                SubVersionNumber = 0,
                AmendmentType = "NOTIFICATION"
            };

            Assert.IsTrue(variation.IsValid());
            Assert.IsTrue(notification.IsValid());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAmendmentInformation_IsValid_ShouldReturnFalseIfContractNumberIsNullEmpty()
        {
            var nullContractNumber = new ContractAmendmentInformation
            {
                ContractNumber = null,
                VersionNumber = 1,
                SubVersionNumber = 0,
                AmendmentType = "NOTIFICATION"
            };

            var emptyContractNumber = new ContractAmendmentInformation
            {
                ContractNumber = "",
                VersionNumber = 1,
                SubVersionNumber = 0,
                AmendmentType = "NOTIFICATION"
            };

            Assert.IsFalse(nullContractNumber.IsValid());
            Assert.IsFalse(emptyContractNumber.IsValid());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAmendmentInformation_IsValid_ShouldReturnFalseIfVersionNumberIsZero()
        {
            var zeroVersionNumber = new ContractAmendmentInformation
            {
                ContractNumber = "ABC-123",
                VersionNumber = 0,
                SubVersionNumber = 0,
                AmendmentType = "NOTIFICATION"
            };

            Assert.IsFalse(zeroVersionNumber.IsValid());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAmendmentInformation_IsValid_ShouldReturnFalseIfAmendmentTypeIsNotValid()
        {
            var wrongAmendmentType = new ContractAmendmentInformation
            {
                ContractNumber = "ABC-123",
                VersionNumber = 0,
                SubVersionNumber = 0,
                AmendmentType = "OTHER"
            };

            Assert.IsFalse(wrongAmendmentType.IsValid());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAmendmentInformation_GetAmendmentType_ShouldReturnTheCorrectEnum()
        {
            ContractAmendmentInformation contractAmendmentInformation = new ContractAmendmentInformation
            {
                ContractNumber = "ABC-123",
                VersionNumber = 0,
                SubVersionNumber = 0,
                AmendmentType = "NOTIFICATION"
            };

            // act and assert
            Assert.AreEqual(AmendmentType.Notification, contractAmendmentInformation.GetAmendmentType());
        }

        [TestMethod, TestCategory("UnitTest")]

        public void ContractAmendmentInformation_GetAmendmentType_ShouldThrowExceptionWhenAmendmentTypeNotSupported()
        {
            ContractAmendmentInformation contractAmendmentInformation = new ContractAmendmentInformation
            {
                ContractNumber = "ABC-123",
                VersionNumber = 0,
                SubVersionNumber = 0,
                AmendmentType = "OTHER"
            };

            ExceptionAssert.Throws<ArgumentException>(() => contractAmendmentInformation.GetAmendmentType());
        }

        private static class ExceptionAssert
        {
            public static void Throws<T>(Action action) where T : Exception
            {
                try
                {
                    action();
                }
                catch (T)
                {
                    return;
                }

                Assert.Fail($"Exception of type {typeof(T)} should be thrown.");
            }
        }
    }
}