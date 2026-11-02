namespace ContractCreateDomain.Tests.ValidationTests
{
    using System;
    using System.Linq;
    using System.Collections.Generic;
    using System.Xml.Linq;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using UnitTests.Common;

    [TestClass]
    public class AllocationPeriodTypeValidForFundingStreamCodeRuleTest
    {
        private contractRequestType _contract;
        private AllocationPeriodTypeValidForFundingStreamCodeRule _rule;

        [TestInitialize]
        public void Setup()
        {
            using (TestResource resource = new TestResource("ContractCreateDomain.Tests", @"Resources.ContractRequest.xml"))
            {
                XDocument testData = XDocument.Load(resource.Stream);
                System.Xml.Serialization.XmlSerializer xmlSerializer = new System.Xml.Serialization.XmlSerializer(typeof(contractRequestType));
                _contract = (contractRequestType)xmlSerializer.Deserialize(testData.Root.CreateReader());  
            }

            List<FundingConfigurationDataType> validFundingConfig = new List<FundingConfigurationDataType>();
            validFundingConfig.Add(new FundingConfigurationDataType()
            {
                FundingTypeCode = "24+LOANS",
                FundingStreamCode = "24+ ALLF",
                FundingStreamName = "24+ Advanced Learning Loans Facility",
                FundingStreamPeriodCode = "24+ALLF1516",
                Period = "1516",
                FundingPeriodStartDate = new DateTime(2015, 7, 31),
                FundingPeriodEndDate = new DateTime(2016, 7, 30),
                PeriodTypeName = "Academic Year",
                PeriodTypeCode = "AY"
            });
            validFundingConfig.Add(new FundingConfigurationDataType()
            {
                FundingTypeCode = "24+LOANS",
                FundingStreamCode = "24+ ALLBC",
                FundingStreamName = "24+ Advanced Learning Loans Bursary (College)",
                FundingStreamPeriodCode = "24+ALLBC1516",
                Period = "1516",
                FundingPeriodStartDate = new DateTime(2015, 7, 31),
                FundingPeriodEndDate = new DateTime(2016, 7, 30),
                PeriodTypeName = "Academic Year",
                PeriodTypeCode = "AY"
            });
            validFundingConfig.Add(new FundingConfigurationDataType()
            {
                FundingTypeCode = "24+LOANS",
                FundingStreamCode = "24+ ALLB",
                FundingStreamName = "24+ Advanced Learning Loans Bursary",
                FundingStreamPeriodCode = "24+ALLB1516",
                Period = "1516",
                FundingPeriodStartDate = new DateTime(2015, 7, 31),
                FundingPeriodEndDate = new DateTime(2016, 7, 30),
                PeriodTypeName = "Academic Year",
                PeriodTypeCode = "AY"
            });

            _rule = new AllocationPeriodTypeValidForFundingStreamCodeRule(validFundingConfig);
        }


        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_ValidFundingStreamCode()
        {
            Assert.AreEqual<int>(0, _rule.GetFailuresForItem(_contract).Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_InvalidFundingStreamCode()
        {
            _contract.contract.contracts[0].contractAllocations[0].fundingStreamCode = "INVALID";

            Assert.AreEqual<int>(1, _rule.GetFailuresForItem(_contract).Count());
        }
    }
}
