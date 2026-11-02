namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.CrmRepositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.CrmRepositories;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class CrmFundingClaimReconciliationRepositoryTests
    {
        private EntityReference _providerEntityReference = null;
        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingClaimReconciliationRepository_ShouldGetFcrInfos()
        {
            // arrange
            const string contractNumber = "Test C";
            const string allocationNumber = "Test Alloc";
            const string period = "1718";
            const string periodType = "FY";
            const string claimTypeName = "Final";
            const int contractVersion = 1;
            const int claimVersionNumber = 1;
            const decimal cappedClaimAdjustment = 56.78m;
            RemoveFcrsForThisProvider(GetProvider().Id);
            DeleteContracts(contractNumber);

            Guid contractId = CreateContract(contractNumber, contractVersion);
            Guid allocationId = CreateAllocation(allocationNumber, contractId);
            FcrIdSet fcrIds = CreateDraftFcrRelatedToAllocation(allocationId,
                periodType + period,
                claimTypeName,
                claimVersionNumber,
                fcrAllocationPlannedValue: null,
                cappedClaimAdjustment: cappedClaimAdjustment);

            CrmFundingClaimReconciliationRepository repository =
                new CrmFundingClaimReconciliationRepository(GetConnection());

            // act 
            IReadOnlyCollection<FundingClaimReconciliationInformation> fcrInfos = repository.GetFundingClaimReconciliationInfos(allocationNumber);

            // assert
            Assert.AreEqual(1, fcrInfos.Count, "The wrong number of fcrs have been returned");

            var fcrInfo = fcrInfos.First();
            Assert.AreEqual(period, fcrInfo.Period, "The wrong period on the FCR");
            Assert.AreEqual(periodType, fcrInfo.PeriodTypeCode, "The wrong periodType on the FCR");
            Assert.IsTrue(fcrInfo.IsDraft, "The FCR is not draft");
            Assert.AreEqual(claimTypeName.ToUpper(), fcrInfo.ClaimTypeName, "The ClaimTypeName returned is not correct");
            Assert.AreEqual(fcrIds.FcrId, fcrInfo.FcrCrmId, "The FcrCrmId is not correct");
            Assert.AreEqual(cappedClaimAdjustment, fcrInfo.CappedClaimAdjustment, "The CappedClaimAdjustment is not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingClaimReconciliationRepository_UpdateValues_ShouldUpdateValues()
        {
            // arrange
            const string contractNumber = "Test C";
            const string allocationNumber = "Test Alloc";
            const string period = "1718";
            const string periodType = "FY";
            const string claimTypeName = "Final";
            const int claimVersionNumber = 1;
            const int contractVersion = 1;
            const decimal newProposedValue = 12345689.01m;
            const decimal newPlannedValue = 200m;
            const decimal adjustedCappedClaimValue = 220m;
            const decimal cappedClaimedValue = 201m;
            RemoveFcrsForThisProvider(GetProvider().Id);
            DeleteContracts(contractNumber);

            Guid contractId = CreateContract(contractNumber, contractVersion);
            Guid allocationId = CreateAllocation(allocationNumber, contractId);
            FcrIdSet fcrIds = CreateDraftFcrRelatedToAllocation(allocationId, periodType + period, claimTypeName, claimVersionNumber);

            CrmFundingClaimReconciliationRepository repository =
                new CrmFundingClaimReconciliationRepository(GetConnection());

            // act
            repository.UpdateValues(fcrIds.FcrId, newProposedValue, newPlannedValue, adjustedCappedClaimValue, cappedClaimedValue);

            var fcrInCrm = GetFcr(fcrIds.FcrId);

            // assert
            Assert.AreEqual(newProposedValue, fcrInCrm.sfa_ProposedReconciliationValue, "Value in CRM did not match updated Proposed Reconciliation Value");
            Assert.AreEqual(newPlannedValue, fcrInCrm.sfa_PlannedValue, "Value in CRM did not match updated PlannedValue");
            Assert.AreEqual(adjustedCappedClaimValue, fcrInCrm.sfa_adjustedcappedclaimedvalue, "Value in CRM did not match updated adjustedCappedClaimValue");
            Assert.AreEqual(cappedClaimedValue, fcrInCrm.sfa_CappedClaimedValue, "Value in CRM did not match updated cappedClaimedValue");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingClaimReconciliationRepository_ShouldAssociateAllocationToFcr()
        {
            // arrange
            const string contractNumber = "Test C";
            const string allocationNumber = "Test Alloc";
            const string period = "1718";
            const string periodType = "FY";
            const string claimTypeName = "Final";
            const int claimVersionNumber = 1;
            const int contractVersion = 1;
            const decimal plannedValue = 111;
            const decimal proposedReconciliationValue = 222;
            const decimal adjustedCappedClaimValue = 100m;
            const decimal cappedClaimValue = 101m;
            RemoveFcrsForThisProvider(GetProvider().Id);
            DeleteContracts(contractNumber);

            Guid contractId = CreateContract(contractNumber, contractVersion);
            Guid amendedContractId = CreateContract(contractNumber, contractVersion + 1);
            Guid allocationId = CreateAllocation(allocationNumber, contractId);
            FcrIdSet fcrIds = CreateDraftFcrRelatedToAllocation(allocationId, periodType + period, claimTypeName, claimVersionNumber);
            Guid newAllocationId = CreateAllocation(allocationNumber, amendedContractId);

            CrmFundingClaimReconciliationRepository repository =
                new CrmFundingClaimReconciliationRepository(GetConnection());

            // act
            repository.AssociateAllocationToFcrAndUpdateValues(
                fcrIds.FcrId,
                fcrIds.FcrAllocId,
                allocationNumber,
                contractVersion + 1,
                1,
                plannedValue,
                proposedReconciliationValue,
                adjustedCappedClaimValue,
                cappedClaimValue);

            // assert
            var fcrAllocationsInCrm = GetFcrAllocations(fcrIds.FcrId);
            var firstAllocation = fcrAllocationsInCrm.First();
            Assert.AreEqual(newAllocationId, firstAllocation.sfa_ContractAllocationId.Id, "The allocation associated is incorrect");
            Assert.AreEqual(plannedValue, firstAllocation.sfa_PlannedValue, "The planned value is incorrect");
            Assert.AreEqual(proposedReconciliationValue, firstAllocation.sfa_ProposedReconciliationValue, "The proposed reconciliation value is incorrect");
            Assert.AreEqual(adjustedCappedClaimValue, firstAllocation.sfa_adjustedcappedclaimedvalue, "The adjustedCappedClaimValue is incorrect");
            Assert.AreEqual(cappedClaimValue, firstAllocation.sfa_CappedClaimedValue, "The cappedClaimValue is incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingClaimReconciliationRepository_ShouldGetAllocationInfos()
        {
            // arrange
            const string contractNumber = "Test D";
            const string allocationNumber = "Test Alloc";
            const string period = "1718";
            const string periodType = "FY";
            const string claimTypeName = "Final";
            const int claimVersionNumber = 1;
            const int contractVersion = 1;
            decimal allocPlannedValue = 1002.01m;
            RemoveFcrsForThisProvider(GetProvider().Id);
            DeleteContracts(contractNumber);

            Guid contractId = CreateContract(contractNumber, contractVersion);
            Guid allocationId = CreateAllocation(allocationNumber, contractId);
            FcrIdSet fcrIds = CreateDraftFcrRelatedToAllocation(allocationId, periodType + period, claimTypeName, claimVersionNumber, allocPlannedValue);

            CrmFundingClaimReconciliationRepository repository =
                new CrmFundingClaimReconciliationRepository(GetConnection());

            AllocationPlannedValue expectedAllocationPlannedValue = new AllocationPlannedValue(allocationNumber, allocPlannedValue);

            // act
            IReadOnlyCollection<AllocationPlannedValue> allocationInfos = repository.GetFcrAllocationInfos(fcrIds.FcrId);

            // assert
            Assert.AreEqual(1, allocationInfos.Count);

            AllocationPlannedValue actuaAllocationPlannedValue = allocationInfos.Single();

            Assert.AreEqual(expectedAllocationPlannedValue, actuaAllocationPlannedValue);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingClaimReconciliationRepository_ShouldIssueNotification()
        {
            // arrange
            const string contractNumber = "Test D";
            const string allocationNumber = "Test Alloc";
            const string period = "1718";
            const string periodType = "FY";
            const string claimTypeName = "Final";
            const int claimVersionNumber = 1;
            const int contractVersion = 1;
            decimal allocPlannedValue = 1002.01m;
            string fundingStreamName = GetFundingStreamName();
            string notificationName = GetNotificationName(allocationNumber, fundingStreamName);
            RemoveFcrsForThisProvider(GetProvider().Id);
            DeleteContracts(contractNumber);
            RemoveNotificationsWithName(notificationName);

            Guid contractId = CreateContract(contractNumber, contractVersion);
            Guid allocationId = CreateAllocation(allocationNumber, contractId);
            CreateDraftFcrRelatedToAllocation(allocationId, periodType + period, claimTypeName, claimVersionNumber, allocPlannedValue);

            CrmFundingClaimReconciliationRepository repository =
                new CrmFundingClaimReconciliationRepository(GetConnection());

            // act
            repository.IssueCrmNotificationForAllocation(allocationNumber, contractVersion);

            // assert
            var actualNotification =
                GetNotificationWithName(notificationName);

            Assert.IsNotNull(actualNotification);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingClaimReconciliationRepository_UpdateFcrAndAllocationValues_ShouldUpdateValues_AdjustedAndProposed()
        {
            // arrange
            const string fcrName = "some new name";
            const string period = "1718";
            const string periodType = "FY";
            const string claimTypeName = "Final";
            const int claimVersionNumber = 1;
            const decimal adjustedCappedClaimValue = 9740M;
            const decimal proposedReconciliationValue = -260M;
            const decimal claimAdjustmentValue = -100M;
            const decimal earningsBoostValue = 100M;
            RemoveFcrsForThisProvider(GetProvider().Id);

            FcrIdSet fcrIdSet = CreateFcrAndRelatedFcrAllocation(periodType + period, claimTypeName, claimVersionNumber, fcrName);

            CrmFundingClaimReconciliationRepository repository =
                new CrmFundingClaimReconciliationRepository(GetConnection());

            // act
            repository.UpdateFcrAndAllocationValues(
                fcrId: fcrIdSet.FcrId,
                adjustedCappedClaimValue: adjustedCappedClaimValue,
                claimAdjustmentValue: claimAdjustmentValue,
                proposedReconciliationValue: proposedReconciliationValue,
                reconciliationValue: proposedReconciliationValue,
                earningsBoostValue : earningsBoostValue,
                fcrAllocationIds: new List<Guid> { fcrIdSet.FcrAllocId });

            // assert
            var fcrInCrm = GetFcr(fcrIdSet.FcrId);
            Assert.AreEqual(adjustedCappedClaimValue, fcrInCrm.sfa_adjustedcappedclaimedvalue, "FCR Value in CRM did not match updated adjustedCappedClaimValue");
            Assert.AreEqual(claimAdjustmentValue, fcrInCrm.sfa_claimadjustmentvalue, "FCR Value in CRM did not match updated claimAdjustmentValue");
            Assert.AreEqual(proposedReconciliationValue, fcrInCrm.sfa_ProposedReconciliationValue, "FCR Value in CRM did not match updated proposedReconciliationValue");
            Assert.AreEqual((int)sfa_FCRServiceStatus.CalculationSuccessful, fcrInCrm.sfa_servicestatus.Value, "FCR Value in CRM did not match updated sfa_servicestatus");
            Assert.AreEqual(proposedReconciliationValue, fcrInCrm.sfa_ReconciliationValue, "FCR Value in CRM did not match updated proposedReconciliationValue");

            var fcrAllocation = GetFcrAllocation(fcrIdSet.FcrAllocId);
            Assert.AreEqual(adjustedCappedClaimValue, fcrAllocation.sfa_adjustedcappedclaimedvalue, "FCR Allocation Value in CRM did not match updated adjustedCappedClaimValue");
            Assert.AreEqual(proposedReconciliationValue, fcrAllocation.sfa_ProposedReconciliationValue, "FCR Allocation Value in CRM did not match updated proposedReconciliationValue");
            Assert.AreEqual(proposedReconciliationValue, fcrAllocation.sfa_ReconciliationValue, "FCR Allocation Value in CRM did not match updated reconciliationValue");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingClaimReconciliationRepository_UpdateFcrAndAllocationValues_ShouldUpdateValues_Adjusted()
        {
            // arrange
            const string fcrName = "some new name";
            const string period = "1718";
            const string periodType = "FY";
            const string claimTypeName = "Final";
            const int claimVersionNumber = 1;
            const decimal adjustedCappedClaimValue = 9740M;
            const decimal claimAdjustmentValue = -100M;
            const decimal earningsBoostValue = 100M;
            const decimal proposedReconciliationValue = -101M;
            RemoveFcrsForThisProvider(GetProvider().Id);

            FcrIdSet fcrIdSet = CreateFcrAndRelatedFcrAllocation(periodType + period, claimTypeName, claimVersionNumber, fcrName);

            CrmFundingClaimReconciliationRepository repository =
                new CrmFundingClaimReconciliationRepository(GetConnection());

            // act
            repository.UpdateFcrAndAllocationValues(
                fcrId: fcrIdSet.FcrId,
                adjustedCappedClaimValue: adjustedCappedClaimValue,
                claimAdjustmentValue: claimAdjustmentValue,
                proposedReconciliationValue: proposedReconciliationValue,
                earningsBoostValue: earningsBoostValue,
                fcrAllocationIds: new List<Guid> { fcrIdSet.FcrAllocId });

            // assert
            var fcrInCrm = GetFcr(fcrIdSet.FcrId);
            Assert.AreEqual(adjustedCappedClaimValue, fcrInCrm.sfa_adjustedcappedclaimedvalue, "FCR Value in CRM did not match updated adjustedCappedClaimValue");
            Assert.AreEqual(claimAdjustmentValue, fcrInCrm.sfa_claimadjustmentvalue, "FCR Value in CRM did not match updated claimAdjustmentValue");
            Assert.AreEqual((int)sfa_FCRServiceStatus.CalculationSuccessful, fcrInCrm.sfa_servicestatus.Value, "FCR Value in CRM did not match updated sfa_servicestatus");
            Assert.AreEqual(proposedReconciliationValue, fcrInCrm.sfa_ProposedReconciliationValue, "FCR Value in CRM did not match updated proposedReconciliationValue");

            var fcrAllocation = GetFcrAllocation(fcrIdSet.FcrAllocId);
            Assert.AreEqual(adjustedCappedClaimValue, fcrAllocation.sfa_adjustedcappedclaimedvalue, "FCR Allocation Value in CRM did not match updated adjustedCappedClaimValue");
            Assert.AreEqual(proposedReconciliationValue, fcrAllocation.sfa_ProposedReconciliationValue, "FCR Allocation Value in CRM did not match updated proposedReconciliationValue");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingClaimReconciliationRepository_GetFcrAllocationIdsForFcrId_ShouldGetIds()
        {
            // arrange
            const string fcrName = "some new name";
            const string period = "1718";
            const string periodType = "FY";
            const string claimTypeName = "Final";
            const int claimVersionNumber = 1;
            RemoveFcrsForThisProvider(GetProvider().Id);

            FcrIdSet fcrIdSet = CreateFcrAndRelatedFcrAllocation(periodType + period, claimTypeName, claimVersionNumber, fcrName);

            CrmFundingClaimReconciliationRepository repository =
                new CrmFundingClaimReconciliationRepository(GetConnection());

            // act
            IReadOnlyCollection<Guid> fcrAllocationIds = repository.GetFcrAllocationIdsForFcrId(fcrIdSet.FcrId);

            // assert
            Assert.AreEqual(1, fcrAllocationIds.Count, "The number of related fcr allocations is incorrect");
            Assert.AreEqual(fcrIdSet.FcrAllocId, fcrAllocationIds.First(), "The related fcr allocation id is incorrect");
        }

        private void RemoveNotificationsWithName(string notificationName)
        {
            using (var xrmContext = new XrmServiceContext(GetConnection()))
            {
                xrmContext.sfa_notificationSet.Where(n => n.sfa_Name == notificationName)
                          .Select(n => n.sfa_notificationId.Value).ToList()
                          .ForEach(n => GetConnection().Delete(sfa_notification.EntityLogicalName, n));
            }
        }

        private string GetNotificationName(string allocationNumber, string fundingStreamName)
        {
            return $"Amendment Approval-Allocation {allocationNumber} - {fundingStreamName}";
        }

        private FcrIdSet CreateDraftFcrRelatedToAllocation(Guid allocationId, string fundingPeriod, string claimTypeName,
                                                   int claimVersionNumber, decimal? fcrAllocationPlannedValue = null, decimal? cappedClaimAdjustment = null)
        {
            sfa_fundingclaimreconciliation fcr = new sfa_fundingclaimreconciliation
            {
                sfa_name = "Some name",
                sfa_StatusCodeEnum = sfa_sfastatuscode.Draft,
                sfa_ClaimTypeId = GetClaimType(claimTypeName),
                sfa_ProviderId = GetProvider(),
                sfa_FundingPeriodId = GetFundingPeriod(fundingPeriod),
                sfa_AllocationGroupId = GetAllocationGroup(),
                sfa_ClaimVersionNumber = claimVersionNumber,
                sfa_claimadjustmentvalue = cappedClaimAdjustment
            };

            Guid fcrId = GetConnection().Create(fcr);

            sfa_fcrallocation fcrallocation = new sfa_fcrallocation
            {
                sfa_FundingClaimReconciliationId =
                    new EntityReference(sfa_fundingclaimreconciliation.EntityLogicalName, fcrId),
                sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationId),
                sfa_PlannedValue = fcrAllocationPlannedValue,
                sfa_claimadjustmentvalue = cappedClaimAdjustment
            };

            Guid fcrAllocId = GetConnection().Create(fcrallocation);

            return new FcrIdSet(fcrId, fcrAllocId);
        }

        private FcrIdSet CreateFcrAndRelatedFcrAllocation(string fundingPeriod, string claimTypeName, int claimVersionNumber, string fcrName)
        {
            sfa_fundingclaimreconciliation fcr = new sfa_fundingclaimreconciliation
            {
                sfa_name = fcrName,
                sfa_StatusCodeEnum = sfa_sfastatuscode.Draft,
                sfa_ClaimTypeId = GetClaimType(claimTypeName),
                sfa_ProviderId = GetProvider(),
                sfa_FundingPeriodId = GetFundingPeriod(fundingPeriod),
                sfa_AllocationGroupId = GetAllocationGroup(),
                sfa_ClaimVersionNumber = claimVersionNumber
            };

            Guid fcrId = GetConnection().Create(fcr);

            sfa_fcrallocation fcrAllocation = new sfa_fcrallocation
            {
                sfa_FundingClaimReconciliationId =
                    new EntityReference(sfa_fundingclaimreconciliation.EntityLogicalName, fcrId)
            };

            Guid fcrAllocId = GetConnection().Create(fcrAllocation);

            return new FcrIdSet(fcrId, fcrAllocId);
        }

        private EntityReference GetFundingPeriod(string fundingPeriod)
        {
            using (var xrmContext = new XrmServiceContext(GetConnection()))
            {
                return xrmContext.sfa_periodSet.First(p => p.sfa_periodname == fundingPeriod).ToEntityReference();
            }
        }

        private EntityReference GetProvider()
        {
            if (_providerEntityReference == null)
            {
                using (var xrmContext = new XrmServiceContext(GetConnection()))
                {
                    _providerEntityReference = xrmContext.AccountSet.First(o => o.sfa_OrganisationID != null).ToEntityReference();
                }
            }

            return _providerEntityReference;
        }

        private EntityReference GetClaimType(string claimType)
        {
            using (var xrmContext = new XrmServiceContext(GetConnection()))
            {
                return xrmContext.sfa_claimtypeSet.First(ct => ct.sfa_name == claimType).ToEntityReference();
            }
        }

        private EntityReference GetAllocationGroup()
        {
            using (var xrmContext = new XrmServiceContext(GetConnection()))
            {
                return xrmContext.sfa_claimreconallocgroupSet.First().ToEntityReference();
            }
        }

        private EntityReference GetFundingStream()
        {
            using (var xrmContext = new XrmServiceContext(GetConnection()))
            {
                return xrmContext.sfa_fundingstreamSet.First().ToEntityReference();
            }
        }

        private string GetFundingStreamName()
        {
            using (var xrmContext = new XrmServiceContext(GetConnection()))
            {
                return xrmContext.sfa_fundingstreamSet.First().sfa_fundingstreamname;
            }
        }

        private Guid CreateAllocation(string allocationNumber, Guid contractId)
        {
            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_contractallocationnumber = allocationNumber,
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                sfa_FundingStreamId = GetFundingStream()
            };

            return GetConnection().Create(allocation);
        }

        private Guid CreateContract(string contractNumber, int version)
        {
            sfa_contract contract = new sfa_contract
            {
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_SubVersion = 1,
                sfa_ProviderName = GetProvider(),
                sfa_UKPRN = "1"
            };

            return GetConnection().Create(contract);
        }

        private void RemoveFcrsRelatedToAllocation(string allocationNumber)
        {
            using (var xrmContext = new XrmServiceContext(GetConnection()))
            {
                var fcrs = (from fcr in xrmContext.sfa_fundingclaimreconciliationSet
                            join fcra in xrmContext.sfa_fcrallocationSet on fcr.Id equals
                                fcra.sfa_FundingClaimReconciliationId.Id
                            join ca in xrmContext.sfa_contractallocationSet on fcra.sfa_ContractAllocationId.Id equals
                                ca.Id
                            where ca.sfa_contractallocationnumber == allocationNumber

                            select fcr.Id).ToList();

                fcrs.ForEach(f => GetConnection().Delete(sfa_fundingclaimreconciliation.EntityLogicalName, f));
            }
        }

        private void RemoveFcrsForThisProvider(Guid accountId)
        {
            using (var xrmContext = new XrmServiceContext(GetConnection()))
            {
                var fcrIds = xrmContext.sfa_fundingclaimreconciliationSet.Where(fcr => fcr.sfa_ProviderId.Id == accountId)
                    .Select(f => f.Id)
                    .ToList();

                fcrIds.ForEach(f => GetConnection().Delete(sfa_fundingclaimreconciliation.EntityLogicalName, f));
            }
        }

        private void DeleteContracts(string contractNumber)
        {
            using (var xrmContext = new XrmServiceContext(GetConnection()))
            {
                xrmContext.sfa_contractSet.Where(c => c.sfa_number == contractNumber).ToList()
                     .ForEach(ca => GetConnection().Delete(sfa_contract.EntityLogicalName, ca.Id));
            }
        }

        private static IOrganizationService GetConnection()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }

        private sfa_fundingclaimreconciliation GetFcr(Guid fcrId)
        {
            using (var xrmContext = new XrmServiceContext(GetConnection()))
            {
                return xrmContext.sfa_fundingclaimreconciliationSet
                                 .Single(fcr => fcr.Id == fcrId);
            }
        }

        private sfa_fcrallocation GetFcrAllocation(Guid fcrAllocationId)
        {
            using (var xrmContext = new XrmServiceContext(GetConnection()))
            {
                return xrmContext.sfa_fcrallocationSet.Single(a => a.Id == fcrAllocationId);
            }
        }

        private sfa_notification GetNotificationWithName(string name)
        {
            using (var xrmContext = new XrmServiceContext(GetConnection()))
            {
                return xrmContext.sfa_notificationSet
                                 .Single(n => n.sfa_Name == name);
            }
        }

        private IReadOnlyCollection<sfa_fcrallocation> GetFcrAllocations(Guid fcrId)
        {
            using (var xrmContext = new XrmServiceContext(GetConnection()))
            {
                return
                    xrmContext.sfa_fcrallocationSet.Where(fcra => fcra.sfa_FundingClaimReconciliationId.Id == fcrId)
                        .ToList();

            }
        }

        private class FcrIdSet
        {
            public FcrIdSet(Guid fcrId, Guid fcrAllocId)
            {
                FcrId = fcrId;
                FcrAllocId = fcrAllocId;
            }

            public Guid FcrId { get; }

            public Guid FcrAllocId { get; }
        }
    }
}