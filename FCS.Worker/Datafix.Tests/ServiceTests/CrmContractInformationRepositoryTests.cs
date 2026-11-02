namespace Datafix.Tests.ServiceTests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using AutoMapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using UnitTests.Common;
    using CrmConnectionFactory = SFA.FCS.Worker.Common.Crm.CrmConnectionFactory;
    using Repositories;

    [TestClass]
    public class CrmContractInformationRepositoryTests
    {
        private const string LevyFundingType = "LEVY";
        private const string LevyFundingPeriod = "LEVY1799";

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractInformationRepository_GetLatestContractInformationByFundingTypeAndFundingPeriod_ShouldReturnExpectedContracts()
        {
            // arrange
            setupOrgs();
            DeleteContractsForFundingTypeAndPeriod(LevyFundingType, LevyFundingPeriod);
            
            CreateTestContract("ESFA-1", "APPLEVY-1", 1, 0, "LEVY-1", 11111, sfa_contractstatus.Approved, "Approved");
            CreateTestContract("ESFA-2", "APPLEVY-2", 2, 0, "LEVY-2", 22222, sfa_contractstatus.Draft, "Published to Provider");
            CreateTestContract("ESFA-3", "APPLEVY-3", 3, 0, "LEVY-3", 33333, sfa_contractstatus.Approved, "Awaiting Closure Approval");
            CreateTestContract("ESFA-4", "APPLEVY-4", 4, 0, "LEVY-4", 44444, sfa_contractstatus.Closed, "Closed");
            CreateTestContract("ESFA-5", "APPLEVY-5", 5, 0, "LEVY-5", 55555, sfa_contractstatus.Withdrawn, "Withdrawn By Agency");

            CrmContractInformationRepository repository = new CrmContractInformationRepository();

            // act
            IReadOnlyCollection<ContractInformation> contractInfos =
                repository.GetLatestContractInformationByFundingTypeAndFundingPeriod(LevyFundingType, LevyFundingPeriod);

            // assert
            int expectedLevyContractCount = GetLevyContractCount();
            Assert.AreEqual(expectedLevyContractCount, contractInfos.Count, "Incorrect number of contracts returned");

            AssertExpectedContractIsPresentInCollection(contractInfos, "ESFA-1", "APPLEVY-1", 1, 0, 11111, ContractStatus.Approved, ContractSubStatus.Approved);
            AssertExpectedContractIsPresentInCollection(contractInfos, "ESFA-2", "APPLEVY-2", 2, 0, 22222, ContractStatus.Draft, ContractSubStatus.PublishedtoProvider);
            AssertExpectedContractIsPresentInCollection(contractInfos, "ESFA-3", "APPLEVY-3", 3, 0, 33333, ContractStatus.Approved, ContractSubStatus.AwaitingClosureApproval);
            AssertExpectedContractIsPresentInCollection(contractInfos, "ESFA-4", "APPLEVY-4", 4, 0, 44444, ContractStatus.Closed, ContractSubStatus.Closed);
            AssertExpectedContractIsPresentInCollection(contractInfos, "ESFA-5", "APPLEVY-5", 5, 0, 55555, ContractStatus.Other, ContractSubStatus.Other);
        }

        private void DeleteContractsForFundingTypeAndPeriod(string levyFundingType, string levyFundingPeriod)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                var contractIds = (
                   from contract in context.sfa_contractSet
                   join period in context.sfa_periodSet on contract.sfa_PeriodId.Id equals period.Id
                   join fundingType in context.sfa_fundingtypeSet on contract.sfa_FundingType.Id equals fundingType.Id
                   join sfaStatus in context.sfa_statusSet on contract.sfa_SubStatus.Id equals sfaStatus.Id
                   where fundingType.sfa_fundingtypecode == levyFundingType
                         && period.sfa_periodname == levyFundingPeriod
                         && contract.sfa_HierarchyType.Value == (int)sfa_contracthierarchytype.Contract
                         && contract.sfa_LatestVersion == true
                   select contract.Id
                   )
                   .ToList();

                contractIds.ForEach(contractId => organizationService.Delete(sfa_contract.EntityLogicalName, contractId));
            }
        }

        private static void AssertExpectedContractIsPresentInCollection(
            IReadOnlyCollection<ContractInformation> contractInfos,
            string expectedMasterContractNumber,
            string expectedContractNumber,
            int expectedVersionNumber,
            int expectedSubVersionNumber,
            int expectedUkprn,
            ContractStatus expectedStatus,
            ContractSubStatus expectedSubStatus)
        {
            ContractInformation actualLevyContract = contractInfos.SingleOrDefault(c => c.ContractNumber == expectedContractNumber);
            Assert.IsNotNull(actualLevyContract, "Expected contract not returned");

            Assert.AreEqual(expectedContractNumber, actualLevyContract.ContractNumber, $"Incorrect contract number returned for {expectedContractNumber}");
            Assert.AreEqual(expectedMasterContractNumber, actualLevyContract.MasterContractNumber, $"Incorrect master contract number returned for {expectedContractNumber}");
            Assert.AreEqual(expectedUkprn.ToString(), actualLevyContract.Ukprn, $"Incorrect UKPRN returned for {expectedContractNumber}");
            Assert.AreEqual(expectedVersionNumber, actualLevyContract.ContractVersionNumber, $"Incorrect contract version returned for {expectedContractNumber}");
            Assert.AreEqual(expectedSubVersionNumber, actualLevyContract.SubVersionNumber, $"Incorrect contract subversion returned for {expectedContractNumber}");
            Assert.AreEqual(expectedStatus, actualLevyContract.ContractStatus, $"Incorrect contract status returned for {expectedContractNumber}");
            Assert.AreEqual(expectedSubStatus, actualLevyContract.ContractSubStatus, $"Incorrect contract substatus returned for {expectedContractNumber}");
        }

        private static void CreateTestContract(
            string masterContractNumber,
            string contractNumber,
            int versionNumber,
            int subVersionNumber,
            string allocationNumber,
            int ukprn,
            sfa_contractstatus status,
            string subStatus)
        {
            DeleteContracts(contractNumber);
            DeleteContracts(masterContractNumber);

            ExtendedContract levyContract = GetCorporateContractFromResource();
            levyContract.contractNumber = masterContractNumber;
            levyContract.contracts.Single().contractNumber = contractNumber;
            levyContract.contracts.Single().contractVersionNumber = versionNumber;
            levyContract.contracts.Single().contractSubVersionNumber = subVersionNumber;
            levyContract.contracts.Single().contractAllocations.Single().contractAllocationNumber = allocationNumber;
            levyContract.contractor.ukprn = ukprn;

            CreateContractsManager().CreateContract(levyContract, Guid.NewGuid().ToString());
            SetContractState(contractNumber, versionNumber, subVersionNumber, status, subStatus);
        }

        private static ExtendedContract GetCorporateContractFromResource()
        {
            contract contract = TestResource.FromJson<contract>("Datafix.Tests.Resources", "LevyCorporateContract.json");

            Mapper.CreateMap<contract, ExtendedContract>();
            Mapper.CreateMap<contractType, ExtendedContractType>();
            Mapper.CreateMap<contractAllocationsContractAllocation, ExtendedContractAllocation>();
            return Mapper.Map<contract, ExtendedContract>(contract);
        }

        private static void SetContractState(string contractNumber, int versionNumber, int subVersionNumber, sfa_contractstatus status, string subStatusName)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                Guid contractId = context.sfa_contractSet
                    .Single(c => c.sfa_number == contractNumber && c.sfa_Version == versionNumber && c.sfa_SubVersion == subVersionNumber).Id;
                Guid subStatus = context.sfa_statusSet.Single(s => s.sfa_name == subStatusName).Id;

                organizationService.Update(new sfa_contract
                {
                    Id = contractId,
                    sfa_ContractStatusEnum = status,
                    sfa_SubStatus = new EntityReference(sfa_status.EntityLogicalName, subStatus),
                    sfa_LastApprovedVersion = true,
                    sfa_LatestVersion = true,
                    sfa_ContractApprovalDate = DateTime.UtcNow,
                    sfa_StatusLastUpdatedDate = DateTime.UtcNow
                });
            }
        }

        private static void DeleteContracts(string contractNumber)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                context.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.Id)
                    .ForEach(id => ActionRetrier.RetryWhenExceptionThrown(() => organizationService.Delete("sfa_contract", id)));
            }
        }

        public static int GetLevyContractCount()
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return (
                    from contract in context.sfa_contractSet
                    join period in context.sfa_periodSet on contract.sfa_PeriodId.Id equals period.Id
                    join fundingType in context.sfa_fundingtypeSet on contract.sfa_FundingType.Id equals fundingType.Id
                    join sfaStatus in context.sfa_statusSet on contract.sfa_SubStatus.Id equals sfaStatus.Id
                    where fundingType.sfa_fundingtypecode == LevyFundingType
                          && period.sfa_periodname == LevyFundingPeriod
                          && contract.sfa_HierarchyType.Value == (int)sfa_contracthierarchytype.Contract
                          && contract.sfa_LatestVersion == true
                    select contract.Id
                    )
                    .ToList()
                    .Count();
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

        private void setupOrgs()
        {
            GetOrCreateOrgEntityReference("10026004");
            GetOrCreateOrgEntityReference("11111");
            GetOrCreateOrgEntityReference("22222");
            GetOrCreateOrgEntityReference("33333");
            GetOrCreateOrgEntityReference("44444");
            GetOrCreateOrgEntityReference("55555");
        }

        private void GetOrCreateOrgEntityReference(string ukprn)
        {
            Account org = GetOrg(ukprn);

            if (org == null)
            {
                Account acc = new Account
                {
                    sfa_UKPRN = ukprn
                };

                CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(acc);

                org = GetOrg(ukprn);
            }
        }

        private Account GetOrg(string ukprn)
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return crmContext.AccountSet.FirstOrDefault(a => a.sfa_UKPRN == ukprn);
            }
        }
    }
}