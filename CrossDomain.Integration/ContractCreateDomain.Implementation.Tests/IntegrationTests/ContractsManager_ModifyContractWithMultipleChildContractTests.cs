namespace ContractCreateDomain.Implementation.Tests.IntegrationTests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Xml.Linq;
    using AutoMapper;
    using Endpoint.XrmService.Repositories;
    using Endpoint.XrmService.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using MoreLinq;
    using SFA.FCT.Contract.XrmAdapterService.Tests.Utils;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using UnitTests.Common;
    using XmlSerializer = System.Xml.Serialization.XmlSerializer;
    using CrmConnectionFactory = SFA.FCS.Worker.Common.Crm.CrmConnectionFactory;

    [TestClass]
    public class ContractsManager_ModifyContractWithMultipleChildContractTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_AmendContract_ShouldSaveMasterWithMultipleChildren()
        {
            // arrange
            const string childContractNumber1 = "Test - Contract1";
            const string childContractNumber2 = "Test - Contract2";

           var contractsManager = CreateContractsManager();

            DeleteContractsWithContractNumber(childContractNumber1);
            DeleteContractsWithContractNumber(childContractNumber2);

            ExtendedContract masterContract = GetExtendedCorpContractWith2ChildContracts(childContractNumber1, childContractNumber2);
           
            // act
            contractsManager.AmendContract(masterContract, Guid.NewGuid().ToString());

            // assert
            Assert.IsTrue(GetContractsWithContractNumber(childContractNumber1).Any(), $"We have not created a contract with this contract number {childContractNumber1}");
            Assert.IsTrue(GetContractsWithContractNumber(childContractNumber2).Any(), $"We have not created a contract with this contract number {childContractNumber2}");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_AmendContract_ShouldNotCreateDuplicateContracts()
        {
            // arrange
            const string childContractNumber1 = "Test - Contract1";
            const string childContractNumber2 = "Test - Contract2";

            var contractsManager = CreateContractsManager();

            DeleteContractsWithContractNumber(childContractNumber1);
            DeleteContractsWithContractNumber(childContractNumber2);

            ExtendedContract masterContract = GetExtendedCorpContractWith2ChildContracts(childContractNumber1, childContractNumber2);
            var xrmConnection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            ContractDeDuplicationService service = new ContractDeDuplicationService(new ContractQueryRepository(xrmConnection), new ContractAllocationRepository(xrmConnection));

            contractsManager.AmendContract(masterContract, Guid.NewGuid().ToString(), insertAllocationIfNotPresent: service.InsertAllocationWithoutDuplication, getExistingContractId: service.GetExistingContractId);
            service = new ContractDeDuplicationService(new ContractQueryRepository(xrmConnection), new ContractAllocationRepository(xrmConnection));
            // act
            contractsManager.AmendContract(masterContract, Guid.NewGuid().ToString(), insertAllocationIfNotPresent: service.InsertAllocationWithoutDuplication, getExistingContractId: service.GetExistingContractId);

            // assert
            Assert.AreEqual(1, GetContractsWithContractNumber(childContractNumber1).Count, $"We number of contracts created with this number: {childContractNumber1}, is incorrect");
            Assert.AreEqual(1, GetContractsWithContractNumber(childContractNumber2).Count, $"We number of contracts created with this number: {childContractNumber2}, is incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_AmendContract_ShouldNotCreateWhenContractIsAlreadyThereButShouldAddMissingAllocations()
        {
            // arrange
            const string addAllocationNumber = "added";
            ExtendedContract masterContract = GetContractFromFile();
            masterContract.contractNumber = "Master for Dup Test";
            string masterContractNumber = masterContract.contractNumber;
            masterContract.contracts.First().contractNumber = "Dup Test";
            string childContractNumber = masterContract.contracts.First().contractNumber;
            DeleteContractsWithContractNumber(childContractNumber);
            DeleteContractsWithContractNumber(masterContractNumber);
            DateTime now = DateTime.UtcNow.Date;

            string correlationId = Guid.NewGuid().ToString();
            var contractsManager = CreateContractsManager();
            var xrmConnection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            var service = new ContractDeDuplicationService(new ContractQueryRepository(xrmConnection), new ContractAllocationRepository(xrmConnection));
            contractsManager.AmendContract(masterContract, correlationId, service.InsertAllocationWithoutDuplication, service.GetExistingContractId);

            service = new ContractDeDuplicationService(new ContractQueryRepository(xrmConnection), new ContractAllocationRepository(xrmConnection)); // I have 'new-ed' up a new one here to simulate a message replay

            var allocation = masterContract.ChildContract().contractAllocations.First().SerializeToXml().DeserializeXml<ExtendedContractAllocation>();

            allocation.contractAllocationNumber = addAllocationNumber;
            masterContract.ChildContract().contractAllocations.Add(allocation);
            // act
            contractsManager.AmendContract(masterContract, correlationId, service.InsertAllocationWithoutDuplication, service.GetExistingContractId);

            // assert
            var numContracts = GetNumberOfContracts(childContractNumber, 1, 1);
            Assert.AreEqual(1, numContracts, "The number of contracts is incorrect");
            var allocations = GetAllocations(childContractNumber, 1, 1);
            Assert.AreEqual(9, allocations.Count, "The number of allocations is incorrect");
            Assert.IsTrue(allocations.Any(a => a.sfa_contractallocationnumber == addAllocationNumber), "we have not added the missing allocation");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_UpdateContract_ShouldSaveMasterWithMultipleChildren()
        {
            // arrange
            const string childContractNumber1 = "Test - Contract3";
            const string childContractNumber2 = "Test - Contract4";
            const string parentContractNumber = "Test - Parent 2";
            const int version = 2;

            var contractsManager = CreateContractsManager();

            DeleteContractsWithContractNumber(childContractNumber1);
            DeleteContractsWithContractNumber(childContractNumber2);
            DeleteContractsWithContractNumber(parentContractNumber);

            CreateContractRelatedToParent(childContractNumber1, parentContractNumber);
            CreateContractRelatedToParent(childContractNumber2, parentContractNumber);

            var masterContract = GetCorpContractWith2ChildContracts(childContractNumber1: childContractNumber1, childContractNumber2: childContractNumber2, version: version);

            // act
            contractsManager.UpdateContract(masterContract, Guid.NewGuid().ToString());

            // assert
            Assert.IsTrue(GetContractsWithContractNumberAndVersion(childContractNumber1, version).Any(), $"We have not created a contract with this contract number {childContractNumber1}");
            Assert.IsTrue(GetContractsWithContractNumberAndVersion(childContractNumber2, version).Any(), $"We have not created a contract with this contract number {childContractNumber2}");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_UpdateAmendedContract_ShouldSaveMasterWithMultipleChildren()
        {
            // arrange
            const string childContractNumber1 = "Test - Contract5";
            const string childContractNumber2 = "Test - Contract6";
            const string parentContractNumber = "Test - Parent 4";

            var contractsManager = CreateContractsManager();

            DeleteContractsWithContractNumber(childContractNumber1);
            DeleteContractsWithContractNumber(childContractNumber2);
            DeleteContractsWithContractNumber(parentContractNumber);

            ExtendedContract masterContract = GetExtendedCorpContractWith2ChildContracts(childContractNumber1, childContractNumber2);

            masterContract.contracts[0].PreviousVersionId = CreateContractRelatedToParent(childContractNumber1,
                parentContractNumber);

            masterContract.contracts[1].PreviousVersionId = CreateContractRelatedToParent(childContractNumber2,
               parentContractNumber);
            var crmConnection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            ContractDeDuplicationService service = new ContractDeDuplicationService(new ContractQueryRepository(crmConnection), new ContractAllocationRepository(crmConnection));

            // act
            contractsManager.UpdateAmendedContract(
                masterContract, Guid.NewGuid().ToString(),
                insertAllocationIfNotPresent:service.InsertAllocationWithoutDuplication,
                getExistingContractId:service.GetExistingContractId);

            // assert
            Assert.IsTrue(GetContractsWithContractNumber(childContractNumber1).Any(), $"We have not created a contract with this contract number {childContractNumber1}");
            Assert.IsTrue(GetContractsWithContractNumber(childContractNumber2).Any(), $"We have not created a contract with this contract number {childContractNumber2}");
        }

        private static Guid CreateContractRelatedToParent(string contractNumber, string parentContractNumber)
        {
            Guid? parentEntityId;
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                parentEntityId = context.sfa_contractSet.SingleOrDefault(c => c.sfa_number == parentContractNumber)?.Id;
            }

            // create the parent if required
            if (!parentEntityId.HasValue)
            {
                parentEntityId = organizationService.Create(new sfa_contract
                {
                    sfa_number = parentContractNumber,
                    sfa_Version = 1,
                    sfa_SubVersion = 1,
                    sfa_ProviderName = GetProvider(),
                    sfa_UKPRN = "1"
                });
            }
            
            // create the child
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(new sfa_contract
            {
                sfa_number = contractNumber,
                sfa_Version = 1,
                sfa_SubVersion = 1,
                sfa_ProviderName = GetProvider(),
                sfa_UKPRN = "1",
                sfa_ParentContractId = new EntityReference(sfa_contract.EntityLogicalName, parentEntityId.Value)
            });
        }

        private static EntityReference GetProvider()
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return xrmContext.AccountSet.First(o => o.sfa_OrganisationID != null).ToEntityReference();
            }
        }

        private ExtendedContract GetExtendedCorpContractWith2ChildContracts(string childContractNumber1, string childContractNumber2)
        {
            var extendedContract = GetExtendedCorpContract();
            var childContract1 = extendedContract.contracts.First();
            childContract1.contractNumber = childContractNumber1;

            var childContract2 = CloneObject(childContract1);
            childContract2.contractNumber = childContractNumber2;

            extendedContract.contracts.Add(childContract2);

            return extendedContract;
        }

        private contractType GetCorpContractWith2ChildContracts(string childContractNumber1, string childContractNumber2, int version)
        {
            Contract contract = GetCorpContract();
            var childContract1 = contract.contracts.First();
            childContract1.contractNumber = childContractNumber1;
            childContract1.contractVersionNumber = version;

            contractType childContract2 = CloneObject(childContract1);
            childContract2.contractNumber = childContractNumber2;
            childContract2.contractVersionNumber = version;

            contract.contracts.Add(childContract2);

            return contract;
        }

        private T CloneObject<T>(T instance)
        {
            var instanceBytes = instance.ConvertObjectToByteArray();
            return instanceBytes.ConvertByteArrayToObject<T>();
        }

        private ExtendedContract GetExtendedCorpContract()
        {
            return TransformCorpContractToExtendedCorpContract(GetCorpContract());
        }

        private static ExtendedContract TransformCorpContractToExtendedCorpContract(
            Contract corpContract)
        {
            var mapperConfig = new MapperConfiguration(cfg =>
            {
                cfg.CreateMap<Contract, ExtendedContract>();
                cfg.CreateMap<SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractType, ExtendedContractType>();
                cfg.CreateMap<SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractAllocationsContractAllocation, ExtendedContractAllocation>();
            },null);

            var mapper = mapperConfig.CreateMapper();

            return mapper.Map<ExtendedContract>(corpContract);
        }


        private static Contract GetCorpContract()
        {
            using (var resource = new TestResource("ContractCreateDomain.Implementation.Tests", @"Resources.masterContract.xml"))
            {
                var document = XDocument.Load(resource.Stream);

                XmlSerializer serializer = new XmlSerializer(typeof(SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.Contract));
                return (SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.Contract)serializer.Deserialize(document.Root.CreateReader());
            }
        }

        private void DeleteContractsWithContractNumber(string contractNumber)
        {
            var columnValues = new List<ColumnValueCriteria>
            {
                 new ColumnValueCriteria(CrmContractFieldName.Number, ConditionOperator.Equal, contractNumber)
            };

            var lookupCriteria = new CrmLookupCriteria { EntityName = CrmEntityName.Contract, LookupCriteria = columnValues };

            var contracts = CrmManager.GetCrmEntities(lookupCriteria);
            contracts.ForEach(c => RemoveContract(c.Id));
        }

        private static IList<Entity> GetContractsWithContractNumber(string contractNumber)
        {
            var columnValues = new List<ColumnValueCriteria>
            {
                 new ColumnValueCriteria(CrmContractFieldName.Number, ConditionOperator.Equal, contractNumber)
            };

            var lookupCriteria = new CrmLookupCriteria { EntityName = CrmEntityName.Contract, LookupCriteria = columnValues };

            return CrmManager.GetCrmEntities(lookupCriteria);
        }

        private IList<Entity> GetContractsWithContractNumberAndVersion(string contractNumber, int version)
        {
            var columnValues = new List<ColumnValueCriteria>
            {
                 new ColumnValueCriteria(CrmContractFieldName.Number, ConditionOperator.Equal, contractNumber),
                 new ColumnValueCriteria(CrmContractFieldName.Version, ConditionOperator.Equal, version)
            };

            var lookupCriteria = new CrmLookupCriteria { EntityName = CrmEntityName.Contract, LookupCriteria = columnValues };

            return CrmManager.GetCrmEntities(lookupCriteria);
        }

        private void RemoveContract(Guid contractGuid)
        {
            var crmService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

;            ActionRetrier.RetryWhenExceptionThrown<System.ServiceModel.FaultException>(
                () => CrmManager.DeleteEntity(crmService, CrmEntityName.Contract, contractGuid));
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
    }
}
