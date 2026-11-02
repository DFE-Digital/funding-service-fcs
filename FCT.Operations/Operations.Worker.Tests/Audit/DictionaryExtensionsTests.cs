namespace Operations.Worker.Tests.Audit
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Worker.Audit;

    [TestClass]
    public class DictionaryExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DictionaryExtensions_ShouldGetDefaultValueIfKeyNotPresent()
        {
            // arrange
            Dictionary<string, object> properties = new Dictionary<string, object>
            {
                { "TestKey", "value"},
            };

            const string defaultValue = "Default";
            // act
            var val = properties.GetStringValueOrDefault("SomeOtherKey", defaultValue);

            // assert
            Assert.AreEqual(defaultValue, val);
        }
    }
}
