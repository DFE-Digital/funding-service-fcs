namespace CrossDomain.Integration.Common.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.XPath;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;

    [TestClass]
    public class ContractAllocationsContractAllocationTests
    {
        private const string TerminationAllocationAttrsStart = @"<allocationTerminationAttrs";

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationsContractAllocation_ShouldSerializeProcurementAttrsWhenTendSpecReferenceIsSet()
        {
            // arrange
            Contract corporateContract = new Contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "XX",
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                ProcurementAttrs = new ProcurementAttrsCT
                                {
                                    TenderSpecReference = "SOME REF"
                                }
                            }
                        }
                    }
                }
            };

            string xmlCorporateContract = corporateContract.SerializeToXml();

            // act

            Contract rehydratedContract = xmlCorporateContract.DeserializeXml<Contract>();

            // assert
            Assert.IsNotNull(rehydratedContract.contracts.First().contractAllocations.First().ProcurementAttrs.TenderSpecReference);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationsContractAllocation_ShouldSerializeAllocationOrganisationRelationshipsWhenIsSet()
        {
            // arrange
            Contract corporateContract = new Contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "XX",
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                allocationOrganisationRelationships = new allocationOrganisationRelationships
                                {
                                    contractAllocationNumber = "ABC-123",
                                    RelationshipType = allocationOrganisationRelationshipType.DELIVERYORGANISATION,
                                    Organisation = new contractor
                                    {
                                        legalName = "Delivery Org 1",
                                        ukprn = 12345678
                                    }
                                }
                            }
                        }
                    }
                }
            };

            // act
            string xmlCorporateContract = corporateContract.SerializeToXml();

            // assert
            Assert.IsTrue(xmlCorporateContract.Contains("<allocationOrganisationRelationships>"), 
                "Serialized contract did not contain delivery org relationship");

            Assert.IsTrue(xmlCorporateContract.Contains("<contractor>"),
                "Serialized contract did not contain delivery org");

            // act

            Contract rehydratedContract = xmlCorporateContract.DeserializeXml<Contract>();

            // assert
            Assert.IsNotNull(rehydratedContract.contracts.First().contractAllocations.First().allocationOrganisationRelationships.Organisation,
                "Delivery org was null");
            Assert.IsNotNull(rehydratedContract.contracts.First().contractAllocations.First().allocationOrganisationRelationships.Organisation.legalName,
                "Legal name of delivery org was not set");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationsContractAllocation_ShouldSerializeWhenOtherThan1619FundingContractFor1718()
        {
            // arrange
            const int allocationDeliveryOrgUkprn = 12345678;
            const string fundingTypeCode = "ESF";
            const string period = "1718";


            Contract master = new Contract
            {
                fundingType = new fundingType { fundingTypeCode = fundingTypeCode },
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                allocationOrganisationRelationships = new allocationOrganisationRelationships()
                                {
                                    Organisation = new contractor()
                                    {
                                        ukprn = allocationDeliveryOrgUkprn
                                    },
                                    RelationshipType = allocationOrganisationRelationshipType.DELIVERYORGANISATION
                                },
                                fundingStream = new fundingStream
                                {
                                    fundingTypeCode = fundingTypeCode
                                },
                                //period = new Period
                                //{
                                //    period = period
                                //}
                            }
                        }
                    }
                }
            };

            // act
            string xml = master.Serialize();

            // assert
            XDocument document = XDocument.Load(new StringReader(xml));
            XmlNamespaceManager namespaceManager = new XmlNamespaceManager(new NameTable());
            XNamespace nameSpace = "urn:sfa:schemas:contract";
            namespaceManager.AddNamespace("ns", nameSpace.NamespaceName);
            IEnumerable<XElement> orgsForAllocations = document.XPathSelectElements("//ns:contractAllocation//ns:allocationOrganisationRelationships/ns:Organisation", namespaceManager).ToList();

            Assert.AreEqual(1, orgsForAllocations.Count(), "We have more than one delivery org");
            string xmlUkprn = orgsForAllocations.First().Element(nameSpace +  "ukprn").Value;
            Assert.AreEqual(allocationDeliveryOrgUkprn, int.Parse(xmlUkprn), "The value of the ukprn is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationsContractAllocation_ShouldSerializeWhen1619FundingContractFor1718()
        {
            // arrange
            const int allocationDeliveryOrgUkprn = 12345678;
            const string fundingTypeCode = "1619FUND";
            const string period = "1718";


            Contract master = new Contract
            {
                fundingType = new fundingType { fundingTypeCode = fundingTypeCode },
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                allocationOrganisationRelationships = new allocationOrganisationRelationships()
                                {
                                    Organisation = new contractor()
                                    {
                                        ukprn = allocationDeliveryOrgUkprn
                                    },
                                    RelationshipType = allocationOrganisationRelationshipType.DELIVERYORGANISATION
                                },
                                fundingStream = new fundingStream
                                {
                                    fundingTypeCode = fundingTypeCode
                                },
                                //period = new Period
                                //{
                                //    period1 = period
                                //}
                            }
                        }
                    }
                }
            };

            // act
            string xml = master.Serialize();

            // assert
            XDocument document = XDocument.Load(new StringReader(xml));
            XmlNamespaceManager namespaceManager = new XmlNamespaceManager(new NameTable());
            XNamespace nameSpace = "urn:sfa:schemas:contract";
            namespaceManager.AddNamespace("ns", nameSpace.NamespaceName);
            IEnumerable<XElement> orgsForAllocations = document.XPathSelectElements("//ns:contractAllocation//ns:allocationOrganisationRelationships/ns:Organisation", namespaceManager);

            Assert.AreEqual(1, orgsForAllocations.Count(), "We have more than one delivery org");
            string xmlUkprn = orgsForAllocations.First().Element(nameSpace + "ukprn").Value;
            Assert.AreEqual(allocationDeliveryOrgUkprn, int.Parse(xmlUkprn), "The value of the ukprn is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocation_ShouldNotSerializeTerminationAttrsIfNull()
        {
            // arrange
            var contract = new Contract
            {
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        allocationTerminationAttrs = null
                    }
                }
            };

            // act
            string xmlContract = contract.SerializeToXml();

            // assert
            Assert.IsFalse(xmlContract.Contains(TerminationAllocationAttrsStart), "Serialized Contract contained allocationTerminationAttrs");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocation_ShouldNotSerializeTerminationAttrsIfTerminationDateAndStopNewStartsIsNull()
        {
            // arrange
            var contract = new Contract
            {
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        allocationTerminationAttrs = new TerminationAllocationAttrsCT
                        {
                            stopNewStartsFromDate = null
                        }
                    }
                }
            };

            // act
            string xmlContract = contract.SerializeToXml();

            // assert
            Assert.IsFalse(xmlContract.Contains(TerminationAllocationAttrsStart), "Serialized Contract contained allocationTerminationAttrs");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocation_ShouldSerializeTerminationAttrsIfTerminationDateAndStopNewStartsIsSet()
        {
            // arrange
            var contract = new Contract
            {
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        allocationTerminationAttrs = new TerminationAllocationAttrsCT
                        {
                            stopNewStartsFromDate = DateTime.UtcNow
                        }
                    }
                }
            };

            // act
            string xmlContract = contract.SerializeToXml();

            // assert
            Assert.IsTrue(xmlContract.Contains(TerminationAllocationAttrsStart), "Serialized Contract did not contain allocationTerminationAttrs");
        }
    }
}
