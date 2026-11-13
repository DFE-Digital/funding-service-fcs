using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.CorporateContract;
    using UnitTests.Common;

    [TestClass]
    public class CorporateContractValidatorTests
    {

        [TestMethod, TestCategory("UnitTest")]
        public void TestContractValidatorValidateWithEmptyFundingType()
        {
            Contract masterContract = GetMasterContract();
            masterContract.fundingType = null;

            Assert.AreNotEqual("", new CorporateContractValidator().Validate(masterContract));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestContractValidatorValidateWithFundingTypeCodeNull()
        {
            Contract masterContract = GetMasterContract();
            masterContract.fundingType.fundingTypeCode = null;

            Assert.AreNotEqual("", new CorporateContractValidator().Validate(masterContract));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestContractValidatorValidateWithNoContractsList()
        {
            Contract masterContract = GetMasterContract();
            masterContract.contracts = null;

            Assert.AreNotEqual("", new CorporateContractValidator().Validate(masterContract));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestContractValidatorValidateWithEmptyContractsList()
        {
            Contract masterContract = GetMasterContract();
            masterContract.contracts = new List<contractType>();

            Assert.AreNotEqual("", new CorporateContractValidator().Validate(masterContract));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestContractValidatorValidateWithMoreThanOneContract()
        {
            Contract masterContract = GetMasterContract();
            masterContract.contracts.Add(new contractType());

            Assert.AreNotEqual("", new CorporateContractValidator().Validate(masterContract));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestContractValidatorValidateWithNullAllocationsList()
        {
            Contract masterContract = GetMasterContract();
            masterContract.contracts.First().contractAllocations = null;

            Assert.AreNotEqual("", new CorporateContractValidator().Validate(masterContract));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestContractValidatorValidateWithEmptyAllocationsList()
        {
            Contract masterContract = GetMasterContract();
            masterContract.contracts[0].contractAllocations = null;
            Assert.AreNotEqual("", new CorporateContractValidator().Validate(masterContract));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestContractValidatorValidateWithMissingAllocationNumberInOneAllocation()
        {
            Contract masterContract = GetMasterContract();
            masterContract.contracts[0].contractAllocations[0].contractAllocationNumber = null;
            Assert.AreNotEqual("", new CorporateContractValidator().Validate(masterContract));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestContractValidatorValidateWithEmptyAllocationNumberInOneAllocation()
        {
            Contract masterContract = GetMasterContract();
            masterContract.contracts[0].contractAllocations[0].contractAllocationNumber = string.Empty;
            Assert.AreNotEqual("", new CorporateContractValidator().Validate(masterContract));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestContractValidatorValidateWithMissingStartDateInOneAllocation()
        {
            Contract masterContract = GetMasterContract();
            masterContract.contracts[0].contractAllocations[0].startDate = DateTime.MinValue;
            Assert.AreNotEqual("", new CorporateContractValidator().Validate(masterContract));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestContractValidatorValidateWithWithNullAllocationFundingStream()
        {
            Contract masterContract = GetMasterContract();
            masterContract.contracts[0].contractAllocations[0].fundingStream = null;
            Assert.AreNotEqual("", new CorporateContractValidator().Validate(masterContract));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestContractValidatorValidateWithWithNullAllocationFundingStreamCode()
        {
            Contract masterContract = GetMasterContract();
            masterContract.contracts[0].contractAllocations[0].fundingStream.fundingStreamCode = null;
            Assert.AreNotEqual("", new CorporateContractValidator().Validate(masterContract));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestContractValidatorValidateWithWithEmptyAllocationFundingStreamCode()
        {
            Contract masterContract = GetMasterContract();
            masterContract.contracts[0].contractAllocations[0].fundingStream.fundingStreamCode = string.Empty;
            Assert.AreNotEqual("", new CorporateContractValidator().Validate(masterContract));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestContractValidatorValidateWithWithNullDeliverablesList()
        {
            Contract masterContract = GetMasterContract();
            masterContract.contracts[0].contractAllocations[0].contractDeliverables = null;
            Assert.AreNotEqual("", new CorporateContractValidator().Validate(masterContract));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestContractValidatorValidateWithWithEmptyDeliverablesList()
        {
            Contract masterContract = GetMasterContract();
            masterContract.contracts[0].contractAllocations[0].contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>();
            Assert.AreNotEqual("", new CorporateContractValidator().Validate(masterContract));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CorporateContractValidator_ShouldValidateLevyAmendmentCorpContract()
        {
            Contract levyAmendmentCorpContract = GetLevyAmendmentCorpContract();

            Assert.AreEqual(string.Empty, new CorporateContractValidator().Validate(levyAmendmentCorpContract));
        }

        private Contract GetLevyAmendmentCorpContract()
        {
            return TestResource.FromJson<Contract>(
                "SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Resources", "LevyAmendmentCorpContract.json");
        }


        private Contract GetMasterContract()
        {
            Contract masterContract = new Contract()
            {
                fundingType = new fundingType
                {
                    fundingTypeCode = "MAIN"
                },
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 8,
                                                periodType = new periodTypeType
                                                {
                                                    periodTypeCode = periodTypeCodeType.AY
                                                },
                                                plannedValue = 12345,
                                                year = 2015
                                            }
                                        }
                                    }
                                },
                                contractAllocationNumber = "ALC-001",
                                startDate = new DateTime(2015, 08, 01),
                                endDate = new DateTime(2016, 07, 31),
                                fundingStream = new fundingStream
                                {
                                    fundingStreamCode = "16-18 APPS"
                                }
                            }
                        },
                        contractNumber = "APPS-1234",
                        contractVersionNumber = 321,
                        startDate = new DateTime(2015, 08, 01)
                    }
                },
                contractNumber = "MASTER-001"
            };

            return masterContract;
        }
    }
}
