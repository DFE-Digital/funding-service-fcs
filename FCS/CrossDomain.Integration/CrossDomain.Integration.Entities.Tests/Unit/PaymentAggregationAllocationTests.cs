namespace CrossDomain.Integration.Entities.Tests.Unit
{
    using System;
    using System.IO;
    using System.Linq;
    using System.Text;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using UnitTests.Common;

    [TestClass]
    public class PaymentAggregationAllocationTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AllocationPartial_ShouldGetDistinctSubnominalCodes()
        {
            // arrange
            Allocation allocation = GetObjectFromJsonFile<Allocation>(
                "CrossDomain.Integration.Entities.Tests",
                @"Resources.CorporatePaymentAggregation.EOP1-2005_Allocation.json");
            
            // act
            var subnominalCodes = allocation.GetDistinctSubnominalCodes();

            // assert
            Assert.AreEqual(2, subnominalCodes.Count, "the number of subnominal codes is incorrect");
            Assert.IsTrue(subnominalCodes.Contains("2201850"), "this subnominal code is not present 2201850");
            Assert.IsTrue(subnominalCodes.Contains("2306850"), "this subnominal code is not present 2306850");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationPartial_ShouldGetDistinctAggregateKeys()
        {
            // arrange
            Allocation allocation = GetObjectFromJsonFile<Allocation>(
                "CrossDomain.Integration.Entities.Tests",
                @"Resources.CorporatePaymentAggregation.EOP1-2005_Allocation.json");

            // act
            var aggregateKeys = allocation.GetDistinctAggregateKeys();

            // assert
            Assert.AreEqual(38, aggregateKeys.Count);
            Assert.IsTrue(aggregateKeys.Contains("2201850_EOP1-2005_Jan-17"), "this subnominal code is not present 2201850_EOP1-2005_Jan-17");
            Assert.IsTrue(aggregateKeys.Contains("2201850_EOP1-2005_Feb-17"), "this subnominal code is not present 2201850_EOP1-2005_Feb-17");
            Assert.IsTrue(aggregateKeys.Contains("2306850_EOP1-2005_Aug-15"), "this subnominal code is not present 2201850_EOP1-2005_Aug-15");
            Assert.IsTrue(aggregateKeys.Contains("2306850_EOP1-2005_Aug-15"), "this subnominal code is not present 2201850_EOP1-2005_Aug-15");
        }

        private static T GetObjectFromJsonFile<T>(string rootNamespace, string fileName)
        {
            using (var resource = new TestResource(rootNamespace, fileName))
            {
                string jsonText = ReadFromStream(resource.Stream);
                return (T)DeserializeJsonToObject(jsonText, typeof(T));
            }
        }

        private static string ReadFromStream(Stream stream)
        {
            stream.Position = 0;
            using (StreamReader reader = new StreamReader(stream, Encoding.UTF8))
            {
                return reader.ReadToEnd();
            }
        }

        private static object DeserializeJsonToObject(string jsonText, Type messageType)
        {
            var message = Activator.CreateInstance(messageType);
            JsonConvert.PopulateObject(jsonText, message);
            return message;
        }
    }
}
