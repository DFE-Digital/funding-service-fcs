namespace ContractRequestDomain.Tests.ContractSyntaxValidationTests.UnitTests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Utils;

    [TestClass]
    public class IntParseHelperTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_IsInteger_ShouldReturnFalseIfIsString()
        {
            Assert.IsFalse(IntParseHelper.IsInteger("test"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_IsInteger_ShouldReturnFalseIfIsDecimal()
        {
            Assert.IsFalse(IntParseHelper.IsInteger("1.5"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_IsInteger_ShouldReturnTrueIfInteger()
        {
            Assert.IsTrue(IntParseHelper.IsInteger("230"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_IsInteger_ShouldReturnTrueIfIntegerWithDecimalPlace()
        {
            Assert.IsTrue(IntParseHelper.IsInteger("5.000"));
        }
    }
}