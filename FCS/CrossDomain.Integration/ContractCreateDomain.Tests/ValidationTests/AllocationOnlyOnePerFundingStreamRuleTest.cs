namespace ContractCreateDomain.Tests.ValidationTests
{ 
    using System.Linq;
    using System.Collections.Generic;
    using System.Xml.Linq;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using UnitTests.Common;

    [TestClass]
    public class AllocationOnlyOnePerFundingStreamRuleTest
    {
        private contractRequestType _contract;
        private AllocationOnlyOnePerFundingStreamRule _rule;

        [TestInitialize]
        public void Setup()
        {
            using (TestResource resource = new TestResource("ContractCreateDomain.Tests", @"Resources.ContractRequest.xml"))
            {
                XDocument testData = XDocument.Load(resource.Stream);
                System.Xml.Serialization.XmlSerializer xmlSerializer = new System.Xml.Serialization.XmlSerializer(typeof(contractRequestType));
                _contract = (contractRequestType)xmlSerializer.Deserialize(testData.Root.CreateReader());
                
                _rule = new AllocationOnlyOnePerFundingStreamRule(isDeliveryOrganisationAllowedToBeSet: false);
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_OneAllocationPerFundingStream()
        {
            Assert.AreEqual<int>(0, _rule.GetFailuresForItem(_contract).Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_InvalidFundingStreamCode()
        {
            _contract.contract.contracts[0].contractAllocations[1].fundingStreamCode = "ASC";
            _contract.contract.contracts[0].contractAllocations[2].fundingStreamCode = "ASC";

            List<string> failures = _rule.GetFailuresForItem(_contract).ToList();
            Assert.AreEqual<int>(2, failures.Count());
            Assert.IsTrue(failures.Contains(_contract.contract.contracts[0].contractAllocations[1].correlationId));
            Assert.IsTrue(failures.Contains(_contract.contract.contracts[0].contractAllocations[2].correlationId));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_MultipleOLASSAllocationsPermitted()
        {
            _contract.contract.contracts[0].contractAllocations[1].fundingStreamCode = "OLASS";
            _contract.contract.contracts[0].contractAllocations[2].fundingStreamCode = "OLASS";

            Assert.AreEqual<int>(0, _rule.GetFailuresForItem(_contract).Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_MultipleAllocationsPermittedForESF()
        {
            _contract.contract.fundingTypeCode = "ESF";
            _contract.contract.contracts[0].fundingTypeCode = "ESF";
            _contract.contract.contracts[0].contractAllocations[1].fundingStreamCode = "ASC";
            _contract.contract.contracts[0].contractAllocations[2].fundingStreamCode = "ASC";

            Assert.AreEqual<int>(0, _rule.GetFailuresForItem(_contract).Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_MultipleAllocationsPermittedForEOP()
        {
            _contract.contract.fundingTypeCode = "EOP";
            _contract.contract.contracts[0].fundingTypeCode = "EOP";
            _contract.contract.contracts[0].contractAllocations[1].fundingStreamCode = "ASC";
            _contract.contract.contracts[0].contractAllocations[2].fundingStreamCode = "ASC";

            Assert.AreEqual<int>(0, _rule.GetFailuresForItem(_contract).Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_MultipleAllocationsPermittedForEOF()
        {
            _contract.contract.fundingTypeCode = "EOF";
            _contract.contract.contracts[0].fundingTypeCode = "EOF";
            _contract.contract.contracts[0].contractAllocations[1].fundingStreamCode = "ASC";
            _contract.contract.contracts[0].contractAllocations[2].fundingStreamCode = "ASC";

            Assert.AreEqual<int>(0, _rule.GetFailuresForItem(_contract).Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_OneAllocationPerFundingStreamPerDeliveryOrg()
        {
            _rule = new AllocationOnlyOnePerFundingStreamRule(isDeliveryOrganisationAllowedToBeSet: true);
            _contract.contract.fundingTypeCode = "1619FUND";
            var firstAllocation = _contract.contract.contracts.First().contractAllocations[0];
            firstAllocation.fundingStreamCode = "1619LR";
            firstAllocation.fundingStreamPeriodCode = "1619LR1718";
            firstAllocation.DeliveryOrganisation = "123";

            var secondAllocation = _contract.contract.contracts.First().contractAllocations[1];
            secondAllocation.fundingStreamCode = "1619LR";
            secondAllocation.fundingStreamPeriodCode = "1619LR1718";
            firstAllocation.DeliveryOrganisation = "456";

            var thirdAllocation = _contract.contract.contracts.First().contractAllocations[1];
            thirdAllocation.fundingStreamCode = "NMF";
            thirdAllocation.fundingStreamPeriodCode = "NMF1718";
            firstAllocation.DeliveryOrganisation = "789";

            Assert.AreEqual<int>(0, _rule.GetFailuresForItem(_contract).Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_TwoAllocationForSameFundingStreamAndDeliveryOrg()
        {
            _rule = new AllocationOnlyOnePerFundingStreamRule(isDeliveryOrganisationAllowedToBeSet: true);
            _contract.contract.fundingTypeCode = "1619FUND";

            var firstAllocation = _contract.contract.contracts.First().contractAllocations[0];
            firstAllocation.fundingStreamCode = "1619LR";
            firstAllocation.fundingStreamPeriodCode = "1619LR1718";
            firstAllocation.DeliveryOrganisation = "123";

            var secondAllocation = _contract.contract.contracts.First().contractAllocations[1];
            secondAllocation.fundingStreamCode = "1619LR";
            secondAllocation.fundingStreamPeriodCode = "1619LR1718";
            secondAllocation.DeliveryOrganisation = "123";

            var thirdAllocation = _contract.contract.contracts.First().contractAllocations[2];
            thirdAllocation.fundingStreamCode = "NMF";
            thirdAllocation.fundingStreamPeriodCode = "NMF1718";
            thirdAllocation.DeliveryOrganisation = "789";

            Assert.AreEqual<int>(2, _rule.GetFailuresForItem(_contract).Count());
        }
    }
}
