namespace PerformanceManagementDomain.ReconciliationPublication.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.CorporateSchema._3_0;

    public static class FundingClaimReconciliationTransformer
    {
        public static FCReconciliation ToCorpSchema(FundingClaimReconciliation fundingClaimReconciliationDto)
        {
            return new FCReconciliation
            {
                FCReconciliationAllAttrs = TransformToFcReconciliationAllAttrs(fundingClaimReconciliationDto)
            };
        }

        private static FCReconciliationAllAttrsCT TransformToFcReconciliationAllAttrs(FundingClaimReconciliation fundingClaimReconciliationDto)
        {
            return new FCReconciliationAllAttrsCT
            {
                FCReconciliationPKeyAttrs = TransformToFcReconciliationPKeyAttrs(
                    fundingClaimReconciliationDto.AllocationGroup,
                    fundingClaimReconciliationDto.ClaimType,
                    fundingClaimReconciliationDto.Period,
                    fundingClaimReconciliationDto.Contractor,
                    fundingClaimReconciliationDto.ClaimVersionNumber),
                FCReconciliationNonPKeyAttrs = TransformToFcReconciliationNonPKeyAttrs(
                    fundingClaimReconciliationDto.Amounts,
                    fundingClaimReconciliationDto.ContractAllocations,
                    fundingClaimReconciliationDto.Status,
                    fundingClaimReconciliationDto.StatusLastUpdatedDate)
            };
        }

        private static FCReconciliationNonPKeyAttrsCT TransformToFcReconciliationNonPKeyAttrs(
            AmountSummary amounts,
            IList<ContractAllocation> contractAllocations,
            ReconciliationStatus status,
            DateTime statusLastUpdatedDate)
        {
            FCReconciliationNonPKeyAttrsCT transformedFcrAttributes = new FCReconciliationNonPKeyAttrsCT
            {
                AmountAttrs = TransformAmounts(amounts),
                ContractAllocation = TransformContractAllocations(contractAllocations),
                Status = EnumTransformer.Transform<ReconciliationStatus, ReconciliationStatusST>(status),
                StatusLastUpdatedDate = statusLastUpdatedDate
            };

            ApplyAllocationClaimAdjustmentToParentFundingClaimReconciliationFor1819(transformedFcrAttributes);

            return transformedFcrAttributes;
        }

        private static void ApplyAllocationClaimAdjustmentToParentFundingClaimReconciliationFor1819(FCReconciliationNonPKeyAttrsCT fcrAttributes)
        {
            // for 18/19 funding claims any claim adjustments are made at allocation level in a single allocation FCR and are applied to the parent FCR for publishing
            if (fcrAttributes.ContractAllocation.Count == 1)
            {
                ClaimAdjustmentAttrsCT claimAdjustmentAttributes = fcrAttributes.ContractAllocation.Single().ContractAllocationNonPKeyAttrs.AmountAttrs.ClaimAdjustments;

                if (claimAdjustmentAttributes != null)
                {
                    fcrAttributes.AmountAttrs.ClaimAdjustments = claimAdjustmentAttributes;
                }
            }
        }

        private static List<ContractAllocationAllAttrsCT> TransformContractAllocations(IList<ContractAllocation> contractAllocations)
        {
            return contractAllocations.Select(TransformContractAllocation).ToList();
        }

        private static ContractAllocationAllAttrsCT TransformContractAllocation(ContractAllocation contractAllocation)
        {
            return new ContractAllocationAllAttrsCT
            {
                ContractAllocationPKeyAttrs = new ContractAllocationPKeyAttrsCT
                {
                    ContractAllocationNumber = contractAllocation.ContractAllocationNumber
                },
                ContractAllocationDNAttrs = new ContractAllocationDNAttrsCT
                {
                    ContractAttrs = new ContractAllAttrsCT
                    {
                        ContractNumber = contractAllocation.Contract.ContractNumber,
                        ContractApprovalDate = contractAllocation.Contract.ContractApprovalDate,
                        ContractSubVersionNumber = contractAllocation.Contract.ContractSubVersionNumber,
                        ContractVersionNumber = contractAllocation.Contract.ContractVersionNumber,
                        FundingTypeAllAttrs = TransformFundingType(contractAllocation.Contract.FundingType)
                    }
                },
                ContractAllocationNonPKeyAttrs = new ContractAllocationNonPKeyAttrsCT
                {
                    AllocationStartDate = contractAllocation.AllocationStartDate,
                    AllocationEndDate = contractAllocation.AllocationEndDate,
                    AmountAttrs = TransformAmounts(contractAllocation.Amounts),
                    ContractDeliverables = TransformDeliverables(contractAllocation.ContractDeliverables),
                    FundingstreamPeriodCode = contractAllocation.FundingstreamPeriodCode,
                }
            };
        }

        private static List<ContractDeliverablesAllAttrsCTContractDeliverable> TransformDeliverables(IList<ContractDeliverable> contractDeliverables)
        {
            return contractDeliverables.Select(TransformDeliverable).ToList();
        }

        private static ContractDeliverablesAllAttrsCTContractDeliverable TransformDeliverable(ContractDeliverable contractDeliverable)
        {
            return new ContractDeliverablesAllAttrsCTContractDeliverable
            {
                AmountAttrs = new AmountAttrsCT
                {
                    ClaimedValue = contractDeliverable.Amounts.ClaimedValue,
                    CappedClaimedValue = contractDeliverable.Amounts.CappedClaimedValue,
                    PlannedValue = contractDeliverable.Amounts.PlannedValue,
                    ProposedReconciliationValue = contractDeliverable.Amounts.ProposedReconciliationValue,
                    ReconciliationValue = contractDeliverable.Amounts.ReconciliationValue
                },
                Deliverable = new DeliverableAllAttrsCT
                {
                    DeliverableCode = contractDeliverable.Deliverable.DeliverableCode,
                    DeliverableName = contractDeliverable.Deliverable.DeliverableName
                }
            };
        }

        private static FundingTypeAllAttrsCT TransformFundingType(FundingType fundingType)
        {
            return new FundingTypeAllAttrsCT
            {
                FundingPKeyAttrs = new FundingTypePKeyAttrsCT
                {
                    FundingTypeCode = fundingType.FundingTypeCode
                },
                FundingTypeNonPKeyAttrs = new FundingTypeNonPKeyAttrsCT
                {
                    FundingTypeName = fundingType.FundingTypeName
                }
            };
        }

        private static AmountAttrsCT TransformAmounts(AmountSummary amount)
        {
            return new AmountAttrsCT
            {
                ClaimedValue = amount.ClaimedValue,
                CappedClaimedValue = amount.CappedClaimedValue,
                PlannedValue = amount.PlannedValue,
                ProposedReconciliationValue = amount.ProposedReconciliationValue,
                ReconciliationValue = amount.ReconciliationValue,
                AdjustedCappedClaimedValue = amount.AdjustedCappedClaimValue,
                EarningsBoostValue = amount.EarningsBoostValue,
                ClaimAdjustments = amount.ClaimAdjustments != null ? TransformClaimAdjustments(amount.ClaimAdjustments) : null
            };
        }

        private static ClaimAdjustmentAttrsCT TransformClaimAdjustments(ClaimAdjustment claimAdjustment)
        {
            return new ClaimAdjustmentAttrsCT
            {
                ClaimAdjustmentValue = claimAdjustment.ClaimAdjustmentValue,
                ClaimAdjustmentReason = claimAdjustment.ClaimAdjustmentReason
            };
        }

        private static FCReconciliationPKeyAttrsCT TransformToFcReconciliationPKeyAttrs(
            AllocationGroup allocationGroup,
            ClaimType claimType,
            Period period,
            Contractor contractor,
            int claimVersionNumber)
        {
            return new FCReconciliationPKeyAttrsCT
            {
                Contractor = TransformContractor(contractor),
                AllocationGroup = TransformAllocationGroup(allocationGroup),
                ClaimType = TransformClaimType(claimType),
                ClaimVersionNumber = claimVersionNumber,
                Period = TransformPeriod(period)
            };
        }

        private static PeriodAllAttrsCT TransformPeriod(Period period)
        {
            return new PeriodAllAttrsCT
            {
                Period = period.PeriodYear,
                PeriodTypeNonPKeyAttrs = new PeriodTypeNonPKeyAttrsCT
                {
                    PeriodTypeName = EnumTransformer.TransformPeriodTypeName(period.PeriodTypeName)
                },
                PeriodTypePKeyAttrs = new PeriodTypePKeyAttrsCT
                {
                    PeriodTypeCode = EnumTransformer.TransformPeriodTypeCode(period.PeriodTypeCode)
                }
            };
        }

        private static ClaimTypeAllAttrsCT TransformClaimType(ClaimType claimType)
        {
            return new ClaimTypeAllAttrsCT
            {
                ClaimTypeNonPKeyAttrs = new ClaimTypeNonPKeyAttrsCT
                {
                    ClaimTypeName = claimType.ClaimTypeName
                },
                ClaimTypePKeyAttrs = new ClaimTypePKeyAttrsCT
                {
                    ClaimTypeCode = claimType.ClaimTypeCode
                }
            };
        }

        private static AllocationGroupAllAttrsCT TransformAllocationGroup(AllocationGroup allocationGroup)
        {
            return new AllocationGroupAllAttrsCT
            {
                AllocationGroupNonPKeyAttrs = new AllocationGroupNonPKeyAttrsCT
                {
                    AllocationGroupName = allocationGroup.AllocationGroupName
                },
                AllocationGroupPKeyAttrs = new AllocationGroupPKeyAttrsCT
                {
                    AllocationGroupCode = allocationGroup.AllocationGroupCode
                }
            };
        }

        private static ContractorAllAttrsCT TransformContractor(Contractor contractor)
        {
            return new ContractorAllAttrsCT
            {
                ContractorNonPKeyAttrs = new ContractorNonPKeyAttrsCT
                {
                    LegalName = contractor.LegalName,
                    UKPRN = contractor.UKPRN
                },
                ContractorPKeyAttrs = new ContractorPKeyAttrsCT
                {
                    OrganisationIdentifier = contractor.OrganisationIdentifier
                }
            };
        }
    }
}
