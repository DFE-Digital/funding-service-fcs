namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Extensions
{
    using DocumentDefiner.DocumentPartCreators.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class StringExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_AddPrefixIfNotEmpty_ShouldAddPrefix()
        {
            // arrange
            const string prefixText = "prefix: ";
            const string stringWithText = "123456";

            // act
            var assertString = stringWithText.AddPrefixIfNotEmpty(prefixText);

            // assert
            Assert.AreEqual(prefixText + stringWithText, assertString,"Prefix text was not added");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_AddPrefixIfNotEmpty_ShouldNotAddPrefix()
        {
            // arrange
            const string prefixText = "prefix: ";
            string stringWithoutText = "";

            // act
            var assertString = stringWithoutText.AddPrefixIfNotEmpty(prefixText);

            // assert
            Assert.AreEqual(string.Empty, assertString, "Prefix text was added");
        }
    }
}