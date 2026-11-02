namespace ContractManagementDomain.Endpoint.Tests.Integration
{
    using System;
    using System.Linq;
    using AutoMapper;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.DeleteContract;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Moq;
    using MoreLinq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using UnitTests.Common;
    using CrmConnectionFactory = SFA.FCS.Worker.Common.Crm.CrmConnectionFactory;

    [TestClass]
    public class CrmDeleteContractHandlerIntegrationTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmDeleteContractHandler_ShouldDeleteMasterWhenDraftContractVersionToDeleteIsOnlyChildOfMaster()
        {
            ExtendedContract contract = GetCorporateContractFromResource();
            string contractNumber = contract.contracts.Single().contractNumber;
            string masterContractNumber = contract.contractNumber;

            // clean up
            DeleteContracts(contractNumber);
            DeleteMasterAndChildContracts(masterContractNumber);

            // arrange
            CreateContract(contract);
            TestableInvokeHandlerContext context = new TestableMessageHandlerContext();
            // act
            CrmDeleteContractHandler handler = CreateCrmDeleteContractHandler();
            handler.Handle(new DeleteContractCommand
            {
                ContractNumber = contractNumber,
                VersionNumber = 1
            }, context).Wait();

            // assert
            Assert.IsFalse(IsContractPresentInCrm(contractNumber, 1, 0), "Contract version to delete is still present in CRM.");
            Assert.AreEqual(1, context.SentMessages.Length, "The number of commands sent is incorrect");
            DeleteMasterContractsCommand command = context.SentMessages.Select(m => m.Message).Cast<DeleteMasterContractsCommand>().First();
            Assert.AreEqual(1, command.MasterContractIds.Count, "The number of Master contract ids sent is incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmDeleteContractHandler_ShouldNotDeleteMasterWhenMasterHoldsOtherVersionsOfSameChildContract()
        {
            ExtendedContract contract = GetCorporateContractFromResource();
            string contractNumber = contract.contracts.Single().contractNumber;
            string masterContractNumber = contract.contractNumber;

            // clean up
            DeleteContracts(contractNumber);
            DeleteMasterAndChildContracts(masterContractNumber);

            // arrange
            CreateContract(contract);
            ApproveContract(contractNumber, 1);

            contract.contracts.Single().contractVersionNumber = 2;
            contract.contracts.Single().ParentContractId = GetContractId(masterContractNumber);
            AmendContract(contract);
            TestableInvokeHandlerContext context = new TestableMessageHandlerContext();

            // act
            CrmDeleteContractHandler handler = CreateCrmDeleteContractHandler();
            handler.Handle(new DeleteContractCommand
            {
                ContractNumber = contractNumber,
                VersionNumber = 2
            }, context).Wait();

            // assert
            Assert.IsFalse(IsContractPresentInCrm(contractNumber, 2, 0), "Contract version to delete is still present in CRM.");
            Assert.IsTrue(IsContractPresentInCrm(contractNumber, 1, 0), "Contract version which should not be deleted is not present in CRM.");
            Assert.IsTrue(IsContractPresentInCrm(masterContractNumber), "Master contract is not present in CRM.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmDeleteContractHandler_ShouldNotDeleteMasterWhenMasterHoldsOtherSubVersionsOfSameChildContract()
        {
            ExtendedContract contract = GetCorporateContractFromResource();
            string contractNumber = contract.contracts.Single().contractNumber;
            string masterContractNumber = contract.contractNumber;
            const string someOtherContractNumber = "Some other Number";

            // clean up
            DeleteContracts(contractNumber);
            DeleteContracts(someOtherContractNumber);
            DeleteMasterAndChildContracts(masterContractNumber);

            // arrange
            Guid masterContractId = CreateContract(contract);

            CreateContractWithMasterId(masterContractId, someOtherContractNumber);
            TestableInvokeHandlerContext context = new TestableMessageHandlerContext();

            // act
            CrmDeleteContractHandler handler = CreateCrmDeleteContractHandler();
            handler.Handle(new DeleteContractCommand
            {
                ContractNumber = contractNumber,
                VersionNumber = 1
            }, context).Wait();

            // assert
            Assert.IsFalse(IsContractPresentInCrm(contractNumber, 1, 0), "Contract version to delete is still present in CRM.");
            Assert.IsFalse(IsContractPresentInCrm(contractNumber, 1, 2), "Contract version to delete is still present in CRM.");
            Assert.IsTrue(IsContractPresentInCrm(masterContractNumber), "Master contract is still present in CRM.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmDeleteContractHandler_ShouldNotDeleteMasterWhenMasterHoldsOtherChildContracts()
        {
            ExtendedContract contract = GetCorporateContractFromResource();
            string contractNumber = contract.contracts.Single().contractNumber;
            string masterContractNumber = contract.contractNumber;
            const string newAmendmentSuffix = "-1617";

            // clean up
            DeleteContracts(contractNumber);
            DeleteContracts(contractNumber + newAmendmentSuffix);
            DeleteMasterAndChildContracts(masterContractNumber);

            // arrange
            CreateContract(contract);

            contract.contracts.Single().contractNumber += newAmendmentSuffix;
            contract.contracts.Single().period = new period { period1 = "1617" };
            contract.contracts.ForEach(c => c.contractAllocations.ForEach(a => a.contractAllocationNumber += newAmendmentSuffix));
            CreateNewAmendment(contract);
            TestableInvokeHandlerContext context = new TestableMessageHandlerContext();

            // act
            CrmDeleteContractHandler handler = CreateCrmDeleteContractHandler();
            handler.Handle(new DeleteContractCommand
            {
                ContractNumber = contractNumber,
                VersionNumber = 1
            }, context).Wait();

            // assert
            Assert.IsFalse(IsContractPresentInCrm(contractNumber, 1, 0), "Contract version to delete is still present in CRM.");
            Assert.IsTrue(IsContractPresentInCrm(contractNumber + newAmendmentSuffix, 1, 0), "Contract which should not be deleted is not present in CRM.");
            Assert.IsTrue(IsContractPresentInCrm(masterContractNumber), "Master contract is not present in CRM.");
        }

        private static void CreateContractWithMasterId(Guid masterContractId, string contractNumber)
        {
            sfa_contract contract = new sfa_contract
            {
                sfa_ParentContractId = new EntityReference(sfa_contract.EntityLogicalName, masterContractId),
                sfa_number = contractNumber,
                sfa_Version = 1,
                sfa_SubVersion = 0,
                sfa_ProviderName = GetProvider(),
                sfa_UKPRN = "1"
            };

            CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(contract);
        }

        private static EntityReference GetProvider()
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                var oId = xrmContext.AccountSet.Where(o => o.sfa_OrganisationID != null)
                    .Select(o => o.Id)
                    .First();

                return new EntityReference(Account.EntityLogicalName, oId);
            }
        }

        private Guid CreateContract(ExtendedContractType contract)
        {
            return CreateContractsManager().CreateContract(contract, Guid.NewGuid().ToString());
        }

        private static void UpdateDraftContract(contractType contract)
        {
            CreateContractsManager().UpdateContract(contract, Guid.NewGuid().ToString());
        }

        private static void AmendContract(ExtendedContractType contract)
        {
            CreateContractsManager().AmendContract(contract, Guid.NewGuid().ToString());
        }

        private static void CreateNewAmendment(ExtendedContractType contract)
        {
            CreateContractsManager().CreateNewAmendedContract(contract, Guid.NewGuid().ToString());
        }

        private static void ApproveContract(string contractNumber, int version)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                Guid contractId = context.sfa_contractSet.Single(c => c.sfa_number == contractNumber && c.sfa_Version == version).Id;
                Guid approvedSubStatus = context.sfa_statusSet.Single(s => s.sfa_name == "Approved").Id;

                organizationService.Update(new sfa_contract
                {
                    Id = contractId,
                    sfa_ContractStatusEnum = sfa_contractstatus.Approved,
                    sfa_SubStatus = new EntityReference(sfa_status.EntityLogicalName, approvedSubStatus),
                    sfa_LastApprovedVersion = true,
                    sfa_ContractApprovalDate = DateTime.UtcNow,
                    sfa_StatusLastUpdatedDate = DateTime.UtcNow
                });
            }
        }

        private static void DeleteContracts(string contractNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                context.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.Id)
                    .ForEach(id => organizationService.Delete("sfa_contract", id));
            }
        }

        private static void DeleteMasterAndChildContracts(string masterContractNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                context.sfa_contractSet
                    .Where(c => c.sfa_number == masterContractNumber)
                    .Select(c => c.Id)
                    .AsEnumerable()
                    .ForEach(masterContractId =>
                    {
                        context.sfa_contractSet
                            .Where(c => c.sfa_ParentContractId.Id == masterContractId)
                            .Select(c => c.Id)
                            .AsEnumerable()
                            .ForEach(contractId => organizationService.Delete("sfa_contract", contractId));

                        organizationService.Delete("sfa_contract", masterContractId);
                    });
            }
        }

        private static bool IsContractPresentInCrm(string contractNumber, int version, int subVersion)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                return context.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber && c.sfa_Version == version && c.sfa_SubVersion == subVersion)
                    .Select(c => c.Id)
                    .AsEnumerable()
                    .Any();
            }
        }

        private static bool IsContractPresentInCrm(string contractNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                return context.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.Id)
                    .AsEnumerable()
                    .Any();
            }
        }

        private static Guid GetContractId(string contractNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                return context.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.Id)
                    .AsEnumerable()
                    .Single();
            }
        }

        private static IContractsManager CreateContractsManager()
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

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

        private static ExtendedContract GetCorporateContractFromResource()
        {
            Mapper.CreateMap<contract, ExtendedContract>();
            Mapper.CreateMap<contractType, ExtendedContractType>();
            Mapper.CreateMap<contractAllocationsContractAllocation, ExtendedContractAllocation>();

            contract contract = TestResource.FromXml<contract>("ContractManagementDomain.Endpoint.Tests.Resources", "masterContract.xml");
            return Mapper.Map<contract, ExtendedContract>(contract);
        }

        private static CrmDeleteContractHandler CreateCrmDeleteContractHandler()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<CrmDeleteContractHandler>().LifestyleScoped())
                .Register(Component.For<ILogger>().Instance(Mock.Of<ILogger>()).LifestyleScoped().IsDefault());
            container.BeginScope();

            return container.Resolve<CrmDeleteContractHandler>();
        }
    }
}