namespace PerformanceManagementDomain.Tests.RecalculationInitiated.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using PerformanceManagementDomain.RecalculationInitiated.Dto;
    using PerformanceManagementDomain.RecalculationInitiated.Repositories;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class FundingClaimReconciliationRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimReconciliationRepository_ShouldReturnExpectedInformation()
        {
            // arrange
            const string contractNumber = "TEST-1234";
            const string allocationNumber = "ALLOC-1234";
            const string periodTypeCode = "AY";
            const string period = "1819";
            const string claimTypeName = "Final";
            const int contractVersion = 1;
            const int claimVersionNumber = 1;
            const string allocationGroupCode = "AEBC1819";
            const decimal allocationClaimAdjustmentValue = 123.45m;

            Account provider = GetFirstProvider();

            RemoveFcrsRelatedToAllocation(allocationNumber);
            DeleteContracts(contractNumber);

            Guid contractId = CreateContract(contractNumber, contractVersion, provider);
            Guid allocationId = CreateAllocation(allocationNumber, contractId);
            Guid fcrId = CreateDraftFcrRelatedToAllocation(allocationId, periodTypeCode + period, claimTypeName, claimVersionNumber, allocationGroupCode, provider, allocationClaimAdjustmentValue);

            FundingClaimReconciliationRepository fundingClaimReconciliationRepository = new FundingClaimReconciliationRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act
            FundingClaimReconciliationInfo fcrInfo = fundingClaimReconciliationRepository.GetFundingClaimReconciliationInfo(fcrId);

            // assert
            Assert.IsNotNull(fcrInfo, "Unexpected null reference returned");
            Assert.AreEqual(fcrId, fcrInfo.FcrId, "Unexpected FcrId returned");
            Assert.AreEqual(claimVersionNumber, fcrInfo.ClaimVersionNumber, "Unexpected ClaimVersionNumber returned");
            Assert.AreEqual(provider.sfa_OrganisationID, fcrInfo.OrganisationIdentifier, "Unexpected OrganisationIdentifier returned");
            Assert.AreEqual(claimTypeName, fcrInfo.ClaimTypeName, "Unexpected ClaimTypeName returned");
            Assert.AreEqual(periodTypeCode, fcrInfo.PeriodTypeCode, "Unexpected PeriodTypeCode returned");
            Assert.AreEqual(period, fcrInfo.Period, "Unexpected Period returned");
            Assert.AreEqual(allocationGroupCode, fcrInfo.AllocationGroupCode, "Unexpected AllocationGroupCode returned");

            Assert.AreEqual(1, fcrInfo.Allocations.Count, "Unexpected number of Allocations returned");
            Assert.AreEqual(allocationClaimAdjustmentValue, fcrInfo.Allocations.Single().ClaimAdjustmentValue, "Unexpected Allocation ClaimAdjustmentValue returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimReconciliationRepository_ShouldReturnExpectedInformation_WhenClaimAdjustmentNull()
        {
            // arrange
            const string contractNumber = "TEST-1234";
            const string allocationNumber = "ALLOC-1234";
            const string periodTypeCode = "AY";
            const string period = "1819";
            const string claimTypeName = "Final";
            const int contractVersion = 1;
            const int claimVersionNumber = 1;
            const string allocationGroupCode = "AEBC1819";
            decimal? allocationClaimAdjustmentValue = null;

            Account provider = GetFirstProvider();

            RemoveFcrsRelatedToAllocation(allocationNumber);
            DeleteContracts(contractNumber);

            Guid contractId = CreateContract(contractNumber, contractVersion, provider);
            Guid allocationId = CreateAllocation(allocationNumber, contractId);
            Guid fcrId = CreateDraftFcrRelatedToAllocation(allocationId, periodTypeCode + period, claimTypeName, claimVersionNumber, allocationGroupCode, provider, allocationClaimAdjustmentValue);

            FundingClaimReconciliationRepository fundingClaimReconciliationRepository = new FundingClaimReconciliationRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act
            FundingClaimReconciliationInfo fcrInfo = fundingClaimReconciliationRepository.GetFundingClaimReconciliationInfo(fcrId);

            // assert
            Assert.IsNotNull(fcrInfo, "Unexpected null reference returned");
            Assert.AreEqual(fcrId, fcrInfo.FcrId, "Unexpected FcrId returned");
            Assert.AreEqual(claimVersionNumber, fcrInfo.ClaimVersionNumber, "Unexpected ClaimVersionNumber returned");
            Assert.AreEqual(provider.sfa_OrganisationID, fcrInfo.OrganisationIdentifier, "Unexpected OrganisationIdentifier returned");
            Assert.AreEqual(claimTypeName, fcrInfo.ClaimTypeName, "Unexpected ClaimTypeName returned");
            Assert.AreEqual(periodTypeCode, fcrInfo.PeriodTypeCode, "Unexpected PeriodTypeCode returned");
            Assert.AreEqual(period, fcrInfo.Period, "Unexpected Period returned");
            Assert.AreEqual(allocationGroupCode, fcrInfo.AllocationGroupCode, "Unexpected AllocationGroupCode returned");

            Assert.AreEqual(1, fcrInfo.Allocations.Count, "Unexpected number of Allocations returned");
            Assert.AreEqual(0, fcrInfo.Allocations.Single().ClaimAdjustmentValue, "Unexpected Allocation ClaimAdjustmentValue returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimReconciliationRepository_ShouldReturnExpectedInformation_WhenAllocationHasDeliveryOrg()
        {
            // arrange
            const string contractNumber = "TEST-1234";
            const string allocationNumber = "ALLOC-1234";
            const string periodTypeCode = "AY";
            const string period = "1819";
            const string claimTypeName = "Final";
            const int contractVersion = 1;
            const int claimVersionNumber = 1;
            const string allocationGroupCode = "AEBC1819";
            decimal? allocationClaimAdjustmentValue = null;

            Account provider = GetFirstProvider();
            Account provider2 = GetFirstProviderNotThisOne(provider.Id);

            RemoveFcrsRelatedToAllocation(allocationNumber);
            DeleteContracts(contractNumber);

            Guid contractId = CreateContract(contractNumber, contractVersion, provider);
            Guid allocationId = CreateAllocationWithDeliveryOrg(allocationNumber, contractId, provider2.ToEntityReference());
            Guid fcrId = CreateDraftFcrRelatedToAllocation(allocationId, periodTypeCode + period, claimTypeName, claimVersionNumber, allocationGroupCode, provider, allocationClaimAdjustmentValue);

            FundingClaimReconciliationRepository fundingClaimReconciliationRepository = new FundingClaimReconciliationRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act
            FundingClaimReconciliationInfo fcrInfo = fundingClaimReconciliationRepository.GetFundingClaimReconciliationInfo(fcrId);

            // assert
            Assert.IsNotNull(fcrInfo, "Unexpected null reference returned");
            Assert.AreEqual(fcrId, fcrInfo.FcrId, "Unexpected FcrId returned");
            Assert.AreEqual(claimVersionNumber, fcrInfo.ClaimVersionNumber, "Unexpected ClaimVersionNumber returned");
            Assert.AreEqual(provider2.sfa_OrganisationID, fcrInfo.OrganisationIdentifier, "Unexpected OrganisationIdentifier returned");
            Assert.AreEqual(claimTypeName, fcrInfo.ClaimTypeName, "Unexpected ClaimTypeName returned");
            Assert.AreEqual(periodTypeCode, fcrInfo.PeriodTypeCode, "Unexpected PeriodTypeCode returned");
            Assert.AreEqual(period, fcrInfo.Period, "Unexpected Period returned");
            Assert.AreEqual(allocationGroupCode, fcrInfo.AllocationGroupCode, "Unexpected AllocationGroupCode returned");

            Assert.AreEqual(1, fcrInfo.Allocations.Count, "Unexpected number of Allocations returned");
            Assert.AreEqual(0, fcrInfo.Allocations.Single().ClaimAdjustmentValue, "Unexpected Allocation ClaimAdjustmentValue returned");
        }

        private static void RemoveFcrsRelatedToAllocation(string allocationNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext xrmContext = new XrmServiceContext(organizationService))
            {
                List<Guid> fcrs = (from fcr in xrmContext.sfa_fundingclaimreconciliationSet
                            join fcra in xrmContext.sfa_fcrallocationSet on fcr.Id equals
                                fcra.sfa_FundingClaimReconciliationId.Id
                            join ca in xrmContext.sfa_contractallocationSet on fcra.sfa_ContractAllocationId.Id equals
                                ca.Id
                            where ca.sfa_contractallocationnumber == allocationNumber

                            select fcr.Id).ToList();

                fcrs.ForEach(f => organizationService.Delete(sfa_fundingclaimreconciliation.EntityLogicalName, f));
            }
        }

        private static void DeleteContracts(string contractNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext xrmContext = new XrmServiceContext(organizationService))
            {
                xrmContext.sfa_contractSet.Where(c => c.sfa_number == contractNumber).ToList()
                     .ForEach(ca => organizationService.Delete(sfa_contract.EntityLogicalName, ca.Id));
            }
        }

        private static Guid CreateContract(string contractNumber, int version, Entity provider)
        {
            sfa_contract contract = new sfa_contract
            {
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_SubVersion = 1,
                sfa_ProviderName = provider.ToEntityReference(),
                sfa_UKPRN = "1"
            };

            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(contract);
        }

        private static Account GetFirstProvider()
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return xrmContext.AccountSet.First(o => o.sfa_OrganisationID != null);
            }
        }

        private static Account GetFirstProviderNotThisOne(Guid accountId)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return xrmContext.AccountSet.First(o => o.Id != accountId && o.sfa_OrganisationID != null);
            }
        }

        private static Guid CreateAllocation(string allocationNumber, Guid contractId)
        {
            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_contractallocationnumber = allocationNumber,
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                sfa_FundingStreamId = GetFundingStream()
            };

            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(allocation);
        }

        private static Guid CreateAllocationWithDeliveryOrg(string allocationNumber, Guid contractId, EntityReference deliveryOrg)
        {
            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_contractallocationnumber = allocationNumber,
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                sfa_FundingStreamId = GetFundingStream(),
                sfa_deliveryorganisationprovider = deliveryOrg
            };

            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(allocation);
        }

        private static EntityReference GetFundingStream()
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return xrmContext.sfa_fundingstreamSet.First().ToEntityReference();
            }
        }

        private static Guid CreateDraftFcrRelatedToAllocation(
            Guid allocationId,
            string fundingPeriod,
            string claimTypeName,
            int claimVersionNumber,
            string allocationGroupCode,
            Entity provider,
            decimal? allocationClaimAdjustmentValue)
        {
            sfa_fundingclaimreconciliation fcr = new sfa_fundingclaimreconciliation
            {
                sfa_name = "TEST-FCR",
                sfa_StatusCodeEnum = sfa_sfastatuscode.Draft,
                sfa_ClaimTypeId = GetClaimType(claimTypeName),
                sfa_ProviderId = provider.ToEntityReference(),
                sfa_FundingPeriodId = GetFundingPeriod(fundingPeriod),
                sfa_AllocationGroupId = GetAllocationGroup(allocationGroupCode),
                sfa_ClaimVersionNumber = claimVersionNumber
            };

            Guid fcrId = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(fcr);

            sfa_fcrallocation fcrallocation = new sfa_fcrallocation
            {
                sfa_FundingClaimReconciliationId = new EntityReference(sfa_fundingclaimreconciliation.EntityLogicalName, fcrId),
                sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationId),
                sfa_claimadjustmentvalue = allocationClaimAdjustmentValue
            };

            CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(fcrallocation);

            return fcrId;
        }

        private static EntityReference GetClaimType(string claimType)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return xrmContext.sfa_claimtypeSet.First(ct => ct.sfa_name == claimType).ToEntityReference();
            }
        }

        private static EntityReference GetFundingPeriod(string fundingPeriod)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return xrmContext.sfa_periodSet.First(p => p.sfa_periodname == fundingPeriod).ToEntityReference();
            }
        }

        private static EntityReference GetAllocationGroup(string allocationGroupCode)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return xrmContext.sfa_claimreconallocgroupSet
                    .Single(crag => crag.sfa_AllocationGroupCode == allocationGroupCode)
                    .ToEntityReference();
            }
        }
    }
}
