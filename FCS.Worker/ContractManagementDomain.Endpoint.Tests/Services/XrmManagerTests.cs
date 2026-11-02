namespace ContractManagementDomain.Endpoint.Tests.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Endpoint.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class XrmManagerTests : IntegrationTestBase
    {
        private Guid _masterContractGuid;

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

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void UpdateContractForApproval_ForNotification_UpdatesContractInCrmSuccessful()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            var masterContract = GetCorpContract();
            masterContract.contracts.Add(new contractType
            {
                period = masterContract.contracts[0].period
            });

            var contractsManager = GetContractsManager();
            IXrmManager xrmManager = new XrmManager(CrmOrganizationService);

            contractsManager.BatchId = batchId;

            masterContract.contractNumber = $"SFA-{DateTime.Now.ToString("yyMMddHHmmss")}";

            var versionNumber = 1;
            foreach (var contract in masterContract.contracts)
            {
                contract.contractNumber = $"24Loans-{DateTime.Now.ToString("yyMMddHHmmss")}";
                contract.amendmentType = "Notification";
                contract.contractSubVersionNumber = 1;
                contract.contractVersionNumber = versionNumber++;
            }

            _masterContractGuid = contractsManager.CreateContract(TransformCorpContractToExtendedCorpContract(masterContract), correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            UpdateContractSubStatus(masterContract.contracts[1], "Published to Provider");

            contractType currentContract = masterContract.contracts[1];
            currentContract.StatusLastUpdatedDate = DateTime.Now;

            xrmManager.UpdateContractForNotificationApproval(currentContract);

            var contracts = GetContractsForMaster(_masterContractGuid);

            foreach (var contract in contracts)
            {
                var contractServiceResponse = contract.GetAttributeValue<OptionSetValue>("sfa_serviceresponse");

                if (contract.GetAttributeValue<int>(CrmContractFieldName.Version) == 2)
                {
                    Assert.AreEqual((int)sfa_serviceresponse.MarkAsAutomaticallyApproved, contractServiceResponse.Value,
                        $"Contract service response is {contractServiceResponse} but expected {nameof(sfa_serviceresponse.MarkAsAutomaticallyApproved)}");
                }
                else
                {
                    Assert.IsNull(contractServiceResponse, "Contract should not have a service response");
                }
            }
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void UpdateContractForElectronicApproval_UpdatesContractInCrmSuccessful()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            var masterContract = GetCorpContract();
            masterContract.contracts.Add(new contractType
            {
                period = masterContract.contracts[0].period
            });

            var contractsManager = GetContractsManager();
            var xrmManager = new XrmManager(CrmOrganizationService);

            contractsManager.BatchId = batchId;

            masterContract.contractNumber = $"SFA-{DateTime.Now.ToString("yyMMddHHmmss")}";

            var versionNumber = 1;
            foreach (var contract in masterContract.contracts)
            {
                contract.contractNumber = $"24Loans-{DateTime.Now.ToString("yyMMddHHmmss")}";
                contract.contractSubVersionNumber = 1;
                contract.contractVersionNumber = versionNumber++;
            }

            _masterContractGuid = contractsManager.CreateContract(TransformCorpContractToExtendedCorpContract(masterContract), correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            UpdateContractSubStatus(masterContract.contracts[1], "Published to Provider");

            contractType currentContract = masterContract.contracts[1];
            currentContract.StatusLastUpdatedDate = DateTime.Now;

            xrmManager.UpdateContractForElectronicApproval(currentContract);

            var contracts = GetContractsForMaster(_masterContractGuid);

            foreach (var contract in contracts)
            {
                var contractServiceResponse = contract.GetAttributeValue<OptionSetValue>("sfa_serviceresponse");

                if (contract.GetAttributeValue<int>(CrmContractFieldName.Version) == 2)
                {
                    Assert.AreEqual((int)sfa_serviceresponse.MarkAsElectronicApproved, contractServiceResponse.Value,
                        $"Contract service response is {contractServiceResponse} but expected {nameof(sfa_serviceresponse.MarkAsAutomaticallyApproved)}");
                }
                else
                {
                    Assert.IsNull(contractServiceResponse, "Contract should not have a service response");
                }
            }
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void XrmManager_ShouldUpdateContractInCrmSuccessfullyOnManualApproval()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            // arrange
            var masterContract = GetCorpContract();
            masterContract.contracts.Add(new contractType
            {
                period = masterContract.contracts[0].period
            });

            var contractsManager = GetContractsManager();
            var xrmManager = new XrmManager(CrmOrganizationService);

            contractsManager.BatchId = batchId;

            masterContract.contractNumber = $"SFA-{DateTime.Now.ToString("yyMMddHHmmss")}";

            var versionNumber = 1;
            foreach (var contract in masterContract.contracts)
            {
                contract.contractNumber = $"24Loans-{DateTime.Now.ToString("yyMMddHHmmss")}";
                contract.contractSubVersionNumber = 1;
                contract.contractVersionNumber = versionNumber++;
            }

            _masterContractGuid = contractsManager.CreateContract(TransformCorpContractToExtendedCorpContract(masterContract), correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            UpdateContractSubStatus(masterContract.contracts[1], "Approval in Progress");

            contractType currentContract = masterContract.contracts[1];
            currentContract.StatusLastUpdatedDate = DateTime.Now;

            // act
            xrmManager.UpdateContractForManualApproval(currentContract);

            // assert
            var contracts = GetContractsForMaster(_masterContractGuid);

            foreach (var contract in contracts)
            {
                var contractServiceResponse = contract.GetAttributeValue<OptionSetValue>("sfa_serviceresponse");

                if (contract.GetAttributeValue<int>(CrmContractFieldName.Version) == 2)
                {
                    Assert.AreEqual((int)sfa_serviceresponse.MarkAsManuallyApproved, contractServiceResponse.Value,
                        $"Contract service response is {contractServiceResponse} but expected {nameof(sfa_serviceresponse.MarkAsAutomaticallyApproved)}");
                }
                else
                {
                    Assert.IsNull(contractServiceResponse, "Contract should not have a service response");
                }
            }
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void XrmManager_ShouldUpdateContractInCrmFailureOnManualApproval()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            string reasonForFailure = "There was a failure to approve contract for UKPRN: {0} & Contract: {1}. This failure was caused by contracting activity having closed for {2} contracts.";
            // arrange
            var masterContract = GetCorpContract();
            //masterContract.contracts.Add(new contractType
            //{
            //    period = masterContract.contracts[0].period
            //});

            var contractsManager = GetContractsManager();
            var xrmManager = new XrmManager(CrmOrganizationService);

            contractsManager.BatchId = batchId;

            masterContract.contractNumber = $"SFA-{DateTime.Now.ToString("yyMMddHHmmss")}";

            var versionNumber = 1;
            foreach (var contract in masterContract.contracts)
            {
                contract.contractNumber = $"24Loans-{DateTime.Now.ToString("yyMMddHHmmss")}";
                contract.contractSubVersionNumber = 1;
                contract.contractVersionNumber = versionNumber++;
            }

            _masterContractGuid = contractsManager.CreateContract(TransformCorpContractToExtendedCorpContract(masterContract), correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            UpdateContractSubStatus(masterContract.contracts[0], "Approval in Progress");

            contractType currentContract = masterContract.contracts[0];
            currentContract.StatusLastUpdatedDate = DateTime.Now;

            reasonForFailure = string.Format(reasonForFailure, masterContract.contracts[0].contractor.ukprn,
                masterContract.contracts[0].contractNumber, masterContract.contracts[0].fundingType.fundingTypeName);

            // act
            xrmManager.UpdateContractForManualFailure(currentContract, reasonForFailure);

            // assert
            var contracts = GetContractsForMaster(_masterContractGuid);

            foreach (var contract in contracts)
            {
                var contractServiceResponse = contract.GetAttributeValue<OptionSetValue>("sfa_serviceresponse");

                if (contract.GetAttributeValue<int>(CrmContractFieldName.Version) == 1)
                {
                    Assert.AreEqual((int)sfa_serviceresponse.ManualApprovalFailed, contractServiceResponse.Value,
                        $"Contract service response is {contractServiceResponse} but expected {nameof(sfa_serviceresponse.ManualApprovalFailed)}");
                }
                else
                {
                    Assert.IsNull(contractServiceResponse, "Contract should not have a service response");
                }
            }
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void UpdateContractForWithdrawalSuccessful_UpdatesContractInCrmSuccessful()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            var masterContract = GetCorpContract();
            var contractsManager = GetContractsManager();
            var xrmManager = new XrmManager(CrmOrganizationService);

            contractsManager.BatchId = batchId;

            string masterContractNumber = $"SFA-{DateTime.Now.ToUniversalTime().ToString("yyMMddHHmmss")}";
            string contractNumber = $"24Loans-{DateTime.Now.ToUniversalTime().ToString("yyMMddHHmmss")}";

            masterContract.contractNumber = masterContractNumber;
            masterContract.contracts[0].contractNumber = contractNumber;
            masterContract.contracts[0].contractVersionNumber = 1;
            masterContract.contracts[0].contractSubVersionNumber = 2;

            var contractSV1 = new contractType()
            {
                contractNumber = masterContract.contracts[0].contractNumber,
                contractVersionNumber = masterContract.contracts[0].contractVersionNumber,
                contractSubVersionNumber = 1,
                period = masterContract.contracts[0].period
            };
            masterContract.contracts.Insert(0, contractSV1);

            masterContract.contracts.ForEach(c => c.contractor.Status = "Active");

            _masterContractGuid = contractsManager.CreateContract(TransformCorpContractToExtendedCorpContract(masterContract), correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            contractType currentContract = masterContract.contracts.Last();
            DateTime now = DateTime.Now.ToUniversalTime();
            currentContract.StatusLastUpdatedDate = now;

            UpdateContractSubStatus(masterContract.contracts[1], "Withdrawal In Progress");

            xrmManager.UpdateContractForWithdrawalSuccessful(currentContract);

            var contracts = GetContractsForMaster(_masterContractGuid);

            foreach (var contract in contracts)
            {
                var serviceResponse = contract.GetAttributeValue<OptionSetValue>(CrmContractFieldName.ServiceResponse);
                DateTime contractWithdrawnDate = contract.GetAttributeValue<DateTime>(CrmContractFieldName.WithdrawnDate);

                if (contract.GetAttributeValue<int>(CrmContractFieldName.SubVersion) == 2)
                {
                    Assert.AreEqual(serviceResponse.Value, ((int)sfa_serviceresponse.WithdrawalSuccessful),
                        $"Service Response returns {serviceResponse.Value} but expected is {sfa_serviceresponse.WithdrawalSuccessful}");

                    Assert.IsTrue(contractWithdrawnDate.IsDateTimeEqualTo(now),
                        $"Withdrawn date returns {contractWithdrawnDate} but expected is {now}");
                }
                else
                {
                    Assert.IsNull(serviceResponse, $"Service Response for sub version 1 should be null");
                }
            }
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void UpdateContractForWithdrawalByProviderSuccessful_UpdatesContractInCrmSuccessful()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            var masterContract = GetCorpContract();
            var contractsManager = GetContractsManager();
            var xrmManager = new XrmManager(CrmOrganizationService);

            contractsManager.BatchId = batchId;

            string masterContractNumber = $"SFA-{DateTime.Now.ToUniversalTime().ToString("yyMMddHHmmss")}";
            string contractNumber = $"24Loans-{DateTime.Now.ToUniversalTime().ToString("yyMMddHHmmss")}";

            masterContract.contractNumber = masterContractNumber;
            masterContract.contracts[0].contractNumber = contractNumber;
            masterContract.contracts[0].contractVersionNumber = 1;
            masterContract.contracts[0].contractSubVersionNumber = 2;

            var contractSV1 = new contractType()
            {
                contractNumber = masterContract.contracts[0].contractNumber,
                contractVersionNumber = masterContract.contracts[0].contractVersionNumber,
                contractSubVersionNumber = 1,
                period = masterContract.contracts[0].period
            };
            masterContract.contracts.Insert(0, contractSV1);

            _masterContractGuid = contractsManager.CreateContract(TransformCorpContractToExtendedCorpContract(masterContract), correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            contractType currentContract = masterContract.contracts.Last();
            DateTime now = DateTime.Now.ToUniversalTime();
            currentContract.StatusLastUpdatedDate = now;

            UpdateContractSubStatus(masterContract.contracts[1], "Withdrawal In Progress");

            xrmManager.UpdateContractForWithdrawalByProviderSuccessful(currentContract);

            var contracts = GetContractsForMaster(_masterContractGuid);

            foreach (var contract in contracts)
            {
                var serviceResponse = contract.GetAttributeValue<OptionSetValue>(CrmContractFieldName.ServiceResponse);
                DateTime contractWithdrawnDate = contract.GetAttributeValue<DateTime>(CrmContractFieldName.WithdrawnDate);

                if (contract.GetAttributeValue<int>(CrmContractFieldName.SubVersion) == 2)
                {
                    Assert.AreEqual(serviceResponse.Value, ((int)sfa_serviceresponse.WithdrawalOnBehalfOfProviderSuccessful),
                        $"Service Response returns {serviceResponse.Value} but expected is {sfa_serviceresponse.WithdrawalOnBehalfOfProviderSuccessful}");

                    Assert.IsTrue(contractWithdrawnDate.IsDateTimeEqualTo(now),
                        $"Withdrawn date returns {contractWithdrawnDate} but expected is {now}");
                }
                else
                {
                    Assert.IsNull(serviceResponse, $"Service Response for sub version 1 should be null");
                }
            }
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void UpdateContractForAutoWithdrawalSuccessful_UpdatesContractInCrmSuccessful()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            var masterContract = GetCorpContract();
            var contractsManager = GetContractsManager();
            var xrmManager = new XrmManager(CrmOrganizationService);

            contractsManager.BatchId = batchId;

            string masterContractNumber = $"SFA-{DateTime.Now.ToUniversalTime().ToString("yyMMddHHmmss")}";
            string contractNumber = $"24Loans-{DateTime.Now.ToUniversalTime().ToString("yyMMddHHmmss")}";

            masterContract.contractNumber = masterContractNumber;
            masterContract.contracts[0].contractNumber = contractNumber;
            masterContract.contracts[0].contractVersionNumber = 1;
            masterContract.contracts[0].contractSubVersionNumber = 2;

            var contractSV1 = new contractType()
            {
                contractNumber = masterContract.contracts[0].contractNumber,
                contractVersionNumber = masterContract.contracts[0].contractVersionNumber,
                contractSubVersionNumber = 1,
                period = masterContract.contracts[0].period
            };
            masterContract.contracts.Insert(0, contractSV1);

            _masterContractGuid = contractsManager.CreateContract(TransformCorpContractToExtendedCorpContract(masterContract), correlationId);
            Assert.IsTrue(_masterContractGuid != null);

            contractType currentContract = masterContract.contracts.Last();
            DateTime now = DateTime.Now.ToUniversalTime();
            currentContract.StatusLastUpdatedDate = now;

            UpdateContractSubStatus(masterContract.contracts[1], "Published to Provider");

            xrmManager.UpdateContractForAutoWithdrawalSuccessful(currentContract);

            var contracts = GetContractsForMaster(_masterContractGuid);

            foreach (var contract in contracts)
            {
                var serviceResponse = contract.GetAttributeValue<OptionSetValue>(CrmContractFieldName.ServiceResponse);
                DateTime contractWithdrawnDate = contract.GetAttributeValue<DateTime>(CrmContractFieldName.WithdrawnDate);

                if (contract.GetAttributeValue<int>(CrmContractFieldName.SubVersion) == 2)
                {
                    Assert.AreEqual(serviceResponse.Value, ((int)sfa_serviceresponse.AutoWithdrawalSuccessful),
                        $"Service Response returns {serviceResponse.Value} but expected is {sfa_serviceresponse.AutoWithdrawalSuccessful}");

                    Assert.IsTrue(contractWithdrawnDate.IsDateTimeEqualTo(now),
                        $"Withdrawn date returns {contractWithdrawnDate} but expected is {now}");
                }
                else
                {
                    Assert.IsNull(serviceResponse, $"Service Response for sub version 1 should be null");
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmManager_UpdateBulkWithdrawalByAgencySuccessful_ShouldUpdateContractInCrm()
        {
            // arrange
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            var masterContract = GetCorpContract();
            var contractsManager = GetContractsManager();
            var xrmManager = new XrmManager(CrmOrganizationService);

            contractsManager.BatchId = batchId;

            string masterContractNumber = $"SFA-{DateTime.Now.ToUniversalTime().ToString("yyMMddHHmmss")}";
            string contractNumber = $"24Loans-{DateTime.Now.ToUniversalTime().ToString("yyMMddHHmmss")}";

            masterContract.contractNumber = masterContractNumber;
            masterContract.contracts[0].contractNumber = contractNumber;
            masterContract.contracts[0].contractVersionNumber = 1;

            _masterContractGuid = contractsManager.CreateContract(TransformCorpContractToExtendedCorpContract(masterContract), correlationId);
            UpdateContractSubStatus(masterContract.contracts.Single(), "Published to Provider");

            contractType currentContract = masterContract.contracts.Single();
            currentContract.StatusLastUpdatedDate = DateTime.UtcNow;

            // act
            xrmManager.UpdateContractForBulkWithdrawalByAgencySuccessful(currentContract);

            // assert
            Entity contract = GetContractsForMaster(_masterContractGuid).Single();
            OptionSetValue serviceResponse = contract.GetAttributeValue<OptionSetValue>(CrmContractFieldName.ServiceResponse);

            Assert.AreEqual(serviceResponse.Value, (int)sfa_serviceresponse.BulkWithdrawalByAgency,
                $"Service Response returns {serviceResponse.Value} but expected is {sfa_serviceresponse.BulkWithdrawalByAgency}");
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void XrmManager_ShouldUpdateContractToPublishProviderFailed()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";
            const string ukprn = "10000673";
            contract masterContract = GetCorpContract();

            // pre-cleanup
            GetContractsForUkprn(ukprn)
                .ToList()
                .OrderByDescending(c => c.GetAttributeValue<OptionSetValue>("sfa_hierarchytype").Value)
                .ForEach(c => CrmOrganizationService.Delete(sfa_contract.EntityLogicalName, c.Id));

            DeleteContractsForNumber(masterContract.contracts.Single().contractNumber);
            DeleteMasterAndChildContractsForNumber(masterContract.contractNumber);

            // arrange
            masterContract.contractor.ukprn = int.Parse(ukprn);
            masterContract.contracts.ForEach(c =>
            {
                c.contractor.ukprn = int.Parse(ukprn);
                c.contractor.Status = "Active";
            });

            var contractsManager = GetContractsManager();
            var xrmManager = new XrmManager(CrmOrganizationService);

            contractsManager.BatchId = batchId;

            masterContract.contractNumber = $"SFA-{DateTime.Now.ToString("yyMMddHHmmss")}";

            _masterContractGuid = contractsManager.CreateContract(TransformCorpContractToExtendedCorpContract(masterContract), correlationId);
            Assert.IsTrue(_masterContractGuid != null);
            UpdateContractSubStatus(masterContract.contracts[0], "Document Transfer in Progress");

            contractType currentContract = masterContract.contracts[0];

            const string reason = "XX";

            // act
            xrmManager.UpdateContractPublishedToProviderFailed(currentContract.contractNumber, currentContract.contractVersionNumber, currentContract.contractSubVersionNumber, reason);

            // assert
            var childContract = GetContractsForMaster(_masterContractGuid).Single();

            var contractServiceResponse = childContract.GetAttributeValue<OptionSetValue>("sfa_serviceresponse");
            Assert.AreEqual((int)sfa_serviceresponse.DocumentPublishFailed, contractServiceResponse.Value, "Contract service response is not correct");
            // this reason gets removed from the contract by CRM so we have not checked it here
        }

        [TestCleanup]
        public void TearDown()
        {
            RemoveMasterAndChildContracts(_masterContractGuid);
        }

        private void UpdateContractSubStatus(contractType contract, string subStatus)
        {
            var updateContractObject = new sfa_contract { Id = GetXrmContract(contract.contractNumber).Id };

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

                updateContractObject.EntityState = EntityState.Changed;
                CrmOrganizationService.Update(updateContractObject);
            }

        }

        private List<sfa_contract> GetMatchingXrmContracts(string contractNumber)
        {
            using (var xrmContext = new XrmServiceContext(CrmOrganizationService))
            {
                return (from c in xrmContext.sfa_contractSet
                        join m in xrmContext.sfa_contractSet on c.sfa_ParentContractId.Id equals m.sfa_contractId
                        where c.sfa_number == contractNumber
                        select c).ToList();
            }
        }

        private sfa_contract GetXrmContract(string contractNumber) => GetMatchingXrmContracts(contractNumber).MaxBy(c => (double)(c.sfa_Version ?? 0) + (((double?)c.sfa_SubVersion / 100) ?? 0));

        private static void DeleteContractsForNumber(string contractNumber)
        {
            
            using (XrmServiceContext context = new XrmServiceContext(CrmOrganizationService))
            {
                context.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.Id)
                    .ForEach(id => CrmOrganizationService.Delete("sfa_contract", id));
            }
        }

        private static void DeleteMasterAndChildContractsForNumber(string masterContractNumber)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmOrganizationService))
            {
                List<string> childContractNumbers = (
                    from c in context.sfa_contractSet
                    join m in context.sfa_contractSet on c.sfa_ParentContractId.Id equals m.sfa_contractId
                    where m.sfa_number == masterContractNumber
                    select c.sfa_number).ToList();

                childContractNumbers.ForEach(DeleteContractsForNumber);

                DeleteContractsForNumber(masterContractNumber);
            }
        }
    }
}
