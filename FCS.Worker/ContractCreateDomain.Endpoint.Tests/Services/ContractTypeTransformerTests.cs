namespace ContractCreateDomain.Endpoint.Tests.Services
{
    using AutoMapper;
    using ContractCreateDomain.Endpoint.Services;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;

    [TestClass]
    public class ContractTypeTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractTypeTransformer_TransformContractTypeToContract_ShouldTransform()
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

            var transformer = CreateTransformer();

            var contractType = new contractType
            {
                contractAllocations = new List<contractAllocationsContractAllocation>()
                {
                    new contractAllocationsContractAllocation
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
                                    deliverableCode = 1
                                },
                                contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                {
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        year = 2021
                                    }
                                }
                            }
                        }
                    }
                },
                contractNumber = "some number",
                contractVersionNumber = 2,
                contractSubVersionNumber = 1
            };

            // act
            var transformed = transformer.TransformContractTypeToContract(contractType);
            var orgContractor = transformed.contractAllocations[0].DeliveryOrganisationDetail;

            // assert
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
            Assert.AreEqual(true, transformed.contractAllocations.First().HasBeenAddedOrUpdated, "The HasBeenAddedOrUpdated has not been set");
            Assert.AreEqual(contractType.contractNumber, transformed.contractNumber, "The contract number is not correct");
            Assert.AreEqual(contractType.contractVersionNumber, transformed.contractVersionNumber, "The contractVersionNumber is not correct");
            Assert.AreEqual(contractType.contractSubVersionNumber, transformed.contractSubVersionNumber, "The contractSubVersionNumber is not correct");
            var transformedContractAllocation = transformed.contractAllocations[0];

            Assert.AreEqual(1, transformedContractAllocation.contractDeliverables.Count, "The number of deliverables is not correct");
            Assert.AreEqual(1, transformedContractAllocation.contractDeliverables.First().deliverable.deliverableCode, "The deliverableCode is not correct");
            Assert.AreEqual(2021, transformedContractAllocation.contractDeliverables.First().contractDeliverablePeriods.First().year, "The year of the period is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractTypeTransformer_TransformContractTypeToExtendedContractType_ShouldTransform()
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
            DateTime startDate = DateTime.UtcNow;

            var transformer = CreateTransformer();

            var contractType = new contractType
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
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
                                            deliverableCode = 1
                                        },
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                year = 2021
                                            }
                                        }
                                    }
                                }
                            }
                        },
                        TerminationReason = string.Empty,
                        startDate = startDate
                    }
                }
            };

            // act
            var transformed = transformer.TransformContractTypeToExtendedContractType(contractType);

            // assert
            var childContract = transformed.contracts.First();
            var orgContractor = childContract.contractAllocations[0].DeliveryOrganisationDetail;
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
            Assert.AreEqual(true, childContract.contractAllocations.First().HasBeenAddedOrUpdated, "The HasBeenAddedOrUpdated has not been set");
            Assert.AreEqual(null, childContract.TerminationReason, "The TerminationReason should be null");
            Assert.AreEqual(startDate, childContract.startDate, "The startDate is not right");
            var transformedContractAllocation = childContract.contractAllocations[0];

            Assert.AreEqual(1, transformedContractAllocation.contractDeliverables.Count, "The number of deliverables is not correct");
            Assert.AreEqual(1, transformedContractAllocation.contractDeliverables.First().deliverable.deliverableCode, "The deliverableCode is not correct");
            Assert.AreEqual(2021, transformedContractAllocation.contractDeliverables.First().contractDeliverablePeriods.First().year, "The year of the period is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractTypeTransformer_TransformContractTypeToContract_ShouldTransformWithRightDeliverablesWhenThereAre2LevelsOfHierarchy()
        {
            // 'AEBC1819'
            contractType corpContract = GetCorporateContractFromFile("corporate_contracts_withAEBC1819.json");

            Assert.IsNotNull(corpContract);

            var transformer = CreateTransformer();

            // act
            Contract schemaContract = transformer.TransformContractTypeToContract(corpContract);

            // assert
            schemaContract.contracts.First().contractAllocations.ForEach(schemaAllocation =>
            {
                var corpAllocation = corpContract.contracts.First().contractAllocations.Single(a =>
                    a.contractAllocationNumber == schemaAllocation.contractAllocationNumber);

                var schemaDeliverables = FlattenDeliverables(schemaAllocation.contractDeliverables);

                var corpAllocationDeliverables = corpAllocation.GetAllDeliverables();
                Assert.AreEqual(corpAllocationDeliverables.Count, schemaDeliverables.Count, $"The number of deliverables on allocation: {schemaAllocation.contractAllocationNumber} is incorrect");

                bool areAllTheDeliverableNamesPresent = corpAllocationDeliverables.Select(d => d.deliverable.deliverableName).All(corpDeliverableName =>
                    schemaDeliverables.Select(d => d.deliverable.deliverableName).Contains(corpDeliverableName));

                Assert.IsTrue(areAllTheDeliverableNamesPresent, $"Not all the deliverale names for this allocation: {schemaAllocation.contractAllocationNumber}");
            });

            var schemaAllocationAEC = schemaContract.contracts.First().contractAllocations
                .Single(a => a.contractAllocationNumber == "AEC-529");

            Assert.AreEqual(1, schemaAllocationAEC.contractDeliverables.Count, "There should only be on top level deliverable");
            Assert.AreEqual(1, schemaAllocationAEC.contractDeliverables.First().deliverable.deliverableCode, "The top level deliverable should have a deliverable code of 1");
            Assert.AreEqual(2, schemaAllocationAEC.contractDeliverables.First().contractDeliverables.Count, "There should only be on top level deliverable");
            var deliverable13 = schemaAllocationAEC.contractDeliverables.First().contractDeliverables
                .Single(d => d.deliverable.deliverableCode == 13);

            Assert.AreEqual(0, deliverable13.contractDeliverables.Count, "Deliverable 13 does not have the right number of children");
            var deliverable14 = schemaAllocationAEC.contractDeliverables.First().contractDeliverables
                .Single(d => d.deliverable.deliverableCode == 14);

            Assert.AreEqual(5, deliverable14.contractDeliverables.Count, "Deliverable 14 does not have the right number of children");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractTypeTransformer_TransformContractTypeToExtendedContractType_ShouldTransformWithRightDeliverablesWhenThereAre2LevelsOfHierarchy()
        {
            // 'AEBC1819'
            contractType corpContract = GetCorporateContractFromFile("corporate_contracts_withAEBC1819.json");

            Assert.IsNotNull(corpContract);

            var transformer = CreateTransformer();

            // act
            ExtendedContractType schemaContract = transformer.TransformContractTypeToExtendedContractType(corpContract);

            // assert
            schemaContract.contracts.First().contractAllocations.ForEach(schemaAllocation =>
            {
                var corpAllocation = corpContract.contracts.First().contractAllocations.Single(a =>
                    a.contractAllocationNumber == schemaAllocation.contractAllocationNumber);

                var schemaDeliverables = FlattenDeliverables(schemaAllocation.contractDeliverables);

                var corpAllocationDeliverables = corpAllocation.GetAllDeliverables();
                Assert.AreEqual(corpAllocationDeliverables.Count, schemaDeliverables.Count, $"The number of deliverables on allocation: {schemaAllocation.contractAllocationNumber} is incorrect");

                bool areAllTheDeliverableNamesPresent = corpAllocationDeliverables.Select(d => d.deliverable.deliverableName).All(corpDeliverableName =>
                    schemaDeliverables.Select(d => d.deliverable.deliverableName).Contains(corpDeliverableName));

                Assert.IsTrue(areAllTheDeliverableNamesPresent, $"Not all the deliverale names for this allocation: {schemaAllocation.contractAllocationNumber}");
            });

            var schemaAllocationAEC = schemaContract.contracts.First().contractAllocations
                .Single(a => a.contractAllocationNumber == "AEC-529");

            Assert.AreEqual(1, schemaAllocationAEC.contractDeliverables.Count, "There should only be on top level deliverable");
            Assert.AreEqual(1, schemaAllocationAEC.contractDeliverables.First().deliverable.deliverableCode, "The top level deliverable should have a deliverable code of 1");
            Assert.AreEqual(2, schemaAllocationAEC.contractDeliverables.First().contractDeliverables.Count, "There should only be on top level deliverable");
            var deliverable13 = schemaAllocationAEC.contractDeliverables.First().contractDeliverables
                .Single(d => d.deliverable.deliverableCode == 13);

            Assert.AreEqual(0, deliverable13.contractDeliverables.Count, "Deliverable 13 does not have the right number of children");
            var deliverable14 = schemaAllocationAEC.contractDeliverables.First().contractDeliverables
                .Single(d => d.deliverable.deliverableCode == 14);

            Assert.AreEqual(5, deliverable14.contractDeliverables.Count, "Deliverable 14 does not have the right number of children");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractTypeTransformer_TransformCorpContractToContractRequest_ShouldTransform()
        {
            // arrange
            contractType corpContract = GetCorporateContractFromFile("corporate_contracts_withAEBC1819.json").contracts.Single();
            ContractTypeTransformer transformer = CreateTransformer();

            // act
            var contractRequest = transformer.TransformCorpContractToContractRequest(corpContract);

            // assert
            contractRequest.contractAllocations.Count.Should().Be(corpContract.contractAllocations.Count);
            contractRequest.contractAllocations.ForEach(contractRequestAllocation =>
            {
                var matchingAllocation = corpContract.contractAllocations.Single(ca =>
                    ca.contractAllocationNumber == contractRequestAllocation.contractAllocationNumber);

                contractRequestAllocation.contractDeliverables.Count.Should().Be(matchingAllocation.GetAllDeliverables().Count);
                contractRequestAllocation.contractDeliverables.ForEach(contractRequestDeliverable =>
                {
                    var matchingDeliverable = matchingAllocation.GetAllDeliverables().Single(d =>
                        d.deliverable.deliverableCode == contractRequestDeliverable.deliverable.deliverableCode);

                    contractRequestDeliverable.contractDeliverablePeriods.Count.Should()
                        .Be(matchingDeliverable.contractDeliverablePeriods.Count);
                    contractRequestDeliverable.contractDeliverablePeriods.ForEach(contractRequestDeliverablePeriod =>
                    {
                        var matchingPeriod = matchingDeliverable.contractDeliverablePeriods.Single(dp =>
                            dp.year == contractRequestDeliverablePeriod.year &&
                            dp.period == contractRequestDeliverablePeriod.period);

                        contractRequestDeliverablePeriod.plannedValue.Should().Be(matchingPeriod.plannedValue);
                    });
                });
            });
        }

        private static contractType GetCorporateContractFromFile(string fileName)
        {
            using (var stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"ContractCreateDomain.Endpoint.Tests.Resources.{fileName}"))
            using (var streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<Contract>(streamReader.ReadToEnd());
            }
        }

        public List<SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractDeliverablesTypeContractDeliverable> FlattenDeliverables(
            List<SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractDeliverablesTypeContractDeliverable> hierarchicalDeliverableList,
            List<SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractDeliverablesTypeContractDeliverable> flattenedList = null,
            int? parentDeliverableId = null)
        {
            flattenedList = flattenedList ?? new List<SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractDeliverablesTypeContractDeliverable>();

            foreach (var deliverable in hierarchicalDeliverableList)
            {
                flattenedList.Add(deliverable);

                flattenedList = FlattenDeliverables(deliverable.contractDeliverables, flattenedList, deliverable.deliverable.deliverableCode);
            }

            return flattenedList;
        }    

    
        private static ContractTypeTransformer CreateTransformer()
        {
            var mapperConfig = new MapperConfiguration(cfg =>
            {
                cfg.AddMaps(typeof(ContractTypeTransformer).Assembly);
            },null);

            return new ContractTypeTransformer(
                mapperConfig.CreateMapper());
        }

    }
}