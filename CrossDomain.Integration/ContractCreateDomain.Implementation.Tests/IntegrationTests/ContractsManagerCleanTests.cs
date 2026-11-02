namespace ContractCreateDomain.Implementation.Tests.IntegrationTests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using Endpoint.XrmService.Repositories;
    using Endpoint.XrmService.Services;
    using ExtensionMethods;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Moq;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging.NullObjects;
    using UnitTests.Common;
    using contractType = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType;
    using CrmConnectionFactory = SFA.FCS.Worker.Common.Crm.CrmConnectionFactory;

    [TestClass]
    public class ContractsManagerCleanTests
    {
        private EntityReference _fundingTypeEntityReference;
        private EntityReference _providerEntityReference;

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_ShouldGetMostRecentContractId()
        {
            // arrange
            const string contractNumber = "XX=Test";
            const int versionNumber = 1;
            var contractsManager = CreateContractsManager();

            DeleteContracts(contractNumber);

            // create 3 test contracts allowing time between insertions for CRM to generate their created dates in the expected order
            CreateTestContract(contractNumber, versionNumber);
            System.Threading.Tasks.Task.Delay(TimeSpan.FromSeconds(3)).Wait();
            CreateTestContract(contractNumber, versionNumber);
            System.Threading.Tasks.Task.Delay(TimeSpan.FromSeconds(3)).Wait();
            Guid expectedMostRecentGuid = CreateTestContract(contractNumber, versionNumber);

            // act
            Guid mostRecentGuid = contractsManager.GetMostRecentContractId(contractNumber, versionNumber);

            // assert
            Assert.AreEqual(expectedMostRecentGuid, mostRecentGuid);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_ShouldGetContractForId()
        {
            // arrange
            const string contractNumber = "XX=Test";
            const string masterContractNumber = "MXX=Test";
            const string deliveryOrgUkprn = "14161810";
            const string deliveryOrgLegalName = "Some Org";

            const int versionNumber = 1;
            var contractsManager = CreateContractsManager();

            DeleteContracts(contractNumber);
            DeleteContracts(masterContractNumber);
            DeleteOrg(deliveryOrgUkprn);
            EntityReference deliveryOrgEntityRef = CreateOrg(deliveryOrgUkprn, deliveryOrgLegalName);
            Guid masterContract = CreateTestContract(masterContractNumber, versionNumber);
            Guid contractId = CreateTestContract(contractNumber, versionNumber, new EntityReference(sfa_contract.EntityLogicalName, masterContract), skipValue: true);
            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_ProjectDescription = "project",
                sfa_AgreementNumber = "agreement",
                sfa_Priority = "priority",
                sfa_LearningRatePremium = "learning",
                sfa_LEPcode = "lepcode",
                sfa_LEPName = "lepname",
                sfa_lotreference = "lot",
                sfa_RegionType = "region",
                sfa_SpecificationTitle = "spec",
                sfa_awardreference = "award",
                sfa_ITTReference = "tender_spec_ref",
                sfa_FundingStreamId = GetFundingStreamEntityRef(),
                sfa_FundingStreamPeriodId = GetFundingStreamPeriodEntityRef(),
                sfa_deliveryorganisationukprn = deliveryOrgUkprn,
                sfa_deliveryorganisationprovider = deliveryOrgEntityRef,
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId)
            };

            CreateAllocation(allocation);

            Guid mostRecentGuid = contractsManager.GetMostRecentContractId(contractNumber, versionNumber);

            // act
            contractType retrievedMasterContract = contractsManager.GetContractForId(mostRecentGuid);

            // assert
            Assert.AreEqual(masterContractNumber, retrievedMasterContract.contractNumber, "the master contract number is incorrect");
            Assert.AreEqual(contractNumber, retrievedMasterContract.contracts[0].contractNumber, "the contract number is incorrect");
            Assert.AreEqual(true, retrievedMasterContract.contracts[0].SkipDocumentMerge, "the SkipDocumentMerge field is incorrect");
            Assert.AreEqual(true, retrievedMasterContract.contracts[0].SkipCaseloadAssignment, "the SkipCaseloadAssignment field is incorrect");
            Assert.AreEqual(true, retrievedMasterContract.contracts[0].SkipReviewAndInternalApproval, "the SkipReviewAndInternalApproval field is incorrect");

            // assert the allocation
            Assert.AreEqual(1, retrievedMasterContract.contracts[0].contractAllocations.Count, "The number of allocations returned is incorrect");
            contractAllocation retrievedllocation = retrievedMasterContract.contracts[0].contractAllocations.First();
            Assert.AreEqual(allocation.sfa_ProjectDescription, retrievedllocation.activityDescription, "The activityDescription is not correct on the allocation");
            Assert.AreEqual(allocation.sfa_AgreementNumber, retrievedllocation.agreementNumber, "The agreementNumber is not correct on the allocation");
            Assert.AreEqual(allocation.sfa_Priority, retrievedllocation.investmentPriority, "The investmentPriority is not correct on the allocation");
            Assert.AreEqual(allocation.sfa_LearningRatePremium, retrievedllocation.learningRatePremium, "The learningRatePremium is not correct on the allocation");
            Assert.AreEqual(allocation.sfa_LEPcode, retrievedllocation.LEPCode, "The LEPCode is not correct on the allocation");
            Assert.AreEqual(allocation.sfa_LEPName, retrievedllocation.LEPName, "The LEPName is not correct on the allocation");
            Assert.AreEqual(allocation.sfa_lotreference, retrievedllocation.lotReference, "The lotReference is not correct on the allocation");
            Assert.AreEqual(allocation.sfa_RegionType, retrievedllocation.regionType, "The regionType is not correct on the allocation");
            Assert.AreEqual(allocation.sfa_SpecificationTitle, retrievedllocation.specificationTitle, "The specificationTitle is not correct on the allocation");
            Assert.AreEqual(allocation.sfa_awardreference, retrievedllocation.tenderAwardReference, "The tenderAwardReference is not correct on the allocation");
            Assert.AreEqual(allocation.sfa_ITTReference, retrievedllocation.tenderSpecificationReference, "The tenderSpecificationReference is not correct on the allocation");
            Assert.AreEqual(deliveryOrgUkprn, retrievedllocation.DeliveryOrganisation, "The DeliveryOrganisation is not correct on the allocation");
            Assert.AreEqual(deliveryOrgLegalName, retrievedllocation.DeliveryOrganisationDetail.legalName, "The DeliveryOrganisationDetail.legalName is not correct on the allocation");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_GetContractForId_ShouldGetContractorInfo()
        {
            // arrange
            const string contractNumber = "XX=Test";
            const string masterContractNumber = "MXX=Test";
            const string ukprn = "85312444";
            const string legalName = "Some Org";
            const string companyNumber = "CompanyNumber";
            const string charityNumber = "CharityNumber";
            const string addressLine1 = "addressLine1";
            const string addressLine2 = "addressLine2";
            const string addressLine3 = "addressLine3";
            const string addressLine4 = "addressLine4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";

            const int versionNumber = 1;
            DeleteContracts(contractNumber);
            DeleteContracts(masterContractNumber);
            DeleteOrg(ukprn);

            EntityReference contractOrgEntityRef = CreateOrgWithAddressInfo(ukprn, legalName, companyNumber,
                charityNumber, addressLine1, addressLine2, addressLine3,
                addressLine4, town, county, postcode);

            Guid masterContract = CreateTestContract(masterContractNumber, versionNumber, null, null, null, contractOrgEntityRef, ukprn);

            CreateTestContractWithProvider(contractNumber, ukprn, versionNumber, contractOrgEntityRef, 
            new EntityReference(sfa_contract.EntityLogicalName, masterContract), skipValue: true);

            var contractsManager = CreateContractsManager();

            Guid mostRecentGuid = contractsManager.GetMostRecentContractId(contractNumber, versionNumber);

            // act
            contractType retrievedMasterContract = contractsManager.GetContractForId(mostRecentGuid);

            // assert
            var retrievedContractProvider = retrievedMasterContract.contracts[0].contractor;

            Assert.AreEqual(ukprn, retrievedContractProvider.ukprn.ToString(), "The ukprn is not correct on the contract provider");
            Assert.AreEqual(legalName, retrievedContractProvider.legalName, "The legalName is not correct on the contract provider");

            Assert.AreEqual(companyNumber, retrievedContractProvider.registeredCompanyNumber, "The registeredCompanyNumber is not correct on the contract provider");
            Assert.AreEqual(charityNumber, retrievedContractProvider.CharityNumber, "The CharityNumber is not correct on the contract provider");
            Assert.AreEqual(addressLine1, retrievedContractProvider.addressLine1, "The addressLine1 is not correct on the contract provider");
            Assert.AreEqual(addressLine2, retrievedContractProvider.addressLine2, "The addressLine2 is not correct on the contract provider");
            Assert.AreEqual(addressLine3, retrievedContractProvider.addressLine3, "The addressLine3 is not correct on the contract provider");
            Assert.AreEqual(addressLine4, retrievedContractProvider.addressLine4, "The addressLine4 is not correct on the contract provider");
            Assert.AreEqual(town, retrievedContractProvider.town, "The own is not correct on the contract provider");
            Assert.AreEqual(county, retrievedContractProvider.county, "The county is not correct on the contract provider");
            Assert.AreEqual(postcode, retrievedContractProvider.postcode, "The postcode is not correct on the contract provider");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_GetApprovedContractId_ShouldGetContractIdWhenThereIsAnApprovedVersion()
        {
            // arrange
            const string contractNumber = "XX=ApprovedVersTest";
            var contractsManager = CreateContractsManager();

            DeleteContracts(contractNumber);
            Guid expectedLatestVersionContractId = CreateTestContractSetStatus(contractNumber: contractNumber, version: 1, sfaContractstatus: sfa_contractstatus.Approved);
            CreateTestContractSetStatus(contractNumber: contractNumber, version: 2, sfaContractstatus: sfa_contractstatus.Draft);

            // act
            Guid? latestVersionContractId = contractsManager.GetApprovedContractId(contractNumber);

            // assert
            Assert.AreEqual(expectedLatestVersionContractId, latestVersionContractId);
        }

        [TestMethod, TestCategory("IntegrationTest"), ExpectedException(typeof(InvalidOperationException))]
        public void ContractsManager_GetApprovedContractId_ShouldFailWithInvalidOperationExceptionWhenThereIsNoApprovedVersion()
        {
            // arrange
            const string contractNumber = "XX=ApprovedVersTest";
            var contractsManager = CreateContractsManager();

            DeleteContracts(contractNumber);
            CreateTestContractSetStatus(contractNumber: contractNumber, version: 1, sfaContractstatus: sfa_contractstatus.Draft);
            CreateTestContractSetStatus(contractNumber: contractNumber, version: 2, sfaContractstatus: sfa_contractstatus.Withdrawn);

            // act & assert
            contractsManager.GetApprovedContractId(contractNumber);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_GetLatestVersionContractId_ShouldGetContractIdWhereLatestVersionIsTrue()
        {
            // arrange
            const string contractNumber = "XX=LatestVersionTest";
            var contractsManager = CreateContractsManager();

            DeleteContracts(contractNumber);
            Guid expectedLatestVersionContractId = CreateTestContract(contractNumber: contractNumber, version: 1);
            CreateTestContract(contractNumber: contractNumber, version: 2, parentContract: null, isLatestVersion: false);

            // act
            Guid? latestVersionContractId = contractsManager.GetLatestVersionContractId(contractNumber);

            // assert
            Assert.AreEqual(expectedLatestVersionContractId, latestVersionContractId);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_GetLatestVersionContractId_ShouldReturnNullWhenNoLatestVersionPresent()
        {
            // arrange
            const string contractNumber = "XX=LatestVersionTest";
            var contractsManager = CreateContractsManager();

            DeleteContracts(contractNumber);
            CreateTestContract(contractNumber: contractNumber, version: 1, parentContract: null, isLatestVersion: false);
            CreateTestContract(contractNumber: contractNumber, version: 2, parentContract: null, isLatestVersion: false);

            // act
            Guid? latestVersionContractId = contractsManager.GetLatestVersionContractId(contractNumber);

            // assert
            Assert.IsNull(latestVersionContractId);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_GetCorporateContract_ShouldReturnTerminationData()
        {
            // arrange
            const string contractNumber = "XX=LatestVersionTest";
            const string masterContractNumber = "XX-Master";
            const int versionNumber = 1;
            DateTime terminationDate = DateTime.UtcNow;
            DateTime stopNewStartsDate = terminationDate.AddDays(-1);
            sfa_TerminationReasons terminationReason = sfa_TerminationReasons.NoticefromAgency;
            var contractsManager = CreateContractsManager();

            DeleteContracts(contractNumber);
            DeleteContracts(masterContractNumber);
            Guid masterContractId = CreateTestContract(masterContractNumber, versionNumber);
            Guid contractId = CreateTestContract(contractNumber, versionNumber, new EntityReference(sfa_contract.EntityLogicalName, masterContractId), skipValue: true);
            CreateTestAllocation(new EntityReference(sfa_contract.EntityLogicalName, contractId), terminationDate,
                stopNewStartsDate, sfa_newstartssuspendedreason.Other, "CA");
            sfa_contract contract = new sfa_contract
            {
                Id = contractId,
                sfa_terminationdate = terminationDate,
                sfa_terminationreasonEnum = terminationReason
            };

            sfa_contract masterContract = new sfa_contract
            {
                Id = masterContractId,
                sfa_ContractValue = new Money(0)
            };

            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            organizationService.Update(contract);
            organizationService.Update(masterContract);

            // act
            var contractReturned =
                contractsManager.GetCorporateContract(contractNumber, masterContractNumber, lastApproved: false);

            // assert - contract
            var childContract = contractReturned.contracts.First();
            Assert.AreEqual(terminationReason.ToString(), childContract.TerminationReason, "The termination reason is not correct on the contract");
            Assert.AreEqual(terminationDate.ToString(), childContract.TerminationDate.ToString(), "The termination date is not correct on the contract");

            // assert - allocation
            var allocation = childContract.contractAllocations.First();
            Assert.AreEqual(terminationDate.ToString(), allocation.FundingCessationDate.ToString(), "The FundingCessationDate is not correct on the allocation");
            Assert.AreEqual(stopNewStartsDate.ToString(), allocation.StopNewStartsDate.ToString(), "The stop new starts date is not correct on the allocation");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_GetCorporateContractForSpecificVersion_ShouldReturnNullEndDateIfNotSet()
        {
            // arrange
            const string contractNumber = "NullEndDate";
            const string masterContractNumber = "Master";
            const int versionNumber = 1;
            
            var contractsManager = CreateContractsManager();

            DeleteContracts(contractNumber);
            DeleteContracts(masterContractNumber);
            Guid masterContractId = CreateTestContract(masterContractNumber, versionNumber);
            Guid contractId = CreateTestContract(contractNumber, versionNumber, new EntityReference(sfa_contract.EntityLogicalName, masterContractId), skipValue: true);

            sfa_contract contract = new sfa_contract
            {
                Id = contractId,
                sfa_EndDate = null,
            };

            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            organizationService.Update(contract);

            // act
            var contractReturned =
                contractsManager.GetCorporateContractForSpecificVersion(contractNumber, versionNumber, 0);

            // assert - contract
            var childContract = contractReturned.contracts.First();
            Assert.AreEqual(null, childContract.endDate, "The end date is not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_CreateContract_ShouldCreateContractWithTerminationFields()
        {
            // arrange
            ExtendedContract masterContract = GetContractFromFile();
            string masterContractNumber = masterContract.contractNumber;
            string childContractNumber = masterContract.contracts.First().contractNumber;
            DeleteContracts(childContractNumber);
            DeleteContracts(masterContractNumber);
            DateTime now = DateTime.UtcNow.Date;
            DateTime terminationDate = now;
            DateTime stopNewStartDate = now.AddDays(1).Date;
            sfa_TerminationReasons terminationReason = sfa_TerminationReasons.ProviderChange;

            string correlationId = Guid.NewGuid().ToString();
            var contractsManager = CreateContractsManager();

            masterContract.contracts.ForEach(c =>
            {
                c.TerminationDate = terminationDate;
                c.TerminationReason = terminationReason.ToString();

                c.contractAllocations.ForEach(ca =>
                {
                    ca.FundingCessationDate = terminationDate;
                    ca.StopNewStartsDate = stopNewStartDate;
                });
            });
            var crmConnection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            ContractDeDuplicationService service = new ContractDeDuplicationService(new ContractQueryRepository(crmConnection), new ContractAllocationRepository(crmConnection));

            // act
            contractsManager.CreateContract(masterContract, correlationId, service.InsertAllocationWithoutDuplication, service.GetExistingContractId);;

            // assert
            var contractNumbers = masterContract.contracts.Select(c => c.contractNumber).ToList();

            contractType contractType = contractsManager.GetLatestContract(masterContractNumber, contractNumbers);
            contractType.contracts.ForEach(c =>
                {
                    Assert.AreEqual(terminationDate, c.TerminationDate, $"The termination date is not saved on contract: {c.contractNumber}");
                    Assert.AreEqual(terminationReason.ToString(), c.TerminationReason, $"The TerminationReason is not saved on contract: {c.contractNumber}");
                    Assert.AreEqual(8, c.contractAllocations.Count, "The number of allocations is incorrect");
                    c.contractAllocations.ForEach(ca =>
                    {
                        Assert.AreEqual(terminationDate, ca.TerminationDate, $"The termination date is not saved on allocation: {ca.contractAllocationNumber} on contract: {c.contractNumber} ");
                        Assert.AreEqual(stopNewStartDate, ca.StopNewStartsDate, $"The stopNewStartDate is not saved on allocation: {ca.contractAllocationNumber} on contract: {c.contractNumber} ");
                    });
                });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_CreateContract_ShouldNotCreateWhenContractIsAlreadyThere()
        {
            // arrange
            ExtendedContract masterContract = GetContractFromFile();
            masterContract.contractNumber = "Master for Dup Test";
            string masterContractNumber = masterContract.contractNumber;
            masterContract.contracts.First().contractNumber = "Dup Test";
            string childContractNumber = masterContract.contracts.First().contractNumber;
            DeleteContracts(childContractNumber);
            DeleteContracts(masterContractNumber);
            DateTime now = DateTime.UtcNow.Date;

            string correlationId = Guid.NewGuid().ToString();
            var contractsManager = CreateContractsManager();
            var xrmConnection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            var contractDeDuplicationService = new ContractDeDuplicationService(
                new ContractQueryRepository(xrmConnection), new ContractAllocationRepository(xrmConnection));
            contractsManager.CreateContract(masterContract, correlationId, contractDeDuplicationService.InsertAllocationWithoutDuplication, contractDeDuplicationService.GetExistingContractId);
            
            contractDeDuplicationService = new ContractDeDuplicationService(
                new ContractQueryRepository(xrmConnection), new ContractAllocationRepository(xrmConnection)); ; // I have 'new-ed' up a new one here to simulate a message replay
            // act
            contractsManager.CreateContract(masterContract, correlationId, contractDeDuplicationService.InsertAllocationWithoutDuplication, contractDeDuplicationService.GetExistingContractId);

            // assert
            var numContracts = GetNumberOfContracts(childContractNumber, 1, 1);
            Assert.AreEqual(1, numContracts);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_CreateContract_ShouldNotCreateWhenContractIsAlreadyThereButShouldAddMissingAllocations()
        {
            // arrange
            const string addAllocationNumber = "added";
            ExtendedContract masterContract = GetContractFromFile();
            masterContract.contractNumber = "Master for Dup Test";
            string masterContractNumber = masterContract.contractNumber;
            masterContract.contracts.First().contractNumber = "Dup Test";
            string childContractNumber = masterContract.contracts.First().contractNumber;
            DeleteContracts(childContractNumber);
            DeleteContracts(masterContractNumber);
            DateTime now = DateTime.UtcNow.Date;

            string correlationId = Guid.NewGuid().ToString();
            var contractsManager = CreateContractsManager();
            var xrmConnection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            var contractDeDuplicationService = new ContractDeDuplicationService(
                new ContractQueryRepository(xrmConnection), new ContractAllocationRepository(xrmConnection));
            contractsManager.CreateContract(masterContract, correlationId, contractDeDuplicationService.InsertAllocationWithoutDuplication, contractDeDuplicationService.GetExistingContractId);

            contractDeDuplicationService = new ContractDeDuplicationService(
                new ContractQueryRepository(xrmConnection), new ContractAllocationRepository(xrmConnection)); // I have 'new-ed' up a new one here to simulate a message replay

            var allocation = masterContract.ChildContract().contractAllocations.First().SerializeToXml().DeserializeXml<ExtendedContractAllocation>();

            allocation.contractAllocationNumber = addAllocationNumber;
            masterContract.ChildContract().contractAllocations.Add(allocation);
            // act
            contractsManager.CreateContract(masterContract, correlationId, contractDeDuplicationService.InsertAllocationWithoutDuplication, contractDeDuplicationService.GetExistingContractId);

            // assert
            var numContracts = GetNumberOfContracts(childContractNumber, 1, 1);
            Assert.AreEqual(1, numContracts, "The number of contracts is incorrect");
            var allocations = GetAllocations(childContractNumber, 1, 1);
            Assert.AreEqual(9, allocations.Count, "The number of allocations is incorrect");
            Assert.IsTrue(allocations.Any(a => a.sfa_contractallocationnumber == addAllocationNumber), "we have not added the missing allocation");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_GetContractForId_ShouldRetrieveContractWithTerminationFields()
        {
            // arrange
            const string allocationNumberNewStartSuspended = "CN - New Start";
            DateTime now = DateTime.UtcNow.Date;
            DateTime stopNewStartsDate = now;
            DateTime initialStopNewStartsDate = stopNewStartsDate.AddDays(1);
            sfa_newstartssuspendedreason stopNewStartReason = sfa_newstartssuspendedreason.Other;
            sfa_newstartssuspendedreason initialStopNewStartReason = sfa_newstartssuspendedreason.InadequateFinancialHealth;
            ExtendedContract masterContract = GetContractFromFile();
            string masterContractNumber = masterContract.contractNumber;
            string childContractNumber = masterContract.contracts.First().contractNumber;
            DeleteContracts(childContractNumber);
            DeleteContracts(masterContractNumber);
            
            DateTime terminationDate = now;
            DateTime stopNewStartDate = now.AddDays(1).Date;
            sfa_TerminationReasons terminationReason = sfa_TerminationReasons.ProviderChange;

            string correlationId = Guid.NewGuid().ToString();
            var contractsManager = CreateContractsManager();

            masterContract.contracts.ForEach(c =>
            {
                c.TerminationDate = terminationDate;
                c.TerminationReason = terminationReason.ToString();

                c.contractAllocations.ForEach(ca =>
                {
                    ca.FundingCessationDate = terminationDate;
                    ca.StopNewStartsDate = stopNewStartDate;
                });
            });

            contractsManager.CreateContract(masterContract, correlationId);
            Guid childContractId = contractsManager.GetMostRecentContractId(childContractNumber, 1);
            CreateTestAllocation(new EntityReference(sfa_contract.EntityLogicalName, childContractId), terminationDate,
                terminationDate, sfa_newstartssuspendedreason.InadequateFinancialHealth, allocationNumberNewStartSuspended);
            UpdateStopNewStartFields(childContractId, stopNewStartsDate, initialStopNewStartsDate, stopNewStartReason,
                initialStopNewStartReason, terminationReason);

            // act
            var childContract = contractsManager.GetContractForId(childContractId);

            // assert
            childContract.contracts.ForEach(c =>
            {
                Assert.AreEqual(terminationDate, c.TerminationDate, $"The termination date is not saved on contract: {c.contractNumber}");
                Assert.AreEqual(terminationReason.ToString(), c.TerminationReason, $"The TerminationReason is not saved on contract: {c.contractNumber}");
                Assert.AreEqual(stopNewStartReason.ToString(), c.NewStartsSuspendedReason, $"The NewStartsSuspendedReason is not saved on contract: {c.contractNumber}");
                Assert.IsTrue(stopNewStartsDate.IsDateEqualTo(c.StopNewStartsDate), $"The StopNewStartsDate is not saved on contract: {c.contractNumber}");
                Assert.IsTrue(initialStopNewStartsDate.IsDateEqualTo(c.InflightStopNewStartsDate), $"The InflightStopNewStartsDate is not saved on contract: {c.contractNumber}");
                Assert.IsTrue(stopNewStartsDate.IsDateEqualTo(c.InflightTerminationDate), $"The InflightTerminationDate is not saved on contract: {c.contractNumber}");
                Assert.AreEqual(terminationReason.ToString(), c.InflightTerminationReason, $"The InflightTerminationReason is not saved on contract: {c.contractNumber}");
                c.contractAllocations.Where(ca => ca.contractAllocationNumber != allocationNumberNewStartSuspended).ToList().ForEach(ca =>
                {
                    Assert.AreEqual(terminationDate, ca.TerminationDate, $"The termination date is not saved on allocation: {ca.contractAllocationNumber} on contract: {c.contractNumber} ");
                    Assert.AreEqual(stopNewStartDate, ca.StopNewStartsDate, $"The stopNewStartDate is not saved on allocation: {ca.contractAllocationNumber} on contract: {c.contractNumber} ");
                });
                c.contractAllocations.Where(ca => ca.contractAllocationNumber == allocationNumberNewStartSuspended).ToList().ForEach(ca =>
                {
                    Assert.AreEqual("Inadequate Financial Health", ca.NewStartsSuspendedReason, "The NewStartsSuspendedReason is not correctly set");
                    Assert.AreEqual("Inadequate Financial Health", ca.InflightNewStartsSuspendedReason, "The InflightNewStartsSuspendedReason is not correctly set");
                    Assert.AreEqual(terminationDate, ca.InflightTerminationDate, "The InflightTerminationDate is not correctly set");
                });
            });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_GetCorporateContractForSpecificVersion_ShouldRetrieveAllocationWithModificationFields()
        {
            DateTime stopNewStartDate = DateTime.UtcNow.AddDays(1).Date;
            const string newStartsSuspendedReason = "Inadequate Financial Health";

            // arrange
            ExtendedContract masterContract = GetContractFromFile();
            string masterContractNumber = masterContract.contractNumber;
            string childContractNumber = masterContract.contracts.First().contractNumber;
            int contractVersionNumber = masterContract.contracts.First().contractVersionNumber;
            
            DeleteContracts(childContractNumber);
            DeleteContracts(masterContractNumber);
            
            IContractsManager contractsManager = CreateContractsManager();

            masterContract.contracts.ForEach(c =>
            {
                c.contractAllocations.ForEach(ca =>
                {
                    ca.StopNewStartsDate = stopNewStartDate;
                    ca.NewStartsSuspendedReason = newStartsSuspendedReason;
                });
            });

            contractsManager.CreateContract(masterContract, Guid.NewGuid().ToString());

            // act
            contract childContract = contractsManager.GetCorporateContractForSpecificVersion(childContractNumber, masterContractNumber, contractVersionNumber);

            // assert
            childContract.contracts.ForEach(c =>
            {
                c.contractAllocations.ForEach(ca =>
                {
                    Assert.AreEqual(stopNewStartDate, ca.StopNewStartsDate, "The StopNewStartsDate is incorrect");
                    Assert.AreEqual(newStartsSuspendedReason, ca.NewStartsSuspendedReason, "The NewStartsSuspendedReason is incorrect");
                });
            });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_GetSubStatusOfLastApproved_ShouldReturnSubStatus()
        {
            // arrange
            const string contractNumberApproved = "some test num 2";
            const string contractNumber = "some test num 2";
            const string underTerminationSubStatus = "Under Termination";
            DeleteContracts(contractNumber);
            DeleteContracts(contractNumberApproved);
            CreateContractInCrmWithStatusAndSubStatus(contractNumberApproved, sfa_contractstatus.Approved,
                underTerminationSubStatus, true);
            CreateContractInCrmWithStatusAndSubStatus(contractNumber, sfa_contractstatus.Draft,
                "Awaiting Documentation", false);

            IContractsManager contractsManager = CreateContractsManager();

            // act
            var subStatus = contractsManager.GetSubStatusOfLastApproved(contractNumber);

            // assert            
            Assert.AreEqual(underTerminationSubStatus, subStatus);
        }

        private void CreateContractInCrmWithStatusAndSubStatus(string contractNumber, sfa_contractstatus status, string subStatus, bool isLastApproved)
        {
            IOrganizationService orgService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            sfa_contract newContract = new sfa_contract
            {
                sfa_number = contractNumber,
                sfa_UKPRN = "4321",
                sfa_Version = 1,
                sfa_SubVersion = 0,
                sfa_ProviderName = GetOrgEntityReference()
            };

            Guid contractId = orgService.Create(newContract);

            newContract.Id = contractId;
            newContract.sfa_ContractStatus = new OptionSetValue((int)status);
            newContract.sfa_LastApprovedVersion = isLastApproved;
            newContract.sfa_SubStatus = GetSubStatusEntityReference(subStatus);
            newContract.EntityState = EntityState.Changed;
            orgService.Update(newContract);
        }

        private EntityReference GetSubStatusEntityReference(string subStatus)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return context.sfa_statusSet.First(s => s.sfa_name == subStatus).ToEntityReference();
            }
        }

        private static void UpdateStopNewStartFields(
            Guid contractId,
            DateTime stopNewStartsDate,
            DateTime initialStopNewStartsDate,
            sfa_newstartssuspendedreason stopNewStartReason,
            sfa_newstartssuspendedreason initialStopNewStartReason,
            sfa_TerminationReasons terminationReason)
        {
            sfa_contract crmContract = new sfa_contract
            {
                Id = contractId,
                sfa_defaultstopnewstartsdate = stopNewStartsDate,
                sfa_defaultnewstartssuspendedreason = new OptionSetValue((int) stopNewStartReason),
                sfa_inflightstopnewstartsdate = initialStopNewStartsDate,
                sfa_inflightnewstartssuspendedreason = new OptionSetValue((int) initialStopNewStartReason),
                sfa_inflightterminationdate = stopNewStartsDate,
                sfa_inflightterminationreason = new OptionSetValue((int)terminationReason)
            };

            CrmConnectionFactory.GetRetryOnErrorOrganizationService().Update(crmContract);
        }

        private static ExtendedContract GetContractFromFile()
        {
            ExtendedContract masterContract = TestResource.FromJson<ExtendedContract>("ContractCreateDomain.Implementation.Tests",
                "Resources.ExtendedContractType.json");

            masterContract.contracts.ForEach(c =>
            {
                c.Owner = new CrmEntityOwner
                {
                    OwnerId = GetTeamId("Document Management Team")
                };

                c.ContractAdvisorId = GetUserId("CRM Integration").Value;
            });

            return masterContract;
        }

        private static Guid CreateAllocation(sfa_contractallocation allocation)
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(allocation);
        }

        private static void DeleteContracts(string contractNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (var crmContext = new XrmServiceContext(organizationService))
            {
                var matchingContracts =
                    crmContext.sfa_contractSet.Where(
                        c => c.sfa_number == contractNumber)
                        .Select(c => c.Id);

                matchingContracts.ToList().ForEach(c => organizationService.Delete(sfa_contract.EntityLogicalName, c));
            }
        }

        private static int GetNumberOfContracts(string contractNumber, int version, int subVersion)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (var crmContext = new XrmServiceContext(organizationService))
            {
                return 
                    crmContext.sfa_contractSet.Where(
                            c => c.sfa_number == contractNumber && c.sfa_Version == version && c.sfa_SubVersion == subVersion)
                        .Select(c => c.Id)
                        .ToList()
                        .Count;
            }
        }

        private static IReadOnlyCollection<sfa_contractallocation> GetAllocations(string contractNumber, int version, int subVersion)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (var crmContext = new XrmServiceContext(organizationService))
            {
                return (from c in crmContext.sfa_contractSet
                    join a in crmContext.sfa_contractallocationSet on c.sfa_contractId equals a.sfa_ContractId.Id
                    where c.sfa_number == contractNumber
                          && c.sfa_Version == version
                          && c.sfa_SubVersion == subVersion
                    select a).ToList();
            }
        }

        private static EntityReference GetFundingStreamPeriodEntityRef()
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return crmContext.sfa_fundingstreamperiodSet.First().ToEntityReference();
            }
        }

        private static EntityReference GetFundingStreamEntityRef()
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return crmContext.sfa_fundingstreamSet.First().ToEntityReference();
            }
        }

        private Guid CreateTestContract(
            string contractNumber,
            int version,
            EntityReference parentContract = null,
            bool? isLatestVersion = null,
            bool? skipValue = null,
            EntityReference providerRef = null,
            string ukprn = "1111",
            int subVersion = 0
            )
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = ukprn,
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_LastApprovedVersion = false,
                sfa_FundingType = GetFundingType(),
                sfa_ProviderName = providerRef ?? GetOrgEntityReference(),
                sfa_ParentContractId = parentContract,
                sfa_skipcaseloadassignment = skipValue,
                sfa_skipdocumentmerge = skipValue,
                sfa_skipreviewandinternalapproval = skipValue,
                sfa_SubVersion = subVersion,
                sfa_ContractValue = new Money(0)
            };

            Guid contractId = organizationService.Create(contract);

            if (isLatestVersion.HasValue)
            {
                organizationService.Update(new sfa_contract
                {
                    Id = contractId,
                    sfa_LatestVersion = isLatestVersion
                });
            }

            return contractId;
        }

        private Guid CreateTestContractWithProvider(string contractNumber, string ukprn, int version, EntityReference providerRef,  EntityReference parentContract = null, bool? isLatestVersion = null, bool? skipValue = null)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = ukprn,
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_LastApprovedVersion = false,
                sfa_FundingType = GetFundingType(),
                sfa_ProviderName = providerRef,
                sfa_ParentContractId = parentContract,
                sfa_skipcaseloadassignment = skipValue,
                sfa_skipdocumentmerge = skipValue,
                sfa_skipreviewandinternalapproval = skipValue,
            };

            Guid contractId = organizationService.Create(contract);

            if (isLatestVersion.HasValue)
            {
                organizationService.Update(new sfa_contract
                {
                    Id = contractId,
                    sfa_LatestVersion = isLatestVersion
                });
            }

            return contractId;
        }

        private Guid CreateTestAllocation(
            EntityReference contractEntityReference,
            DateTime terminationDate,
            DateTime stopNewStartsDate,
            sfa_newstartssuspendedreason newstartssuspendedreason,
            string allocationNumber)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_ContractId = contractEntityReference,
                sfa_terminationdate = terminationDate,
                sfa_stopnewstartsdate = stopNewStartsDate,
                sfa_FundingStreamId = GetFundingStreamEntityRef(),
                sfa_FundingStreamPeriodId = GetFundingStreamPeriodEntityRef(),
                sfa_newstartssuspendedreason = new OptionSetValue((int)newstartssuspendedreason),
                sfa_inflightnewstartssuspendedreason = new OptionSetValue((int)newstartssuspendedreason),
                sfa_contractallocationnumber = allocationNumber,
                sfa_inflightterminationdate = terminationDate
            };

            return organizationService.Create(allocation);
        }

        private Guid CreateTestContractSetStatus(string contractNumber, int version, EntityReference parentContract = null, sfa_contractstatus? sfaContractstatus = null)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_LastApprovedVersion = false,
                sfa_FundingType = GetFundingType(),
                sfa_ProviderName = GetOrgEntityReference(),
                sfa_ParentContractId = parentContract
            };

            Guid contractId = organizationService.Create(contract);

            if (sfaContractstatus.HasValue)
            { 
                organizationService.Update(new sfa_contract
                {
                    Id = contractId,
                    sfa_ContractStatus = new OptionSetValue((int) sfaContractstatus)
                });
            }
            return contractId;
        }

        private EntityReference GetFundingType()
        {
            if (_fundingTypeEntityReference == null)
            {
                using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
                {
                    _fundingTypeEntityReference = crmContext.sfa_fundingtypeSet.First().ToEntityReference();
                }
            }

            return _fundingTypeEntityReference;
        }

        private EntityReference GetOrgEntityReference()
        {
            if (_providerEntityReference == null)
            {
                using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
                {
                    _providerEntityReference = crmContext.AccountSet.First().ToEntityReference();
                }
            }

            return _providerEntityReference;
        }

        private static EntityReference CreateOrg(string ukprn, string legalName)
        {
            Account account = new Account
            {
                sfa_UKPRN = ukprn,
                Name = legalName
            };

            Guid accountId = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(account);

            return new EntityReference(Account.EntityLogicalName, accountId);
        }

        private static EntityReference CreateOrgWithAddressInfo(string ukprn, string legalName, 
            string companyNumber, string charityNumber, string addressLine1, string addressLine2, 
            string addressLine3, string addressLine4, string town, string county, string postcode)
        {
            Account account = new Account
            {
                sfa_UKPRN = ukprn,
                Name = legalName,
                sfa_companynumber = companyNumber,
                sfa_charitynumber = charityNumber,
                Address1_Line1 = addressLine1,
                Address1_Line2 = addressLine2,
                Address1_Line3 = addressLine3,
                Address1_Line4 = addressLine4,
                Address1_Town = town,
                Address1_County = county,
                Address1_PostCode = postcode
            };

            Guid accountId = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(account);

            return new EntityReference(Account.EntityLogicalName, accountId);
        }

        private static void DeleteOrg(string ukprn)
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                crmContext.AccountSet.Where(a => a.sfa_UKPRN == ukprn)
                    .Select(a => a.Id)
                    .ToList()
                    .ForEach(id => CrmConnectionFactory.GetRetryOnErrorOrganizationService().Delete(Account.EntityLogicalName, id));
            }
        }

        private static Guid? GetTeamId(string name)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return context.TeamSet.Single(t => t.Name == name).TeamId;
            }
        }

        private static Guid? GetUserId(string fullname)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return context.SystemUserSet.First(u => u.FullName == fullname).SystemUserId;
            }
        }

        private static IContractsManager CreateContractsManager()
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            return new ContractsManager
            {
                LookupManager = new LookupManager
                {
                    BatchCacheManager = new BatchCacheManager(),
                    EnduringCacheManager = new EnduringCacheManager(),
                    OrganizationService = organizationService
                },
                OrganizationService = organizationService,
                XrmOrganisationManager = new XrmOrganisationManager
                {
                    OrgService = organizationService
                },
                XrmWorkflowManager = new XrmWorkflowManager
                {
                    OrganizationService = organizationService
                }
            };
        }
    }
}
