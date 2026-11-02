namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.CrmRepositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Microsoft.Xrm.Sdk;

    public class CrmFundingClaimReconciliationRepository : ICrmFundingClaimReconciliationRepository
    {
        private readonly IOrganizationService _organizationService;

        public CrmFundingClaimReconciliationRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public IReadOnlyCollection<FundingClaimReconciliationInformation> GetFundingClaimReconciliationInfos(string allocationNumber)
        {
            using (var xrmContext = new XrmServiceContext(_organizationService))
            {
                var fcrs = (from fcr in xrmContext.sfa_fundingclaimreconciliationSet
                            join fcra in xrmContext.sfa_fcrallocationSet on fcr.sfa_fundingclaimreconciliationId equals fcra.sfa_FundingClaimReconciliationId.Id
                            join ca in xrmContext.sfa_contractallocationSet on fcra.sfa_ContractAllocationId.Id equals ca.sfa_contractallocationId.Value
                            join c in xrmContext.sfa_contractSet on ca.sfa_ContractId.Id equals c.sfa_contractId.Value
                            join o in xrmContext.AccountSet on fcr.sfa_ProviderId.Id equals o.AccountId.Value
                            join p in xrmContext.sfa_periodSet on fcr.sfa_FundingPeriodId.Id equals p.sfa_periodId.Value
                            join ct in xrmContext.sfa_claimtypeSet on fcr.sfa_ClaimTypeId.Id equals ct.sfa_claimtypeId.Value
                            join pt in xrmContext.sfa_periodtypeSet on p.sfa_PeriodTypeId.Id equals pt.sfa_periodtypeId.Value
                            join ag in xrmContext.sfa_claimreconallocgroupSet on fcr.sfa_AllocationGroupId.Id equals ag.sfa_claimreconallocgroupId.Value
                            where ca.sfa_contractallocationnumber == allocationNumber

                            select new
                            {
                                fcr.sfa_StatusCodeEnum,
                                o.sfa_OrganisationID,
                                ClaimTypeName = ct.sfa_name,
                                p.sfa_Period,
                                pt.sfa_periodtypecode,
                                fcr.sfa_ClaimVersionNumber,
                                ag.sfa_AllocationGroupCode,
                                fcr.Id,
                                fcra.sfa_claimadjustmentvalue
                            }).ToList();

                return fcrs.Select(fcr => new FundingClaimReconciliationInformation(
                    isDraft: fcr.sfa_StatusCodeEnum == sfa_sfastatuscode.Draft,
                    organisationIdentifier: fcr.sfa_OrganisationID,
                    claimTypeName: fcr.ClaimTypeName.Replace(" ", string.Empty).ToUpper(),
                    period: fcr.sfa_Period,
                    periodTypeCode: fcr.sfa_periodtypecode,
                    version: fcr.sfa_ClaimVersionNumber.Value,
                    allocationGroupCode: fcr.sfa_AllocationGroupCode,
                    fcrCrmId: fcr.Id, 
                    cappedClaimAdjustment: fcr.sfa_claimadjustmentvalue ?? 0)).ToList();
            }
        }

        public void UpdateValues(
            Guid fcrId,
            decimal newProposedReconciliationValue,
            decimal newPlannedValue,
            decimal adjustedCappedClaimValue,
            decimal cappedClaimValue)
        {
            var fcr = new sfa_fundingclaimreconciliation
            {
                Id = fcrId,
                sfa_ProposedReconciliationValue = newProposedReconciliationValue,
                sfa_PlannedValue = newPlannedValue,
                sfa_adjustedcappedclaimedvalue = adjustedCappedClaimValue,
                sfa_CappedClaimedValue = cappedClaimValue,
                EntityState = EntityState.Changed
            };

            _organizationService.Update(fcr);
        }

        public void UpdateFcrAndAllocationValues(
            Guid fcrId,
            decimal? adjustedCappedClaimValue,
            decimal? claimAdjustmentValue,
            decimal? proposedReconciliationValue,
            decimal? earningsBoostValue,
            IReadOnlyCollection<Guid> fcrAllocationIds)
        {
            var fcr = new sfa_fundingclaimreconciliation
            {
                Id = fcrId,
                sfa_adjustedcappedclaimedvalue = adjustedCappedClaimValue,
                sfa_claimadjustmentvalue = claimAdjustmentValue, 
                SFA_EarningsBoostValue = earningsBoostValue,
                sfa_servicestatusEnum = sfa_FCRServiceStatus.CalculationSuccessful,
                sfa_ProposedReconciliationValue = proposedReconciliationValue,
                EntityState = EntityState.Changed
            };

            var fcrAllocations = fcrAllocationIds.Select(fcrAllocationId => new sfa_fcrallocation
            {
                sfa_FundingClaimReconciliationId =
                    new EntityReference(sfa_fundingclaimreconciliation.EntityLogicalName, fcrId),
                Id = fcrAllocationId,
                sfa_adjustedcappedclaimedvalue = adjustedCappedClaimValue,
                sfa_ProposedReconciliationValue = proposedReconciliationValue
            }).ToList();

            AddFcrAllocationsToFcr(fcr, fcrAllocations);

            _organizationService.Update(fcr);
        }

        public void UpdateFcrAndAllocationValues(
            Guid fcrId,
            decimal? adjustedCappedClaimValue,
            decimal? claimAdjustmentValue,
            decimal? proposedReconciliationValue,
            decimal? reconciliationValue,
            decimal? earningsBoostValue,
            IReadOnlyCollection<Guid> fcrAllocationIds)
        {
            var fcr = new sfa_fundingclaimreconciliation
            {
                Id = fcrId,
                sfa_adjustedcappedclaimedvalue = adjustedCappedClaimValue,
                sfa_ProposedReconciliationValue = proposedReconciliationValue,
                sfa_claimadjustmentvalue = claimAdjustmentValue,
                SFA_EarningsBoostValue = earningsBoostValue,
                sfa_ReconciliationValue = reconciliationValue,
                sfa_servicestatusEnum = sfa_FCRServiceStatus.CalculationSuccessful,
                EntityState = EntityState.Changed
            };

            var fcrAllocations = fcrAllocationIds.Select(fcrAllocationId => new sfa_fcrallocation
            {
                sfa_FundingClaimReconciliationId =
                    new EntityReference(sfa_fundingclaimreconciliation.EntityLogicalName, fcrId),
                Id = fcrAllocationId,
                sfa_adjustedcappedclaimedvalue = adjustedCappedClaimValue,
                sfa_ProposedReconciliationValue = proposedReconciliationValue,
                sfa_ReconciliationValue = reconciliationValue
            }).ToList();

            AddFcrAllocationsToFcr(fcr, fcrAllocations);

            _organizationService.Update(fcr);
        }

        public void AssociateAllocationToFcrAndUpdateValues(
                Guid fcrId,
                Guid fcrAllocId,
                string allocationNumber,
                int versionNumber, int subVersionNumber,
                decimal plannedValue,
                decimal proposedReconciliationValue,
                decimal adjustedCappedClaimValue,
                decimal cappedClaimValue)
        {
            EntityReference contractAllocationEntityReference = GetContractAllocation(allocationNumber, versionNumber, subVersionNumber);

            var fcrAllocation = new sfa_fcrallocation
            {
                Id = fcrAllocId,
                sfa_ContractAllocationId = contractAllocationEntityReference,
                sfa_PlannedValue = plannedValue,
                sfa_ProposedReconciliationValue = proposedReconciliationValue,
                sfa_adjustedcappedclaimedvalue = adjustedCappedClaimValue,
                sfa_CappedClaimedValue = cappedClaimValue,
                EntityState = EntityState.Changed
            };

            _organizationService.Update(fcrAllocation);
        }

        public IReadOnlyCollection<AllocationPlannedValue> GetFcrAllocationInfos(Guid fcrId)
        {
            using (var xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return (from fcrAlloc in xrmServiceContext.sfa_fcrallocationSet
                        join alloc in xrmServiceContext.sfa_contractallocationSet on
                            fcrAlloc.sfa_ContractAllocationId.Id equals alloc.sfa_contractallocationId
                        where fcrAlloc.sfa_FundingClaimReconciliationId.Id == fcrId
                        select
                            new AllocationPlannedValue(alloc.sfa_contractallocationnumber, fcrAlloc.sfa_PlannedValue.Value)
                            {
                                FcrAllocationId = fcrAlloc.sfa_fcrallocationId.Value
                            })
                    .ToList();

            }
        }

        public void IssueCrmNotificationForAllocation(string contractAllocationNumber, int contractVersionNumber)
        {
            using (var xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                CRMAllocationNotificationData notificationData =
                    (from alloc in xrmServiceContext.sfa_contractallocationSet
                     join contract in xrmServiceContext.sfa_contractSet on alloc.sfa_ContractId.Id equals
                         contract.sfa_contractId
                     join fs in xrmServiceContext.sfa_fundingstreamSet on alloc.sfa_FundingStreamId.Id equals
                         fs.sfa_fundingstreamId
                     join org in xrmServiceContext.AccountSet on contract.sfa_ProviderName.Id equals org.AccountId
                     where alloc.sfa_contractallocationnumber == contractAllocationNumber
                           && contract.sfa_Version == contractVersionNumber
                     select
                         new CRMAllocationNotificationData(fs.sfa_fundingstreamname, alloc.sfa_contractallocationnumber,
                             contract.sfa_Version.Value, int.Parse(org.sfa_UKPRN), org.Name)).First();

                IQueryable<Team> claimEditorTeam =
                    from t in xrmServiceContext.TeamSet
                    where t.Name == "Claim Editor Team"
                    select t;

                sfa_notification crmNotification = new sfa_notification
                {
                    sfa_NotificationType = new OptionSetValue((int)sfa_notificationtype.AmendmentApproval),
                    sfa_Name = notificationData.CreateNotificationName(),
                    OwnerId = new EntityReference("team", claimEditorTeam.FirstOrDefault().Id),
                    sfa_Notification = notificationData.CreateNotificationText()
                };

                _organizationService.Create(crmNotification);
            }
        }
        
        private void AddFcrAllocationsToFcr(sfa_fundingclaimreconciliation fcr,
            IReadOnlyCollection<sfa_fcrallocation> fcrAllocations)
        {
            Relationship relationship = new Relationship("sfa_sfa_fundingclaimreconciliation_sfa_fcrall")
            {
                PrimaryEntityRole = EntityRole.Referenced
            };

            EntityCollection fcrAllocationEntityCollection = new EntityCollection()
            {
                EntityName = sfa_fcrallocation.EntityLogicalName
            };

            fcrAllocationEntityCollection.Entities.AddRange(fcrAllocations);

            fcr.RelatedEntities.Add(relationship, fcrAllocationEntityCollection);
        }

        private EntityReference GetContractAllocation(string allocationNumber, int versionNumber, int subVersionNumber)
        {
            using (var xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return (from alloc in xrmServiceContext.sfa_contractallocationSet
                        join contract in xrmServiceContext.sfa_contractSet
                        on alloc.sfa_ContractId.Id equals contract.Id
                        where alloc.sfa_contractallocationnumber == allocationNumber
                        && contract.sfa_Version == versionNumber
                        && contract.sfa_SubVersion == subVersionNumber
                        select alloc).Single().ToEntityReference();
            }
        }

        public IReadOnlyCollection<Guid> GetFcrAllocationIdsForFcrId(Guid fcrId)
        {
            using (var xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return xrmServiceContext.sfa_fcrallocationSet.Where(a => a.sfa_FundingClaimReconciliationId.Id == fcrId)
                    .Select(a => a.Id)
                    .ToList();
            }
        }
    }
}