namespace ContractCreateDomain.Implementation.Tests.IntegrationTests
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.Schema;
    using System.Xml.Serialization;
    using ExtensionMethods;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Query;
    using MoreLinq;
    using SFA.FCT.Contract.XrmAdapterService.Tests.Utils;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Tests.IntegrationTests;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using UnitTests.Common;
    using ContractRequest = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using CorporateContract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using CorporateSchema = SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using CrmConnectionFactory = SFA.FCS.Worker.Common.Crm.CrmConnectionFactory;

    [TestClass]
    public class ContractsManagerIntegrationTests : IntegrationTestBase
    {
        private readonly List<Entity> _createdProviderEntities = new List<Entity>();
        private const string FundingStreamCode = "16-18 APPS";
        private const string CorpContractSchemaNamespace = "urn:sfa:schemas:contract";
        private const string CorpContractSchemaResourceName = "SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.contract_corporate_schema_v11.08.xsd";
        private Guid _masterContractGuid = Guid.Empty;
        private Guid _masterContractGuid2 = Guid.Empty;

        [TestCleanup]
        public void TestCleanup()
        {
            if (_masterContractGuid != Guid.Empty)
            {
                RemoveMasterAndChildContracts(_masterContractGuid);
            }

            if (_masterContractGuid2 != Guid.Empty)
            {
                RemoveMasterAndChildContracts(_masterContractGuid2);
            }

            RemoveProviders();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_CheckContractExists_ShouldReturnTrueWhenCorrelationIdIsAssociatedWithExistingContract()
        {
            // arrange
            ExtendedContract masterContract = GetExtendedCorpContract();
            DeleteContracts(masterContract);
            string correlationId = Guid.NewGuid().ToString();
            IContractsManager contractsManager = CreateContractsManager();
            _masterContractGuid = contractsManager.CreateContract(masterContract, correlationId);

            // act
            bool doesContractExist = contractsManager.CheckContractExists(correlationId);

            // assert
            Assert.IsTrue(doesContractExist);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_CheckContractExists_ShouldReturnFalseWhenCorrelationIdIsNotAssociatedWithExistingContract()
        {
            // arrange
            string correlationId = Guid.NewGuid().ToString();
            IContractsManager contractsManager = CreateContractsManager();

            // act
            bool doesContractExist = contractsManager.CheckContractExists(correlationId);

            // assert
            Assert.IsFalse(doesContractExist);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_GetLatestContract_ShouldReturnExpectedValues()
        {
            // clean up
            DeleteContractsWithContractNumber("24Loans-1049");
            DeleteContractsWithContractNumber("SFA-6442");

            // arrange
            DateTime terminationDate = DateTime.UtcNow.Date;
            DateTime stopNewStartsDate = DateTime.UtcNow.Date.AddDays(-1).Date;
            const sfa_TerminationReasons terminationReason = sfa_TerminationReasons.ProviderChange;
            const string allocationNumber = "ALLB-665";
            
            DateTime inflightStopNewStartDate = stopNewStartsDate.AddDays(1);
            ExtendedContract masterContract = GetExtendedCorpContract();
            masterContract.contracts.First().contractAllocations.Single(a => a.contractAllocationNumber == "ALLB-665").DeliveryOrganisation = "12345";
            IContractsManager contractsManager = CreateContractsManager();
            _masterContractGuid = contractsManager.CreateContract(masterContract, Guid.NewGuid().ToString());
            UpdateOrganisationUpin(masterContract.contracts.First().contractor.ukprn, "TESTUPIN");
            Guid childContractId = UpdateContractWithTerminationAndStopNewStartsDetails(
                _masterContractGuid,
                terminationDate,
                terminationReason,
                stopNewStartsDate,
                inflightStopNewStartDate,
                sfa_newstartssuspendedreason.Other,
                sfa_newstartssuspendedreason.InadequateOfsted);
            UpdateAllocationWithTerminationDetails(childContractId, allocationNumber, terminationDate,
                stopNewStartsDate);

            // act
            ContractRequest.contractType returnedMasterContract = contractsManager.GetLatestContract(
                masterContract.contractNumber, masterContract.contracts.Select(c => c.contractNumber));

            // assert
            Assert.AreEqual("TESTUPIN", returnedMasterContract.contractor.Upin);
            Assert.AreEqual("TESTUPIN", returnedMasterContract.contracts.First().contractor.Upin);
            Assert.AreEqual(terminationDate, returnedMasterContract.contracts.First().TerminationDate, "The termination date has not been retrieved");
            Assert.AreEqual(terminationReason, (sfa_TerminationReasons)Enum.Parse(typeof(sfa_TerminationReasons), returnedMasterContract.contracts.First().TerminationReason), "The termination reason has not been retrieved");

            var allocation = returnedMasterContract.contracts.First().contractAllocations
                .Single(a => a.contractAllocationNumber == allocationNumber);
            Assert.AreEqual("12345", allocation.DeliveryOrganisation, $"Delivery Org not set on {allocation}");
            Assert.AreEqual(terminationDate, allocation.TerminationDate, $"Termination Date not set on {allocation}");
            Assert.AreEqual(stopNewStartsDate, allocation.StopNewStartsDate, $"StopNewStartsDate not set on {allocation}");

            Assert.IsNull(returnedMasterContract.contracts.First().contractAllocations.Single(a => a.contractAllocationNumber == "ALLC-745").DeliveryOrganisation);
            Assert.IsNull(returnedMasterContract.contracts.First().contractAllocations.Single(a => a.contractAllocationNumber == "ALLF-897").DeliveryOrganisation);
            var childContract = returnedMasterContract.contracts.First();
            Assert.AreEqual(stopNewStartsDate, childContract.StopNewStartsDate, $"StopNewStartsDate not set on contract");
            Assert.AreEqual(inflightStopNewStartDate, childContract.InflightStopNewStartsDate, $"InflightStopNewStartsDate not set on contract");
            Assert.AreEqual("Other", childContract.NewStartsSuspendedReason, $"InflightStopNewStartsDate not set on contract");
            Assert.AreEqual("Inadequate Ofsted", childContract.InflightNewStartsSuspendedReason, $"InflightStopNewStartsDate not set on contract");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_GetLatestContract_ShouldReturnMultipleChildContractsWithinASingleMasterContract()
        {
            // clean up
            DeleteContractsWithContractNumber("24Loans-1050");
            DeleteContractsWithContractNumber("24Loans-1051");
            DeleteContractsWithContractNumber("SFA-6444");

            // arrange first child contract
            IContractsManager contractsManager = CreateContractsManager();
            ExtendedContract masterContract = GetExtendedCorpContract();
            masterContract.contractNumber = "SFA-6444";
            masterContract.contracts.Single().contractNumber = "24Loans-1050";
            _masterContractGuid = contractsManager.CreateContract(masterContract, Guid.NewGuid().ToString());

            // arrange second child contract
            masterContract = GetExtendedCorpContract();
            masterContract.contractNumber = "SFA-6444";
            masterContract.contracts.Single().contractNumber = "24Loans-1051";
            contractsManager.CreateNewAmendedContract(masterContract, Guid.NewGuid().ToString());

            // act
            ContractRequest.contractType returnedMasterContract = contractsManager.GetLatestContract(
                masterContract.contractNumber, new[] { "24Loans-1050", "24Loans-1051" });

            // assert
            Assert.IsNotNull(returnedMasterContract);
            Assert.AreEqual(2, returnedMasterContract.contracts.Count);
            Assert.AreEqual("SFA-6444", returnedMasterContract.contractNumber);
            Assert.IsNotNull(returnedMasterContract.contracts.SingleOrDefault(c => c.contractNumber == "24Loans-1050"));
            Assert.IsNotNull(returnedMasterContract.contracts.SingleOrDefault(c => c.contractNumber == "24Loans-1051"));
            returnedMasterContract.contracts.ForEach(c =>
            {
                Assert.IsNull(c.TerminationReason, $"The termination reason is not null {c.contractNumber}");
            });
            
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_GetLatestContract_ShouldOnlyReturnSpecifiedChildContracts()
        {
            // clean up
            DeleteContractsWithContractNumber("24Loans-1050");
            DeleteContractsWithContractNumber("24Loans-1051");
            DeleteContractsWithContractNumber("SFA-6444");

            // arrange first child contract
            IContractsManager contractsManager = CreateContractsManager();
            ExtendedContract masterContract = GetExtendedCorpContract();
            masterContract.contractNumber = "SFA-6444";
            masterContract.contracts.Single().contractNumber = "24Loans-1050";
            _masterContractGuid = contractsManager.CreateContract(masterContract, Guid.NewGuid().ToString());

            // arrange second child contract
            masterContract = GetExtendedCorpContract();
            masterContract.contractNumber = "SFA-6444";
            masterContract.contracts.Single().contractNumber = "24Loans-1051";
            contractsManager.CreateNewAmendedContract(masterContract, Guid.NewGuid().ToString());

            // act
            ContractRequest.contractType returnedMasterContract = contractsManager.GetLatestContract(masterContract.contractNumber, new[] { "24Loans-1050" });

            // assert
            Assert.IsNotNull(returnedMasterContract);
            Assert.AreEqual(1, returnedMasterContract.contracts.Count);
            Assert.AreEqual("SFA-6444", returnedMasterContract.contractNumber);
            Assert.IsNotNull(returnedMasterContract.contracts.SingleOrDefault(c => c.contractNumber == "24Loans-1050"));
            Assert.IsNull(returnedMasterContract.contracts.SingleOrDefault(c => c.contractNumber == "24Loans-1051"));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_ShouldCreateContractsWithCorrectFieldOnContract()
        {
            /**
             * This was originally written for amendment type but is now used for new fields on the contract that are added post R1
             */
            const string batchId = "XX";
            const string correlationId = "ZZZ";
            const string notificationAmendmentType = "Notification";
            const string amendmentReason = "Test";
            const decimal variation = 10.01m;
            const bool isDocumentationRequired = true;
            const bool skipDocumentMerge = true;

            CorporateContract.ExtendedContract masterContract = GetExtendedCorpContract();

            // Add a valid amendment type to each contract
            masterContract.contracts.ForEach(c =>
            {
                c.amendmentType = notificationAmendmentType;
                c.ValueVariation = variation;
                c.DocumentationRequired = isDocumentationRequired;
                c.SkipDocumentMerge = skipDocumentMerge;
            });

            // add the amendment reaon to the allocations
            masterContract.contracts.ForEach(
                c => c.contractAllocations.ForEach(ca => ca.reasonForAmendment = amendmentReason));

            var contractsManager = CreateContractsManager();
            contractsManager.BatchId = batchId;
            Assert.IsTrue(_masterContractGuid != null);

            // now get the contracts for the master and check that the ammendment types have been added
            IList<Entity> contracts = GetContractsForMaster(_masterContractGuid);
            foreach (var contract in contracts)
            {
                OptionSetValue amendmentType =
                    contract.GetAttributeValue<OptionSetValue>(CrmContractFieldName.AmendmentType);
                bool documentationRequiredCrmValue =
                    contract.GetAttributeValue<bool>(CrmContractFieldName.DocumentRequired);
                bool skipDocMergeCrmValue =
                    contract.GetAttributeValue<bool>(CrmContractFieldName.SkipDocumentMerge);
                decimal crmVariation = contract.GetAttributeValue<decimal>(CrmContractFieldName.Variation);
                
                masterContract.contracts.ForEach(c => c.amendmentType = notificationAmendmentType);
                Assert.IsTrue(amendmentType != null,
                    $"The amendment type: {notificationAmendmentType} on the contract has not gone into CRM");
                Assert.IsTrue(crmVariation == variation,
                    $"The Contract Value: {variation} on the contract has not gone into CRM");
                Assert.AreEqual(isDocumentationRequired, documentationRequiredCrmValue,
                    $"The Documentation Required column has not been set in CRM");
                Assert.AreEqual(skipDocumentMerge, skipDocMergeCrmValue,
                   $"The skip document merge column has not been set in CRM");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_ShouldAddNewAmendedContractsToExistingMaster()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";
            const string masterContractRef = "SFA_MSTR1";
            const string firstChildContractRef = "MAIN_NEW1";
            const string secongChildContractRef = "MAIN_NEW2";

            // arrange
            IEnumerable<Entity> contractEntities = GetContracts(masterContractRef, 1);
            MoreEnumerable.ForEach(contractEntities, e => RemoveMasterAndChildContracts(e.Id));

            CorporateContract.ExtendedContract masterContract = GetExtendedCorpContract();
            masterContract.contractNumber = masterContractRef;
            masterContract.contracts[0].contractNumber = firstChildContractRef;
            var contractsManager = CreateContractsManager();
            contractsManager.BatchId = batchId;
            _masterContractGuid = contractsManager.CreateContract(masterContract, correlationId);
            Assert.IsTrue(_masterContractGuid != null);
            masterContract.contracts[0].contractNumber = secongChildContractRef;

            // act
            contractsManager.CreateNewAmendedContract(masterContract, correlationId);
            
            // assert
            // now get the contracts for the master and check that the ammendment types have been added
            IList<Entity> contracts = GetContractsForMaster(_masterContractGuid);
            Assert.AreEqual(2, contracts.Count(), "The new amendment has not been added to the master");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_ShouldCreateContractsWithCorrectFieldOnContractAllocation()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";
            const string amendmentReason = "Test";
            const string upinToTest = "1234";
            const string deliveryOrganisation = "DELIVERYORG12345";

            CorporateContract.ExtendedContractType masterContract = GetExtendedCorpContract();
            masterContract.contractor.Upin = upinToTest;
            // add the amendment reaon to the allocations
            masterContract.contracts.ForEach(
                c => c.contractAllocations.ForEach(ca =>
                {
                    ca.reasonForAmendment = amendmentReason;
                    ca.DeliveryOrganisation = deliveryOrganisation;
                }));

            var contractsManager = CreateContractsManager();
            contractsManager.BatchId = batchId;
            _masterContractGuid = contractsManager.CreateContract(masterContract, correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            // now get the contracts for the master and check that the ammendment types have been added
            IList<Entity> contracts = GetContractsForMaster(_masterContractGuid);
            foreach (var contract in contracts)
            {

                IList<Entity> allocations = GetAllocationsForContract(contract.Id);
                foreach (var allocation in allocations)
                {
                    Assert.IsTrue(allocation.GetAttributeValue<string>(CrmAllocationFieldName.AmendmentReason).Equals(amendmentReason));
                    Assert.AreEqual(deliveryOrganisation, allocation.GetAttributeValue<string>(CrmAllocationFieldName.DeliveryOrganisationUkprn), "Delivery Organisation not persisted.");
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_ShouldCreateContractWithASubStatusOfUnassigned()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";
            const string primaryKey = "sfa_statusid";
            const int newUkprn = 23323234;
            IList<Guid> statusPrimaryKeys = GetLookupManager()
                    .GetPkColumnValuesForEntity(CrmLookupType.SubStatus, primaryKey, new[] { "Unassigned" });

            Guid unassignedStatusGuid = statusPrimaryKeys.First();
            CorporateContract.ExtendedContractType masterContract = GetExtendedCorpContract();

            // use a ukprn that we don't have in the system so that the contract will not be assigned
            masterContract.contracts.First().contractor.ukprn = newUkprn;
            masterContract.contractor.ukprn = newUkprn;
            masterContract.contracts.First().contractor.Status = "Active";

            var contractsManager = CreateContractsManager();
            contractsManager.BatchId = batchId;
            _masterContractGuid = contractsManager.CreateContract(masterContract, correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            // now get the contracts for the master and check that the ammendment types have been added
            IList<Entity> contracts = GetContractsForMaster(_masterContractGuid);
            foreach (var contract in contracts)
            {
                EntityReference subStatus =
                    contract.GetAttributeValue<EntityReference>(CrmContractFieldName.SubStatus);
                Assert.AreEqual(subStatus.Id, unassignedStatusGuid,
                    "The contract does not have a substatus of Unassigned");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_ShouldCreateContractWithDocumentRequiredSetToFalse()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            CorporateContract.ExtendedContractType masterContract = GetExtendedCorpContract();

            var contractsManager = CreateContractsManager();
            contractsManager.BatchId = batchId;

            //change to funding type with no documentation.
            var fundingType = new CorporateContract.fundingType
            {
                fundingTypeCode = "EOP",
                fundingTypeName = "Employer Ownership Pilot"
            };
            masterContract.fundingType = fundingType;
            masterContract.contracts[0].fundingType = fundingType;
            
            _masterContractGuid = contractsManager.CreateContract(masterContract, correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            // now get the contracts for the master and check that the ammendment types have been added
            IList<Entity> contracts = GetContractsForMaster(_masterContractGuid);
            foreach (var contract in contracts)
            {
                bool documentRequiredValue = contract.GetAttributeValue<bool>(CrmContractFieldName.DocumentRequired);
                Assert.AreEqual(documentRequiredValue, false, $"The contract does not have {CrmContractFieldName.DocumentRequired} set to No");
            }

            //now test documentationRequired for Update
            var updatedContractGuid = Guid.Empty;
            var corpContract = GetCorpContract();
            corpContract.fundingType = fundingType;
            corpContract.contracts[0].fundingType = fundingType;
            updatedContractGuid = contractsManager.UpdateContract(corpContract, $"{correlationId}1");

            Assert.IsTrue(updatedContractGuid != null);

            // now get the contracts for the master and check that the ammendment types have been added
            IList<Entity> contracts1 = GetContractsForMaster(_masterContractGuid);
            foreach (var contract in contracts1)
            {
                bool documentRequiredValue = contract.GetAttributeValue<bool>(CrmContractFieldName.DocumentRequired);
                Assert.AreEqual(documentRequiredValue, false, $"The updated contract does not have {CrmContractFieldName.DocumentRequired} set to No");
                var allocartions = GetAllocationsForContract(contract.Id);
                Assert.AreEqual(3, allocartions.Count, "The number of allocations related to the contract is not correct");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_ShouldCreateContractWithNewFieldsAdded()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            CorporateContract.ExtendedContractType masterContract = GetExtendedCorpContract();

            var contractsManager = CreateContractsManager();
            contractsManager.BatchId = batchId;
            //Add new fields. 
            const string activityDescription = "ExampleActivityDescription";
            const string agreementNumber = "1234567890";
            const string specificationTitle = "ExampleSpecificationTitle";
            const string regionType = "ExampleRegionType";
            const string learningRatePremium = "ExampleLearningRatePremium";
            
            //renamed fields
            const string description = "ExampleDescription";
            const string tenderSpecificationReference = "ExampleTenderSpecificationReference";
            const string tenderAwardReference = "ExampleTenderAwardReference";
            const string priority = "ExamplePriority";
            const decimal unitCost = 98765432.1M;

            //new fields
            masterContract.contracts[0].contractAllocations[0].ActivityDescription = activityDescription;
            masterContract.contracts[0].contractAllocations[0].AgreementNumber = agreementNumber;
            masterContract.contracts[0].contractAllocations[0].SpecificationTitle = specificationTitle;
            masterContract.contracts[0].contractAllocations[0].RegionType = regionType;
            masterContract.contracts[0].contractAllocations[0].LearningRatePremium = learningRatePremium;
            //Renamed fields
            masterContract.contracts[0].description = description;
            masterContract.contracts[0].contractAllocations[0].tenderSpecificationReference = tenderSpecificationReference;
            masterContract.contracts[0].contractAllocations[0].tenderAwardReference = tenderAwardReference;
            masterContract.contracts[0].contractAllocations[0].InvestmentPriority = priority;
            masterContract.contracts[0].contractAllocations[0].contractDeliverables[0].unitCost = unitCost;

            // rename master contact number, contract number and allocations
            masterContract.contractNumber = "SFA-XXX1";
            masterContract.contracts[0].contractNumber = "MAIN-XXX1";
            masterContract.contracts[0].contractAllocations.ForEach(a => a.contractAllocationNumber += a.contractAllocationNumber + "X");
            _masterContractGuid = contractsManager.CreateContract(masterContract, correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            //Check contract values have persisted. 
            IList<Entity> contracts = GetContractsForMaster(_masterContractGuid);
            Assert.AreEqual(contracts[0].GetAttributeValue<string>(CrmContractFieldName.Description), description);

            //Check allocation values have persisted.
            IList<Entity> allocations = GetAllocationsForContract(contracts[0].Id);
            Entity allocationUnderTest = allocations.SingleOrDefault(e => e.GetAttributeValue<string>(CrmAllocationFieldName.AgreementNumber) == agreementNumber);
            Assert.IsNotNull(allocationUnderTest, "Allocation with matching agreementNumber not present");
            Assert.AreEqual(allocationUnderTest.GetAttributeValue<string>(CrmAllocationFieldName.ActivityDescription), activityDescription);
            Assert.AreEqual(allocationUnderTest.GetAttributeValue<string>(CrmAllocationFieldName.SpecificationTitle), specificationTitle);
            Assert.AreEqual(allocationUnderTest.GetAttributeValue<string>(CrmAllocationFieldName.RegionType), regionType);
            Assert.AreEqual(allocationUnderTest.GetAttributeValue<string>(CrmAllocationFieldName.LearningRatePremium), learningRatePremium);
            Assert.AreEqual(allocationUnderTest.GetAttributeValue<string>(CrmAllocationFieldName.TenderSpecificationReference), tenderSpecificationReference);
            Assert.AreEqual(allocationUnderTest.GetAttributeValue<string>(CrmAllocationFieldName.TenderAwardReference), tenderAwardReference);
            Assert.AreEqual(allocationUnderTest.GetAttributeValue<string>(CrmAllocationFieldName.InvestmentPriority), priority);

            //Check deliverable values have persisted.
            IList<Entity> deliverables = GetDeliverablesForAllocation(allocationUnderTest.GetAttributeValue<string>(CrmAllocationFieldName.ContractAllocationNumber));
            Assert.AreEqual(deliverables.First(d => d.Attributes[CrmDeliverableFieldName.DeliverableCode].ToString() == "1").GetAttributeValue<decimal>(CrmDeliverableFieldName.UnitCost), unitCost);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_ShouldCreateContractWithDraftStatusAndAwaitingDocumentSubStatus_And_InitiateDocMergeTaskIsAssignedToDocMgmtTeam()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";
            ILookupManager lookupManager = GetLookupManager();
            int draftContractOptionId = lookupManager.GetOptionsetValue(CrmOptionSetType.Status.GetOptionSetName(), "Draft").Value;

            const string primaryKey = "sfa_statusid";
            const string awaitingDocumentionText = "Awaiting Documentation";
            Guid awaitingDocumentationGuid = lookupManager.GetPkColumnValuesForEntity(CrmLookupType.SubStatus, primaryKey, new[] { awaitingDocumentionText }).Single();

            CorporateContract.ExtendedContractType masterContract = GetExtendedCorpContract();
            masterContract.contracts.First().DocumentationRequired = true;

            var contractsManager = CreateContractsManager();
            contractsManager.BatchId = batchId;
            _masterContractGuid = contractsManager.CreateContract(masterContract, correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            // now get the contracts for the master and check that the ammendment types have been added
            IList<Entity> contracts = GetContractsForMaster(_masterContractGuid);
            foreach (var contract in contracts)
            {
                OptionSetValue statusValue = contract.GetAttributeValue<OptionSetValue>(CrmContractFieldName.ContractStatus);
                Assert.AreEqual(draftContractOptionId, statusValue.Value, "The contract does not have a Draft status");

                EntityReference awaitingDocumentationReference = contract.GetAttributeValue<EntityReference>(CrmContractFieldName.SubStatus);
                Assert.AreEqual(awaitingDocumentationGuid, awaitingDocumentationReference.Id, "The contract does not have a Sub status of {0}", awaitingDocumentionText);

                EntityReference currentTaskReference = contract.GetAttributeValue<EntityReference>(CrmContractFieldName.CurrentTask);
                Assert.IsTrue(IsTaskLinkedToDocumentManagementTeam(currentTaskReference.Id));

                // check that there is a task called 'Initiate Document Merge' assigned to this contract
                Assert.IsTrue(IsTaskAssociatedToContract(contract.Id, "Initiate Document Merge"));
            }
        }
        
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_ShouldGetMaxWithdrawnContractVersion_WhenWithdrawnContractsExistForContractNumber()
        {
            // arrange
            const string batchId = "XX";
            const string correlationId = "ZZZ";
            DeleteContractsWithContractNumber("24Loans-1093");
            DeleteContractsWithContractNumber("SFA-6443");

            var masterContract = GetCorpContractForWithdraw();
            var masterContract2 = GetCorpContractForWithdraw();
            var masterContract3 = GetCorpContractForWithdraw();

            var contractsManager = CreateContractsManager();

            contractsManager.BatchId = batchId;

            //setting up difference master and child contract in each test as keeping them same in parallel execution causes orphaned contracts to be left in CRM
            masterContract.contractNumber = "SFA-6443";
            masterContract.contracts[0].contractNumber = "24Loans-1093";

            #region 'Contract 2'

            var contract2 = masterContract2.contracts[0];

            contract2.contractNumber = "24Loans-1093";
            contract2.contractVersionNumber = 2;
            contract2.contractStatus = new CorporateContract.contractStatusType
            {
                parentStatus = "Withdrawn",
                status = "Withdrawn By Agency"
            };
      

            #endregion

            #region 'Contract 3'

            var contract3 = masterContract3.contracts[0];

            contract3.contractNumber = "24Loans-1093";
            contract3.contractVersionNumber = 3;
            contract3.contractStatus = new CorporateContract.contractStatusType
            {
                parentStatus = "Withdrawn",
                status = "Withdrawn By Agency"
            };

            #endregion

            masterContract.contracts.Add(contract2);
            masterContract.contracts.Add(contract3);

            _masterContractGuid = contractsManager.CreateContract(TransformCorpContractToExtendedCorpContract(masterContract), correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            var currentContract = masterContract.contracts.First();

            var contractsOrderedByVersionDesc = GetContracts(currentContract.contractNumber).OrderByDescending(c => c.sfa_Version).ToList();
            
            UpdateContractStatus(contractsOrderedByVersionDesc[0].Id, sfa_contractstatus.Approved, "Approved");
            UpdateContractStatus(contractsOrderedByVersionDesc[1].Id, sfa_contractstatus.Withdrawn, "Withdrawn By Agency");
            UpdateContractStatus(contractsOrderedByVersionDesc[2].Id, sfa_contractstatus.Withdrawn, "Withdrawn By Agency");

            // act
            var maxWithdrawnVersion = contractsManager.GetMaxWithdrawnContractVersion(currentContract.contractNumber);

            Assert.AreEqual(2, maxWithdrawnVersion);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_ShouldUpdateContractWithDocumentRequiredSetToTrue()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            CorporateContract.ExtendedContractType masterContract = GetExtendedCorpContract();

            DeleteContractsByNumber(masterContract.contracts.Single().contractNumber);
            DeleteContractsByNumber(masterContract.contractNumber);

            var contractsManager = CreateContractsManager();

            var workflowManager = new XrmWorkflowManager
            {
                OrganizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService()
            };

            contractsManager.BatchId = batchId;
            _masterContractGuid = contractsManager.CreateContract(masterContract, correlationId);
            Assert.IsTrue(_masterContractGuid != null);
            ContractRequest.contractType draftContractType = contractsManager.GetLatestContract(
                masterContract.contractNumber, masterContract.contracts.Select(c => c.contractNumber));
            draftContractType.contracts[0].PreviousVersionId = draftContractType.contracts[0].Id;

            ContractRequest.contractRequestType draContractRequestType = new ContractRequest.contractRequestType
            {
                contract = draftContractType
            };
            CorporateContract.ExtendedContractType corporateContract = new ContractRequestTransformer().TransformToCorpContractType(draContractRequestType);
            corporateContract.contracts[0].contractVersionNumber++;
            corporateContract.contracts[0].contractAllocations.ForEach(a => a.contractDeliverables.ForEach(d => d.DisplayOrder = 1));
            corporateContract.contracts[0].contractAllocations.ForEach(a => a.contractDeliverables.ForEach(d => d.contractDeliverablePeriods.ForEach(dp => dp.displayOrder = 1)));
            Guid updatedContractGuid = new Guid();
            try
            {
                updatedContractGuid = contractsManager.UpdateAmendedContract(corporateContract, "SOME STRING");

                // now get the contracts for the master and check that the ammendment types have been added
                IList<Entity> contracts = GetContractForGuid(updatedContractGuid);
                Assert.IsTrue(contracts.Count > 0);
                foreach (var contract in contracts)
                {
                    bool documentRequiredValue = contract.GetAttributeValue<bool>(CrmContractFieldName.DocumentRequired);
                        Assert.AreEqual(documentRequiredValue, true, "The contract does not have {0} set to Yes",
                            CrmContractFieldName.DocumentRequired);

                    List<sfa_contracttransitionhistory> contracttransitionhistories = workflowManager.GetWorkflowHistory(contract.Id);
                    Assert.AreEqual(2, contracttransitionhistories.Count, "The number of work flow histories is not correct");
                    int numAllocations = GetAllocationId(contract.Id);
                    Assert.AreEqual(3, numAllocations, "The number of allocations is not correct");
                }
            }
            finally
            {
                // now remove the contracts and then the master
                RemoveContract(updatedContractGuid);
            }
        }

        private static void DeleteContractsByNumber(string contractNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                context.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.Id)
                    .ToList()
                    .ForEach(id => organizationService.Delete("sfa_contract", id));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_ShouldUpdateContract_TheNewContractShouldHaveAStatusOfDraftAndASubStatusOfAwaitingDocumentation()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            CorporateContract.ExtendedContractType masterContract = GetExtendedCorpContract();

            var testContractNumber = masterContract.contracts.First().contractNumber;
            DeleteContractsWithContractNumber(testContractNumber);

            ILookupManager lookupManager = GetLookupManager();
            int draftContractOptionId = lookupManager.GetOptionsetValue(CrmOptionSetType.Status.GetOptionSetName(), "Draft").Value;

            const string primaryKey = "sfa_statusid";
            const string awaitingDocumentionText = "Awaiting Documentation";
            Guid awaitingDocumentationGuid = lookupManager.GetPkColumnValuesForEntity(CrmLookupType.SubStatus, primaryKey, new[] { awaitingDocumentionText }).Single();

            var contractsManager = CreateContractsManager();
            contractsManager.BatchId = batchId;
            _masterContractGuid = contractsManager.CreateContract(masterContract, correlationId);
            Assert.IsTrue(_masterContractGuid != null);
            ContractRequest.contractType draftContractType = contractsManager.GetLatestContract(
                masterContract.contractNumber, masterContract.contracts.Select(c => c.contractNumber));
            draftContractType.contracts[0].PreviousVersionId = draftContractType.contracts[0].Id;

            ContractRequest.contractRequestType draContractRequestType = new ContractRequest.contractRequestType
            {
                contract = draftContractType
            };
            CorporateContract.ExtendedContractType corporateContract = new ContractRequestTransformer().TransformToCorpContractType(draContractRequestType);
            corporateContract.contracts[0].contractVersionNumber++;
            corporateContract.contracts[0].contractAllocations.ForEach(a => a.contractDeliverables.ForEach(d => d.DisplayOrder = 1));
            corporateContract.contracts[0].contractAllocations.ForEach(a => a.contractDeliverables.ForEach(d => d.contractDeliverablePeriods.ForEach(dp => dp.displayOrder = 1)));
            Guid updatedContractGuid = new Guid();
            try
            {
                updatedContractGuid = contractsManager.UpdateAmendedContract(corporateContract, "SOME STRING");

            // now get the contracts for the master and check that the ammendment types have been added
            IList<Entity> contracts = GetContractForGuid(updatedContractGuid);
            foreach (var contract in contracts)
            {
                    OptionSetValue statusValue =
                        contract.GetAttributeValue<OptionSetValue>(CrmContractFieldName.ContractStatus);
                    Assert.AreEqual(draftContractOptionId, statusValue.Value,
                        "The contract does not have a Draft status");

                    EntityReference awaitingDocumentationReference =
                        contract.GetAttributeValue<EntityReference>(CrmContractFieldName.SubStatus);
                    Assert.AreEqual(awaitingDocumentationGuid, awaitingDocumentationReference.Id,
                        "The contract does not have a Sub status of {0}", awaitingDocumentionText);

                    EntityReference currentTaskReference =
                        contract.GetAttributeValue<EntityReference>(CrmContractFieldName.CurrentTask);
                Assert.IsTrue(IsTaskLinkedToDocumentManagementTeam(currentTaskReference.Id));

                // check that there are no tasks called 'Review Contract' assigned to this contract
                Assert.IsFalse(IsTaskAssociatedToContract(contract.Id, "Review Contract"));
            }
            }
            finally
            {
            // now remove the contracts and then the master
            RemoveContract(updatedContractGuid);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_ShouldCreateAndGetCorporateContractValidTest()
        {
            // Arrange
            const string masterContractNumber = "SFA-6442";
            const string contractNumber = "24Loans-1049";
            const string batchId = "XX";
            const string correlationId = "ZZZ";
            const string amendmentReason = "Test";
            DateTime terminationDate = DateTime.Now;
            sfa_TerminationReasons terminationReason = sfa_TerminationReasons.InadequateOfsted;

            CorporateContract.ExtendedContractType masterContract = GetExtendedCorpContract();
            string ukprnForProviderInCrm = GetUkrpnForProviderAlreadyInTheSystem();

            //// add the amendment reaon to the allocations
            masterContract.contracts.ForEach(c => c.contractAllocations.ForEach(
                ca =>
                {
                    ca.reasonForAmendment = amendmentReason;
                    ca.uopCode = "TESTUOP";
                    ca.DeliveryOrganisation = ukprnForProviderInCrm;
                }));

            var contractsManager = CreateContractsManager();
            contractsManager.BatchId = batchId;
            _masterContractGuid = contractsManager.CreateContract(masterContract, correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            foreach (var contract in GetChildContracts(_masterContractGuid))
            {
                UpdateContractStatusToApproved(contract.Id);
                UpdateTerminationDateAndReason(contract.Id, terminationDate, terminationReason);
            }

            // Act
            CorporateContract.contractType corporateContract = contractsManager.GetCorporateContract(contractNumber, masterContractNumber);

            // Assert
            Assert.IsNotNull(corporateContract, "No Contract Returned. Corporate Contract Object is Null");
            Assert.IsTrue(corporateContract.fundingType != null, "Invalid number of contracts returned");
            Assert.IsTrue(corporateContract.contracts.Count == 1, "Invalid number of contracts returned");
            Assert.IsTrue(corporateContract.contracts[0].period.period1 == masterContract.contracts[0].period.period1, string.Format("Invalid period, should be {0} instead is this {1}", masterContract.contracts[0].period.period1, corporateContract.contracts[0].period.period1));
            Assert.IsTrue(corporateContract.contracts[0].contractAllocations.Count == 3,
                "Invalid number of contract allocations for the child contract");
            var childContract = corporateContract.contracts.First();
            Assert.IsTrue(childContract.TerminationDate.Value.IsDateEqualTo(terminationDate), "The TerminationDate is not correct");
            Assert.AreEqual(terminationReason.ToString(),  childContract.TerminationReason, "The TerminationReason is not correct");

            var firstAlloc = corporateContract.contracts[0].contractAllocations[0];
            Assert.IsTrue(firstAlloc.contractDeliverables.Count == 1,
                "Invalid number of contract deliverables for first allocation for child contract");
            Assert.IsTrue(firstAlloc.period.period1 == masterContract.contracts[0].contractAllocations[0].period.period1,
                "Invalid period on Allocation");
            Assert.IsTrue(firstAlloc.contractDeliverables[0].contractDeliverablePeriods.Count == 12, "There are not 12 periods");

            Assert.IsTrue(firstAlloc.uopCode == "TESTUOP", "UOP Code not set");
            Assert.AreEqual(ukprnForProviderInCrm, firstAlloc.DeliveryOrganisation, "The DeliveryOrganisation is not retrieved for the allocation");
            Assert.IsNotNull(firstAlloc.DeliveryOrganisationDetail, "The DeliveryOrganisationDetail is not retrieved for the allocation");
            Assert.AreEqual(ukprnForProviderInCrm, firstAlloc.DeliveryOrganisationDetail.ukprn.ToString(), "The DeliveryOrganisationDetail.Ukprn is not retrieved for the allocation");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_ShouldCreateAndGetCorporateContractAndValidateAgainstXsd()
        {
            // Arrange
            const string masterContractNumber = "SFA-6442";
            const string contractNumber = "24Loans-1049";
            const string batchId = "XX";
            const string correlationId = "ZZZ";
            const string ukprn = "87654567";

                CorporateContract.ExtendedContractType masterContract = GetExtendedCorpContract();

                masterContract.contractor.ukprn = int.Parse(ukprn);
                masterContract.contractor.organisationIdentifier = "ORG" + ukprn;
                masterContract.contractor.Status = "Active";

                masterContract.contracts.ForEach(c =>
                {
                    c.contractor.ukprn = int.Parse(ukprn);
                    c.contractor.organisationIdentifier = "ORG" + ukprn;
                    c.contractor.Status = "Active";

                    c.amendmentType = "Variation";

                    c.contractAllocations.ForEach(
                        ca =>
                        {
                            ca.reasonForAmendment = "Test";
                            ca.uopCode = "TESTUOP";
                        });
                });

                ContractTransformer contractTransformer = new ContractTransformer();

                var contractsManager = CreateContractsManager();
                contractsManager.BatchId = batchId;

            _masterContractGuid = contractsManager.CreateContract(masterContract, correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            foreach (var contract in GetChildContracts(_masterContractGuid))
                {
                    UpdateContractStatusToApproved(contract.Id);
                }

                // Act
                CorporateContract.Contract corporateContract = contractsManager.GetCorporateContract(contractNumber, masterContractNumber);

                var corpSchemeContract = contractTransformer.TransformToCorporateSchemaContract(corporateContract);

                //Assert
                ValidateCorpContractAgainstXsd(corpSchemeContract);

                // Assert
                Assert.IsNotNull(corpSchemeContract, "No Contract Returned. Corporate Contract Object is Null");
                Assert.IsTrue(corpSchemeContract.fundingType != null, "Invalid number of contracts returned");
                Assert.IsTrue(corpSchemeContract.contracts.Count == 1, "Invalid number of contracts returned");

                var firstContract = corpSchemeContract.contracts[0];

            var firstContractStartDate = firstContract.startDate.GetValueOrDefault();

                Assert.IsTrue(firstContractStartDate.Year.Equals(2015)
                              && firstContractStartDate.Month.Equals(8)
                              && firstContractStartDate.Day.Equals(1), $"Invalid Start Date, should be 1/8/2015 instead is this { firstContractStartDate.ToLongDateString()}");

                Assert.IsTrue(firstContract.amendmentType == "Variation",
                    $"Invalid amendmentType, should be Variation instead is this {firstContract.amendmentType}");

                Assert.IsTrue(firstContract.period.period1 == masterContract.contracts[0].period.period1,
                    $"Invalid period, should be {masterContract.contracts[0].period.period1} instead is this {corpSchemeContract.contracts[0].period.period1}");
                Assert.IsTrue(firstContract.contractAllocations.Count == 3, "Invalid number of contract allocations for the child contract");

                var firstAlloc = firstContract.contractAllocations[0];
                Assert.IsTrue(firstAlloc.contractDeliverables.Count == 1,
                    "Invalid number of contract deliverables for first allocation for child contract");
                Assert.IsTrue(firstAlloc.period.period1 == masterContract.contracts[0].contractAllocations[0].period.period1,
                    "Invalid period on Allocation");
                Assert.IsTrue(firstAlloc.contractDeliverables[0].contractDeliverablePeriods.Count == 12, "There are not 12 periods");

                Assert.IsTrue(firstAlloc.uopCode == "TESTUOP", "UOP Code not set");
        }
        
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_GetHierarchicalContract_ReturnsChildDeliverablesCorrectly()
        {
            // Arrange 
            const string masterContractNumber = "SFA-9999";
            const string contractNumber = "MAIN-9999";
            const int ukprn = 10120139;
            const string providerName = "IntegrationTest Provider";
            const string contractAllocationNumber = "16AP-999";

            DeleteContractsWithContractNumber(contractNumber);
            DeleteContractsWithContractNumber(masterContractNumber);

            var provider = new CorporateContract.Contractor
            {
                ukprn = ukprn,
                legalName = providerName,
                organisationIdentifier = ukprn.ToString()
            };

            CorporateContract.ExtendedContractType corpContract = null;

            try
            {
                corpContract = GetHierarchicalCorpContract(masterContractNumber, provider, contractNumber, contractAllocationNumber);

                var contractManager = CreateContractsManager();
                contractManager.BatchId = "1000001";

                CreateProvider(ukprn, ukprn.ToString(), providerName);

                // Create Contract
                var masterGuid = contractManager.CreateContract(corpContract, "CORRELATION1");

                for (int i = 0; i < 3; i++)
                {
                    System.Threading.Tasks.Task.Delay(TimeSpan.FromSeconds(5)).Wait();

                    if (ApproveContract(contractNumber))
                    {
                        break;
                    }
                }

                // The CRM workflow that attaches the deliverables to the contract does not necessarily finish quickly enough
                CorporateContract.Contract exportedCorpContract = null;

                for (int i = 0; i < 3; i++)
                {
                    exportedCorpContract = contractManager.GetCorporateContract(contractNumber, masterContractNumber);

                    if (exportedCorpContract != null)
                    {
                        var del1 = exportedCorpContract.contracts.First().contractAllocations.First().contractDeliverables.First();

                        if (del1.contractDeliverables != null)
                        {
                            var del2 = del1.contractDeliverables.FirstOrDefault();
                            if (del2 != null)
                            {
                                if (del2.contractDeliverables != null)
                                {
                                    var del3 = del2.contractDeliverables.FirstOrDefault();
                                    if (del3 != null)
                                    {
                                        // contract has sorted out
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    System.Threading.Tasks.Task.Delay(TimeSpan.FromSeconds(10)).Wait();
                }

                // Master Contract
                Assert.IsTrue(exportedCorpContract.contractNumber != string.Empty, "Master Contract Number is not returned correctly");
                Assert.IsTrue(exportedCorpContract.fundingType != null, "Master Funding Type is null");
                Assert.IsTrue(exportedCorpContract.fundingType.fundingTypeCode == corpContract.fundingType.fundingTypeCode, "Funding Type is not returned correctly");
                Assert.IsTrue(exportedCorpContract.contractType1 == corpContract.contractType1, "Contract Type is not returned correctly");
                Assert.IsTrue(exportedCorpContract.contractor != null, "Master Contractor is not returned correctly");
                Assert.IsTrue(exportedCorpContract.contractor.ukprn == ukprn, "MasterContractor UKPRN is not returned correctly");
                Assert.IsTrue(exportedCorpContract.contractor.legalName == providerName, "Master Contractor Provider Name is not returned correctly");
                Assert.IsTrue(exportedCorpContract.contractor.organisationIdentifier.Contains(ukprn.ToString()), "Master Contractor Org ID is not returned correctly");

                // Contract
                var exportedContract = exportedCorpContract.contracts[0];

                Assert.IsTrue(exportedContract.contractNumber != string.Empty, "Contract Number is not returned correctly");
                Assert.IsTrue(exportedContract.fundingType.fundingTypeCode == corpContract.fundingType.fundingTypeCode, "Funding Type is not returned correctly");
                Assert.IsTrue(exportedContract.fundingType.fundingTypeCode == corpContract.fundingType.fundingTypeCode, "Funding Type is not returned correctly");
                Assert.IsTrue(exportedContract.contractType1 == corpContract.contractType1, "Contract Type is not returned correctly");
                Assert.IsTrue(exportedContract.contractor != null, "Contractor is not returned correctly");
                Assert.IsTrue(exportedContract.contractor.ukprn == ukprn, "Contractor UKPRN is not returned correctly");
                Assert.IsTrue(exportedContract.contractor.legalName == providerName, "Contractor Provider Name is not returned correctly");
                Assert.IsTrue(exportedContract.contractor.organisationIdentifier.Contains(ukprn.ToString()), "Contractor Org ID is not returned correctly");

                Assert.AreEqual(1,
                    exportedCorpContract.contracts.First()
                        .contractAllocations.First()
                        .contractDeliverables.First()
                        .deliverable.deliverableCode, "Parent deliverable code not set correctly");

                Assert.AreEqual(2,
                    exportedCorpContract.contracts.First()
                        .contractAllocations.First()
                        .contractDeliverables.First()
                        .contractDeliverables.First()
                        .deliverable.deliverableCode, "1st child deliverable code not set correctly");

                Assert.AreEqual(3,
                    exportedCorpContract.contracts.First()
                        .contractAllocations.First()
                        .contractDeliverables.First()
                        .contractDeliverables.First()
                        .contractDeliverables.First()
                        .deliverable.deliverableCode, "3rd child deliverable code not set correctly");
            }
            finally
            {
                ActionRetrier.RetryWhenExceptionThrown(() => DeleteContracts(corpContract));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_ShouldValidateCorporateContractMappingFromv804To810()
        {

            const string masterContractNumber = "SFA-6442";
            const string contractNumber = "24Loans-1049";
            const string batchId = "XX";
            const string correlationId = "ZZZ";
            const string ukprn = "87654567";

            CorporateContract.ExtendedContractType masterContract = GetExtendedCorpContract();
            ////setting up difference master and child contract in each test as keeping them same in parallel execution causes orphaned contracts to be left 
            masterContract.ContractApprovalDate = null;
            masterContract.StatusLastUpdatedDate = null;
            masterContract.LastModifiedDate = null;
            masterContract.contractStatus = null;
            masterContract.endDate = null;
            masterContract.startDate = null;
            masterContract.parentContractVersionNumber = null;
            masterContract.contractValue = null;

            //set enddates null test schema change 03/11/2016
            masterContract.contracts[0].endDate = null;
            masterContract.contracts[0].contractAllocations[0].endDate = null;

            masterContract.contractor.ukprn = int.Parse(ukprn);
            masterContract.contractor.organisationIdentifier = "ORG" + ukprn;
            masterContract.contractor.Status = "Active";

            masterContract.contracts.ForEach(c =>
            {
                c.contractor.ukprn = int.Parse(ukprn);
                c.contractor.organisationIdentifier = "ORG" + ukprn;
                c.contractor.Status = "Active";

                c.amendmentType = "Variation";

                c.contractAllocations.ForEach(
                    ca =>
                    {
                        ca.reasonForAmendment = "Test";
                        ca.uopCode = "TESTUOP";
                    });
            });

            ContractTransformer contractTransformer = new ContractTransformer();

            var contractsManager = CreateContractsManager();
            contractsManager.BatchId = batchId;

            _masterContractGuid = contractsManager.CreateContract(masterContract, correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            foreach (var contract in GetChildContracts(_masterContractGuid))
            {
                UpdateContractStatusToApproved(contract.Id);
            }

            // Act
            CorporateContract.Contract corporateContract = contractsManager.GetCorporateContract(contractNumber, masterContractNumber, false);

            var corpSchemeContract = contractTransformer.TransformToCorporateSchemaContract(corporateContract);

            //Assert
            ValidateCorpContractAgainstXsd(corpSchemeContract);

            Assert.IsNull(corpSchemeContract.contractValue);
            Assert.IsNull(corpSchemeContract.ContractApprovalDate);
            Assert.IsNull(corpSchemeContract.startDate);
            Assert.IsNull(corpSchemeContract.endDate);
            Assert.IsNull(corpSchemeContract.contractStatus);
            Assert.IsNull(corpSchemeContract.StatusLastUpdatedDate);
            Assert.IsNull(corpSchemeContract.LastModifiedDate);
            Assert.IsNull(corpSchemeContract.parentContractVersionNumber);
            Assert.IsNull(corpSchemeContract.period);

        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_ShouldGetPlannedVolumeAggregatedAtPeriodForADeliverableWhenContractIsCreatedInCrm()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            CorporateContract.ExtendedContractType masterContract = GetExtendedCorpContract();

            var contractsManager = CreateContractsManager();
            contractsManager.BatchId = batchId;

            const decimal unitCost = 98765432.1M;
            const int plannedVolume = 210;

            string allocationNumber = masterContract.contracts[0].contractAllocations[0].contractAllocationNumber;
            masterContract.contracts[0].contractAllocations[0].contractDeliverables[0].unitCost = unitCost;
            masterContract.contracts[0].contractAllocations[0].contractDeliverables[0].plannedVolume = plannedVolume;

            // rename master contact number, contract number and allocations
            string contractSuffix = DateTime.Now.ToString("ddMMyyhhmm");
            masterContract.contractNumber = "SFA-" + contractSuffix;
            masterContract.contracts[0].contractNumber = "ESIF-" + contractSuffix;
            masterContract.contracts[0].contractAllocations.ForEach(a => a.contractAllocationNumber = a.contractAllocationNumber + "Y");
            _masterContractGuid = contractsManager.CreateContract(masterContract, correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            //Check contract values have persisted. 
            IList<Entity> contracts = GetContractsForMaster(_masterContractGuid);

            //Check deliverable values have persisted.
            IList<Entity> allocations = GetAllocationsForContract(contracts[0].Id);

            IList<Entity> deliverables = GetDeliverablesForAllocation(allocationNumber + "Y");
            Assert.AreEqual(unitCost, deliverables.First(d => d.Attributes[CrmDeliverableFieldName.DeliverableCode].ToString() == "1").GetAttributeValue<decimal>(CrmDeliverableFieldName.UnitCost));
            Assert.AreEqual(plannedVolume, deliverables.First(d => d.Attributes[CrmDeliverableFieldName.DeliverableCode].ToString() == "1").GetAttributeValue<int>(CrmDeliverableFieldName.PlannedVolume));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_ShouldPersistDisplayOrderOnContractDeliverableWhenContractIsCreatedInCrm()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            CorporateContract.ExtendedContractType masterContract = GetExtendedCorpContract();

            var contractsManager = CreateContractsManager();
            contractsManager.BatchId = batchId;


            string allocationNumber = masterContract.contracts[0].contractAllocations[0].contractAllocationNumber;

            // rename master contact number, contract number and allocations
            string contractSuffix = DateTime.Now.ToString("ddMMyyhhmm");
            masterContract.contractNumber = "SFA-" + contractSuffix;
            masterContract.contracts[0].contractNumber = "MAIN-" + contractSuffix;
            masterContract.contracts[0].contractAllocations.ForEach(a => a.contractAllocationNumber = a.contractAllocationNumber + "X");
            _masterContractGuid = contractsManager.CreateContract(masterContract, correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            //Check contract values have persisted. 
            IList<Entity> contracts = GetContractsForMaster(_masterContractGuid);

            //Check deliverable values have persisted.
            IList<Entity> allocations = GetAllocationsForContract(contracts[0].Id);

            IList<Entity> deliverables = GetDeliverablesForAllocation(allocationNumber + "X");
            Assert.AreEqual(1, deliverables.First(d => d.Attributes[CrmDeliverableFieldName.DeliverableCode].ToString() == "1").GetAttributeValue<int>(CrmDeliverableFieldName.DisplayOrder));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_GetLastApprovedContractIdentityInfo_ShouldGetApprovedContractVersionDataWhenLaterVersionExists()
        {
            // pre-clean up
            DeleteContractsWithContractNumber("24Loans-1049");
            DeleteContractsWithContractNumber("SFA-6442");

            IContractsManager contractsManager = CreateContractsManager();

            // arrange initial approved contract
            ExtendedContract version1MasterContract = GetExtendedCorpContract();
            version1MasterContract.contracts.First().contractVersionNumber = 1;
            version1MasterContract.contracts.First().contractSubVersionNumber = 0;
            version1MasterContract.contracts.First().contractAllocations.Single(a => a.contractAllocationNumber == "ALLB-665").DeliveryOrganisation = "DELIVERYORG1";
            version1MasterContract.contracts.First().contractAllocations.Single(a => a.contractAllocationNumber == "ALLC-745").DeliveryOrganisation = "DELIVERYORG2";
            version1MasterContract.contracts.First().contractAllocations.Single(a => a.contractAllocationNumber == "ALLF-897").DeliveryOrganisation = string.Empty;
            _masterContractGuid = contractsManager.CreateContract(version1MasterContract, Guid.NewGuid().ToString());
            UpdateContractStatusToApproved(GetChildContracts(_masterContractGuid)[0].Id);

            // arrange draft amendment
            ExtendedContract version2MasterContract = GetExtendedCorpContract();
            version2MasterContract.contracts.First().contractVersionNumber = 2;
            version2MasterContract.contracts.First().contractSubVersionNumber = 0;
            version2MasterContract.contracts.First().contractAllocations.Single(a => a.contractAllocationNumber == "ALLB-665").DeliveryOrganisation = "DELIVERYORG3";
            version2MasterContract.contracts.First().contractAllocations.Single(a => a.contractAllocationNumber == "ALLC-745").DeliveryOrganisation = "DELIVERYORG4";
            version2MasterContract.contracts.First().contractAllocations.Single(a => a.contractAllocationNumber == "ALLF-897").DeliveryOrganisation = "CONTRACTINGORG";
            _masterContractGuid2 = contractsManager.AmendContract(version2MasterContract, Guid.NewGuid().ToString());

            // act
            ContractRequest.ContractIdentityInfo approvedContractIdentityInfo = contractsManager.GetLastApprovedContractIdentityInfo("24Loans-1049");

            // assert
            Assert.IsNotNull(approvedContractIdentityInfo);
            Assert.AreEqual("24Loans-1049", approvedContractIdentityInfo.ContractNumber);
            Assert.AreEqual("DELIVERYORG1", approvedContractIdentityInfo.Allocations.Single(a => a.AllocationNumber == "ALLB-665").DeliveryOrganisation);
            Assert.AreEqual("DELIVERYORG2", approvedContractIdentityInfo.Allocations.Single(a => a.AllocationNumber == "ALLC-745").DeliveryOrganisation);
            Assert.IsNull(approvedContractIdentityInfo.Allocations.Single(a => a.AllocationNumber == "ALLF-897").DeliveryOrganisation);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_GetLastApprovedContractIdentityInfo_ShouldGetApprovedContractVersionDataWhenLaterVersionDoesNotExists()
        {
            // pre-clean up
            DeleteContractsWithContractNumber("24Loans-1049");
            DeleteContractsWithContractNumber("SFA-6442");

            IContractsManager contractsManager = CreateContractsManager();

            // arrange initial approved contract
            ExtendedContract version1MasterContract = GetExtendedCorpContract();
            version1MasterContract.contracts.First().contractVersionNumber = 1;
            version1MasterContract.contracts.First().contractSubVersionNumber = 0;
            version1MasterContract.contracts.First().contractAllocations.Single(a => a.contractAllocationNumber == "ALLB-665").DeliveryOrganisation = "DELIVERYORG1";
            version1MasterContract.contracts.First().contractAllocations.Single(a => a.contractAllocationNumber == "ALLC-745").DeliveryOrganisation = "DELIVERYORG2";
            version1MasterContract.contracts.First().contractAllocations.Single(a => a.contractAllocationNumber == "ALLF-897").DeliveryOrganisation = string.Empty;
            _masterContractGuid = contractsManager.CreateContract(version1MasterContract, Guid.NewGuid().ToString());
            UpdateContractStatusToApproved(GetChildContracts(_masterContractGuid)[0].Id);

            // act
            ContractRequest.ContractIdentityInfo approvedContractIdentityInfo = contractsManager.GetLastApprovedContractIdentityInfo("24Loans-1049");

            // assert
            Assert.IsNotNull(approvedContractIdentityInfo);
            Assert.AreEqual("24Loans-1049", approvedContractIdentityInfo.ContractNumber);
            Assert.AreEqual("DELIVERYORG1", approvedContractIdentityInfo.Allocations.Single(a => a.AllocationNumber == "ALLB-665").DeliveryOrganisation);
            Assert.AreEqual("DELIVERYORG2", approvedContractIdentityInfo.Allocations.Single(a => a.AllocationNumber == "ALLC-745").DeliveryOrganisation);
            Assert.IsNull(approvedContractIdentityInfo.Allocations.Single(a => a.AllocationNumber == "ALLF-897").DeliveryOrganisation);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_GetLastApprovedContractIdentityInfo_ShouldReturnNullWhenNoApprovedVersionExists()
        {
            // pre-clean up
            DeleteContractsWithContractNumber("24Loans-1049");
            DeleteContractsWithContractNumber("SFA-6442");

            IContractsManager contractsManager = CreateContractsManager();

            // arrange initial approved contract
            ExtendedContract version1MasterContract = GetExtendedCorpContract();
            version1MasterContract.contracts.First().contractVersionNumber = 1;
            version1MasterContract.contracts.First().contractSubVersionNumber = 0;
            version1MasterContract.contracts.First().contractAllocations.Single(a => a.contractAllocationNumber == "ALLB-665").DeliveryOrganisation = "DELIVERYORG1";
            version1MasterContract.contracts.First().contractAllocations.Single(a => a.contractAllocationNumber == "ALLC-745").DeliveryOrganisation = "DELIVERYORG2";
            version1MasterContract.contracts.First().contractAllocations.Single(a => a.contractAllocationNumber == "ALLF-897").DeliveryOrganisation = string.Empty;
            _masterContractGuid = contractsManager.CreateContract(version1MasterContract, Guid.NewGuid().ToString());

            // act
            ContractRequest.ContractIdentityInfo approvedContractIdentityInfo = contractsManager.GetLastApprovedContractIdentityInfo("24Loans-1049");

            // assert
            Assert.IsNull(approvedContractIdentityInfo);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_DoesContractVersionExist_ShouldCheckContractExists()
        {
            // pre-clean up
            DeleteContractsWithContractNumber("24Loans-1049");
            DeleteContractsWithContractNumber("SFA-6442");

            IContractsManager contractsManager = CreateContractsManager();

            // arrange initial approved contract
            ExtendedContract version1MasterContract = GetExtendedCorpContract();
            version1MasterContract.contracts.First().contractVersionNumber = 1;
            version1MasterContract.contracts.First().contractSubVersionNumber = 0;
            version1MasterContract.contracts.First().contractAllocations.Single(a => a.contractAllocationNumber == "ALLB-665").DeliveryOrganisation = "DELIVERYORG1";
            version1MasterContract.contracts.First().contractAllocations.Single(a => a.contractAllocationNumber == "ALLC-745").DeliveryOrganisation = "DELIVERYORG2";
            version1MasterContract.contracts.First().contractAllocations.Single(a => a.contractAllocationNumber == "ALLF-897").DeliveryOrganisation = string.Empty;
            _masterContractGuid = contractsManager.CreateContract(version1MasterContract, Guid.NewGuid().ToString());

            // act
            Assert.IsTrue(contractsManager.DoesContractVersionExist("24Loans-1049", 1));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_DoesContractVersionExist_ShouldBeFalseIfNotExists()
        {
            // pre-clean up
            DeleteContractsWithContractNumber("24Loans-1049");
            DeleteContractsWithContractNumber("SFA-6442");

            IContractsManager contractsManager = CreateContractsManager();

            // act
            Assert.IsFalse(contractsManager.DoesContractVersionExist("24Loans-1049", 1));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_ShouldGetMaxContractVersionNumber()
        {
            // arrange
            const string batchId = "XX";
            const string correlationId = "ZZZ";
            DeleteContractsWithContractNumber("24Loans-1093");
            DeleteContractsWithContractNumber("SFA-6443");

            var masterContract = GetCorpContractForWithdraw();
            var masterContract2 = GetCorpContractForWithdraw();
            var masterContract3 = GetCorpContractForWithdraw();

            var contractsManager = CreateContractsManager();

            contractsManager.BatchId = batchId;

            //setting up difference master and child contract in each test as keeping them same in parallel execution causes orphaned contracts to be left in CRM
            masterContract.contractNumber = "SFA-6443";
            masterContract.contracts[0].contractNumber = "24Loans-1093";

            #region 'Contract 2'

            var contract2 = masterContract2.contracts[0];

            contract2.contractNumber = "24Loans-1093";
            contract2.contractVersionNumber = 2;
            contract2.contractStatus = new CorporateContract.contractStatusType
            {
                parentStatus = "Withdrawn",
                status = "Withdrawn By Agency"
            };


            #endregion

            #region 'Contract 3'

            var contract3 = masterContract3.contracts[0];

            contract3.contractNumber = "24Loans-1093";
            contract3.contractVersionNumber = 3;
            contract3.contractStatus = new CorporateContract.contractStatusType
            {
                parentStatus = "Withdrawn",
                status = "Withdrawn By Agency"
            };

            #endregion

            masterContract.contracts.Add(contract2);
            masterContract.contracts.Add(contract3);

            _masterContractGuid = contractsManager.CreateContract(TransformCorpContractToExtendedCorpContract(masterContract), correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            var currentContract = masterContract.contracts.First();

            var contracts = GetContracts(currentContract.contractNumber);

            UpdateContractStatus(contracts[0].Id, sfa_contractstatus.Approved, "Approved");
            UpdateContractStatus(contracts[1].Id, sfa_contractstatus.Withdrawn, "Withdrawn By Agency");
            UpdateContractStatus(contracts[2].Id, sfa_contractstatus.Withdrawn, "Withdrawn By Agency");

            // act
            int actualMaxVersionNumber = contractsManager.GetMaximumContractVersionNumber(currentContract.contractNumber);

            // assert
            Assert.AreEqual(3, actualMaxVersionNumber);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_CreateContract_ShouldSetGivenOrganisationStatusWhenCreatingNewOrganisation()
        {
            const int contractorUkprn = 1234321;
            const string contractorStatus = "Locked Restructure";

            // arrange
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                context.AccountSet
                    .Where(org => org.sfa_UKPRN == contractorUkprn.ToString())
                    .ForEach(org => organizationService.Delete("account", org.Id));
            }

            ExtendedContract masterContract = GetExtendedCorpContract();
            masterContract.contracts.Single().contractor.ukprn = contractorUkprn;
            masterContract.contracts.Single().contractor.Status = contractorStatus;

            IContractsManager contractsManager = CreateContractsManager();

            // act
            _masterContractGuid = contractsManager.CreateContract(masterContract, Guid.NewGuid().ToString());

            // assert
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                Account organisation = context.AccountSet
                    .SingleOrDefault(org => org.sfa_UKPRN == contractorUkprn.ToString());

                Assert.IsNotNull(organisation, "Organisation was not created in CRM");
                Assert.AreEqual(contractorStatus, organisation.sfa_Status.Name, "Organisation status was not correctly set in CRM");
            }
        }

        private static List<sfa_contract> GetContracts(string contractNumber)
        {
            using (var xrmContext = new XrmServiceContext(CrmOrganizationService))
            {
                return (from c in xrmContext.sfa_contractSet
                        join m in xrmContext.sfa_contractSet on c.sfa_ParentContractId.Id equals m.sfa_contractId
                        where c.sfa_number == contractNumber
                        select c).ToList();
            }
        }

        private static void UpdateContractStatus(Guid contractId, sfa_contractstatus status, string subStatus)
        {
            var updateContractObject = new sfa_contract
            {
                Id = contractId
            };

            Guid? statusId = new Guid();
            using (var xrmContext = new XrmServiceContext(CrmOrganizationService))
            {
                var firstOrDefault = (from c in xrmContext.sfa_statusSet
                                      where c.sfa_name == subStatus
                                      select c).FirstOrDefault();
                if (firstOrDefault != null)
                {
                    statusId = firstOrDefault.sfa_statusId;
                }
            }

            if (statusId != null)
            {
                updateContractObject.sfa_SubStatus = new EntityReference
                {
                    LogicalName = "sfa_status",
                    Id = statusId.Value
                };

                updateContractObject.sfa_ContractStatus = new OptionSetValue((int)status);

                updateContractObject.EntityState = EntityState.Changed;
                CrmOrganizationService.Update(updateContractObject);
            }

        }

        private static void UpdateContractStatusToApproved(Guid contractId)
        {
            var contractToUpdate = new sfa_contract
            {
                Id = contractId,
                sfa_ContractStatusEnum = sfa_contractstatus.Approved,
                sfa_LastApprovedVersion = true,
                sfa_ContractApprovalDate = DateTime.Now,
                sfa_StatusLastUpdatedDate = DateTime.Now
            };

            CrmOrganizationService.Update(contractToUpdate);
        }

        private static void UpdateTerminationDateAndReason(Guid contractId, DateTime terminationDate, sfa_TerminationReasons terminationReason)
        {
            var contractToUpdate = new sfa_contract
            {
                Id = contractId,
                sfa_terminationdate = terminationDate,
                sfa_terminationreasonEnum = terminationReason
            };

            CrmOrganizationService.Update(contractToUpdate);
        }

        private static List<sfa_contract> GetChildContracts(Guid contractId)
        {
            using (var xrmContext = new XrmServiceContext(CrmOrganizationService))
            {
                return xrmContext.sfa_contractSet
                    .Where(ctx => ctx.sfa_ParentContractId.Id.Equals(contractId))
                    .ToList();
            }
        }

        public string GetUkrpnForProviderAlreadyInTheSystem()
        {
            using (var xrmContext = new XrmServiceContext(CrmOrganizationService))
            {
                return xrmContext.AccountSet.First(a => a.sfa_UKPRN != null).sfa_UKPRN;
            }
        }

        private static void ValidateCorpContractAgainstXsd(CorporateSchema.Contract contract)
        {

            XmlSchemaSet schemas = new XmlSchemaSet();
            AddSchemasToSet(schemas);

            XmlSerializer serializer = new XmlSerializer(typeof(SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.Contract));

            XDocument responseXml;
            using (MemoryStream xmlStream = new MemoryStream())
            {
                serializer.Serialize(xmlStream, contract);
                xmlStream.Position = 0;
                responseXml = XDocument.Load(xmlStream, LoadOptions.PreserveWhitespace | LoadOptions.SetLineInfo);
            }

            responseXml.Validate(
                schemas,
                (o, e) =>
                {
                    Assert.Fail(e.Message);
                });
        }

        private static void AddSchemasToSet(XmlSchemaSet schemas)
        {
            Stream xsdStream = GetCorporateSchemaXsdFile();
            schemas.Add(CorpContractSchemaNamespace, new XmlTextReader(xsdStream));
        }

        private static Stream GetCorporateSchemaXsdFile()
        {
            return typeof(CorporateSchema.Contract).Assembly.GetManifestResourceStream(CorpContractSchemaResourceName);
        }

        private static bool ApproveContract(string contractNumber)
        {
            using (var context = new XrmServiceContext(CrmOrganizationService))
            {
                var contract = context.sfa_contractSet.SingleOrDefault(c => c.sfa_number == contractNumber);
                if (contract != null)
                {
                    contract.sfa_LastApprovedVersion = true;
                    contract.sfa_ContractApprovalDate = DateTime.Now;
                    contract.sfa_StatusLastUpdatedDate = DateTime.Now;
                    context.UpdateObject(contract);
                    context.SaveChanges();

                    return true;
                }
            }
            return false;
        }

        private void CreateProvider(int ukprn, string organisationId, string providerName)
        {
            using (var context = new XrmServiceContext(CrmOrganizationService))
            {
                if (!context.AccountSet.Where(a => a.sfa_UKPRN == ukprn.ToString()).ToList().Any())
                {
                    var provider = new Account
                    {
                        sfa_UKPRN = ukprn.ToString(),
                        sfa_OrganisationID = organisationId,
                        Name = providerName
                    };

                    context.AddObject(provider);

                    var caseload = new sfa_caseload
                    {
                        sfa_UKPRN = ukprn.ToString(),
                        sfa_organisationname = providerName,
                    };

                    context.AddRelatedObject(provider, new Relationship("sfa_account_sfa_caseload_OrganisationId"), caseload);

                    context.SaveChanges();
                    _createdProviderEntities.Add(provider);
                }
            }
        }

        private static void DeleteContracts(CorporateContract.ExtendedContractType masterContract)
        {
            if (masterContract != null)
            {
                using (var context = new XrmServiceContext(CrmOrganizationService))
                {
                    foreach (var xrmChild in
                        context.sfa_contractSet.Where(c => c.sfa_number == masterContract.contracts.FirstOrDefault().contractNumber))
                    {
                        context.DeleteObject(xrmChild);
                    }

                    foreach (var xrmMaster in context.sfa_contractSet.Where(c => c.sfa_number == masterContract.contractNumber))
                    {
                        context.DeleteObject(xrmMaster);
                    }
                    context.SaveChanges();
                }
            }
        }

        private static CorporateContract.ExtendedContractType GetHierarchicalCorpContract(string masterContractNumber, CorporateContract.Contractor provider, string contractNumber, string contractAllocationNumber)
        {
            return new CorporateContract.ExtendedContractType
            {
                contractNumber = masterContractNumber,
                contractor = provider,
                hierarchyType = CorporateContract.hierarchyType.MASTERCONTRACT,
                fundingType = new CorporateContract.fundingType
                {
                    fundingTypeCode = "MAIN",
                    fundingTypeName = "Mainstream"
                },
                contractType1 = "Contract for Services",
                contracts = new List<CorporateContract.ExtendedContractType>
                {
                    new CorporateContract.ExtendedContract
                    {
                        contractNumber = contractNumber,
                        contractor = provider,
                        hierarchyType = CorporateContract.hierarchyType.CONTRACT,
                        fundingType = new CorporateContract.fundingType
                        {
                            fundingTypeCode = "MAIN",
                            fundingTypeName = "Mainstream"
                        },
                        contractType1 = "Contract for Services",
                        contractVersionNumber = 1,
                        description = "Sample Contract",
                        contractValue = 100,
                        startDate = DateTime.Today.ToUniversalTime(),
                        endDate = DateTime.Today.ToUniversalTime().AddYears(1),
                        contractStatus = new CorporateContract.contractStatusType
                        {
                            parentStatus = "Draft",
                            status = "Unassigned"
                        },
                        period = new CorporateContract.Period
                        {
                            period1 = "1516",
                            periodType = new CorporateContract.periodTypeType
                            {
                                periodTypeCode = CorporateContract.periodTypeCodeType.AY,
                                periodTypeName = CorporateContract.periodTypeNameType.ACADEMICYEAR
                            }
                        },
                        contractAllocations = new List<CorporateContract.ExtendedContractAllocation>
                        {
                            new CorporateContract.ExtendedContractAllocation
                            {
                                contractAllocationNumber = contractAllocationNumber,
                                maximumContractValue = 190000,
                                fundingStream = new CorporateContract.fundingStream
                                {
                                    fundingStreamCode = FundingStreamCode,
                                    fundingStreamShortCode = "16AP",
                                    fundingStreamName = "16-18 Apprenticeships"
                                },
                                fundingStreamPeriodCode = "16-18APPS1516",
                                startDate = DateTime.Now,
                                endDate = DateTime.Now.AddYears(1),
                                period = new CorporateContract.Period
                                {
                                    period1 = "1516",
                                    periodType = new CorporateContract.periodTypeType
                                    {
                                        periodTypeCode = CorporateContract.periodTypeCodeType.AY,
                                        periodTypeName = CorporateContract.periodTypeNameType.ACADEMICYEAR
                                    }
                                },
                                description = "Sample Allocation",
                                contractDeliverables = new List<CorporateContract.contractDeliverablesTypeContractDeliverable>
                                {
                                    new CorporateContract.contractDeliverablesTypeContractDeliverable
                                    {
                                        deliverable = new CorporateContract.deliverableType
                                        {
                                            deliverableCode = 1,
                                            fundingStreamCode = FundingStreamCode
                                        },
                                        DisplayOrder = 1,
                                        contractDeliverables = new List<CorporateContract.contractDeliverablesTypeContractDeliverable>
                                        {
                                            new CorporateContract.contractDeliverablesTypeContractDeliverable
                                            {
                                                deliverable = new CorporateContract.deliverableType
                                                {
                                                    deliverableCode = 2,
                                                    fundingStreamCode = FundingStreamCode
                                                },
                                                DisplayOrder = 2,
                                                contractDeliverables = new List<CorporateContract.contractDeliverablesTypeContractDeliverable>
                                                {
                                                    new CorporateContract.contractDeliverablesTypeContractDeliverable
                                                    {
                                                        deliverable = new CorporateContract.deliverableType
                                                        {
                                                            deliverableCode = 3,
                                                            fundingStreamCode = FundingStreamCode
                                                        },
                                                        DisplayOrder = 3
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            };
        }

        private QueryExpression CreateQueryExpressionForTaskJoinedToTeam(Guid taskId)
        {
            QueryExpression query = new QueryExpression
            {
                EntityName = CrmEntityName.Task,
                ColumnSet = new ColumnSet("activityid"),
                Criteria = new FilterExpression()
            };

            LinkEntity linkToTeam = new LinkEntity()
            {
                LinkFromAttributeName = "owningteam",
                LinkToEntityName = CrmEntityName.Team,
                LinkToAttributeName = "teamid",
                JoinOperator = JoinOperator.Inner,
                Columns = new ColumnSet("name"),
                EntityAlias = "t"
            };

            query.LinkEntities.Add(linkToTeam);

            query.Criteria.Conditions.Add(
                    new ConditionExpression(
                        CrmEntityName.Task,
                        "activityid",
                        ConditionOperator.In,
                        taskId));

            return query;
        }

        private EntityCollection ExecuteQuery(QueryExpression query)
        {
            EntityCollection entityCollection = null;
            RetrieveMultipleRequest rmr = new RetrieveMultipleRequest();
            rmr.Query = query;

            ExecuteMultipleRequest emr = new ExecuteMultipleRequest();
            emr.Requests = new OrganizationRequestCollection();
            emr.Requests.Add(rmr);
            emr.Settings = new ExecuteMultipleSettings();
            emr.Settings.ReturnResponses = true;

            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            ExecuteMultipleResponse xmr = (ExecuteMultipleResponse)organizationService.Execute(emr);

            foreach (var response in xmr.Responses)
            {
                if (response.Response != null)
                {
                    foreach (var result in response.Response.Results)
                    {
                        entityCollection = result.Value as EntityCollection;
                    }
                }
            }

            return entityCollection;
        }

        private void RemoveProviders()
        {
            if (_createdProviderEntities.Any())
            {
                using (var context = new XrmServiceContext(CrmOrganizationService))
                {
                    MoreEnumerable.ForEach(_createdProviderEntities.OfType<Account>(), e =>
                    {
                        context.Attach(e);
                        context.DeleteObject(e);
                    });
                    context.SaveChanges();
                }
            }
        }

        private static bool IsTaskAssociatedToContract(Guid contractGuid, string taskName)
        {
            var columnValues = new List<ColumnValueCriteria>()
            {
                new ColumnValueCriteria("regardingobjectid", ConditionOperator.Equal, contractGuid),
                new ColumnValueCriteria("subject", ConditionOperator.Equal, taskName)
            };
            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria() { EntityName = CrmEntityName.Task, LookupCriteria = columnValues };

            IList<Entity> taskEntities = CrmManager.GetCrmEntities(lookupCriteria);

            return taskEntities.Any();
        }

        private bool IsTaskLinkedToDocumentManagementTeam(Guid taskId)
        {
            QueryExpression query = CreateQueryExpressionForTaskJoinedToTeam(taskId);

            EntityCollection entityCollection = ExecuteQuery(query);

            Entity taskEntity = entityCollection.Entities.Single();

            AliasedValue teamNameAliasedValue = taskEntity.GetAttributeValue<AliasedValue>("t.name");

            return (string)teamNameAliasedValue.Value == "Document Management Team";
        }

        private static ExtendedContractType GetContractFromFile()
        {
            return TestResource.FromJson<ExtendedContractType>("ContractCreateDomain.Implementation.Tests",
                "Resources.ExtendedContractType.json");
        }

        private void UpdateAllocationWithTerminationDetails(Guid childContractId, string allocationNumber, DateTime terminationDate, DateTime stopNewStartsDate)
        {
            Guid allocationId = GetAllocationId(childContractId, allocationNumber);

            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_terminationdate = terminationDate,
                sfa_stopnewstartsdate = stopNewStartsDate,
                Id = allocationId
            };

            CrmOrganizationService.Update(allocation);
        }

        private Guid GetAllocationId(Guid contractId, string allocationNumber)
        {
            using (var context = new XrmServiceContext(CrmOrganizationService))
            {
                return context.sfa_contractallocationSet.Where(a => a.sfa_ContractId.Id == contractId && a.sfa_contractallocationnumber == allocationNumber)
                    .Select(a => a.sfa_contractallocationId.Value)
                    .Single();
            }
        }

        private int GetAllocationId(Guid contractId)
        {
            using (var context = new XrmServiceContext(CrmOrganizationService))
            {
                return context.sfa_contractallocationSet.Where(a => a.sfa_ContractId.Id == contractId)
                    .AsEnumerable().Count();
            }
        }

        private Guid UpdateContractWithTerminationAndStopNewStartsDetails(
            Guid masterContractGuid,
            DateTime terminationDate,
            sfa_TerminationReasons terminationReason,
            DateTime? stopNewStartDate,
            DateTime? inflightStopNewStartDate,
            sfa_newstartssuspendedreason newstartssuspendedreason,
            sfa_newstartssuspendedreason inflightNewstartssuspendedreason)
        {
            Guid childContractId = GetChildContractIdForMasterId(masterContractGuid);

            sfa_contract contract = new sfa_contract
            {
                sfa_terminationdate = terminationDate,
                sfa_terminationreasonEnum = terminationReason,
                Id = childContractId,
                sfa_defaultstopnewstartsdate = stopNewStartDate,
                sfa_inflightstopnewstartsdate = inflightStopNewStartDate,
                sfa_defaultnewstartssuspendedreason = new OptionSetValue((int)newstartssuspendedreason),
                sfa_inflightnewstartssuspendedreason = new OptionSetValue((int)inflightNewstartssuspendedreason),
            };

            CrmOrganizationService.Update(contract);

            return childContractId;
        }

        private Guid GetChildContractIdForMasterId(Guid masterContractGuid)
        {
            using (var context = new XrmServiceContext(CrmOrganizationService))
            {
                return context.sfa_contractSet.Where(c => c.sfa_ParentContractId.Id == masterContractGuid)
                    .Select(c => c.sfa_contractId.Value)
                    .Single();
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

        private ILookupManager GetLookupManager()
        {
            return new LookupManager
            {
                BatchCacheManager = new BatchCacheManager(),
                EnduringCacheManager = new EnduringCacheManager(),
                OrganizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService()
            };
        }
    }
}