namespace ContractManagementDomain.Endpoint.Xrm.Tests.ContractClosure.Services
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
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using UnitTests.Common;
    using Xrm.ContractClosure.Repositories;
    using Xrm.ContractClosure.Services;
    using CrmConnectionFactory = SFA.FCS.Worker.Common.Crm.CrmConnectionFactory;

    [TestClass]
    public class ContractClosureServiceTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractClosureService_CloseContract_ShouldUpdateContractToClosed()
        {
            ExtendedContract contract = GetCorporateContractFromResource();
            string masterContractNumber = contract.contractNumber;
            string contractNumber = contract.contracts.Single().contractNumber;
            int versionNumber = contract.contracts.Single().contractVersionNumber;
            int subVersionNumber = contract.contracts.Single().contractSubVersionNumber;

            // clean up
            DeleteContracts(contractNumber);
            DeleteMasterAndChildContracts(masterContractNumber);

            // arrange
            CreateContract(contract);
            SetContractState(contractNumber, versionNumber, subVersionNumber, sfa_contractstatus.Approved, "Closure in Progress");

            ContractClosureService contractClosureService = new ContractClosureService(new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService()));

            // act
            contractClosureService.CloseContractInCrm(contractNumber, versionNumber, subVersionNumber, closureDate: DateTime.UtcNow, isContractOpenEnded: false);

            // assert
            sfa_contract updatedContract = GetContract(contractNumber, versionNumber, subVersionNumber);

            Assert.AreEqual(sfa_contractstatus.Closed, updatedContract.sfa_ContractStatusEnum, "Status not set to Closed");
            Assert.AreEqual("Closed", updatedContract.sfa_SubStatus.Name, "SubStatus not set to Closed");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractClosureService_CloseContract_ShouldNotUpdateContractWhenAlreadyClosed()
        {
            ExtendedContract contract = GetCorporateContractFromResource();
            string masterContractNumber = contract.contractNumber;
            string contractNumber = contract.contracts.Single().contractNumber;
            int versionNumber = contract.contracts.Single().contractVersionNumber;
            int subVersionNumber = contract.contracts.Single().contractSubVersionNumber;

            // clean up
            DeleteContracts(contractNumber);
            DeleteMasterAndChildContracts(masterContractNumber);

            // arrange
            CreateContract(contract);
            SetContractState(contractNumber, versionNumber, subVersionNumber, sfa_contractstatus.Closed, "Closed");

            ContractClosureService contractClosureService = new ContractClosureService(new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService()));

            // act
            contractClosureService.CloseContractInCrm(contractNumber, versionNumber, subVersionNumber, closureDate: DateTime.UtcNow, isContractOpenEnded: false);

            // assert - CRM will throw exception when attempt is made to move from Closed state to Closed state
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractClosureService_CloseContract_ShouldUpdateContractAndAllocationEndDatesWhenContractIsOpenEnded()
        {
            ExtendedContract contract = GetCorporateContractFromResource();
            string masterContractNumber = contract.contractNumber;
            string contractNumber = contract.contracts.Single().contractNumber;
            int versionNumber = contract.contracts.Single().contractVersionNumber;
            int subVersionNumber = contract.contracts.Single().contractSubVersionNumber;
            DateTime closureDate = new DateTime(DateTime.UtcNow.Year, DateTime.UtcNow.Month, DateTime.UtcNow.Day, 0, 0,0, DateTimeKind.Utc);

            // clean up
            DeleteContracts(contractNumber);
            DeleteMasterAndChildContracts(masterContractNumber);

            // arrange
            contract.contracts.Single().endDate = null;
            contract.contracts.Single().contractAllocations.ForEach(a => a.endDate = null);
            CreateContract(contract);
            SetContractState(contractNumber, versionNumber, subVersionNumber, sfa_contractstatus.Approved, "Closure in Progress");

            ContractClosureService contractClosureService = new ContractClosureService(new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService()));

            // act
            contractClosureService.CloseContractInCrm(contractNumber, versionNumber, subVersionNumber, closureDate, isContractOpenEnded: true);

            // assert
            sfa_contract updatedContract = GetContract(contractNumber, versionNumber, subVersionNumber);
            IReadOnlyCollection<sfa_contractallocation> updatedAllocations = GetAllocationsForContract(updatedContract.Id);

            Assert.AreEqual(closureDate, updatedContract.sfa_EndDate, "Contract end date not set");
            Assert.IsTrue(updatedAllocations.All(a => a.sfa_enddate == closureDate), "Allocation end dates not set");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractClosureService_CloseContract_ShouldNotUpdateContractAndAllocationEndDatesWhenContractIsNotOpenEnded()
        {
            ExtendedContract contract = GetCorporateContractFromResource();
            string masterContractNumber = contract.contractNumber;
            string contractNumber = contract.contracts.Single().contractNumber;
            int versionNumber = contract.contracts.Single().contractVersionNumber;
            int subVersionNumber = contract.contracts.Single().contractSubVersionNumber;
            DateTime contractEndDate = new DateTime(2016, 12, 31);

            // clean up
            DeleteContracts(contractNumber);
            DeleteMasterAndChildContracts(masterContractNumber);

            // arrange
            contract.contracts.Single().endDate = contractEndDate;
            contract.contracts.Single().contractAllocations.ForEach(a => a.endDate = contractEndDate);
            CreateContract(contract);
            SetContractState(contractNumber, versionNumber, subVersionNumber, sfa_contractstatus.Approved, "Closure in Progress");

            ContractClosureService contractClosureService = new ContractClosureService(new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService()));

            // act
            contractClosureService.CloseContractInCrm(contractNumber, versionNumber, subVersionNumber, closureDate: DateTime.UtcNow, isContractOpenEnded: false);

            // assert
            sfa_contract updatedContract = GetContract(contractNumber, versionNumber, subVersionNumber);
            IReadOnlyCollection<sfa_contractallocation> updatedAllocations = GetAllocationsForContract(updatedContract.Id);

            Assert.AreEqual(contractEndDate, updatedContract.sfa_EndDate, "Contract end date was updated");
            Assert.IsTrue(updatedAllocations.All(a => a.sfa_enddate == contractEndDate), "Allocation end dates were updated");
        }

        private static void CreateContract(ExtendedContractType contract)
        {
            CreateContractsManager().CreateContract(contract, Guid.NewGuid().ToString());
        }

        private static void DeleteContracts(string contractNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                context.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.Id)
                    .ForEach(id => ActionRetrier.RetryWhenExceptionThrown(() => organizationService.Delete("sfa_contract", id)));
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
                            .ForEach(contractId => ActionRetrier.RetryWhenExceptionThrown(() => organizationService.Delete("sfa_contract", contractId)));

                        ActionRetrier.RetryWhenExceptionThrown(() => organizationService.Delete("sfa_contract", masterContractId));
                    });
            }
        }

        private static sfa_contract GetContract(string contractNumber, int versionNumber, int subVersionNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                return context.sfa_contractSet
                    .Single(c => c.sfa_number == contractNumber && c.sfa_Version == versionNumber && c.sfa_SubVersion == subVersionNumber);
            }
        }

        private static IReadOnlyCollection<sfa_contractallocation> GetAllocationsForContract(Guid contractId)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                return context.sfa_contractallocationSet
                    .Where(a => a.sfa_ContractId.Id == contractId)
                    .ToList();
            }
        }

        private static void SetContractState(string contractNumber, int versionNumber, int subVersionNumber, sfa_contractstatus status, string subStatusName)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
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

            contract contract = TestResource.FromXml<contract>("ContractManagementDomain.Endpoint.Xrm.Tests.Resources", "masterContract.xml");
            return Mapper.Map<contract, ExtendedContract>(contract);
        }
    }
}
