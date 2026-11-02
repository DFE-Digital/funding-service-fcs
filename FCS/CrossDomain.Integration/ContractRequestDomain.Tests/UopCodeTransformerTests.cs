namespace ContractRequestDomain.Tests
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;

    [TestClass]
    public class UopCodeTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void UopCodeTransformer_ZeroPad_ShouldZeroPadOneDigitNumberToTenDigits()
        {
            // act
            string transformedValue = UopCodeTransformer.ZeroPad("1");

            // assert
            Assert.AreEqual("0000000001", transformedValue, "UOP Code was not transformed correctly.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UopCodeTransformer_ZeroPad_ShouldZeroPadTwoDigitNumberToTenDigits()
        {
            // act
            string transformedValue = UopCodeTransformer.ZeroPad("12");

            // assert
            Assert.AreEqual("0000000012", transformedValue, "UOP Code was not transformed correctly.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UopCodeTransformer_ZeroPad_ShouldZeroPadAlreadyPaddedNumberToTenDigits()
        {
            // act
            string transformedValue = UopCodeTransformer.ZeroPad("001");

            // assert
            Assert.AreEqual("0000000001", transformedValue, "UOP Code was not transformed correctly.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UopCodeTransformer_ZeroPad_ShouldNotTransformTenDigitZeroPaddedNumber()
        {
            // act
            string transformedValue = UopCodeTransformer.ZeroPad("0000000001");

            // assert
            Assert.AreEqual("0000000001", transformedValue, "UOP Code was not transformed correctly.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UopCodeTransformer_ZeroPad_ShouldTrimExcessivelyZeroPaddedNumberToTenDigits()
        {
            // act
            string transformedValue = UopCodeTransformer.ZeroPad("0000000000001");

            // assert
            Assert.AreEqual("0000000001", transformedValue, "UOP Code was not transformed correctly.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UopCodeTransformer_ZeroPad_ShouldTrimExcessivelyWhiteSpaceAndZeroPaddedNumberToTenDigits()
        {
            // act
            string transformedValue = UopCodeTransformer.ZeroPad("     0000000000001");

            // assert
            Assert.AreEqual("0000000001", transformedValue, "UOP Code was not transformed correctly.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UopCodeTransformer_ZeroPad_ShouldNotTransformExcessivelyLongNumericValue()
        {
            // act
            string transformedValue = UopCodeTransformer.ZeroPad("100000000000000000000001");

            // assert
            Assert.AreEqual("100000000000000000000001", transformedValue, "UOP Code was not transformed correctly.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UopCodeTransformer_ZeroPad_ShouldNotTransformAlphabeticValue()
        {
            // act
            string transformedValue = UopCodeTransformer.ZeroPad("UEE");

            // assert
            Assert.AreEqual("UEE", transformedValue, "UOP Code was not transformed correctly.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UopCodeTransformer_ZeroPad_ShouldNotTransformAlphanumericValue()
        {
            // act
            string transformedValue = UopCodeTransformer.ZeroPad("000UEE123");

            // assert
            Assert.AreEqual("000UEE123", transformedValue, "UOP Code was not transformed correctly.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UopCodeTransformer_ZeroPad_ShouldNotTransformNullOrThrowException()
        {
            // act
            string transformedValue = UopCodeTransformer.ZeroPad(null);

            // assert
            Assert.AreEqual(null, transformedValue, "UOP Code was not transformed correctly.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UopCodeTransformer_ZeroPad_ShouldNotTransformEmptyStringOrThrowException()
        {
            // act
            string transformedValue = UopCodeTransformer.ZeroPad(string.Empty);

            // assert
            Assert.AreEqual(string.Empty, transformedValue, "UOP Code was not transformed correctly.");
        }
    }
}
