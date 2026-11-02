namespace ContractCreateDomain.Implementation.Tests.Unit
{
    using System;
    using System.Xml.Linq;
    using System.Xml.Serialization;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using UnitTests.Common;

    [TestClass]
    public class ContractNumberMethodsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void GetNumberRequestsTest()
        {
            using (var resource = new TestResource("ContractCreateDomain.Implementation.Tests", @"Resources.NumberRequestTest.xml"))
            {
                var testData = XDocument.Load(resource.Stream);
                var manager = new XrmNumberRequestManager(
                    Mock.Of<INumberPrefixRepository>(),
                    Mock.Of<ISequenceRepository>());
                var requestData = DeserializeXml(testData.Root);
                var result = manager.GetNumberRequests(requestData);

                Assert.IsTrue(result.Count > 0);
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetPopulatedContractRequest()
        {
            using (
                var resource = new TestResource("ContractCreateDomain.Implementation.Tests",
                    @"Resources.NumberRequestTest.xml"))
            {
                var testData = XDocument.Load(resource.Stream);
                var manager = new XrmNumberRequestManager(
                    Mock.Of<INumberPrefixRepository>(),
                    Mock.Of<ISequenceRepository>());
                var requestData = DeserializeXml(testData.Root);
                var numberRequestsData = manager.GetNumberRequests(requestData);
                foreach (var numberRequest in numberRequestsData)
                {
                    numberRequest.ContractNumber = "Test-" + new Random().Next();
                }

                manager.PopulateContractNumbers(requestData, numberRequestsData);

                Assert.IsFalse(string.IsNullOrEmpty(requestData.contract.contractNumber));
                Assert.IsFalse(string.IsNullOrEmpty(requestData.contract.contracts[0].contractNumber));
                Assert.IsFalse(
                    string.IsNullOrEmpty(
                        requestData.contract.contracts[0].contractAllocations[0].contractAllocationNumber));
            }
        }

        private contractRequestType DeserializeXml(XElement contractXmlElement)
        {
            try
            {
                var serialzer = new XmlSerializer(typeof(contractRequestType));
                return (contractRequestType)serialzer.Deserialize(contractXmlElement.CreateReader());
            }
            catch (Exception)
            {
                throw new FormatException("Xml does not serialize");
            }
        }
    }
}