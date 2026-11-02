namespace ContractCreateDomain.Implementation.Tests.ExtensionMethods
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.Implementation.Extensions;

    [TestClass]
    public class StringExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_ToTextWithSpaceBeforeCapitals()
        {
            // arrange
            List<(string text, string expected)> stringPairs = new List<(string text, string expected)>
            {
                ("InadequateFinancialHealth", "Inadequate Financial Health"),
                ("InadequateOfsted", "Inadequate Ofsted"),
                ("Other", "Other"),

            };

            stringPairs.ForEach(stringPair =>
            {
                // act
                string titleCase = stringPair.text.ToTextWithSpaceBeforeCapitals();
                // assert
                Assert.AreEqual(stringPair.expected, titleCase, $"This string has failed {stringPair.text}");
            });
        }
    }
}
