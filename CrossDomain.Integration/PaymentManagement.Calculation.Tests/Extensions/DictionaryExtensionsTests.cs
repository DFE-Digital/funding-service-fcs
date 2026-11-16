namespace PaymentManagement.Calculation.Tests.Extensions
{
    using System.Collections.Generic;
    using Calculation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class DictionaryExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void GetValueOrNull_ReturnsValueWhenKeyExistsAndNullOtherwise()
        {
            var dictionary = new Dictionary<string, string> { ["present"] = "value" };

            Assert.AreEqual("value", dictionary.GetValueOrNull("present"));
            Assert.IsNull(dictionary.GetValueOrNull("missing"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetValueOrDefault_ReturnsStoredValueOrNewDefault()
        {
            var dictionary = new Dictionary<string, int> { ["present"] = 5 };

            Assert.AreEqual(5, DictionaryExtensions.GetValueOrDefault(dictionary, "present"));
            Assert.AreEqual(0, DictionaryExtensions.GetValueOrDefault(dictionary, "missing"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetValueOrNone_ReturnsSomeForExistingKeyAndNoneOtherwise()
        {
            var dictionary = new Dictionary<string, string> { ["present"] = "value" };

            Assert.IsTrue(dictionary.GetValueOrNone("present").HasValue);
            Assert.IsFalse(dictionary.GetValueOrNone("missing").HasValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AddOrUpdate_AddsMissingKeyAndReplacesExistingValue()
        {
            var dictionary = new Dictionary<string, int>();

            dictionary.AddOrUpdate("key", 1);
            dictionary.AddOrUpdate("key", 2);

            Assert.AreEqual(1, dictionary.Count);
            Assert.AreEqual(2, dictionary["key"]);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AddValueToExistingValue_AddsOrCombinesValue()
        {
            var dictionary = new Dictionary<string, int>();

            dictionary.AddValueToExistingValue("key", 2, (current, added) => current + added);
            dictionary.AddValueToExistingValue("key", 3, (current, added) => current + added);

            Assert.AreEqual(5, dictionary["key"]);
        }
    }
}
