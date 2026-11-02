namespace SFA.FCT.PerformanceManagementDomain.Common.Repositories
{
    using CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Microsoft.Xrm.Sdk;
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Linq;
    using System.Reflection;
    using sfa_fundingtype = CrossDomain.Integration.Entities.Xrm.sfa_fundingtype;

    public class FundingClaimReconciliationQueryRepository : IFundingClaimReconciliationQueryRepository
    {
        private readonly IOrganizationService _organizationService;
        private static readonly ConcurrentDictionary<Guid, Account> ProviderCache = new ConcurrentDictionary<Guid, Account>();
        private static readonly ConcurrentDictionary<Guid, sfa_period> PeriodCache = new ConcurrentDictionary<Guid, sfa_period>();
        private static readonly ConcurrentDictionary<Guid, sfa_periodtype> PeriodTypeCache = new ConcurrentDictionary<Guid, sfa_periodtype>();
        private static readonly ConcurrentDictionary<Guid, sfa_claimtype> ClaimTypeCache = new ConcurrentDictionary<Guid, sfa_claimtype>();
        private static readonly ConcurrentDictionary<Guid, sfa_claimreconallocgroup> AllocationGroupCache = new ConcurrentDictionary<Guid, sfa_claimreconallocgroup>();
        private static readonly ConcurrentDictionary<Guid, sfa_fundingtype> FundingTypeCache = new ConcurrentDictionary<Guid, sfa_fundingtype>();
        private static readonly ConcurrentDictionary<Guid, sfa_fundingstreamperiod> FundingStreamPeriodCache = new ConcurrentDictionary<Guid, sfa_fundingstreamperiod>();
        private static readonly ConcurrentDictionary<Guid, sfa_deliverable> DeliverableCache = new ConcurrentDictionary<Guid, sfa_deliverable>();

        public FundingClaimReconciliationQueryRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public FundingClaimReconciliation GetFundingClaimReconciliation(Guid id)
        {
            using (XrmServiceContext context = new XrmServiceContext(_organizationService))
            {
                sfa_fundingclaimreconciliation fundingClaimReconciliation =
                    context.sfa_fundingclaimreconciliationSet.Single(fcr => fcr.Id == id);
                IList<sfa_fcrallocation> fundingClaimReconciliationAllocations =
                    context.sfa_fcrallocationSet
                    .Where(fcra => fcra.sfa_FundingClaimReconciliationId.Id == fundingClaimReconciliation.Id)
                    .ToList();

                Account provider = GetProvider(fundingClaimReconciliation.sfa_ProviderId.Id);
                sfa_period period = GetPeriod(fundingClaimReconciliation.sfa_FundingPeriodId.Id);
                sfa_periodtype periodType = GetPeriodType(period.sfa_PeriodTypeId.Id);
                sfa_claimtype claimType = GetClaimType(fundingClaimReconciliation.sfa_ClaimTypeId.Id);
                sfa_claimreconallocgroup allocationGroup = GetAllocationGroup(fundingClaimReconciliation.sfa_AllocationGroupId.Id);

                return new FundingClaimReconciliation
                {
                    Contractor = new Contractor
                    {
                        OrganisationIdentifier = provider.sfa_OrganisationID,
                        UKPRN = int.Parse(provider.sfa_UKPRN),
                        LegalName = provider.Name
                    },
                    Period = new Period
                    {
                        PeriodTypeCode = (PeriodTypeCode)Enum.Parse(typeof(PeriodTypeCode), periodType.sfa_periodtypecode),
                        PeriodTypeName = (PeriodTypeName)Enum.Parse(typeof(PeriodTypeName), periodType.sfa_PeriodTypeName.Replace(" ", "").ToUpper()),
                        PeriodYear = period.sfa_Period
                    },
                    ClaimVersionNumber = fundingClaimReconciliation.sfa_ClaimVersionNumber.GetValueOrDefault(),
                    ClaimType = new ClaimType
                    {
                        ClaimTypeCode = claimType.sfa_ClaimTypeCode,
                        ClaimTypeName = claimType.sfa_name
                    },
                    AllocationGroup = new AllocationGroup
                    {
                        AllocationGroupCode = allocationGroup.sfa_AllocationGroupCode,
                        AllocationGroupName = allocationGroup.sfa_name
                    },
                    Status = DecodeCrmStatus(fundingClaimReconciliation.sfa_StatusCodeEnum),
                    StatusLastUpdatedDate = fundingClaimReconciliation.sfa_StatusLastUpdatedDate.GetValueOrDefault(),
                    Amounts = new AmountSummary
                    {
                        PlannedValue = fundingClaimReconciliation.sfa_PlannedValue,
                        ClaimedValue = fundingClaimReconciliation.sfa_ClaimedValue,
                        ProposedReconciliationValue = fundingClaimReconciliation.sfa_ProposedReconciliationValue,
                        ReconciliationValue = fundingClaimReconciliation.sfa_ReconciliationValue,
                        CappedClaimedValue = fundingClaimReconciliation.sfa_CappedClaimedValue,
                        AdjustedCappedClaimValue = fundingClaimReconciliation.sfa_adjustedcappedclaimedvalue,
                        EarningsBoostValue = fundingClaimReconciliation.SFA_EarningsBoostValue
                    },
                    ContractAllocations = fundingClaimReconciliationAllocations
                        .Select(ConstructRetrievedContractAllocation)
                        .ToList()
                };
            }
        }

        private ReconciliationStatus DecodeCrmStatus(sfa_sfastatuscode? statusCode)
        {
            if (statusCode.HasValue && statusCode.Value == sfa_sfastatuscode.Published)
            {
                return ReconciliationStatus.Published;
            }

            return ReconciliationStatus.Draft;
        }
        
        private ContractAllocation ConstructRetrievedContractAllocation(sfa_fcrallocation fcra)
        {
            using (XrmServiceContext context = new XrmServiceContext(_organizationService))
            {
                sfa_contractallocation contractAllocation = 
                    context.sfa_contractallocationSet.Single(a => a.Id == fcra.sfa_ContractAllocationId.Id);
                sfa_contract contract =
                    GetLatestApprovedContractForAllocation(contractAllocation.sfa_contractallocationnumber);

                IList<sfa_fcrallocationdeliverable> fundingClaimReconciliationAllocationDeliverables =
                    context.sfa_fcrallocationdeliverableSet
                    .Where(fcrad => fcrad.sfa_FCRAllocationId.Id == fcra.Id)
                    .ToList();

                sfa_fundingtype fundingType = GetFundingType(contract.sfa_FundingType.Id);
                sfa_fundingstreamperiod fundingStreamPeriod = GetFundingStreamPeriod(contractAllocation.sfa_FundingStreamPeriodId.Id);

                return new ContractAllocation
                {
                    ContractAllocationNumber = contractAllocation.sfa_contractallocationnumber,
                    FundingstreamPeriodCode = fundingStreamPeriod.sfa_fundingstreamperiodcode,
                    AllocationStartDate = contractAllocation.sfa_startdate.GetValueOrDefault(),
                    AllocationEndDate = contractAllocation.sfa_enddate.GetValueOrDefault(),
                    Amounts = new AmountSummary
                    {
                        PlannedValue = fcra.sfa_PlannedValue,
                        ClaimedValue = fcra.sfa_ClaimedValue,
                        ProposedReconciliationValue = fcra.sfa_ProposedReconciliationValue,
                        ReconciliationValue = fcra.sfa_ReconciliationValue,
                        CappedClaimedValue = fcra.sfa_CappedClaimedValue,
                        AdjustedCappedClaimValue = fcra.sfa_adjustedcappedclaimedvalue,
                        ClaimAdjustments = fcra.sfa_claimadjustmentvalue.HasValue && fcra.sfa_claimadjustmentvalue.Value != 0 ?
                            new ClaimAdjustment(fcra.sfa_claimadjustmentvalue.Value, GetClaimAdjustmentReasonDescription(fcra.sfa_claimadjustmentreason)) : null,
                        EarningsBoostValue = fcra.SFA_EarningsBoostValue
                    },
                    ContractDeliverables = fundingClaimReconciliationAllocationDeliverables
                        .Select(ConstructRetrievedContractAllocationDeliverable)
                        .ToList(),
                    Contract = new Contract
                    {
                        ContractNumber = contract.sfa_number,
                        ContractVersionNumber = contract.sfa_Version.GetValueOrDefault(),
                        ContractSubVersionNumber = contract.sfa_SubVersion.GetValueOrDefault(),
                        FundingType = new FundingType
                        {
                            FundingTypeCode = fundingType.sfa_fundingtypecode,
                            FundingTypeName = fundingType.sfa_name
                        },
                        ContractApprovalDate = contract.sfa_ContractApprovalDate
                    }
                };
            }
        }

        private static string GetClaimAdjustmentReasonDescription(OptionSetValue optionSetValue)
        {
            sfa_ClaimAdjustmentReason enumValue = (sfa_ClaimAdjustmentReason)optionSetValue.Value;
            MemberInfo[] memberInfos = typeof(sfa_ClaimAdjustmentReason).GetMember(enumValue.ToString());
            IEnumerable<DescriptionAttribute> descriptionAttributes = memberInfos.Single().GetCustomAttributes(typeof(DescriptionAttribute)).Cast<DescriptionAttribute>();

            return descriptionAttributes.First().Description;
        }

        private sfa_contract GetLatestApprovedContractForAllocation(string allocationNumber)
        {
            using (XrmServiceContext context = new XrmServiceContext(_organizationService))
            {
                return (from c in context.sfa_contractSet
                    join ca in context.sfa_contractallocationSet on c.Id equals ca.sfa_ContractId.Id
                    where c.sfa_ContractStatus.Value == (int) sfa_contractstatus.Approved
                    && ca.sfa_contractallocationnumber == allocationNumber
                    select c).ToList().OrderByDescending(c => c.sfa_Version).First();
            }
        }

        private ContractDeliverable ConstructRetrievedContractAllocationDeliverable(sfa_fcrallocationdeliverable fundingClaimReconciliationAllocationDeliverable)
        {
            sfa_deliverable fundingStreamDeliverable = GetDeliverable(fundingClaimReconciliationAllocationDeliverable.sfa_DeliverableId.Id);

            return new ContractDeliverable
            {
                Deliverable = new Deliverable
                {
                    DeliverableCode = fundingStreamDeliverable.sfa_DeliverableCode.GetValueOrDefault(),
                    DeliverableName = fundingStreamDeliverable.sfa_name
                },
                Amounts = new AmountSummary
                {
                    PlannedValue = fundingClaimReconciliationAllocationDeliverable.sfa_PlannedValue,
                    ClaimedValue = fundingClaimReconciliationAllocationDeliverable.sfa_ClaimedValue
                }
            };
        }

        private Account GetProvider(Guid providerId)
        {
            return ProviderCache.GetOrAdd(providerId, id =>
            {
                using (XrmServiceContext context = new XrmServiceContext(_organizationService))
                {
                    return context.AccountSet.Single(a => a.Id == id);
                }
            });
        }

        private sfa_period GetPeriod(Guid periodId)
        {
            return PeriodCache.GetOrAdd(periodId, id =>
            {
                using (XrmServiceContext context = new XrmServiceContext(_organizationService))
                {
                    return context.sfa_periodSet.Single(a => a.Id == id);
                }
            });
        }

        private sfa_periodtype GetPeriodType(Guid periodTypeId)
        {
            return PeriodTypeCache.GetOrAdd(periodTypeId, id =>
            {
                using (XrmServiceContext context = new XrmServiceContext(_organizationService))
                {
                    return context.sfa_periodtypeSet.Single(a => a.Id == id);
                }
            });
        }

        private sfa_claimtype GetClaimType(Guid claimTypeId)
        {
            return ClaimTypeCache.GetOrAdd(claimTypeId, id =>
            {
                using (XrmServiceContext context = new XrmServiceContext(_organizationService))
                {
                    return context.sfa_claimtypeSet.Single(a => a.Id == id);
                }
            });
        }

        private sfa_claimreconallocgroup GetAllocationGroup(Guid allocationGroupId)
        {
            return AllocationGroupCache.GetOrAdd(allocationGroupId, id =>
            {
                using (XrmServiceContext context = new XrmServiceContext(_organizationService))
                {
                    return context.sfa_claimreconallocgroupSet.Single(a => a.Id == id);
                }
            });
        }

        private sfa_fundingtype GetFundingType(Guid fundingTypeId)
        {
            return FundingTypeCache.GetOrAdd(fundingTypeId, id =>
            {
                using (XrmServiceContext context = new XrmServiceContext(_organizationService))
                {
                    return context.sfa_fundingtypeSet.Single(a => a.Id == id);
                }
            });
        }

        private sfa_fundingstreamperiod GetFundingStreamPeriod(Guid fundingStreamPeriodId)
        {
            return FundingStreamPeriodCache.GetOrAdd(fundingStreamPeriodId, id =>
            {
                using (XrmServiceContext context = new XrmServiceContext(_organizationService))
                {
                    return context.sfa_fundingstreamperiodSet.Single(a => a.Id == id);
                }
            });
        }

        private sfa_deliverable GetDeliverable(Guid deliverableId)
        {
            return DeliverableCache.GetOrAdd(deliverableId, id =>
            {
                using (XrmServiceContext context = new XrmServiceContext(_organizationService))
                {
                    return context.sfa_deliverableSet.Single(a => a.Id == id);
                }
            });
        }

        public bool IsFundingClaimReconciliationAtDraftForAllocation(string allocationNumber)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
               IReadOnlyCollection<sfa_sfastatuscode?> statuses =
                    (from fcr in xrmServiceContext.sfa_fundingclaimreconciliationSet
                     join fcra in xrmServiceContext.sfa_fcrallocationSet on fcr.Id equals fcra.sfa_FundingClaimReconciliationId.Id
                     join ca in xrmServiceContext.sfa_contractallocationSet on fcra.sfa_ContractAllocationId.Id equals ca.Id
                     where ca.sfa_contractallocationnumber == allocationNumber
                     select fcr.sfa_StatusCodeEnum)
                     .ToList();

                return statuses.Contains(sfa_sfastatuscode.Draft);
            }
        }

        public bool IsPlannedValueDifferentForAllocation(string allocationNumber, decimal newPlannedValue)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return (from fcr in xrmServiceContext.sfa_fundingclaimreconciliationSet
                        join fcra in xrmServiceContext.sfa_fcrallocationSet on fcr.Id equals
                            fcra.sfa_FundingClaimReconciliationId.Id
                        join ca in xrmServiceContext.sfa_contractallocationSet on fcra.sfa_ContractAllocationId.Id
                            equals ca.Id
                        where ca.sfa_contractallocationnumber == allocationNumber
                        select fcra.sfa_PlannedValue).Single() != newPlannedValue;
            }
        }
    }
}
