namespace ContractCreateDomain.Endpoint.Tests.XrmService.Integration_Tests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Endpoint.XrmService.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class ContractRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractRepository_ShouldGetContractInfo()
        {
            // arrange
            const string testContractNumber = "TestXrmSfaNo1";
            const string testAllocationNumber = "TestXrmAllocNumber1";
            const string testAllocationNumber2 = "TestXrmAllocNumber2";

            IOrganizationService xrmConnection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            RemoveContract(testContractNumber);
            Guid contractId = CreateContract(testContractNumber);

            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_contractallocationnumber = testAllocationNumber,
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId)
            };
            xrmConnection.Create(allocation);
            allocation = new sfa_contractallocation
            {
                sfa_contractallocationnumber = testAllocationNumber2,
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId)
            };
            xrmConnection.Create(allocation);
            ContractQueryRepository queryRepository = new ContractQueryRepository(xrmConnection);
            
            // act
            var contractInfo = queryRepository.GetContractInfo(testContractNumber, 1, 0);

            // assert
            Assert.IsTrue(contractInfo.HasValue, "we should have returned a contract");
            contractInfo.MatchSome(c =>
            {
                Assert.AreEqual(testContractNumber, c.ContractNumber, "The contract number is not correct");
                Assert.AreEqual(2, c.Allocations.Count, "The numnber of allocations is incorrect");
            });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractRepository_ShouldGetContractInfoWhenThereAreNoAllocations()
        {
            // arrange
            const string testContractNumber = "TestXrmSfaNo1";
            

            IOrganizationService xrmConnection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            RemoveContract(testContractNumber);
            Guid contractId = CreateContract(testContractNumber);

            ContractQueryRepository queryRepository = new ContractQueryRepository(xrmConnection);

            // act
            var contractInfo = queryRepository.GetContractInfo(testContractNumber, 1, 0);

            // assert
            Assert.IsTrue(contractInfo.HasValue, "we should have returned a contract");
            contractInfo.MatchSome(c =>
            {
                Assert.AreEqual(testContractNumber, c.ContractNumber, "The contract number is not correct");
                Assert.AreEqual(0, c.Allocations.Count, "The numnber of allocations is incorrect");
            });
        }

        private static void RemoveContract(string contractNumber)
        {
            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationSvc))
            {
                List<Guid> contractIds = xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.Id).ToList();

                contractIds.ForEach(c => organizationSvc.Delete(sfa_contract.EntityLogicalName, c));
            }
        }

        private static Guid CreateContract(string contractNumber)
        {
            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationSvc))
            {
                sfa_contract contract = new sfa_contract
                {
                    sfa_number = contractNumber,
                    sfa_Version = 1,
                    sfa_SubVersion = 0,
                    sfa_ContractStatus = new OptionSetValue((int)sfa_contractstatus.Draft),
                    sfa_SubStatus = GetSubstatus(xrmContext, "In Review"),
                    sfa_ProviderName = GetFirstProvider(xrmContext)
                };

                return organizationSvc.Create(contract);
            }
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
    }
}
