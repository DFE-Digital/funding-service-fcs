namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Integration
{
    using System;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories;
    using CrmConnectionFactory = FCS.Worker.Common.Crm.CrmConnectionFactory;

    [TestClass]
    public class CrmAllocationRepositoryTests
    {
        private EntityReference _fundingTypeEntityReference;
        private EntityReference _providerEntityReference;

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractDeliverablePeriodRepository_ShouldGetMostRecentlyApprovedAllocation()
        {
            const string contractNumber = "XX-Test-XX";
            const string allocationNumber = "Test-Alloc";
            const int version = 1;

            // arrange
            DeleteContracts(contractNumber, version);

            Guid replacedContractGuid = CreateContract(contractNumber, version, sfa_contractstatus.Replaced);
            Guid expectedAllocationId = CreateAllocation(replacedContractGuid, allocationNumber);

            Guid approvedContractGuid = CreateContract(contractNumber, version, sfa_contractstatus.Approved);
            CreateAllocation(approvedContractGuid, allocationNumber);
            CrmAllocationRepository repository = new CrmAllocationRepository(GetCrmConnection());

            // act
            Guid? retrievedAllocationId = repository.GetMostRecentAllocationWithSubStatusApproved(allocationNumber, sfa_contractstatus.Replaced);

            // assert
            Assert.AreEqual(expectedAllocationId, retrievedAllocationId);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractDeliverablePeriodRepository_IsReplacedContractPresent_ShouldReturnTrueWhenReplacedPresent()
        {
            const string contractNumber = "XX-Test-XX";
            const string allocationNumber = "Test-Alloc";
            const int version = 1;

            // arrange
            DeleteContracts(contractNumber, version);

            Guid replacedContractGuid = CreateContract(contractNumber, version, sfa_contractstatus.Replaced);
            CreateAllocation(replacedContractGuid, allocationNumber);

            Guid approvedContractGuid = CreateContract(contractNumber, version, sfa_contractstatus.Approved);
            CreateAllocation(approvedContractGuid, allocationNumber);
            CrmAllocationRepository repository = new CrmAllocationRepository(GetCrmConnection());

            // act
            bool isReplacedPresent = repository.IsReplacedContractPresent(allocationNumber);

            // assert
            Assert.AreEqual(true, isReplacedPresent);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractDeliverablePeriodRepository_IsReplacedContractPresent_ShouldReturnFalseWhenReplacedIsNotPresent()
        {
            const string contractNumber = "XX-Test-XX";
            const string allocationNumber = "Test-Alloc";
            const int version = 1;

            // arrange
            DeleteContracts(contractNumber, version);

            Guid withdrawnContractGuid = CreateContract(contractNumber, version, sfa_contractstatus.Withdrawn);
            CreateAllocation(withdrawnContractGuid, allocationNumber);

            Guid approvedContractGuid = CreateContract(contractNumber, version, sfa_contractstatus.Approved);
            CreateAllocation(approvedContractGuid, allocationNumber);
            CrmAllocationRepository repository = new CrmAllocationRepository(GetCrmConnection());

            // act
            bool isReplacedPresent = repository.IsReplacedContractPresent(allocationNumber);

            // assert
            Assert.AreEqual(false, isReplacedPresent);
        }

        private void DeleteContracts(string contractNumber, int versionNumber)
        {
            using (var crmContext = new XrmServiceContext(GetCrmConnection()))
            {
                var matchingContracts =
                    crmContext.sfa_contractSet.Where(
                        c => c.sfa_number == contractNumber && c.sfa_Version == versionNumber)
                        .Select(c => c.Id);

                matchingContracts.ForEach(c => GetCrmConnection().Delete(sfa_contract.EntityLogicalName, c));
            }
        }

        private Guid CreateContract(string contractNumber, int version, sfa_contractstatus contractStatus)
        {
            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_LastApprovedVersion = false,
                sfa_FundingType = GetFundingType(),
                sfa_ProviderName = GetOrgEntityReference()
            };

            Guid guid = GetCrmConnection().Create(contract);

            contract = new sfa_contract
            {
                Id = guid,
                sfa_ContractStatus = new OptionSetValue((int)contractStatus),
                sfa_SubStatus = new EntityReference("sfa_status", GetSubStatusEntityId("Approved")) // Approved
            };

            contract.EntityState = EntityState.Changed;
            GetCrmConnection().Update(contract);

            return guid;
        }

        private Guid GetSubStatusEntityId(string name)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(GetCrmConnection()))
            {
                return xrmContext.sfa_statusSet.Single(s => s.sfa_name == name).Id;
            }
        }

        private Guid CreateAllocation(Guid contractId, string allocationNumber)
        {
            sfa_contractallocation allocation = new sfa_contractallocation
            {
               sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
               sfa_contractallocationnumber = allocationNumber
            };

            return GetCrmConnection().Create(allocation);
        }

        private EntityReference GetFundingType()
        {
            if (_fundingTypeEntityReference == null)
            {
                using (var crmContext = new XrmServiceContext(GetCrmConnection()))
                {
                    _fundingTypeEntityReference = crmContext.sfa_fundingtypeSet.First().ToEntityReference();
                }
            }

            return _fundingTypeEntityReference;
        }

        private EntityReference GetOrgEntityReference()
        {
            if (_providerEntityReference == null)
            {
                using (var crmContext = new XrmServiceContext(GetCrmConnection()))
                {
                    _providerEntityReference = crmContext.AccountSet.First().ToEntityReference();
                }
            }

            return _providerEntityReference;
        }

        private static IOrganizationService GetCrmConnection()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }
    }
}
