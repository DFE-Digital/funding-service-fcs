namespace ContractCreateDomain.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Xml.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using UnitTests.Common;
    using ContractRequest = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class ContractRequestTransformerTest
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractRequestTransformer_ShouldTransformContractRequestToCorpContract()
        {
            const string upin = "1234";
            const string charityNumber = "CN";
            const string deliveryOrgUkprn = "12345";
            const string contractorStatus = "Locked Restructure";

            // arrange
            ContractRequestTransformer transformer = new ContractRequestTransformer();
            ContractRequest.contractRequestType contractRequestType = CreateContractRequestType();
            contractRequestType.contract.contractor.Upin = upin;
            contractRequestType.contract.contractor.CharityNumber = charityNumber;
            contractRequestType.contract.contractor.organisationStatus = contractorStatus;

            var firstChildContract = contractRequestType.contract.contracts.First();
            firstChildContract.contractAllocations[0].DeliveryOrganisation = deliveryOrgUkprn;
            firstChildContract.contractAllocations[0].DeliveryOrganisationDetail = GetDeliveryOrganisationDetail(deliveryOrgUkprn);
            firstChildContract.SkipCaseloadAssignment = true;
            firstChildContract.SkipDocumentMerge = true;
            firstChildContract.SkipReviewAndInternalApproval = true;

            // act
            var contract = transformer.TransformToCorpContractType(contractRequestType);

            // assert
            Assert.IsTrue(contract != null);
            int index = 0;

            Assert.IsTrue(contractRequestType.contract.contracts.Any(), "No contracts found");
            Assert.AreEqual(upin, contract.contractor.Upin, "The upin has not been copied");
            Assert.AreEqual(charityNumber, contract.contractor.CharityNumber, "The CharityNumber has not been copied");
            Assert.AreEqual(contractorStatus, contract.contractor.Status, "The Contractor Status has not been copied");
            foreach (var contractReqContract in contractRequestType.contract.contracts)
            {
                Assert.AreEqual(contractReqContract.startDate, contract.contracts[index].startDate);
                Assert.AreEqual(contractReqContract.SkipCaseloadAssignment, contract.contracts[index].SkipCaseloadAssignment, "The SkipCaseloadAssignment property has not been correctly set");
                Assert.AreEqual(contractReqContract.SkipDocumentMerge, contract.contracts[index].SkipDocumentMerge, "The SkipDocumentMerge property has not been correctly set");
                Assert.AreEqual(contractReqContract.SkipReviewAndInternalApproval, contract.contracts[index].SkipReviewAndInternalApproval, "The SkipReviewAndInternalApproval property has not been correctly set");
                int indexAllocations = 0;
                foreach (var contractAllocation in contract.contracts[index].contractAllocations)
                {
                    Assert.AreEqual(contractReqContract.contractAllocations[indexAllocations].description, contractAllocation.description);
                    Assert.AreEqual(contractReqContract.contractAllocations[indexAllocations].startDate,
                        contractAllocation.startDate);

                    if (!string.IsNullOrWhiteSpace(contractReqContract.contractAllocations[indexAllocations].UoPCode))
                    {
                        Assert.AreEqual(contractReqContract.contractAllocations[indexAllocations].UoPCode, contractAllocation.uopCode);
                    }

                    Assert.AreEqual(contractReqContract.contractAllocations[indexAllocations].tenderSpecificationReference, contractAllocation.tenderSpecificationReference);
                    Assert.AreEqual(contractReqContract.contractAllocations[indexAllocations].tenderAwardReference, contractAllocation.tenderAwardReference);
                    Assert.AreEqual(contractReqContract.contractAllocations[indexAllocations].investmentPriority, contractAllocation.InvestmentPriority);
                    Assert.AreEqual(contractReqContract.contractAllocations[indexAllocations].activityDescription, contractAllocation.ActivityDescription);
                    Assert.AreEqual(contractReqContract.contractAllocations[indexAllocations].agreementNumber, contractAllocation.AgreementNumber);
                    Assert.AreEqual(contractReqContract.contractAllocations[indexAllocations].specificationTitle, contractAllocation.SpecificationTitle);
                    Assert.AreEqual(contractReqContract.contractAllocations[indexAllocations].regionType, contractAllocation.RegionType);
                    Assert.AreEqual(contractReqContract.contractAllocations[indexAllocations].learningRatePremium, contractAllocation.LearningRatePremium);
                    Assert.AreEqual(contractReqContract.contractAllocations[indexAllocations].DeliveryOrganisation, contractAllocation.DeliveryOrganisation);
                    AssertContractorsAreEqual(contractReqContract.contractAllocations[indexAllocations].DeliveryOrganisationDetail, contractAllocation.DeliveryOrganisationDetail);

                    int indexContractDeliverable = 0;
                    foreach (var deliverable in contractAllocation.contractDeliverables)
                    {
                        int indexContractDeliverablePeriod = 0;
                        Assert.AreEqual(contractReqContract.contractAllocations[indexAllocations].contractDeliverables[
                            indexContractDeliverable].deliverableDescription, deliverable.deliverableDescription);

                        Assert.AreEqual(contractReqContract.contractAllocations[indexAllocations].contractDeliverables[
                            indexContractDeliverable].deliverable.deliverableName, deliverable.deliverable.deliverableName);

                        Assert.AreEqual(contractReqContract.contractAllocations[indexAllocations].contractDeliverables[
                            indexContractDeliverable].unitCost, deliverable.unitCost);

                        foreach (var deliverablePeriod in deliverable.contractDeliverablePeriods)
                        {
                            Assert.AreEqual(
                                contractReqContract.contractAllocations[indexAllocations].contractDeliverables[
                                    indexContractDeliverable].contractDeliverablePeriods[indexContractDeliverablePeriod]
                                    .periodType.periodTypeCode.ToString(),
                                deliverablePeriod.periodType.periodTypeCode.ToString());

                            Assert.AreEqual(
                               contractReqContract.contractAllocations[indexAllocations].contractDeliverables[
                                   indexContractDeliverable].contractDeliverablePeriods[indexContractDeliverablePeriod]
                                   .year,
                               deliverablePeriod.year);

                            Assert.AreEqual(
                               contractReqContract.contractAllocations[indexAllocations].contractDeliverables[
                                   indexContractDeliverable].contractDeliverablePeriods[indexContractDeliverablePeriod].unitCost
                                  ,deliverablePeriod.unitCost);

                            Assert.AreEqual(
                               contractReqContract.contractAllocations[indexAllocations].contractDeliverables[
                                   indexContractDeliverable].contractDeliverablePeriods[indexContractDeliverablePeriod].period
                                  , deliverablePeriod.period);


                            indexContractDeliverablePeriod++;
                        }

                        Assert.AreEqual(
                             contractReqContract.contractAllocations[indexAllocations].contractDeliverables[
                                 indexContractDeliverable].deliverable.deliverableCode
                                , deliverable.deliverable.deliverableCode);

                        indexContractDeliverable++;
                    }
                    indexAllocations++;
                }
                index++;
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractRequestTransformer_ShouldTransformExtendedContractToCorpContract()
        {
            // arrange
            ExtendedContract extendedContract = CreateExtendedContract();
            ContractRequestTransformer transformer = new ContractRequestTransformer();

            // act
            Contract corpContract = transformer.TransformToCorpContract(extendedContract);

            // assert
            Assert.IsTrue(corpContract.contracts.Count == extendedContract.contracts.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractRequestTransformer_ShouldTransformAllocationsToContractRequestContract()
        {
            // arrange
            IList<ContractRequest.AllocationValueData> allocationValueDataItems = new List<ContractRequest.AllocationValueData>();
            const int numAllocations = 5;
            const string contractAllocationNumber = "XX";
            for (int i = 0; i < numAllocations; i++)
            {
                allocationValueDataItems.Add(new ContractRequest.AllocationValueData
                {
                    ContractAllocationNumber = contractAllocationNumber,
                    MaximumContractValue = 10,
                    DeliverableCodes = new [] { 1,2,3}
                });
            }
            const string contractNumber = "YYYY";
            const int ukprn = 1235678;
            ContractRequestTransformer transformer = new ContractRequestTransformer();

            // act
            ContractRequest.contractType masterContract = transformer.TransformAllocationsToContractRequestContract(allocationValueDataItems, contractNumber, ukprn);

            // assert
            ContractRequest.contractType subContract = masterContract.contracts[0];
            Assert.IsTrue(subContract.contractAllocations.Count == numAllocations);
            Assert.IsTrue(subContract.contractAllocations.ToList().All(ca => ca.contractAllocationNumber.Equals(contractAllocationNumber)));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractRequestTransformer_ShouldTransformPeriodTypeStringWithSpacingToEnum()
        {
            // arrange
            ContractRequestTransformer transformer = new ContractRequestTransformer();
            ContractRequest.contractRequestType contractRequestType = CreateContractRequestType();
            contractRequestType.contract.contracts
                .ForEach(c => c.contractAllocations
                    .ForEach(a => a.contractDeliverables
                        .ForEach(d => d.contractDeliverablePeriods
                            .ForEach(dp => dp.periodType.periodTypeName = "Academic Year"))));

            // act
            ExtendedContractType transformedContract = transformer.TransformToCorpContractType(contractRequestType);

            // assert
            Assert.IsTrue(transformedContract.contracts
                .All(c => c.contractAllocations
                    .All(a => a.contractDeliverables
                        .All(d => d.contractDeliverablePeriods
                            .All(dp => dp.periodType.periodTypeName == periodTypeNameType.ACADEMICYEAR)))));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractRequestTransformer_ShouldTransformPeriodTypeStringWithHyphensToEnum()
        {
            // arrange
            ContractRequestTransformer transformer = new ContractRequestTransformer();
            ContractRequest.contractRequestType contractRequestType = CreateContractRequestType();
            contractRequestType.contract.contracts
                .ForEach(c => c.contractAllocations
                    .ForEach(a => a.contractDeliverables
                        .ForEach(d => d.contractDeliverablePeriods
                            .ForEach(dp => dp.periodType.periodTypeName = "Non-Levy Apprenticeships"))));

            // act
            ExtendedContractType transformedContract = transformer.TransformToCorpContractType(contractRequestType);

            // assert
            Assert.IsTrue(transformedContract.contracts
                .All(c => c.contractAllocations
                    .All(a => a.contractDeliverables
                        .All(d => d.contractDeliverablePeriods
                            .All(dp => dp.periodType.periodTypeName == periodTypeNameType.NONLEVYAPPRENTICESHIPS)))));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractRequestTransformer_ShouldTransformOrganisationDetailsInAllocation()
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

            ContractRequestTransformer transformer = new ContractRequestTransformer();
            ExtendedContract contract = new ExtendedContract
            {
                contracts = new List<ExtendedContractType>
                {
                    new ExtendedContract
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
                                HasBeenAddedOrUpdated = true
                            }
                        }
                    }
                }
            };

            // act
            Contract transformed = transformer.TransformToCorpContract(contract);
            Contractor orgContractor = transformed.contracts[0].contractAllocations[0].DeliveryOrganisationDetail;

            // assert
            Assert.AreEqual(deliveryOrganisationName, transformed.contracts[0].contractAllocations[0].DeliveryOrganisation);
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
            Assert.AreEqual(true, transformed.contracts.First().contractAllocations.First().HasBeenAddedOrUpdated, "The HasBeenAddedOrUpdated has not been set");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractRequestTransformer_ShouldTransformTerminationDetailsInAllocation()
        {
            var expectedStopNewStartsDate = new DateTime(2020, 08, 01);
            var expectedFundingCessationDate = new DateTime(2020, 09, 01);
            var inflightNewStartsSuspendedReason = "Some reason";
            var inflightStopNewStartsDate = DateTime.Now;
            var newStartsSuspendedReason = "Some other reason";
            var inflightTerminationReason = "Term reason";

            // arrange
            var transformer = new ContractRequestTransformer();

            var contractRequest = new ContractRequest.contractRequestType
            {
                contract = new ContractRequest.contractType
                {
                    contracts = new List<ContractRequest.contractType>
                    {
                        new ContractRequest.contractType
                        {
                            InflightNewStartsSuspendedReason = inflightNewStartsSuspendedReason,
                            InflightStopNewStartsDate = inflightStopNewStartsDate,
                            StopNewStartsDate = expectedStopNewStartsDate,
                            NewStartsSuspendedReason = newStartsSuspendedReason,
                            InflightTerminationDate = inflightStopNewStartsDate,
                            InflightTerminationReason = inflightTerminationReason,
                            contractAllocations = new List<ContractRequest.contractAllocation>
                            {
                                new ContractRequest.contractAllocation
                                {
                                    StopNewStartsDate = expectedStopNewStartsDate,
                                    TerminationDate = expectedFundingCessationDate,
                                    InflightNewStartsSuspendedReason = inflightNewStartsSuspendedReason,
                                    InflightStopNewStartsDate = inflightStopNewStartsDate,
                                    NewStartsSuspendedReason = newStartsSuspendedReason,
                                    InflightTerminationDate = expectedFundingCessationDate
                                }
                            }
                        }
                    }
                }
            };

            // act
            ExtendedContractType transformedContract = transformer.TransformToCorpContractType(contractRequest);

            // assert
            var childContract = transformedContract.contracts[0];
            Assert.AreEqual(expectedStopNewStartsDate, childContract.StopNewStartsDate, "StopNewStartsDate was not transformed correctly");
            Assert.AreEqual(inflightNewStartsSuspendedReason, childContract.InflightNewStartsSuspendedReason, "InflightNewStartsSuspendedReason was not transformed correctly");
            Assert.AreEqual(inflightStopNewStartsDate, childContract.InflightStopNewStartsDate, "InflightStopNewStartsDate was not transformed correctly");
            Assert.AreEqual(newStartsSuspendedReason, childContract.NewStartsSuspendedReason, "NewStartsSuspendedReason was not transformed correctly");
            Assert.AreEqual(inflightStopNewStartsDate, childContract.InflightTerminationDate, "InflightTerminationDate was not transformed correctly");
            Assert.AreEqual(inflightTerminationReason, childContract.InflightTerminationReason, "InflightTerminationReason was not transformed correctly");

            ExtendedContractAllocation transformedAllocation = childContract.contractAllocations[0];
            Assert.AreEqual(expectedStopNewStartsDate, transformedAllocation.StopNewStartsDate, "StopNewStartsDate was not transformed correctly");
            Assert.AreEqual(inflightNewStartsSuspendedReason, transformedAllocation.InflightNewStartsSuspendedReason, "InflightNewStartsSuspendedReason was not transformed correctly");
            Assert.AreEqual(inflightStopNewStartsDate, transformedAllocation.InflightStopNewStartsDate, "InflightStopNewStartsDate was not transformed correctly");
            Assert.AreEqual(newStartsSuspendedReason, transformedAllocation.NewStartsSuspendedReason, "NewStartsSuspendedReason was not transformed correctly");
            Assert.AreEqual(expectedFundingCessationDate, transformedAllocation.InflightTerminationDate, "InflightTerminationDate was not transformed correctly");
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

        private static ContractRequest.contractRequestType CreateContractRequestType()
        {
            using (TestResource resource = new TestResource("ContractCreateDomain.Tests", @"Resources.ContractRequest.xml"))
            {
                XDocument testData = XDocument.Load(resource.Stream);
                System.Xml.Serialization.XmlSerializer xmlSerializer = new System.Xml.Serialization.XmlSerializer(typeof(ContractRequest.contractRequestType));
                return (ContractRequest.contractRequestType)xmlSerializer.Deserialize(testData.Root.CreateReader());
            }
        }

        private ContractRequest.Contractor GetDeliveryOrganisationDetail(string deliveryOrgUkprn)
        {
            return new ContractRequest.Contractor
            {
                ukprn = int.Parse(deliveryOrgUkprn),
                Upin = "DELORG",
                CharityNumber = "CHARITYNUM",
                registeredCompanyNumber = "RegCompanyNum",
                organisationIdentifier = "ORG00001",
                organisationStatus = "Active",
                legalName = "DELIVERY ORG 1"
            };
        }

        private static void AssertContractorsAreEqual(ContractRequest.Contractor expected,Contractor actual)
        {
            if (expected != null)
            {
                Assert.IsNotNull(actual, "Actual delivery org details were null, expected not null");
                Assert.AreEqual(expected.ukprn, actual.ukprn, "Delivery org did not match expected, ukprn was incorrect");
                Assert.AreEqual(expected.Upin, actual.Upin, "Delivery org did not match expected, upin was incorrect");
                Assert.AreEqual(expected.CharityNumber, actual.CharityNumber, "Delivery org did not match expected, charity number was incorrect");
                Assert.AreEqual(expected.registeredCompanyNumber, actual.registeredCompanyNumber, "Delivery org did not match expected, company number was incorrect");
                Assert.AreEqual(expected.organisationIdentifier, actual.organisationIdentifier, "Delivery org did not match expected, organisation identifier was incorrect");
                Assert.AreEqual(expected.legalName, actual.legalName, "Delivery org did not match expected, legal name was incorrect");
            }
            else
            {
                Assert.IsNull(actual, "Expected Delivery Org Details to be null");
            }
        }
    }
}
