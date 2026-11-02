namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Linq;
    using System.Collections.Generic;    
    using System.Xml.Linq;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using UnitTests.Common; 

    [TestClass]
    public class AllocationValidUopCodeRuleTest
    {
        private contractRequestType _contract;
        private AllocationValidUoPCodeRule _rule;

        [TestInitialize]
        public void Setup()
        {
            using (TestResource resource = new TestResource("ContractCreateDomain.Tests", @"Resources.ContractRequest.xml"))
            {
                XDocument testData = XDocument.Load(resource.Stream);
                System.Xml.Serialization.XmlSerializer xmlSerializer = new System.Xml.Serialization.XmlSerializer(typeof(contractRequestType));
                _contract = (contractRequestType)xmlSerializer.Deserialize(testData.Root.CreateReader());   
            }

            List<UnitOfProcurement> validUops = new List<UnitOfProcurement>
            {
                new UnitOfProcurement("UEM", "OLASS", "OLASS1516"),
                new UnitOfProcurement("UEE", "OLASS", "OLASS1516"),
                new UnitOfProcurement("UGL", "OLASS", "OLASS1516"),
                new UnitOfProcurement("1", "NCS", "NCS-P1516")
            };

            _rule = new AllocationValidUoPCodeRule(validUops);
        }


        [TestMethod, TestCategory("UnitTest")]
        public void AllocationValidUoPCodeRule_GetFailuresForItem_ShouldReturnZeroFailuresWhenUoPCodeIsNull()
        {
            // act
            List<string> failures = _rule.GetFailuresForItem(_contract).ToList();

            // assert
            Assert.AreEqual(0, failures.Count, "Returned unexpected failures.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationValidUoPCodeRule_GetFailuresForItem_ShouldReturnZeroFailuresWhenUoPCodeIsValid()
        {
            // arrange
            _contract.contract.contracts[0].contractAllocations[0].UoPCode = "UEM";
            _contract.contract.contracts[0].contractAllocations[0].fundingStreamPeriodCode = "OLASS1516";

            // act
            List<string> failures = _rule.GetFailuresForItem(_contract).ToList();

            // assert
            Assert.AreEqual(0, failures.Count, "Returned unexpected failures.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationValidUoPCodeRule_GetFailuresForItem_ShouldReturnFailuresWhenUoPCodeIsInvalid()
        {
            // arrange
            _contract.contract.contracts[0].contractAllocations[0].UoPCode = "XXX";

            // act
            List<string> failures = _rule.GetFailuresForItem(_contract).ToList();

            // assert
            Assert.AreEqual(1, failures.Count, "Did not return expected failures.");
            Assert.IsTrue(failures.Contains(_contract.contract.contracts[0].contractAllocations[0].correlationId), "Did not return expected correlationId.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationValidUopCodeRule_GetFailuresForItem_ShouldReturnFailuresWhenUopCodeIsNotValidAgainstFsp()
        {
            // arrange
            _contract.contract.contracts[0].contractAllocations[0].UoPCode = "UEM";
            _contract.contract.contracts[0].contractAllocations[0].fundingStreamPeriodCode = "NCS-P1516";

            // act
            List<string> failures = _rule.GetFailuresForItem(_contract).ToList();

            // assert
            Assert.AreEqual(1, failures.Count, "Did not return expected failures.");
            Assert.IsTrue(failures.Contains(_contract.contract.contracts[0].contractAllocations[0].correlationId), "Did not return expected correlationId.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationValidUoPCodeRule_GetFailuresForItem_ShouldReturnFailuresWhenFspShouldNotHaveUoP()
        {
            // arrange
            _contract.contract.contracts[0].contractAllocations[0].UoPCode = "1";
            _contract.contract.contracts[0].contractAllocations[0].fundingStreamPeriodCode = "NOUOP-1415";

            // act
            List<string> failures = _rule.GetFailuresForItem(_contract).ToList();

            // assert
            Assert.AreEqual(1, failures.Count, "Did not return expected failures.");
            Assert.IsTrue(failures.Contains(_contract.contract.contracts[0].contractAllocations[0].correlationId), "Did not return expected correlationId.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationValidUoPCodeRule_GetFailuresForItem_ShouldReturnFailuresWhenFspShouldHaveUoPAndDoesNot()
        {
            // arrange
            _contract.contract.contracts[0].contractAllocations[0].UoPCode = null;
            _contract.contract.contracts[0].contractAllocations[0].fundingStreamPeriodCode = "NCS-P1516";

            // act
            List<string> failures = _rule.GetFailuresForItem(_contract).ToList();

            // assert
            Assert.AreEqual(1, failures.Count, "Did not return expected failures.");
            Assert.IsTrue(failures.Contains(_contract.contract.contracts[0].contractAllocations[0].correlationId), "Did not return expected correlationId.");
        }
    }
}
