namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Unit
{
    using System.Collections.Generic;
    using System.IO;
    using System.Xml.Linq;
    using CrossDomain.Integration.Entities.CorporateContract;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using UnitTests.Common;

    [TestClass]
    public class ContractObjectTests
    {
        const string EsfContractPath = "Resources.ESFContract.xml";
        const string MainContractPath = "Resources.masterContract.xml";

        [TestMethod, TestCategory("UnitTest")]
        public void ContractType_FundingPeriod_ShouldGetAggregateOfPeriodTypeAndPeriod()
        {
            // arrange
            var contract = GetCorpContractXmlString(EsfContractPath);
            var s = new System.Xml.Serialization.XmlSerializer(typeof(Contract));
            var sr = new StringReader(contract);
            var corpContract = (Contract)s.Deserialize(sr);

            // act
            var fundingPeriod = corpContract.contracts[0].GetFundingPeriod();

            // assert
            Assert.AreEqual("ESF1420", fundingPeriod);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractType_FundingPeriod_ShouldGetAggregateOfPeriodTypeAndPeriod_Mainstream()
        {
            // arrange
            var contract = GetCorpContractXmlString(MainContractPath);
            var s = new System.Xml.Serialization.XmlSerializer(typeof(Contract));
            var sr = new StringReader(contract);
            var corpContract = (Contract)s.Deserialize(sr);

            // act
            var fundingPeriod = corpContract.contracts[0].GetFundingPeriod();

            // assert
            Assert.AreEqual("AY1516", fundingPeriod);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractTypePartial_ShouldSerialize()
        {
            // arrange
            Contract approvedContract = new Contract();

            // act
            string serializedContract = JsonConvert.SerializeObject(approvedContract);

            // assert  
            Assert.IsNotNull(serializedContract);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractType_GetDeliveryOrganisationForAllocation_WhenAllocationHasDeliveryOrgDifferentThanOfContract_ShouldReturnDeliveryOrg()
        {
            // arrange
            const int expectedUkprnReturn = 12345678;
            const string allocationNumberWithDeliveryOrg = "Alloc-1";

            Contract contract = new Contract()
            {
                contractor = new Contractor()
                {
                    ukprn = 11223344
                },
                contractAllocations = new List<contractAllocationsContractAllocation>()
                {
                    new ExtendedContractAllocation()
                    {
                        contractAllocationNumber = allocationNumberWithDeliveryOrg,
                        DeliveryOrganisation = "Some org",
                        DeliveryOrganisationDetail = new Contractor()
                        {
                            ukprn = expectedUkprnReturn,
                            legalName = "Some name"
                        }
                    },
                    new ExtendedContractAllocation()
                    {
                        contractAllocationNumber = "Some allocation number",
                        DeliveryOrganisation = "Some org",
                        DeliveryOrganisationDetail = new Contractor()
                        {
                            ukprn = 18742088,
                            legalName = "Some name"
                        }
                    }
                }
            };

            // act
            var returnedOrg = contract.GetOrganisation(allocationNumberWithDeliveryOrg);

            // assert
            Assert.AreEqual(expectedUkprnReturn, returnedOrg.ukprn);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractType_GetDeliveryOrganisationForAllocation_WhenAllocationDoesNotHaveDeliveryOrg_ShouldReturnOrgForContract()
        {
            // arrange
            const int expectedUkprnReturn = 12345678;
            const string expectedLegalName = "New Company Name";
            const string allocationWithNoDeliveryOrganisationDetail = "Alloc-1";

            Contract contract = new Contract()
            {
                contractor = new Contractor()
                {
                    ukprn = expectedUkprnReturn,
                    legalName = expectedLegalName
                },
                contractAllocations = new List<contractAllocationsContractAllocation>()
                {
                    new ExtendedContractAllocation()
                    {
                        contractAllocationNumber = allocationWithNoDeliveryOrganisationDetail,
                        DeliveryOrganisation = null,
                    }, new ExtendedContractAllocation()
                    {
                        contractAllocationNumber = "Alloc-2",
                        DeliveryOrganisation = "Some org-1",
                        DeliveryOrganisationDetail = new Contractor()
                        {
                            ukprn = 16692511,
                            legalName = "Old Company Name"
                        }
                    },
                    new ExtendedContractAllocation()
                    {
                        contractAllocationNumber = "Alloc-3",
                        DeliveryOrganisation = "Some org-2",
                        DeliveryOrganisationDetail = new Contractor()
                        {
                            ukprn = 18742088
                        }
                    }
                }
            };

            // act
            var returnedOrg = contract.GetOrganisation(allocationWithNoDeliveryOrganisationDetail);

            // assert
            Assert.AreEqual(expectedUkprnReturn, returnedOrg.ukprn);
            Assert.AreEqual(expectedLegalName, returnedOrg.legalName);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractType_GetNumberPartOfNumber_ShouldReturnNumber()
        {
            // arrange
            Contract contract = new Contract
            {
                contractNumber = "ESIF-2999"
            };

            // act
            int number =contract.GetNumberPartOfNumber();

            // assert
            Assert.AreEqual(2999, number);
        }

        private string GetCorpContractXmlString(string contractPath)
        {
            using (var resource = new TestResource("SFA.FCT.ContractManagementDomain.Integration.Tests", contractPath))
            {
                var document = XDocument.Load(resource.Stream);

                return document.Root.ToString();
            }
        }
    }
}