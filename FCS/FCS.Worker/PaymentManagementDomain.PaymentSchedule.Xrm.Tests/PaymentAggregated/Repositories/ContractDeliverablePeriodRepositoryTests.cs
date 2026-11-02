namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests.PaymentAggregated.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using AutoMapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client.Services;
    using UnitTests.Common;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.DTOs;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.Repositories;
    using CrmConnectionFactory = SFA.FCS.Worker.Common.Crm.CrmConnectionFactory;

    [TestClass]
    public class ContractDeliverablePeriodRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractDeliverablePeriodRepository_GetContractDeliverablePeriodsForAllocation_ShouldReturnExpectedContractDeliverablePeriods()
        {
            // clean up
            DeleteAllocations("ALLB-665");
            DeleteContracts("24Loans-1049");
            DeleteContracts("SFA-6442");

            // arrange
            var contractDeliverablePeriodRepository = new ContractDeliverablePeriodRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            CreateContract(GetMasterContractFromResource());
            SetContractAsLastApprovedVersion("24Loans-1049");

            // act
            IReadOnlyCollection<ContractDeliverablePeriodInfo> contractDeliverablePeriods =
                contractDeliverablePeriodRepository.GetContractDeliverablePeriodsForAllocation("ALLB-665");

            // assert
            Assert.AreEqual(12, contractDeliverablePeriods.Count, "Unexpected number of contract deliverable periods returned.");
        }

        private static ExtendedContract GetMasterContractFromResource()
        {
            contract corporateContract = TestResource.FromXml<contract>(
                "PaymentManagementDomain.PaymentSchedule.Xrm.Tests.Resources", "masterContract.xml");

            Mapper.CreateMap<contract, ExtendedContract>();
            Mapper.CreateMap<contractType, ExtendedContractType>();
            Mapper.CreateMap<contractAllocationsContractAllocation, ExtendedContractAllocation>();

            return Mapper.Map<contract, ExtendedContract>(corporateContract);
        }

        private static void CreateContract(ExtendedContractType masterContract)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            
            ContractsManager contractsManager = new ContractsManager
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
                }
            };

            contractsManager.CreateContract(masterContract, Guid.NewGuid().ToString());
            
        }

        private static void SetContractAsLastApprovedVersion(string contractNumber)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext xrmContext = new XrmServiceContext(organizationService))
            {
                var contract = xrmContext.sfa_contractSet.Single(c => c.sfa_number == contractNumber);
                contract.sfa_LastApprovedVersion = true;
                xrmContext.UpdateObject(contract);
                xrmContext.SaveChanges();
            }
        }

        private static void DeleteContracts(string contractNumber)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.Id)
                    .ToList()
                    .ForEach(id => ErrorAbsorbingExecutor.XrmExecute(() => organizationService.Delete("sfa_contract", id)));
            }
        }

        private static void DeleteAllocations(string allocationNumber)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                xrmContext.sfa_contractallocationSet
                    .Where(a => a.sfa_contractallocationnumber == allocationNumber)
                    .Select(a => a.Id)
                    .ToList()
                    .ForEach(id => organizationService.Delete("sfa_contractallocation", id));
            }
        }
    }
}