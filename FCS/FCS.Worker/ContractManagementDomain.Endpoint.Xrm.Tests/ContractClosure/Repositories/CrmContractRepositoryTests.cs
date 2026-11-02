namespace ContractManagementDomain.Endpoint.Xrm.Tests.ContractClosure.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Xrm.ContractClosure.Repositories;
    using sfa_fundingtype = SFA.FCT.CrossDomain.Integration.Entities.Xrm.sfa_fundingtype;

    [TestClass]
    public class CrmContractRepositoryTests
    {
        private EntityReference _providerId;

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_IsContractClosed_WhenAContractIsClosed_ShouldReturnTrue()
        {
            const string testContractNumber = "Test-contract";

            // pre-clean up
            DeleteContracts(testContractNumber);

            // arrange
            CreateTestContract(testContractNumber, GetFundingType("LEVY"), GetPeriod("AY1617"), lastApprovedVersion: true, version: 1);
            SetContractState(testContractNumber, 1, sfa_contractstatus.Closed, "Closed");
            CrmContractRepository contractCrmRepository = new CrmContractRepository(GetConnection());

            // act            
            bool isContractClosed = contractCrmRepository.IsContractClosed(testContractNumber);

            // assert
            Assert.IsTrue(isContractClosed);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_IsContractClosed_WhenAContractIsNotClosed_ShouldReturnFalse()
        {
            const string testContractNumber = "Test-contract";

            // pre-clean up
            DeleteContracts(testContractNumber);

            // arrange
            CreateTestContract(testContractNumber, GetFundingType("LEVY"), GetPeriod("AY1617"), lastApprovedVersion: true, version: 1);
            SetContractState(testContractNumber, 1, sfa_contractstatus.Approved, "Closure in Progress");
            CrmContractRepository contractCrmRepository = new CrmContractRepository(GetConnection());

            // act            
            bool isContractClosed = contractCrmRepository.IsContractClosed(testContractNumber);

            // assert
            Assert.IsFalse(isContractClosed);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetContractId_ShouldGetContractId()
        {
            // arrange
            const string contractNumber = "TEST-9742";
            const int versionNumber = 2;
            const int subVersionNumber = 1;

            DeleteContracts(contractNumber);
            Guid expectedContractId = CreateTestContract(
                contractNumber, GetFundingType("AGE"), GetPeriod("FY1617"), true, versionNumber, subVersionNumber);
            ICrmContractRepository repository = new CrmContractRepository(GetConnection());

            // act
            Guid actualContractId = repository.GetContractId(contractNumber, versionNumber, subVersionNumber);

            // assert
            Assert.AreEqual(expectedContractId, actualContractId, "Contract Id was not returned as expected");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_UpdateContract_ShouldUpdateContract()
        {
            // arrange
            const string contractNumber = "TEST-9742";
            const int versionNumber = 2;
            const int subVersionNumber = 1;

            DeleteContracts(contractNumber);
            Guid contractId = CreateTestContractWithEndDate(contractNumber, versionNumber, subVersionNumber, contractEndDate: null);
            ICrmContractRepository repository = new CrmContractRepository(GetConnection());

            // act
            DateTime contractEndDate = DateTime.UtcNow;

            repository.UpdateContract(new sfa_contract
            {
                Id = contractId,
                sfa_EndDate = contractEndDate
            });

            // assert
            sfa_contract updatedContract = GetContract(contractId);
            Assert.AreEqual(TrimDateTime(contractEndDate), TrimDateTime(updatedContract.sfa_EndDate.Value), "Contract was not updated as expected");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetAllocationIdsForContract_ShouldReturnExpectedAllocationIds()
        {
            // arrange
            const string contractNumber = "TEST-9742";
            const int versionNumber = 2;
            const int subVersionNumber = 1;

            DeleteContracts(contractNumber);
            Guid contractId = GetConnection().Create(new sfa_contract
            {
                sfa_number = contractNumber,
                sfa_Version = versionNumber,
                sfa_SubVersion = subVersionNumber,
                sfa_ProviderName = GetProvider(),
                sfa_sfa_contract_sfa_contractallocation = new List<sfa_contractallocation>
                {
                    new sfa_contractallocation { sfa_contractallocationnumber = "ALLOC-1" },
                    new sfa_contractallocation { sfa_contractallocationnumber = "ALLOC-2" }
                }
            });
            ICrmContractRepository repository = new CrmContractRepository(GetConnection());

            // act
            IReadOnlyCollection<Guid> returnedAllocationIds = repository.GetAllocationIdsForContract(contractNumber, versionNumber, subVersionNumber);

            // assert
            IReadOnlyCollection<Guid> actualAllocationIds = GetAllocationsForContract(contractId).Select(a => a.Id).ToList();
            Assert.AreEqual(returnedAllocationIds.Count, actualAllocationIds.Count, "Incorrect number of Allocation Ids returned");
            Assert.IsTrue(actualAllocationIds.All(id => returnedAllocationIds.Contains(id)), "Not all Allocation Ids returned");
        }

        private static DateTime TrimDateTime(DateTime dt)
        {
            return new DateTime(dt.Year, dt.Month, dt.Day, dt.Hour, dt.Minute, dt.Second);
        }

        private Guid CreateTestContractWithEndDate(string contractNumber, int versionNumber, int subversionNumber, DateTime? contractEndDate)
        {
            IOrganizationService orgService = GetConnection();

            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_Version = versionNumber,
                sfa_LastApprovedVersion = false,
                sfa_ProviderName = GetProvider(),
                sfa_SubVersion = subversionNumber,
                sfa_EndDate = contractEndDate
            };

            return orgService.Create(contract);
        }

        private static sfa_contract GetContract(Guid contractId)
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                return crmContext.sfa_contractSet.SingleOrDefault(x => x.sfa_contractId.Value == contractId);
            }
        }

        private static IReadOnlyCollection<sfa_contractallocation> GetAllocationsForContract(Guid contractId)
        {
            using (XrmServiceContext crmContext = new XrmServiceContext(GetConnection()))
            {
                return crmContext.sfa_contractallocationSet
                    .Where(a => a.sfa_ContractId.Id == contractId)
                    .ToList();
            }
        }

        private Guid CreateTestContract(string contractNumber, Guid fundingType, Guid period, bool lastApprovedVersion, int version, int subVersion = 0)
        {
            IOrganizationService orgService = GetConnection();
            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_SubVersion = subVersion,
                sfa_LastApprovedVersion = lastApprovedVersion,
                sfa_ProviderName = GetProvider(),
                sfa_FundingType = new EntityReference(sfa_fundingtype.EntityLogicalName, fundingType),
                sfa_PeriodId = new EntityReference(sfa_period.EntityLogicalName, period)
            };
            return orgService.Create(contract);
        }

        private EntityReference GetProvider()
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                if (_providerId == null)
                {
                    var orgId = crmContext.AccountSet.Where(a => a.sfa_UKPRN != null).Select(a => a.Id).First();
                    _providerId = new EntityReference(Account.EntityLogicalName, orgId);
                }

                return _providerId;
            }
        }

        private static void DeleteContracts(string contractNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext xrmContext = new XrmServiceContext(organizationService))
            {
                xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.Id)
                    .ToList()
                    .ForEach(id => UnitTests.Common.ActionRetrier.RetryWhenExceptionThrown<System.ServiceModel.FaultException>(() => organizationService.Delete(sfa_contract.EntityLogicalName, id)));
            }
        }

        private static void SetContractState(string contractNumber, int versionNumber, sfa_contractstatus status, string subStatusName)
        {
            IOrganizationService organizationService = GetConnection();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                Guid contractId = context.sfa_contractSet
                    .Single(c => c.sfa_number == contractNumber && c.sfa_Version == versionNumber).Id;
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

        private static IOrganizationService GetConnection()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }

        private static Guid GetFundingType(string fundingTypeCode)
        {
            using (XrmServiceContext serviceContext = new XrmServiceContext(GetConnection()))
            {
                return serviceContext.sfa_fundingtypeSet.First(f => f.sfa_fundingtypecode == fundingTypeCode).Id;
            }
        }

        private static Guid GetPeriod(string periodName)
        {
            using (XrmServiceContext serviceContext = new XrmServiceContext(GetConnection()))
            {
                return serviceContext.sfa_periodSet.First(p => p.sfa_periodname == periodName).Id;
            }
        }
    }
}
