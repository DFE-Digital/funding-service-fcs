namespace DocumentsDomain.Endpoint.Tests.Xrm.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using DocumentsDomain.Endpoint.Xrm.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using Moq;
    using MoreLinq;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Documents;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class XrmDocumentManagerTests : IntegrationTestBase
    {
        private Guid _masterContractGuid;
        private const string TransitionConfirmReceiptofSignedContract = "Confirm Receipt of Signed Contract";
        private const string ContractNumberForTest = "24Loans-1065";
        private const string MasterContractNumberForTest = "SFA-6455";
        private const string SecondContractNumber = "TESTNUM-876";


        [TestInitialize]
        public void TestInitialise()
        {
            _masterContractGuid = Guid.Empty;
            RemoveTestContracts();
        }

        [TestCleanup]
        public void TestCleanup()
        {
            if (_masterContractGuid != Guid.Empty)
            {
                RemoveMasterAndChildContracts(_masterContractGuid);
            }

            DeleteEntities(context =>
            {
                return context.sfa_contractSet.Where(c => c.sfa_number == SecondContractNumber);
            });
        }

        private IContractsManager GetContractsManager()
        {
            return new ContractsManager
            {
                BatchId = "X",
                LookupManager = new LookupManager
                {
                    OrganizationService = CrmOrganizationService,
                    BatchId = "X",
                    BatchCacheManager = new BatchCacheManager(),
                    EnduringCacheManager = new EnduringCacheManager()
                },
                OrganizationService = CrmOrganizationService,
                XrmOrganisationManager = new XrmOrganisationManager
                {
                    OrgService = CrmOrganizationService
                }
            };
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmDocumentManager_UpdateContractWithDocumentMergeStatus_CalledWithSuccess_ShouldUpdateContractServiceResponse_WithSuccess()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            var masterContract = GetCorpContract();
            var contractsManager = GetContractsManager();
            XrmDocumentManager xrmDocumentManager = new XrmDocumentManager
            {
                OrganizationService = CrmOrganizationService
            };

            //setting up difference master and child contract in each test as keeping them same in parallel execution causes orphaned contracts to be left 
            masterContract.contractNumber = MasterContractNumberForTest;
            masterContract.contracts[0].contractNumber = ContractNumberForTest;

            contractsManager.BatchId = batchId;
            _masterContractGuid = contractsManager.CreateContract(TransformCorpContractToExtendedCorpContract(masterContract), correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            xrmDocumentManager.UpdateContractSubStatus(masterContract.contracts.First(), "Document Merge In Progress");

            xrmDocumentManager.UpdateContractWithDocumentMergeStatus(masterContract.contracts.First(),
                new MergeStatus { IsMergeSuccessful = true });

            var contracts = GetContractsForMaster(_masterContractGuid);

            foreach (var contract in contracts)
            {
                var serviceResponse = contract.GetAttributeValue<OptionSetValue>(CrmContractFieldName.ServiceResponse);

                Assert.AreEqual(serviceResponse.Value, (int)sfa_serviceresponse.DocumentMergeSuccessful,
                    $"Service Response returns {serviceResponse.Value} but expected is {sfa_serviceresponse.DocumentMergeSuccessful}");

                AssertSubStatus("In Review", contract.Id);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmDocumentManager_UpdateContractWithDocumentMergeStatus_CalledWithFailureDocsNotUploaded_ShouldUpdateContractServiceResponse_WithFailureAndReason()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            var masterContract = GetCorpContract();
            var contractsManager = GetContractsManager();
            XrmDocumentManager xrmDocumentManager = new XrmDocumentManager
            {
                OrganizationService = CrmOrganizationService
            };

            contractsManager.BatchId = batchId;

            //setting up difference master and child contract in each test as keeping them same in parallel execution causes orphaned contracts to be left 
            masterContract.contractNumber = MasterContractNumberForTest;
            masterContract.contracts[0].contractNumber = ContractNumberForTest;

            _masterContractGuid = contractsManager.CreateContract(TransformCorpContractToExtendedCorpContract(masterContract), correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            xrmDocumentManager.UpdateContractSubStatus(masterContract.contracts.First(), "Document Merge In Progress");

            xrmDocumentManager.UpdateContractWithDocumentMergeStatus(masterContract.contracts.First(),
                new MergeStatus
                {
                    IsMergeSuccessful = false,
                    ReasonForFailure = DocumentMergeReasonForError.DocumentNotUploaded
                });

            var contracts = GetContractsForMaster(_masterContractGuid);

            foreach (var contract in contracts)
            {
                var serviceResponse =
                    contract.GetAttributeValue<OptionSetValue>(CrmContractFieldName.ServiceResponse);
                var reasonForFailure = GetCommentsFromLastWorkflowHistory(contract.Id);

                var expectedReasonForFailure =
                    DocumentMergeReasonForError.DocumentNotUploaded
                        .Replace("{UKPRN}", masterContract.contractor.ukprn.ToString())
                        .Replace("{ContractNumber}", masterContract.contracts[0].contractNumber);

                Assert.AreEqual(((int)sfa_serviceresponse.DocumentMergeFailed), serviceResponse.Value,
                    $"Service Response returns {serviceResponse.Value} but expected is {sfa_serviceresponse.DocumentMergeFailed}");

                Assert.AreEqual(expectedReasonForFailure, reasonForFailure,
                    $"Service Response returns {reasonForFailure} but expected is {expectedReasonForFailure}");

                AssertSubStatus("Awaiting Documentation", contract.Id);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmDocumentManager_UpdateContractWithDocumentMergeStatus_CalledWithFailure_OrderWrong_ShouldUpdateContractServiceResponse_WithFailureAndReason()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            var masterContract = GetCorpContract();
            var contractsManager = GetContractsManager();
            XrmDocumentManager xrmDocumentManager = new XrmDocumentManager
            {
                OrganizationService = CrmOrganizationService
            };

            contractsManager.BatchId = batchId;

            //setting up difference master and child contract in each test as keeping them same in parallel execution causes orphaned contracts to be left 
            masterContract.contractNumber = MasterContractNumberForTest;
            masterContract.contracts[0].contractNumber = ContractNumberForTest;

            _masterContractGuid = contractsManager.CreateContract(TransformCorpContractToExtendedCorpContract(masterContract), correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            xrmDocumentManager.UpdateContractSubStatus(masterContract.contracts.First(), "Document Merge In Progress");

            xrmDocumentManager.UpdateContractWithDocumentMergeStatus(masterContract.contracts.First(),
                new MergeStatus
                {
                    IsMergeSuccessful = false,
                    ReasonForFailure = DocumentMergeReasonForError.DocumentIncorrectOrderNumber50
                });

            var contracts = GetContractsForMaster(_masterContractGuid);

            foreach (var contract in contracts)
            {
                var serviceResponse =
                    contract.GetAttributeValue<OptionSetValue>(CrmContractFieldName.ServiceResponse);
                var reasonForFailure = GetCommentsFromLastWorkflowHistory(contract.Id);


                var expectedReasonForFailure =
                    DocumentMergeReasonForError.DocumentIncorrectOrderNumber50
                        .Replace("{UKPRN}", masterContract.contractor.ukprn.ToString())
                        .Replace("{ContractNumber}", masterContract.contracts[0].contractNumber);

                Assert.AreEqual(((int)sfa_serviceresponse.DocumentMergeFailed), serviceResponse?.Value,
                    $"Service Response returns \"{serviceResponse?.Value}\" but expected is {sfa_serviceresponse.DocumentMergeFailed}");

                Assert.AreEqual(expectedReasonForFailure, reasonForFailure,
                    $"Service Response returns {reasonForFailure} but expected is {expectedReasonForFailure}");

                AssertSubStatus("Awaiting Documentation", contract.Id);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmDocumentManager_UpdateContractPublishedToProvider_CalledWithSuccess_ManualSignOff_ShouldUpdateContractServiceWithResponseDocumentPublishSuccessful()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            var masterContract = GetCorpContract();
            var contractsManager = GetContractsManager();
            XrmDocumentManager xrmDocumentManager = new XrmDocumentManager
            {
                OrganizationService = CrmOrganizationService
            };

            contractsManager.BatchId = batchId;

            //setting up difference master and child contract in each test as keeping them same in parallel execution causes orphaned contracts to be left in CRM
            masterContract.contractNumber = MasterContractNumberForTest;
            masterContract.contracts[0].contractNumber = ContractNumberForTest;

            _masterContractGuid = contractsManager.CreateContract(TransformCorpContractToExtendedCorpContract(masterContract), correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            contractType currentContract = masterContract.contracts.First();
            DateTime now = DateTime.Now.ToUniversalTime();
            currentContract.StatusLastUpdatedDate = now;

            xrmDocumentManager.UpdateContractSubStatus(currentContract, "Document Transfer in Progress");
            xrmDocumentManager.UpdateContractPublishedToProviderManualApproval(currentContract);

            var contracts = GetContractsForMaster(_masterContractGuid);

            foreach (var contract in contracts)
            {
                var serviceResponse = contract.GetAttributeValue<OptionSetValue>(CrmContractFieldName.ServiceResponse);
                DateTime contractPublishDate = contract.GetAttributeValue<DateTime>(CrmContractFieldName.PublishedDate);

                Assert.AreEqual(serviceResponse.Value, ((int)sfa_serviceresponse.DocumentPublishSuccessful),
                    $"Service Response returns {serviceResponse.Value} but expected is {sfa_serviceresponse.DocumentPublishSuccessful}");

                Assert.IsTrue(contractPublishDate.IsDateTimeEqualTo(now),
                    $"Published date returns {contractPublishDate} but expected is {now}");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmDocumentManager_UpdateContractPublishedToProvider_CalledWithSuccess_ElectronicSignOff_ShouldUpdateContractServiceWithResponseDocumentPublishSuccessful()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            var masterContract = GetCorpContract();
            var contractsManager = GetContractsManager();
            XrmDocumentManager xrmDocumentManager = new XrmDocumentManager
            {
                OrganizationService = CrmOrganizationService
            };

            contractsManager.BatchId = batchId;

            //setting up difference master and child contract in each test as keeping them same in parallel execution causes orphaned contracts to be left in CRM
            masterContract.contractNumber = MasterContractNumberForTest;
            masterContract.contracts[0].contractNumber = ContractNumberForTest;

            _masterContractGuid = contractsManager.CreateContract(TransformCorpContractToExtendedCorpContract(masterContract), correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            contractType currentContract = masterContract.contracts.First();
            DateTime now = DateTime.Now.ToUniversalTime();
            currentContract.StatusLastUpdatedDate = now;

            xrmDocumentManager.UpdateContractSubStatus(currentContract, "Document Transfer in Progress");
            xrmDocumentManager.UpdateContractPublishedToProviderForElectronicApproval(currentContract);

            var contracts = GetContractsForMaster(_masterContractGuid);

            foreach (var contract in contracts)
            {
                var serviceResponse = contract.GetAttributeValue<OptionSetValue>(CrmContractFieldName.ServiceResponse);
                DateTime contractPublishDate = contract.GetAttributeValue<DateTime>(CrmContractFieldName.PublishedDate);

                Assert.AreEqual(serviceResponse.Value, ((int)sfa_serviceresponse.DocumentPublishedForElectronicSignOff),
                    $"Service Response returns {serviceResponse.Value} but expected is {sfa_serviceresponse.DocumentPublishedForElectronicSignOff}");

                Assert.IsTrue(contractPublishDate.IsDateTimeEqualTo(now),
                    $"Published date returns {contractPublishDate} but expected is {now}");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmDocumentManager_ShouldSetTheContractStatusAndShowAppropriateTransitionsWhenElectronicApproval()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            var masterContract = GetCorpContract();
            var contractsManager = GetContractsManager();
            XrmDocumentManager xrmDocumentManager = new XrmDocumentManager
            {
                OrganizationService = CrmOrganizationService
            };

            contractsManager.BatchId = batchId;

            //setting up difference master and child contract in each test as keeping them same in parallel execution causes orphaned contracts to be left in CRM
            masterContract.contractNumber = MasterContractNumberForTest;
            masterContract.contracts[0].contractNumber = ContractNumberForTest;

            _masterContractGuid = contractsManager.CreateContract(TransformCorpContractToExtendedCorpContract(masterContract), correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            contractType currentContract = masterContract.contracts.First();
            DateTime now = DateTime.Now.ToUniversalTime();
            currentContract.StatusLastUpdatedDate = now;

            xrmDocumentManager.UpdateContractSubStatus(currentContract, "Document Transfer in Progress");
            xrmDocumentManager.UpdateContractPublishedToProviderForElectronicApproval(currentContract);

            var contracts = GetContractsForMaster(_masterContractGuid);

            Assert.AreEqual(1, contracts.Count, $"There should only be one contract for this master {masterContract.contractNumber}");

            var contract = contracts.First();

            var contractStatusEntityReference = contract.GetAttributeValue<EntityReference>(CrmContractFieldName.SubStatus);

            IReadOnlyCollection<sfa_transition> transitions =
                GetTransitionsForContractStatusAndOwner(contractStatusEntityReference, GetTeamEntityReference("Contract Managers Team"));

            // the list of transitions should not contain 'Confirm Receipt of Signed Contract' for electronic
            Assert.AreEqual(0, transitions.Count(s => s.sfa_name == TransitionConfirmReceiptofSignedContract));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmDocumentManager_ShouldSetTheContractStatusAndShowAppropriateTransitionsWhenManualApproval()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            var masterContract = GetCorpContract();
            var contractsManager = GetContractsManager();
            XrmDocumentManager xrmDocumentManager = new XrmDocumentManager
            {
                OrganizationService = CrmOrganizationService
            };

            contractsManager.BatchId = batchId;

            //setting up difference master and child contract in each test as keeping them same in parallel execution causes orphaned contracts to be left in CRM
            masterContract.contractNumber = MasterContractNumberForTest;
            masterContract.contracts[0].contractNumber = ContractNumberForTest;

            _masterContractGuid = contractsManager.CreateContract(TransformCorpContractToExtendedCorpContract(masterContract), correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            contractType currentContract = masterContract.contracts.First();
            DateTime now = DateTime.Now.ToUniversalTime();
            currentContract.StatusLastUpdatedDate = now;

            xrmDocumentManager.UpdateContractSubStatus(currentContract, "Document Transfer in Progress");
            xrmDocumentManager.UpdateContractPublishedToProviderManualApproval(currentContract);

            var contracts = GetContractsForMaster(_masterContractGuid);

            Assert.AreEqual(1, contracts.Count, $"There should only be one contract for this master {masterContract.contractNumber}");

            var contract = contracts.First();

            var contractStatusEntityReference = contract.GetAttributeValue<EntityReference>(CrmContractFieldName.SubStatus);

            IReadOnlyCollection<sfa_transition> transitions =
                GetTransitionsForContractStatusAndOwner(contractStatusEntityReference, GetTeamEntityReference("Contract Advisers Team"));

            // the list of transitions should contain 'Confirm Receipt of Signed Contract' for manual
            Assert.AreEqual(1, transitions.Count(s => s.sfa_name == TransitionConfirmReceiptofSignedContract));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmDocumentManager_UpdateContractPublishedToProvider_CalledWithSuccess_AutoApproval_ShouldUpdateContractServiceWithResponseDocumentPublishedForAutoApproval()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            var masterContract = GetCorpContract();
            var contractsManager = GetContractsManager();
            XrmDocumentManager xrmDocumentManager = new XrmDocumentManager
            {
                OrganizationService = CrmOrganizationService
            };

            contractsManager.BatchId = batchId;

            //setting up difference master and child contract in each test as keeping them same in parallel execution causes orphaned contracts to be left in CRM
            masterContract.contractNumber = MasterContractNumberForTest;
            masterContract.contracts[0].contractNumber = ContractNumberForTest;
            masterContract.contracts[0].amendmentType = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.amendmentType.Notification.ToString();

            _masterContractGuid = contractsManager.CreateContract(TransformCorpContractToExtendedCorpContract(masterContract), correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            contractType currentContract = masterContract.contracts.First();
            DateTime now = DateTime.Now.ToUniversalTime();
            currentContract.StatusLastUpdatedDate = now;

            xrmDocumentManager.UpdateContractSubStatus(currentContract, "Document Transfer in Progress");
            xrmDocumentManager.UpdateContractPublishedToProviderForAutoApproval(currentContract);

            var contracts = GetContractsForMaster(_masterContractGuid);

            foreach (var contract in contracts)
            {
                var serviceResponse = contract.GetAttributeValue<OptionSetValue>(CrmContractFieldName.ServiceResponse);
                DateTime contractPublishDate = contract.GetAttributeValue<DateTime>(CrmContractFieldName.PublishedDate);

                Assert.AreEqual(serviceResponse.Value, ((int)sfa_serviceresponse.DocumentPublishedForAutoApproval),
                    $"Service Response returns {serviceResponse.Value} but expected is {sfa_serviceresponse.DocumentPublishedForAutoApproval}");

                Assert.IsTrue(contractPublishDate.IsDateTimeEqualTo(now),
                    $"Published date returns {contractPublishDate} but expected is {now}");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmDocumentManager_UpdateContractPublishedToProviderForAutoApproval_ShouldNotUpdateIfContractIsInRightState()
        {
            // arrange
            Guid contractId = CreateContract(SecondContractNumber, 1);
            UpdateContractStatus(contractId, sfa_contractstatus.Draft, "Published to Provider");

            var mockOrgService = new Mock<OrganizationService>(CrmOrganizationService) { CallBase = true };

            XrmDocumentManager documentManager = new XrmDocumentManager { OrganizationService = mockOrgService.Object };

            contractType contract = new contractType
            {
                contractNumber = SecondContractNumber,
                contractVersionNumber = 1,
                contractSubVersionNumber = 0,
                StatusLastUpdatedDate = new DateTime(2017, 1, 1)
            };

            // act
            documentManager.UpdateContractPublishedToProviderForAutoApproval(contract);

            // assert
            mockOrgService.Verify(m => m.Update(It.IsAny<sfa_contract>()), Times.Never);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmDocumentManager_UpdateContractPublishedToProvider_CalledWithFailure_ShouldUpdateContractServiceWithResponseDocumentPublishFailed()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            var masterContract = GetCorpContract();
            var contractsManager = GetContractsManager();
            XrmDocumentManager xrmDocumentManager = new XrmDocumentManager
            {
                OrganizationService = CrmOrganizationService
            };

            contractsManager.BatchId = batchId;

            //setting up difference master and child contract in each test as keeping them same in parallel execution causes orphaned contracts to be left in CRM
            masterContract.contractNumber = MasterContractNumberForTest;
            masterContract.contracts[0].contractNumber = ContractNumberForTest;

            _masterContractGuid = contractsManager.CreateContract(TransformCorpContractToExtendedCorpContract(masterContract), correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            contractType currentContract = masterContract.contracts.First();
            DateTime now = DateTime.Now;
            currentContract.StatusLastUpdatedDate = now;
            string failureReason = "Failed because something";

            xrmDocumentManager.UpdateContractSubStatus(currentContract, "Document Transfer in Progress");
            xrmDocumentManager.UpdateContractPublishedToProviderFailed(currentContract, failureReason);

            var contracts = GetContractsForMaster(_masterContractGuid);

            foreach (var contract in contracts)
            {
                var serviceResponse = contract.GetAttributeValue<OptionSetValue>(CrmContractFieldName.ServiceResponse);
                var reasonForFailure = GetCommentsFromLastWorkflowHistory(contract.Id);

                Assert.AreEqual(serviceResponse.Value, (int)sfa_serviceresponse.DocumentPublishFailed,
                    $"Service Response returns {serviceResponse.Value} but expected is {sfa_serviceresponse.DocumentPublishFailed}");

                Assert.IsTrue(reasonForFailure == failureReason,
                    $"Reason for failure returns {reasonForFailure} but expected is {failureReason}");
            }
        }

        private static void RemoveTestContracts()
        {
            var columnValues = new List<ColumnValueCriteria>()
            {
                new ColumnValueCriteria("sfa_number", ConditionOperator.Equal, ContractNumberForTest)
            };

            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria() { EntityName = CrmEntityName.Contract, LookupCriteria = columnValues };
            CrmManager.GetCrmEntities(lookupCriteria).ForEach(CrmManager.DeleteEntity);

            columnValues.Clear();
            columnValues.Add(new ColumnValueCriteria("sfa_number", ConditionOperator.Equal, MasterContractNumberForTest));

            CrmManager.GetCrmEntities(lookupCriteria).ForEach(CrmManager.DeleteEntity);
        }

        private static void AssertSubStatus(string expectedStatus, Guid contractId)
        {
            var count = 15;
            var subStatusResponse = string.Empty;

            while (count > 0)
            {
                subStatusResponse = GetContractSubStatus(contractId);
                if (subStatusResponse == expectedStatus)
                {
                    break;
                }
                count--;
                System.Threading.Tasks.Task.Delay(2000).Wait();
            }

            if (count == 0)
            {
                Assert.Fail(
                    $"The substatus was expected to be {expectedStatus}, however it was actually {subStatusResponse}");
            }
        }

        private static string GetContractSubStatus(Guid contractId)
        {

            using (var xrmContext = new XrmServiceContext(CrmOrganizationService))
            {
                var contract = (from t in xrmContext.sfa_contractSet
                                where (t.sfa_contractId == contractId)
                                select t).FirstOrDefault();

                if (contract != null)
                {
                    return contract.sfa_SubStatus.Name;
                }

                return "NotFound";
            }
        }

        private static string GetCommentsFromLastWorkflowHistory(Guid contractId)
        {

            using (var xrmContext = new XrmServiceContext(CrmOrganizationService))
            {
                var latestworkflowhistory = (from t in xrmContext.sfa_contracttransitionhistorySet
                                             where (t.sfa_Contract.Id == contractId)
                                             orderby t.CreatedOn descending
                                             select t).FirstOrDefault();

                if (latestworkflowhistory != null)
                {
                    return latestworkflowhistory.sfa_Comments;
                }

                return "NotFound";
            }
        }

        private static IReadOnlyCollection<sfa_transition> GetTransitionsForContractStatusAndOwner(EntityReference statusEntityReference, EntityReference owner)
        {
            using (var xrmContext = new XrmServiceContext(CrmOrganizationService))
            {
                return (from t in xrmContext.sfa_transitionSet
                        where t.sfa_FromAction.Equals(statusEntityReference)
                        && t.OwnerId.Equals(owner)
                        select t).ToList();
            }
        }

        private static EntityReference GetTeamEntityReference(string teamName)
        {
            using (var xrmContext = new XrmServiceContext(CrmOrganizationService))
            {
                return xrmContext.TeamSet.Single(t => t.Name == teamName).ToEntityReference();
            }
        }

        private static Guid CreateContract(string contractNumberTest, int versionNumberTest)
        {
            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = "1",
                sfa_number = contractNumberTest,
                sfa_Version = versionNumberTest,
                sfa_SubVersion = 0,
                sfa_ProviderName = GetOrgEntityReference(),
                sfa_ParentContractId = GetParentId(),
                sfa_ContractPublishedDate = new DateTime(2017, 1, 1)
            };

            return CrmOrganizationService.Create(contract);
        }

        private static EntityReference GetOrgEntityReference()
        {
            using (var crmContext = new XrmServiceContext(CrmOrganizationService))
            {
                return crmContext.AccountSet.First().ToEntityReference();
            }
        }

        private static EntityReference GetParentId()
        {
            using (var crmContext = new XrmServiceContext(CrmOrganizationService))
            {
                return crmContext.sfa_contractSet.First(c => c.sfa_HierarchyType.Value == (int)sfa_contracthierarchytype.Master).ToEntityReference();
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

        private static void DeleteEntities(Func<XrmServiceContext, IEnumerable<Entity>> getEntities)
        {
            using (var xrmContext = new XrmServiceContext(CrmOrganizationService))
            {
                getEntities(xrmContext).ForEach(c => CrmOrganizationService.Delete(sfa_contract.EntityLogicalName, c.Id));
            }
        }
    }
}
