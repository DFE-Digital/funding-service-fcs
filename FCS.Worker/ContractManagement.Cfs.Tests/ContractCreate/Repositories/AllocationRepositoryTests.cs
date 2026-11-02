namespace ContractManagement.Cfs.Tests.ContractCreate.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using Microsoft.Xrm.Sdk;
    using ContractManagement.Cfs.ContractCreate.Repositories;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class AllocationRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationRepository_ShouldReleaseAnAllocation()
        {
            // arrange
            const string allocationRef = "AllocationRepositoryTest";
            const string contractNumber = "CNForAlloc";
            const int contractVersion = 1;
            const int contractSubVersion = 1;
            string ukprn = GetUkprnFromCrm().ToString();
            
            // setup allocation 
            ClearDownAllocation(allocationRef);
            Guid allocationId = CreateAllocation(allocationRef, ukprn);

            // setup contract
            ClearDownContract(contractNumber);
            Guid contractId = CreateContract(contractNumber, contractVersion, contractSubVersion, ukprn);
            var contractEntityReference = new EntityReference(sfa_contract.EntityLogicalName, contractId);

            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            var allocationRepository = new AllocationRepository(organizationSvc);

            // act 
            allocationRepository.ReleaseAllocation(allocationId, contractEntityReference);

            using (var context = new XrmServiceContext(organizationSvc))
            {
                var assertAllocation = context.sfa_allocationSet
                    .Single(a => a.sfa_name == allocationRef);

                // assert
                Assert.AreEqual(allocationId, assertAllocation.Id, "Incorrect allocation retrieved from CRM");

                Assert.AreEqual(contractNumber, assertAllocation.sfa_contract.Name, "Incorrect ContractNumber stored in CRM allocation");
                Assert.AreEqual(contractId, assertAllocation.sfa_contract.Id, "Incorrect Contract Id stored in CRM allocation");

                Assert.AreEqual((int)sfa_AllocationServiceResponse.Released, assertAllocation.sfa_serviceresponse.Value, "Incorrect ServiceResponse (Released) stored in CRM allocation");
            }
        }

        private static void ClearDownAllocation(string allocationRef)
        {
            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var context = new XrmServiceContext(organizationSvc))
            {
                List<Guid> allocationIds = context.sfa_allocationSet
                    .Where(a => a.sfa_name == allocationRef)
                    .Select(c => c.Id).ToList();

                allocationIds.ForEach(a => organizationSvc.Delete(sfa_allocation.EntityLogicalName, a));
            }
        }

        private static Guid CreateAllocation(string allocationRef, string ukprn)
        {
            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            sfa_allocation crmAllocation = new sfa_allocation
            {
                sfa_ukprn = ukprn,
                sfa_name = allocationRef
            };

            return organizationSvc.Create(crmAllocation);
        }
        
        private static void ClearDownContract(string contractNumber)
        {
            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var context = new XrmServiceContext(organizationSvc))
            {
                List<Guid> contractIds = context.sfa_contractSet
                    .Where(a => a.sfa_number == contractNumber)
                    .Select(c => c.Id).ToList();

                contractIds.ForEach(c => organizationSvc.Delete(sfa_contract.EntityLogicalName, c));
            }
        }

        private static Guid CreateContract(string contractNumber, int version, int subVersion, string ukprn)
        {
            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            sfa_contract contract = new sfa_contract
            {
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_SubVersion = subVersion,
                sfa_ProviderName = GetProviderEntityReferenceFromCrm(ukprn),
                sfa_UKPRN = ukprn
            };

            Guid contractId = organizationSvc.Create(contract);

            return contractId;
        }

        private static int GetUkprnFromCrm()
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return int.Parse(context.AccountSet.First(a => a.sfa_UKPRN != null).sfa_UKPRN);
            }
        }

        private static EntityReference GetProviderEntityReferenceFromCrm(string ukprn)
        {
            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var context = new XrmServiceContext(organizationSvc))
            {
                return context.AccountSet.First(o => o.sfa_UKPRN == ukprn).ToEntityReference();
            }
        }
    }
}