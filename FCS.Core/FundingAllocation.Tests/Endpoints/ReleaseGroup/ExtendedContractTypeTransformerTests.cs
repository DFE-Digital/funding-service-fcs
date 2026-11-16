namespace FundingAllocation.Tests.Endpoints.ReleaseGroup
{
    using FundingAllocation.Endpoints.ReleaseGroup;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using System.Collections.Generic;
    using System.Linq;

    [TestClass]
    public class ExtendedContractTypeTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ExtendedContractTypeTransformer_TransformToCorpContract_ShouldTransformExtendedContractToCorpContract()
        {
            // arrange
            var extendedContract = CreateExtendedContract();
            var extendedContractTypeTransformer = new ExtendedContractTypeTransformer();

            // act
            var corpContract = extendedContractTypeTransformer.TransformToCorpContract(extendedContract);

            // assert
            Assert.IsTrue(corpContract.contracts.Count == extendedContract.contracts.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ExtendedContractTypeTransformer_TransformToCorpContract_ShouldTransformOrganisationDetailsInAllocation()
        {
            // arrange
            const string deliveryOrganisationName = "Del Org Name";
            const string legalName = "Legal Name";
            const int ukprn = 12345678;
            const string charityNumber = "Charity-No";
            const string upin = "Upin";
            const string addressLine1 = "addressLine1";
            const string addressLine2 = "addressLine2";
            const string addressLine3 = "addressLine3";
            const string addressLine4 = "addressLine4";
            const string county = "county";
            const int orgAddressIdentifier = 5;
            const string orgIdentifier = "Organisation Identifier";
            const string postCode = "P05T C0D3";
            const string registeredCompanyNumber = "company number";
            const string town = "town";
            const string contractorStatus = "Locked Restructure";
            const int deliverableCode = 2;
            const bool isNew = true;

            ExtendedContractTypeTransformer transformer = new ExtendedContractTypeTransformer();
            ExtendedContractType contract = new ExtendedContractType
            {
                contractAllocations = new List<ExtendedContractAllocation>
                {
                    new ExtendedContractAllocation
                    {
                        DeliveryOrganisation = deliveryOrganisationName,
                        DeliveryOrganisationDetail = new Contractor
                        {
                            ukprn = ukprn,
                            legalName = legalName,
                            CharityNumber = charityNumber,
                            Upin = upin,
                            addressLine1 = addressLine1,
                            addressLine2 = addressLine2,
                            addressLine3 = addressLine3,
                            addressLine4 = addressLine4,
                            county = county,
                            organisationAddressIdentifier = orgAddressIdentifier,
                            organisationIdentifier = orgIdentifier,
                            postcode = postCode,
                            registeredCompanyNumber = registeredCompanyNumber,
                            town = town,
                            Status = contractorStatus
                        },
                        HasBeenAddedOrUpdated = true,
                        contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                        {
                            new contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = deliverableCode
                                }
                            }
                        }
                    }
                },
                IsNewRevisedNewOrUpdateDraft = isNew
            };

            // act
            Contract transformed = transformer.TransformToCorpContract(contract);

            // assert
            var allocation = transformed.contractAllocations[0];
            var orgContractor = allocation.DeliveryOrganisationDetail;

            Assert.AreEqual(deliveryOrganisationName, allocation.DeliveryOrganisation);
            Assert.AreEqual(legalName, orgContractor.legalName);
            Assert.AreEqual(ukprn, orgContractor.ukprn);
            Assert.AreEqual(charityNumber, orgContractor.CharityNumber);
            Assert.AreEqual(upin, orgContractor.Upin);
            Assert.AreEqual(addressLine1, orgContractor.addressLine1);
            Assert.AreEqual(addressLine2, orgContractor.addressLine2);
            Assert.AreEqual(addressLine3, orgContractor.addressLine3);
            Assert.AreEqual(addressLine4, orgContractor.addressLine4);
            Assert.AreEqual(county, orgContractor.county, "The county has not been transformed");
            Assert.AreEqual(orgAddressIdentifier, orgContractor.organisationAddressIdentifier);
            Assert.AreEqual(orgIdentifier, orgContractor.organisationIdentifier);
            Assert.AreEqual(postCode, orgContractor.postcode);
            Assert.AreEqual(registeredCompanyNumber, orgContractor.registeredCompanyNumber);
            Assert.AreEqual(town, orgContractor.town);
            Assert.AreEqual(contractorStatus, orgContractor.Status, "Contractor Status has not been transformed");
            Assert.AreEqual(true, allocation.HasBeenAddedOrUpdated, "The HasBeenAddedOrUpdated has not been set");
            Assert.AreEqual(1, transformed.contractAllocations[0].contractDeliverables.Count, "The number of deliverables is not correct");
            Assert.AreEqual(deliverableCode, transformed.contractAllocations[0].contractDeliverables.Single().deliverable.deliverableCode, "The deliverable code for deliverable 2 is not correct");
            Assert.AreEqual(isNew, transformed.IsNewRevisedNewOrUpdateDraft, "The IsNewRevisedNewOrUpdateDraft is not set");
        }

        private static ExtendedContract CreateExtendedContract()
        {
            ExtendedContract extendedContract = new ExtendedContract
            {
                contracts = new List<ExtendedContractType>()
            };
            List<ExtendedContractAllocation> allocations = new List<ExtendedContractAllocation>
            {
                new ExtendedContractAllocation(),
                new ExtendedContractAllocation(),
                new ExtendedContractAllocation()
            };

            extendedContract.contracts.Add(new ExtendedContractType
            {
                contractType1 = "Some Type",
                contractAllocations = allocations
            });

            return extendedContract;
        }
    }
}