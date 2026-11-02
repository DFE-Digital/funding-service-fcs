namespace ContractManagement.Cfs.Tests.Repositories
{
    using System;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using ContractManagement.Cfs.Repositories;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class ContractRepositoryTests
    {
        private const string MasterContractNumber = "MCN_Alloc";
        private const string ContractNumber = "CCN_Alloc";

        private Guid _masterContractId;
        private Guid _childContractId;

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationRepository_ShouldGetChildContractEntityReference()
        {
            // arrange
            ClearContractAndMasterContractForContractNumber(ContractNumber);
            SetUpContract();
            var childContractEntityReference = new EntityReference(sfa_contract.EntityLogicalName, _childContractId);

            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            var contractRepository = new ContractRepository(organizationService);
            // act
            var assertChildContractEntityReference = contractRepository.GetChildContractEntityReference(_masterContractId);

            // assert
            Assert.AreEqual(childContractEntityReference, assertChildContractEntityReference, "Incorrect childContractEntityReference returned");
        }

        private void SetUpContract()
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                Account contractProvider = xrmContext.AccountSet.First();

                sfa_contract masterContract = new sfa_contract
                {
                    sfa_UKPRN = contractProvider.sfa_UKPRN,
                    sfa_number = MasterContractNumber,
                    sfa_HierarchyType = new OptionSetValue((int) sfa_contracthierarchytype.Master),
                    sfa_Version = 1,
                    sfa_SubVersion = 0,
                    sfa_ProviderName = contractProvider.ToEntityReference()
                };

                _masterContractId = organizationService.Create(masterContract);

                sfa_contract contract = new sfa_contract
                {
                    sfa_UKPRN = contractProvider.sfa_UKPRN,
                    sfa_number = ContractNumber,
                    sfa_HierarchyType = new OptionSetValue((int) sfa_contracthierarchytype.Contract),
                    sfa_Version = 1,
                    sfa_SubVersion = 0,
                    sfa_ParentContractId = new EntityReference(sfa_contract.EntityLogicalName, _masterContractId),
                    sfa_ProviderName = contractProvider.ToEntityReference()
                };

                _childContractId = organizationService.Create(contract);
            }
        }

        private static void ClearContractAndMasterContractForContractNumber(string contractNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => new {MasterId = c.sfa_ParentContractId.Id, ContractId = c.sfa_contractId})
                    .ToList()
                    .ForEach(c =>
                    {
                        organizationService.Delete(sfa_contract.EntityLogicalName, c.ContractId.Value);
                        organizationService.Delete(sfa_contract.EntityLogicalName, c.MasterId);
                    });
            }
        }
    }
}