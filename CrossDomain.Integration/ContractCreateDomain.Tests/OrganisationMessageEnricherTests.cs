namespace ContractCreateDomain.Tests
{
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using MoreLinq;

    [TestClass]
    public class OrganisationMessageEnricherTests
    {
        const string Upin = "10";
        const string CompanyNumber = "9876";

        [TestMethod, TestCategory("UnitTest")]
        public void OrganisationMessageEnricher_ShouldAddOrgWithNameToContract()
        {
            contractRequestType contractMessage = CreateContract();
            OrganisationMessageEnricher messageEnricher = new OrganisationMessageEnricher();
            Mock<IOrganisationService> orgServiceMock = new Mock<IOrganisationService>();
            orgServiceMock.Setup(o => o.GetOrganisationForUkprn(contractMessage.contract.contractor.ukprn)).Returns(CreateOrganisationWithNameAndUpin());
            messageEnricher.OrganisationService = orgServiceMock.Object;
            messageEnricher.Enrich(contractMessage);
            Assert.IsTrue(!string.IsNullOrEmpty(contractMessage.contract.contractor.legalName));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrganisationMessageEnricher_ShouldAddOrgWithAddressToContract()
        {
            contractRequestType contractMessage = CreateContract();
            OrganisationMessageEnricher messageEnricher = new OrganisationMessageEnricher();
            Mock<IOrganisationService> orgServiceMock = new Mock<IOrganisationService>();
            organisation organisation = CreateOrganisationWithNameAndUpin();
            AddAddressToOrg(organisation);
            orgServiceMock.Setup(o => o.GetOrganisationForUkprn(contractMessage.contract.contractor.ukprn)).Returns(organisation);
            messageEnricher.OrganisationService = orgServiceMock.Object;
            messageEnricher.Enrich(contractMessage);
            Contractor contractor = contractMessage.contract.contractor;
            organisationAddressesOrganisationAddress orgAddress = organisation.organisationAddresses.First();
            Assert.IsTrue(IsContractorAddressTheSameAsOrgAddress(contractor, orgAddress));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrganisationMessageEnricher_ShouldEnrichContractorWithUpin()
        {
            // arrange
            contractRequestType contractMessage = CreateContract();
            OrganisationMessageEnricher messageEnricher = new OrganisationMessageEnricher();
            Mock<IOrganisationService> orgServiceMock = new Mock<IOrganisationService>();
            organisation organisation = CreateOrganisationWithNameAndUpin();
            AddAddressToOrg(organisation);
            orgServiceMock.Setup(o => o.GetOrganisationForUkprn(contractMessage.contract.contractor.ukprn)).Returns(organisation);
            messageEnricher.OrganisationService = orgServiceMock.Object;

            // act
            messageEnricher.Enrich(contractMessage);

            // assert
            Contractor contractor = contractMessage.contract.contractor;
            
            Assert.AreEqual(Upin, contractor.Upin);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrganisationMessageEnricher_ShouldEnrichContractorWithCompanyAndCharityNumber()
        {
            // arrange
            contractRequestType contractMessage = CreateContract();
            OrganisationMessageEnricher messageEnricher = new OrganisationMessageEnricher();
            Mock<IOrganisationService> orgServiceMock = new Mock<IOrganisationService>();
            organisation organisation = CreateOrganisationWithNameAndUpin();
            const string charityNumber = "CN";
            organisation.organisationIdentifiers.AddRange(new []{new organisationIdentifiersOrganisationIdentifier
            {
                organisationIdentifierType = organisationIdentifierType.COMPANYREGISTRATIONNUMBER,
                organisationIdentifier = CompanyNumber
            },
            new organisationIdentifiersOrganisationIdentifier
            {
                organisationIdentifierType = organisationIdentifierType.CHARITYNUMBER,
                organisationIdentifier = charityNumber
            }});
            AddAddressToOrg(organisation);
            orgServiceMock.Setup(o => o.GetOrganisationForUkprn(contractMessage.contract.contractor.ukprn)).Returns(organisation);
            messageEnricher.OrganisationService = orgServiceMock.Object;

            // act
            messageEnricher.Enrich(contractMessage);

            // assert
            Contractor contractor = contractMessage.contract.contractor;

            Assert.AreEqual(CompanyNumber, contractor.registeredCompanyNumber, "The registeredCompanyNumber is not set");
            Assert.AreEqual(charityNumber, contractor.CharityNumber, "The CharityNumber is not set");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrganisationMessageEnricher_ShouldEnrichContractAndContractAllocationsWhenDeliveryOrgSet()
        {
            // arrange
            const string allocationOrgName = "Alloc Org Name";
            const string contractOrgName = "Contract Org Name";
            const int allocationUkprn = 12344321;
            contractRequestType contractMessage = CreateContract();
            contractMessage.contract.contracts.SelectMany(c => c.contractAllocations).ForEach(a => a.DeliveryOrganisation = allocationUkprn.ToString());
            OrganisationMessageEnricher messageEnricher = new OrganisationMessageEnricher();
            Mock<IOrganisationService> orgServiceMock = new Mock<IOrganisationService>();
            organisation contractOrganisation = CreateOrganisationWithNameAndUpin(contractOrgName);
            const string charityNumber = "CN";
            contractOrganisation.organisationIdentifiers.AddRange(new[]{new organisationIdentifiersOrganisationIdentifier
            {
                organisationIdentifierType = organisationIdentifierType.COMPANYREGISTRATIONNUMBER,
                organisationIdentifier = CompanyNumber
            },
            new organisationIdentifiersOrganisationIdentifier
            {
                organisationIdentifierType = organisationIdentifierType.CHARITYNUMBER,
                organisationIdentifier = charityNumber
            }});

            organisation allocartionOrganisation = CreateOrganisationWithNameAndUpin(allocationOrgName);
            allocartionOrganisation.organisationIdentifiers.AddRange(new[]{new organisationIdentifiersOrganisationIdentifier
            {
                organisationIdentifierType = organisationIdentifierType.COMPANYREGISTRATIONNUMBER,
                organisationIdentifier = CompanyNumber
            },
            new organisationIdentifiersOrganisationIdentifier
            {
                organisationIdentifierType = organisationIdentifierType.CHARITYNUMBER,
                organisationIdentifier = charityNumber
            }});

            AddAddressToOrg(contractOrganisation);
            orgServiceMock.Setup(o => o.GetOrganisationForUkprn(contractMessage.contract.contractor.ukprn)).Returns(contractOrganisation);
            orgServiceMock.Setup(o => o.GetOrganisationForUkprn(allocationUkprn)).Returns(allocartionOrganisation);
            messageEnricher.OrganisationService = orgServiceMock.Object;

            // act
            messageEnricher.Enrich(contractMessage);

            // assert
            Contractor contractOrgDetail = contractMessage.contract.contractor;

            Assert.AreEqual(CompanyNumber, contractOrgDetail.registeredCompanyNumber, "The registeredCompanyNumber is not set");
            Assert.AreEqual(charityNumber, contractOrgDetail.CharityNumber, "The CharityNumber is not set");

            IReadOnlyCollection<contractAllocation> allAllocations =
                contractMessage.contract.contracts.SelectMany(c => c.contractAllocations).ToList();

            allAllocations.ForEach(ca =>
            {
                Assert.AreEqual(allocationOrgName, ca.DeliveryOrganisationDetail.legalName, "The legal name has not been set on the allocation's org");
                Assert.AreEqual(CompanyNumber, ca.DeliveryOrganisationDetail.registeredCompanyNumber,
                    "The registeredCompanyNumber is not set on the allocation's org");
                Assert.AreEqual(charityNumber, ca.DeliveryOrganisationDetail.CharityNumber, "The CharityNumber is not set on the allocation's org");
                Assert.AreEqual(allocationUkprn, ca.DeliveryOrganisationDetail.ukprn, "The ukprn is not set on the allocation's org");
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrganisationMessageEnricher_ShouldCallOrganisationServiceGetOrganisationOnlyWhenUkprnNotInTheCache()
        {
            // Arrange 
            contractRequestType contractMessage = CreateContract();
            contractMessage.contract.contracts[0].contractAllocations.Add(new contractAllocation());
            contractMessage.contract.contracts[0].contractAllocations.Add(new contractAllocation());
            contractMessage.contract.contracts[0].contractAllocations.Add(new contractAllocation());
            contractMessage.contract.contracts[0].contractAllocations.Add(new contractAllocation());

            contractMessage.contract.contracts[0].contractAllocations[0].DeliveryOrganisation = "111111111";
            contractMessage.contract.contracts[0].contractAllocations[1].DeliveryOrganisation = "111111111";
            contractMessage.contract.contracts[0].contractAllocations[2].DeliveryOrganisation = "111111111";
            contractMessage.contract.contracts[0].contractAllocations[3].DeliveryOrganisation = "222222222";
            contractMessage.contract.contracts[0].contractAllocations[4].DeliveryOrganisation = "222222222";
            contractMessage.contract.contracts[0].contractAllocations[5].DeliveryOrganisation = "222222222";

            OrganisationMessageEnricher messageEnricher = new OrganisationMessageEnricher();
            Mock<IOrganisationService> orgServiceMock = new Mock<IOrganisationService>();
            // Test not interested in the content of the returned organisations
            orgServiceMock.Setup(o => o.GetOrganisationForUkprn(It.IsAny<int>())).Returns(CreateOrganisationWithNameAndUpin());
            messageEnricher.OrganisationService = orgServiceMock.Object;

            // Act
            messageEnricher.Enrich(contractMessage);

            // Assert
            orgServiceMock.Verify(c => c.GetOrganisationForUkprn(It.IsAny<int>()), Times.Exactly(3), "GetOrganisationForUkprn was not called 3 times (for ukprns not in OrganisationServiceCache)");
        }

        private bool IsContractorAddressTheSameAsOrgAddress(Contractor contractor,
            organisationAddressesOrganisationAddress orgAddress)
        {
            return contractor.addressLine1 == orgAddress.addressLine1 &&
                   contractor.addressLine2 == orgAddress.addressLine2 &&
                   contractor.addressLine3 == orgAddress.addressLine3 &&
                   contractor.addressLine4 == orgAddress.addressLine4 &&
                   contractor.town == orgAddress.town &&
                   contractor.county == orgAddress.county &&
                   contractor.postcode == orgAddress.postcode;
        }

        private organisation CreateOrganisationWithNameAndUpin(string orgName = "Some Name")
        {
            organisation org = new organisation
            {
                organisationNames = new List<organisationNamesOrganisationName> { new organisationNamesOrganisationName() { organisationName = orgName } },
                organisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier> { new organisationIdentifiersOrganisationIdentifier
                {
                    organisationIdentifierType = organisationIdentifierType.UPIN,
                    organisationIdentifier = Upin
                }}
            };
            
            return org;
        }

        private void AddAddressToOrg(organisation organisation)
        {
            if (organisation.organisationAddresses == null)
            {
                organisation.organisationAddresses = new List<organisationAddressesOrganisationAddress>();
            }

            organisation.organisationAddresses.Add(new organisationAddressesOrganisationAddress
            {
                addressLine1 = "Line 1",
                addressLine2 = "Line 2",
                addressLine3 = "Line 3",
                addressLine4 = "Line 4",
                town = "Some Town",
                county = "County",
                postcode = "AA11 111"
            });

        }

        private contractRequestType CreateContract()
        {
            contractRequestType contractMessage = new contractRequestType
            {
                contract = new contractType
                {
                   contractor = new Contractor(),
                   contracts = new List<contractType>
                   {
                       new contractType
                       {
                           contractAllocations = new List<contractAllocation>
                           {
                               new contractAllocation(),
                               new contractAllocation()
                           }
                       }
                   }
                }
            };

            contractMessage.contract.contractor.ukprn = 10;
            return contractMessage;
        }
    }
}
