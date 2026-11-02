namespace ContractManagementDomain.Endpoint.Tests.LevyAmendmentEndpoint.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using System.Linq.Expressions;
    using ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.Repositories;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractManagementDomain.Integration.Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities;

    [TestClass]
    public class CrmContractRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetContractStatusIfContractIsLatest_ShouldReturnContractStatusIfItIsTheLatest()
        {
            // Arrange
            const string testChildNumber = "Test-Child-GMCN";

            CrmCommon.DeleteEntityFromATable(c => c.sfa_contractSet, c => c.sfa_number == testChildNumber);

            sfa_contractBuilder contractBuilder = new sfa_contractBuilder();

            sfa_contract childContract = contractBuilder.Build(c =>
            {
                c.sfa_number = testChildNumber;
                c.sfa_Version = 2;
                c.sfa_SubVersion = 1;
            });
            CrmCommon.CreateEntity(childContract);

            // Act
            CrmContractRepository crmContractRepository = new CrmContractRepository(CrmCommon.GetConnection());

            ContractStatusInfo contractStatusInfo = crmContractRepository.GetContractStatusIfContractIsLatest(testChildNumber, 2, 1);

            // Assert
            Assert.AreEqual(ContractStatus.Draft, contractStatusInfo.ContractStatus);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetContractStatusIfContractIsLatest_ShouldReturnNullIfItIsNotTheLatest()
        {
            // Arrange
            const string testChildNumber = "Test-Child-GMCN";

            CrmCommon.DeleteEntityFromATable(c => c.sfa_contractSet, c => c.sfa_number == testChildNumber);

            sfa_contractBuilder contractBuilder = new sfa_contractBuilder();

            sfa_contract childContract = contractBuilder.Build(c =>
            {
                c.sfa_number = testChildNumber;
                c.sfa_Version = 2;
                c.sfa_SubVersion = 1;
            });
            CrmCommon.CreateEntity(childContract);

            childContract.sfa_LatestVersion = false;
            CrmCommon.UpdateEntity(childContract);

            // Act
            CrmContractRepository crmContractRepository = new CrmContractRepository(CrmCommon.GetConnection());

            ContractStatusInfo contractStatusInfo = crmContractRepository.GetContractStatusIfContractIsLatest(testChildNumber, 2, 1);

            // Assert
            Assert.AreEqual(null, contractStatusInfo);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetContractStatusIfContractIsLatest_ShouldGetCorrectValueForAwaitingTerminationInitiationApproval()
        {
            // Arrange
            const string testChildNumber = "Test-Child-GMCN";

            CrmCommon.DeleteEntityFromATable(c => c.sfa_contractSet, c => c.sfa_number == testChildNumber);

            sfa_contractBuilder contractBuilder = new sfa_contractBuilder();

            sfa_contract childContract = contractBuilder.Build(c =>
            {
                c.sfa_number = testChildNumber;
                c.sfa_Version = 2;
                c.sfa_SubVersion = 1;
            });
            CrmCommon.CreateEntity(childContract);

            childContract.sfa_ContractStatus = new OptionSetValue((int) sfa_contractstatus.Approved);
            childContract.sfa_SubStatus = GetSubStatus("Awaiting Termination Initiation Approval");
            CrmCommon.UpdateEntity(childContract);

            // Act
            CrmContractRepository crmContractRepository = new CrmContractRepository(CrmCommon.GetConnection());

            ContractStatusInfo contractStatusInfo = crmContractRepository.GetContractStatusIfContractIsLatest(testChildNumber, 2, 1);

            // Assert
            Assert.AreEqual(ContractStatus.Approved, contractStatusInfo.ContractStatus, "Contract status should be \"Approved\"");
            Assert.AreEqual(ContractSubStatus.AwaitingTerminationInitiationApproval, contractStatusInfo.ContractSubStatus, "Contract substatus should be \"Awaiting Termination Initiation Approval\"");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetContractStatusIfContractIsLatest_ShouldGetCorrectValueForUnderTermination()
        {
            // Arrange
            const string testChildNumber = "Test-Child-GMCN";

            CrmCommon.DeleteEntityFromATable(c => c.sfa_contractSet, c => c.sfa_number == testChildNumber);

            sfa_contractBuilder contractBuilder = new sfa_contractBuilder();

            sfa_contract childContract = contractBuilder.Build(c =>
            {
                c.sfa_number = testChildNumber;
                c.sfa_Version = 2;
                c.sfa_SubVersion = 1;
            });
            CrmCommon.CreateEntity(childContract);

            childContract.sfa_ContractStatus = new OptionSetValue((int) sfa_contractstatus.Approved);
            childContract.sfa_SubStatus = GetSubStatus("Under Termination");
            CrmCommon.UpdateEntity(childContract);

            // Act
            CrmContractRepository crmContractRepository = new CrmContractRepository(CrmCommon.GetConnection());

            ContractStatusInfo contractStatusInfo = crmContractRepository.GetContractStatusIfContractIsLatest(testChildNumber, 2, 1);

            // Assert
            Assert.AreEqual(ContractStatus.Approved, contractStatusInfo.ContractStatus, "Contract status should be \"Approved\"");
            Assert.AreEqual(ContractSubStatus.UnderTermination, contractStatusInfo.ContractSubStatus, "Contract substatus should be \"Under Termination\"");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetAllocationsForContract_ShouldGetFsps()
        {
            // Arrange
            const string testChildNumber = "ContractNum123";
            const string fspCode = "16-18NLAP2018";
            const string allocationNumber = "Alloc 123";
            const int version = 2;
            const int subVersion = 1;
            EntityReference fspEntityReference = GetFspEntityReference(fspCode);

            CrmCommon.DeleteEntityFromATable(c => c.sfa_contractSet, c => c.sfa_number == testChildNumber);

            sfa_contractBuilder contractBuilder = new sfa_contractBuilder();

            Relationship contractAllocationRelationship = new Relationship("sfa_sfa_contract_sfa_contractallocation")
            {
                PrimaryEntityRole = EntityRole.Referenced
            };
            EntityCollection contractAllocationCollection = new EntityCollection();
            contractAllocationCollection.Entities.Add(new sfa_contractallocation
            {
                sfa_FundingStreamPeriodId = fspEntityReference,
                sfa_contractallocationnumber = allocationNumber
            });

            sfa_contract childContract = contractBuilder.Build(c =>
            {
                c.sfa_number = testChildNumber;
                c.sfa_Version = version;
                c.sfa_SubVersion = subVersion;
            });

            childContract.RelatedEntities.Add(contractAllocationRelationship, contractAllocationCollection);
            CrmCommon.CreateEntity(childContract);

            // Act
            CrmContractRepository crmContractRepository = new CrmContractRepository(CrmCommon.GetConnection());

            var simpleAllocationInfos = crmContractRepository.GetAllocationsForContract(testChildNumber, version, subVersion);

            // Assert
            Assert.AreEqual(1, simpleAllocationInfos.Count, "The number of allocations is incorrect");
            Assert.AreEqual(fspCode, simpleAllocationInfos.First().FundingStreamPeriodCode, "The fspCode is incorrect");
        }

        private static EntityReference GetFspEntityReference(string fspCode)
        {
            IOrganizationService orgService = GetConnection();
            using (XrmServiceContext crmContext = new XrmServiceContext(orgService))
            {
                return crmContext.sfa_fundingstreamperiodSet.First(fsp => fsp.sfa_fundingstreamperiodcode == fspCode).ToEntityReference();
            }
        }

        public static IOrganizationService GetConnection()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }

        private static EntityReference GetSubStatus(string statusName)
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                return crmContext.sfa_statusSet.Single(s => s.sfa_name == statusName).ToEntityReference();
            }
        }

        public class CrmCommon
        {
            public static Guid CreateEntity(Entity entityToAddToCrm)
            {
                Guid guid = GetConnection().Create(entityToAddToCrm);
                entityToAddToCrm.Id = guid;
                return guid;
            }

            public static void UpdateEntity(Entity entityToUpdate)
            {
                entityToUpdate.EntityState = EntityState.Changed;
                GetConnection().Update(entityToUpdate);
            }

            public static void DeleteEntityFromATable<T>(Func<XrmServiceContext, IQueryable<T>> entitySetToQuery, Expression<Func<T, bool>> queryPredicate)
                where T : Entity
            {
                IOrganizationService orgService = GetConnection();
                using (XrmServiceContext crmContext = new XrmServiceContext(orgService))
                {
                    var entitySet = entitySetToQuery(crmContext);
                    List<Guid> guids = entitySet.Where(queryPredicate).Select(c => c.Id).ToList();
                    guids.ForEach(cid => { orgService.Delete(typeof(T).GetEntityLogicalName(), cid); });
                }
            }

            public static IOrganizationService GetConnection()
            {
                return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            }

            public static EntityReference GetSubstatus(string subStatusName)
            {
                using (var crmContext = new XrmServiceContext(GetConnection()))
                {
                    return crmContext.sfa_statusSet.Single(s => s.sfa_name == subStatusName).ToEntityReference();
                }
            }

            public static EntityReference GetFirstProvider()
            {
                using (var crmContext = new XrmServiceContext(GetConnection()))
                {
                    Guid orgId = crmContext.AccountSet.Where(a => a.sfa_UKPRN != null).Select(a => a.Id).First();
                    return new EntityReference(Account.EntityLogicalName, orgId);
                }
            }
        }

        public class sfa_contractBuilder : AbsBuilder<sfa_contract>
        {
            protected override sfa_contract GetDefault()
            {
                return new sfa_contract()
                {
                    sfa_number = "12345678",
                    sfa_Version = 1,
                    sfa_SubVersion = 0,
                    sfa_ContractStatus = new OptionSetValue((int) sfa_contractstatus.Draft),
                    sfa_SubStatus = CrmCommon.GetSubstatus("In Review"),
                    sfa_ProviderName = CrmCommon.GetFirstProvider()
                };
            }
        }

        public abstract class AbsBuilder<T>
        {
            protected abstract T GetDefault();

            public T Build(Action<T> creator = null)
            {
                T defaultEntity = GetDefault();
                creator?.Invoke(defaultEntity);

                return defaultEntity;
            }
        }
    }
}