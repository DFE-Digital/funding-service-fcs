namespace FundingAllocation.Endpoints.ReleaseGroup
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using DataStore.Model;
    using Dto;

    public static class FundingAllocationExtensions
    {
        public static IReadOnlyCollection<ContractAllocationInfo> GetContractAllocationInfos(
            this IEnumerable<FundingAllocation> fundingAllocations,
            Func<ProviderFundingInfo, FspCodeDeliverable> getFspAndDeliverableCode)
        {
            var providerFundingInfos = fundingAllocations.SelectMany(fa => fa.GetProviderAllocationLines())
                .ToList()
                .Select(pal => new
                {
                    Pfi = new ProviderFundingInfo(
                        providerType: pal.providerFundingAllocation.ProviderFunding.ProviderType,
                        providerSubType: pal.providerFundingAllocation.ProviderFunding.ProviderSubType,
                        fundingStreamCode: pal.allocationFundingStream,
                        fundingPeriodId: pal.cfsPeriod,
                        fundingLineCode: pal.fundingAllocationLine.FundingLineCode,
                        contractingUkprn: pal.contractingUkprn
                    ),
                    Periods = pal.fundingAllocationLine.FundingAllocationProfilePeriods,
                    pal.providerFundingAllocation.ProviderFunding.DeliveryUkprn
                })
                .ToList();

            var fspDeliverableAndPeriodList = providerFundingInfos
                .Select(pfiAndPeriods => new
                {
                    pfiAndPeriods.Periods, 
                    FspDel = getFspAndDeliverableCode(pfiAndPeriods.Pfi),
                    pfiAndPeriods.DeliveryUkprn
                })
                .ToList();

            var logicalAllocations = fspDeliverableAndPeriodList.GroupBy(
                fsp => new {fsp.FspDel.FspCode, fsp.DeliveryUkprn, fsp.FspDel.FundingStreamCode, fsp.FspDel.AllocationReferencePrefix},
                fsp => (
                    fsp.FspDel.DeliverableCode,
                    fsp.FspDel.DeliverableName,
                    fsp.FspDel.DisplayOrder,
                    fsp.FspDel.FundingStreamCode,
                    fsp.FspDel.AllocationReferencePrefix,
                    fsp.Periods)).ToList();

            return logicalAllocations.Select(a =>
                {
                    return new ContractAllocationInfo(
                        fundingStreamPeriodCode: a.Key.FspCode,
                        fundingStreamCode: a.Key.FundingStreamCode,
                        allocationReferencePrefix: a.Key.AllocationReferencePrefix,
                        deliveryUkprn: a.Key.DeliveryUkprn,
                        a.Select(d =>
                                new ContractDeliverableInfo(d.DeliverableCode, d.DeliverableName, d.DisplayOrder, d.Periods))
                            .ToList(),
                        numAllocationsOnContract:logicalAllocations.Count);
                })
                .ToList();
        }
    }
}