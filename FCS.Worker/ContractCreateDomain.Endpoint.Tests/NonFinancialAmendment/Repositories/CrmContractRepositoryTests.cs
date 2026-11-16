namespace ContractCreateDomain.Endpoint.Tests.NonFinancialAmendment.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Endpoint.NonFinancialAmendment.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    
    [TestClass]
    public class CrmContractRepositoryTests
    {
        private const string TestContractNumber = "12345678";
        private const string TestPeriodName = "Test-FundingTypeCode1718_3";

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_IsContractApproved_WhenStatusAndSubstatusIsNotApproved_ShouldReturnFalse()
        {
            // Arrange
            sfa_contract contract;

            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                RemoveContract(organizationService, xrmContext, TestContractNumber);
                contract = GetDefaultContract(xrmContext, TestContractNumber);
                organizationService.Create(contract);
            }

            var contractRepository = new CrmContractRepository(organizationService);
            // Act
            bool isValid = contractRepository.IsContractApproved(contract.sfa_number, contract.sfa_Version.Value, contract.sfa_SubVersion.Value);

            //Assert
            Assert.IsFalse(isValid);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_IsContractApproved_WhenStatusAndSubstatusIsApproved_ShouldReturnTrue()
        {
            // Arrange
            sfa_contract contract;

            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                RemoveContract(organizationService, xrmContext, TestContractNumber);

                contract = GetDefaultContract(xrmContext, TestContractNumber);
                contract.sfa_ContractStatus = new OptionSetValue((int) sfa_contractstatus.Approved);
                contract.sfa_SubStatus = GetSubstatus(xrmContext, "Approved");
                contract.Id = organizationService.Create(contract);

                UpdateContract(organizationService, contract);
            }

            var contractRepository = new CrmContractRepository(organizationService);
            // Act
            bool isValid = contractRepository.IsContractApproved(contract.sfa_number, contract.sfa_Version.Value, contract.sfa_SubVersion.Value);

            //Assert
            Assert.IsTrue(isValid);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_ShouldSetServiceResponseToNonFinancialAmendmentFailed()
        {
            // arrange
            const string contractNumber = "SRTEST-456";
            const int versionNumber = 1;
            const int subVersionNumber = 0;
            Guid contractId;

            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                RemoveContract(organizationService, xrmContext, contractNumber);

                var contract = GetDefaultContract(xrmContext, contractNumber);
                contract.sfa_ContractStatus = new OptionSetValue((int) sfa_contractstatus.Approved);
                contract.sfa_SubStatus = GetSubstatus(xrmContext, "Approved");
                contractId = organizationService.Create(contract);
            }

            var contractRepository = new CrmContractRepository(organizationService);
            // act
            contractRepository.SetNonFinancialAmendmentFailedServiceResponseOnContract(contractNumber, versionNumber, subVersionNumber);

            // assert
            var serviceResponse = ((sfa_contract) organizationService.Retrieve(sfa_contract.EntityLogicalName, contractId, new ColumnSet(true))).sfa_ServiceResponse;

            Assert.IsNotNull(serviceResponse, "Service response was null");
            Assert.AreEqual(sfa_serviceresponse.NonFinancialAmendmentInitiationFailed, (sfa_serviceresponse) serviceResponse.Value,
                "Service response was not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetFundingTypeFundingPeriodKeyForGivenContract_ShouldGetFundingTypeFundingPeriod()
        {
            // Arrange
            const string testFundingTypeCode = "Test-FundingTypeCode_L";
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {

                RemoveContract(organizationService, xrmContext, TestContractNumber);
                RemoveFundingType(organizationService, xrmContext, testFundingTypeCode);
                RemovePeriod(organizationService, xrmContext, TestPeriodName);

                var contract = GetDefaultContract(xrmContext, TestContractNumber);
                contract.sfa_FundingType = CreateFundingType(organizationService, testFundingTypeCode);
                contract.sfa_PeriodId = CreatePeriod(organizationService, TestPeriodName);
                organizationService.Create(contract);
            }

            var contractRepository = new CrmContractRepository(organizationService);
            // Act
            var fundingTypeFundingPeriodKeyForGivenContract = contractRepository.GetFundingTypeFundingPeriodKeyForGivenContract(TestContractNumber, 1, 0);

            // Assert
            Assert.AreEqual(TestPeriodName, fundingTypeFundingPeriodKeyForGivenContract.FundingPeriodName);
            Assert.AreEqual(testFundingTypeCode, fundingTypeFundingPeriodKeyForGivenContract.FundingTypeCode);

            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                RemoveContract(organizationService, xrmContext, TestContractNumber);
                RemoveFundingType(organizationService, xrmContext, testFundingTypeCode);
                RemovePeriod(organizationService, xrmContext, TestPeriodName);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_IsThereNoSubsequentDraftContracts_WhenGivenAContractWhereSubsequentDraftVersionsDoNotExist_ShouldReturnTrue()
        {
            // arrange
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                RemoveContract(organizationService, xrmContext, TestContractNumber);

                var contract = GetDefaultContract(xrmContext, TestContractNumber);
                contract.Id = organizationService.Create(contract);

                contract.sfa_ContractStatus = new OptionSetValue((int) sfa_contractstatus.Approved);
                contract.sfa_SubStatus = GetSubstatus(xrmContext, "Approved");
                UpdateContract(organizationService, contract);

                sfa_contract withdrawnContract = new sfa_contract
                {
                    sfa_number = TestContractNumber,
                    sfa_Version = contract.sfa_Version + 1,
                    sfa_SubVersion = 0,
                    sfa_ContractStatus = new OptionSetValue((int) sfa_contractstatus.Withdrawn),
                    sfa_SubStatus = GetSubstatus(xrmContext, "Withdrawn By Agency"),
                    sfa_ProviderName = GetFirstProvider(xrmContext)
                };

                withdrawnContract.Id = organizationService.Create(withdrawnContract);
                UpdateContract(organizationService, withdrawnContract);
            }

            var contractRepository = new CrmContractRepository(organizationService);
            // act
            bool isThereNoSubsequentDraftContracts = contractRepository.IsThereNoSubsequentDraftContracts(TestContractNumber, 1, 0);

            // assert
            Assert.IsTrue(isThereNoSubsequentDraftContracts);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_IsThereNoSubsequentDraftContracts_WhenGivenAContractWhereSubsequentDraftVersionDoExist_ShouldReturnFalse()
        {
            // arrange
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {

                RemoveContract(organizationService, xrmContext, TestContractNumber);

                var contract = GetDefaultContract(xrmContext, TestContractNumber);
                contract.Id = organizationService.Create(contract);

                contract.sfa_ContractStatus = new OptionSetValue((int) sfa_contractstatus.Approved);
                contract.sfa_SubStatus = GetSubstatus(xrmContext, "Approved");
                UpdateContract(organizationService, contract);

                var draftContractv2 = GetDefaultContract(xrmContext, TestContractNumber);
                draftContractv2.sfa_Version = contract.sfa_Version + 1;
                draftContractv2.sfa_ContractStatus = new OptionSetValue((int) sfa_contractstatus.Draft);
                draftContractv2.sfa_SubStatus = GetSubstatus(xrmContext, "Published to Provider");

                draftContractv2.Id = organizationService.Create(draftContractv2);
                UpdateContract(organizationService, draftContractv2);
            }

            var contractRepository = new CrmContractRepository(organizationService);
            // act
            bool isThereNoSubsequentDraftContracts = contractRepository.IsThereNoSubsequentDraftContracts(TestContractNumber, 1, 0);

            // assert
            Assert.IsFalse(isThereNoSubsequentDraftContracts);
        }


        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void CrmContractRepository_IsThereNoSubsequentDraftContracts_WhenGivenContractInformationThatDoNotExist_ShouldThrowAnException()
        {
            // arrange
            const string bogusContractNo = "bogus-contract-number";

            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                RemoveContract(organizationService, xrmContext, bogusContractNo);
            }

            var contractRepository = new CrmContractRepository(organizationService);

            // ✅ act + assert
            Assert.ThrowsException<ArgumentException>(() =>
            {
                contractRepository.IsThereNoSubsequentDraftContracts(bogusContractNo, 1, 0);
            });
        }


        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_IsContractApprovedWithSubstatus_ShouldOnlyBeTrueWhenSubStatusMatchesAProvidedSubStatus()
        {
            // arrange
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                RemoveContract(organizationService, xrmContext, TestContractNumber);

                var contract = GetDefaultContract(xrmContext, TestContractNumber);
                contract.Id = organizationService.Create(contract);

                contract.sfa_ContractStatus = new OptionSetValue((int) sfa_contractstatus.Approved);
                contract.sfa_SubStatus = GetSubstatus(xrmContext, "Under Termination");
                UpdateContract(organizationService, contract);
            }

            var contractRepository = new CrmContractRepository(organizationService);
            // act
            bool expectTrue = contractRepository.IsContractApprovedWithSubstatus(TestContractNumber, 1, 0, new[] {"Under Termination"});
            bool expectFalse = contractRepository.IsContractApprovedWithSubstatus(TestContractNumber, 1, 0, new[] {"Approved"});

            // assert
            Assert.IsTrue(expectTrue, "Should be true for a contract for which the substatus matches a provided substatus");
            Assert.IsFalse(expectFalse, "Should be false for a contract for which the substatus does not match any provided");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_IsContractApprovedWithSubstatus_ShouldReturnFalseWhenStatusIsNotApproved()
        {
            // arrange
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                RemoveContract(organizationService, xrmContext, TestContractNumber);

                var contract = GetDefaultContract(xrmContext, TestContractNumber);
                contract.Id = organizationService.Create(contract);

                contract.sfa_ContractStatus = new OptionSetValue((int) sfa_contractstatus.Closed);
                contract.sfa_SubStatus = GetSubstatus(xrmContext, "Under Termination");
                UpdateContract(organizationService, contract);
            }

            var contractRepository = new CrmContractRepository(organizationService);
            // act
            bool isContractApprovedWithSubstatus = contractRepository.IsContractApprovedWithSubstatus(
                contractNumber: TestContractNumber, 
                versionNumber: 1, 
                subversionNumber: 0, 
                substatuses: new[] {"Approved", "Under Termination"});

            // assert
            Assert.IsFalse(isContractApprovedWithSubstatus, "Unexpected return value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_HasSiblingContractWithDraftStatusOrAmendmentCreationInProgress_ShouldReturnFalseWhenThereAreNoSiblingContracts()
        {
            // Arrange
            const string masterContractNumber = "SFA-9899";
            const string contractNumberPrefix = "MAIN-989";
            const string actContract = contractNumberPrefix + "0";
            const string siblingContract1 = contractNumberPrefix + "1";
            const string siblingContract2 = contractNumberPrefix + "2";
            const string siblingContract3 = contractNumberPrefix + "3";

            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                RemoveContract(organizationService, xrmContext, TestContractNumber);
                RemoveContract(organizationService, xrmContext, siblingContract3);
                RemoveContract(organizationService, xrmContext, siblingContract2);
                RemoveContract(organizationService, xrmContext, siblingContract1);
                RemoveContract(organizationService, xrmContext, actContract);
                RemoveContract(organizationService, xrmContext, masterContractNumber);
            }
            
            var masterContractId = CreateMasterContract(masterContractNumber, 1, 0, sfa_contractstatus.Approved);
            CreateContractWithMasterContractId(actContract, 1, 0, masterContractId, sfa_contractstatus.Approved);

            CrmContractRepository repository = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());
            
            // Act 
            var hasSiblingContractWithDraftStatus = repository.HasSiblingContractWithDraftStatusOrAmendmentCreationInProgress(actContract);

            // Assert
            Assert.IsFalse(hasSiblingContractWithDraftStatus, "Incorrectly detected a sibling contract with Draft status");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_HasSiblingContractWithDraftStatusOrAmendmentCreationInProgress_ShouldReturnFalseWhenAllSiblingContractsDoNotHaveDraftStatus()
        {
            // Arrange
            const string masterContractNumber = "SFA-9899";
            const string contractNumberPrefix = "MAIN-989";
            const string actContract = contractNumberPrefix + "0";
            const string siblingContract1 = contractNumberPrefix + "1";
            const string siblingContract2 = contractNumberPrefix + "2";
            const string siblingContract3 = contractNumberPrefix + "3";

            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                RemoveContract(organizationService, xrmContext, siblingContract3);
                RemoveContract(organizationService, xrmContext, siblingContract2);
                RemoveContract(organizationService, xrmContext, siblingContract1);
                RemoveContract(organizationService, xrmContext, actContract);
                RemoveContract(organizationService, xrmContext, masterContractNumber);
            }

            var masterContractId = CreateMasterContract(masterContractNumber, 1, 0, sfa_contractstatus.Approved);
            CreateContractWithMasterContractId(actContract, 1, 0, masterContractId, sfa_contractstatus.Approved);

            CreateContractWithMasterContractId(siblingContract1, 1, 0, masterContractId, sfa_contractstatus.Approved);
            CreateContractWithMasterContractId(siblingContract2, 1, 0, masterContractId, sfa_contractstatus.Replaced);
            CreateContractWithMasterContractId(siblingContract3, 1, 0, masterContractId, sfa_contractstatus.Withdrawn);

            CrmContractRepository repository = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // Act 
            var hasSiblingContractWithDraftStatus = repository.HasSiblingContractWithDraftStatusOrAmendmentCreationInProgress(actContract);

            // Assert
            Assert.IsFalse(hasSiblingContractWithDraftStatus, "Incorrectly detected a sibling contract with Draft status");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_HasSiblingContractWithDraftStatusOrAmendmentCreationInProgress_ShouldReturnTrueWhenOneSiblingContractsHasDraftStatus()
        {
            // Arrange
            const string masterContractNumber = "SFA-9899";
            const string contractNumberPrefix = "MAIN-989";
            const string actContract = contractNumberPrefix + "0";
            const string siblingContract1 = contractNumberPrefix + "1";
            const string siblingContract2 = contractNumberPrefix + "2";
            const string siblingContract3 = contractNumberPrefix + "3";

            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                RemoveContract(organizationService, xrmContext, siblingContract3);
                RemoveContract(organizationService, xrmContext, siblingContract2);
                RemoveContract(organizationService, xrmContext, siblingContract1);
                RemoveContract(organizationService, xrmContext, actContract);
                RemoveContract(organizationService, xrmContext, masterContractNumber);
            }

            var masterContractId = CreateMasterContract(masterContractNumber, 1, 0, sfa_contractstatus.Approved);
            CreateContractWithMasterContractId(actContract, 1, 0, masterContractId, sfa_contractstatus.Approved);

            CreateContractWithMasterContractId(siblingContract1, 1, 0, masterContractId, sfa_contractstatus.Approved);
            CreateContractWithMasterContractId(siblingContract2, 1, 0, masterContractId, sfa_contractstatus.Replaced);
            CreateContractWithMasterContractId(siblingContract3, 1, 0, masterContractId, sfa_contractstatus.Draft);

            CrmContractRepository repository = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // Act 
            var hasSiblingContractWithDraftStatus = repository.HasSiblingContractWithDraftStatusOrAmendmentCreationInProgress(actContract);

            // Assert
            Assert.IsTrue(hasSiblingContractWithDraftStatus, "Did not detect a sibling contract with Draft status");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_HasSiblingContractWithDraftStatusOrAmendmentCreationInProgress_ShouldReturnTrueWhenMoreThanOneSiblingContractsHasDraftStatus()
        {
            // Arrange
            const string masterContractNumber = "SFA-9899";
            const string contractNumberPrefix = "MAIN-989";
            const string actContract = contractNumberPrefix + "0";
            const string siblingContract1 = contractNumberPrefix + "1";
            const string siblingContract2 = contractNumberPrefix + "2";
            const string siblingContract3 = contractNumberPrefix + "3";

            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                RemoveContract(organizationService, xrmContext, siblingContract3);
                RemoveContract(organizationService, xrmContext, siblingContract2);
                RemoveContract(organizationService, xrmContext, siblingContract1);
                RemoveContract(organizationService, xrmContext, actContract);
                RemoveContract(organizationService, xrmContext, masterContractNumber);
            }

            var masterContractId = CreateMasterContract(masterContractNumber, 1, 0, sfa_contractstatus.Approved);
            CreateContractWithMasterContractId(actContract, 1, 0, masterContractId, sfa_contractstatus.Approved);

            CreateContractWithMasterContractId(siblingContract1, 1, 0, masterContractId, sfa_contractstatus.Approved);
            CreateContractWithMasterContractId(siblingContract2, 1, 0, masterContractId, sfa_contractstatus.Draft);
            CreateContractWithMasterContractId(siblingContract3, 1, 0, masterContractId, sfa_contractstatus.Draft);

            CrmContractRepository repository = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // Act 
            var hasSiblingContractWithDraftStatus = repository.HasSiblingContractWithDraftStatusOrAmendmentCreationInProgress(actContract);

            // Assert
            Assert.IsTrue(hasSiblingContractWithDraftStatus, "Did not detect a sibling contract with Draft status");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_HasSiblingContractWithDraftStatusOrAmendmentCreationInProgress_ShouldReturnTrueWhenAllSiblingContractsDoNotHaveDraftStatusButOneSiblingHasAmendmentCreationInProgressAsTrue()
        {
            // Arrange
            const string masterContractNumber = "SFA-9899";
            const string contractNumberPrefix = "MAIN-989";
            const string actContract = contractNumberPrefix + "0";
            const string siblingContract1 = contractNumberPrefix + "1";
            const string siblingContract2 = contractNumberPrefix + "2";
            const string siblingContract3 = contractNumberPrefix + "3";

            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                RemoveContract(organizationService, xrmContext, siblingContract3);
                RemoveContract(organizationService, xrmContext, siblingContract2);
                RemoveContract(organizationService, xrmContext, siblingContract1);
                RemoveContract(organizationService, xrmContext, actContract);
                RemoveContract(organizationService, xrmContext, masterContractNumber);
            }

            var masterContractId = CreateMasterContract(masterContractNumber, 1, 0, sfa_contractstatus.Approved);
            CreateContractWithMasterContractId(actContract, 1, 0, masterContractId, sfa_contractstatus.Approved);

            CreateContractWithMasterContractId(siblingContract1, 1, 0, masterContractId, sfa_contractstatus.Approved);
            CreateContractWithMasterContractId(siblingContract2, 1, 0, masterContractId, sfa_contractstatus.Replaced);
            CreateContractWithMasterContractId(siblingContract3, 1, 0, masterContractId, sfa_contractstatus.Withdrawn, amendmentCreationInProgress: true);

            CrmContractRepository repository = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // Act 
            var hasSiblingContractWithDraftStatus = repository.HasSiblingContractWithDraftStatusOrAmendmentCreationInProgress(actContract);

            // Assert
            Assert.IsTrue(hasSiblingContractWithDraftStatus, "Did not detect a sibling contract is undergoing amendment");
        }

        private static EntityReference CreateFundingType(IOrganizationService organizationSvc, string fundingTypeCode)
        {
            var sfaFundingtype = new SFA.FCT.CrossDomain.Integration.Entities.Xrm.sfa_fundingtype
            {
                sfa_fundingtypecode = fundingTypeCode,

            };

            Guid guid = organizationSvc.Create(sfaFundingtype);

            return new EntityReference(SFA.FCT.CrossDomain.Integration.Entities.Xrm.sfa_fundingtype.EntityLogicalName, guid);
        }

        private static EntityReference CreatePeriod(IOrganizationService organizationSvc, string periodName)
        {
            sfa_period period = new sfa_period
            {
                sfa_Period = periodName
            };

            Guid guid = organizationSvc.Create(period);
            return new EntityReference(sfa_period.EntityLogicalName, guid);
        }

        private static void RemoveContract(IOrganizationService organizationSvc, XrmServiceContext xrmContext, string contractNumber)
        {
            List<Guid> contractIds = xrmContext.sfa_contractSet
                .Where(c => c.sfa_number == contractNumber)
                .Select(c => c.Id).ToList();

            contractIds.ForEach(c => organizationSvc.Delete(sfa_contract.EntityLogicalName, c));
        }

        private static void RemoveFundingType(IOrganizationService organizationSvc, XrmServiceContext xrmContext, string fundingTypeCode)
        {
            List<Guid> fundingtypeIds = xrmContext.sfa_fundingtypeSet
                .Where(f => f.sfa_fundingtypecode == fundingTypeCode)
                .Select(f => f.Id).ToList();

            fundingtypeIds.ForEach(c => organizationSvc.Delete(SFA.FCT.CrossDomain.Integration.Entities.Xrm.sfa_fundingtype.EntityLogicalName, c));
        }

        private static void RemovePeriod(IOrganizationService organizationSvc, XrmServiceContext xrmContext, string periodname)
        {
            List<Guid> periodIds = xrmContext.sfa_periodSet
                .Where(p => p.sfa_periodname == periodname)
                .Select(p => p.Id).ToList();

            periodIds.ForEach(c => organizationSvc.Delete(sfa_period.EntityLogicalName, c));
        }

        private static sfa_contract GetDefaultContract(XrmServiceContext crmContext, string contractNumber)
        {
            sfa_contract contract = new sfa_contract
            {
                sfa_number = contractNumber,
                sfa_Version = 1,
                sfa_SubVersion = 0,
                sfa_ContractStatus = new OptionSetValue((int)sfa_contractstatus.Draft),
                sfa_SubStatus = GetSubstatus(crmContext, "In Review"),
                sfa_ProviderName = GetFirstProvider(crmContext)
            };

            return contract;
        }

        private static EntityReference GetSubstatus(XrmServiceContext crmContext, string subStatusName)
        {
            return crmContext.sfa_statusSet.Single(s => s.sfa_name == subStatusName).ToEntityReference();
        }

        private static EntityReference GetFirstProvider(XrmServiceContext crmContext)
        {
            Guid orgId = crmContext.AccountSet.Where(a => a.sfa_UKPRN != null).Select(a => a.Id).First();
            return new EntityReference(Account.EntityLogicalName, orgId);
        }

        public static void UpdateContract(IOrganizationService organizationService, Entity contract)
        {
            contract.EntityState = EntityState.Changed;
            organizationService.Update(contract);
        }

        private static Guid CreateMasterContract(string masterContractNumber, int version, int subVersion, sfa_contractstatus contractStatus)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                Account contractProvider = xrmContext.AccountSet.First();

                sfa_contract masterContract = new sfa_contract
                {
                    sfa_UKPRN = contractProvider.sfa_UKPRN,
                    sfa_number = masterContractNumber,
                    sfa_HierarchyType = new OptionSetValue((int)sfa_contracthierarchytype.Master),
                    sfa_Version = version,
                    sfa_SubVersion = subVersion,
                    sfa_ProviderName = contractProvider.ToEntityReference(),
                    sfa_ContractStatusEnum = contractStatus
                };

                return organizationService.Create(masterContract);
            }
        }

        private static Guid CreateContractWithMasterContractId(string contractNumber,
            int version,
            int subVersion,
            Guid masterContractId,
            sfa_contractstatus contractStatus,
            bool amendmentCreationInProgress = false)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                Account contractProvider = xrmContext.AccountSet.First();

                sfa_contract contract = new sfa_contract
                {
                    sfa_UKPRN = contractProvider.sfa_UKPRN,
                    sfa_number = contractNumber,
                    sfa_HierarchyType = new OptionSetValue((int)sfa_contracthierarchytype.Contract),
                    sfa_Version = version,
                    sfa_SubVersion = subVersion,
                    sfa_ParentContractId = new EntityReference(sfa_contract.EntityLogicalName, masterContractId),
                    sfa_ProviderName = contractProvider.ToEntityReference(),
                    sfa_nfainprogress = amendmentCreationInProgress
                };

                Guid contractId = organizationService.Create(contract);

                sfa_contract c = new sfa_contract
                {
                    sfa_contractId = contractId,
                    sfa_LastApprovedVersion = true,
                    sfa_ContractStatusEnum = contractStatus
                };

                CrmConnectionFactory.GetRetryOnErrorOrganizationService().Update(c);

                return contractId;
            }
        }
    }
}
