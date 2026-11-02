namespace FundingAllocation.Tests.TestHelpers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using DataStore.Model;

    public static class FundingAllocationHelper
    {
        public static FundingAllocation FundingAllocationWithFundingId(string fundingId)
        {
            return new FundingAllocation(fundingId, "", "", "", "", default, default, default, default, default);
        }

        public static FundingAllocation WithReadId(this FundingAllocation fundingAllocation, int readId)
        {
            return new FundingAllocation(fundingAllocation.FundingId,
                fundingAllocation.FundingVersion,
                fundingAllocation.Period,
                fundingAllocation.AllocationFundingStream,
                fundingAllocation.UKPRN,
                fundingAllocation.Value, 
                fundingAllocation.PageNumber,
                fundingAllocation.PositionInPage,
                fundingAllocation.ProviderFundingCount,
                readId).WithPropertiesFrom(fundingAllocation);
        }

        public static FundingAllocation WithPageNumber(this FundingAllocation fundingAllocation, int pageNumber)
        {
            return new FundingAllocation(fundingAllocation.FundingId,
                fundingAllocation.FundingVersion,
                fundingAllocation.Period,
                fundingAllocation.AllocationFundingStream,
                fundingAllocation.UKPRN,
                fundingAllocation.Value,
                pageNumber,
                fundingAllocation.PositionInPage,
                fundingAllocation.ProviderFundingCount,
                fundingAllocation.ReadId).WithPropertiesFrom(fundingAllocation);
        }

        public static FundingAllocation WithStatus(this FundingAllocation target, FundingAllocationStatus status)
        {
            target.FundingAllocationStatus = status;
            return target;
        }

        public static FundingAllocation WithIsPublished(this FundingAllocation target, bool isPublished)
        {
            target.IsPublished = isPublished;
            return target;
        }

        public static FundingAllocation WithSubStatus(this FundingAllocation target, FundingAllocationSubStatus subStatus)
        {
            target.FundingAllocationSubStatus = subStatus;
            return target;
        }

        public static FundingAllocation WithStatusAndSubstatus(
            this FundingAllocation target,
            FundingAllocationStatus status,
            FundingAllocationSubStatus subStatus)
        {
            target.FundingAllocationStatus = status;
            target.FundingAllocationSubStatus = subStatus;

            return target;
        }

        public static FundingAllocation ForContract(
            this FundingAllocation fundingAllocation, int contractId)
        {
            fundingAllocation.ContractId = contractId;
            return fundingAllocation;
        }

        public static FundingAllocation ForReleaseGroup(
            this FundingAllocation fundingAllocation, int releaseGroupId)
        {
            fundingAllocation.ReleaseGroupId = releaseGroupId;

            return fundingAllocation;
        }

        public static FundingAllocation WithCrmEntityId(
            this FundingAllocation fundingAllocation, Guid crmEntityId)
        {
            fundingAllocation.CrmEntityId = crmEntityId;
            return fundingAllocation;
        }

        public static FundingAllocation WithProviderAndLines(this FundingAllocation fundingAllocation, int numLines)
        {
            var provider = new ProviderFundingAllocation(
                string.Empty, fundingAllocation.FundingId)
            {
                ProviderFunding = new ProviderFunding(string.Empty, 0, string.Empty, string.Empty)
            };
            Enumerable.Range(0, numLines).ToList()
                .ForEach(i => provider.ProviderFunding.FundingAllocationLines.Add(new FundingAllocationLine(string.Empty, string.Empty))); 
            fundingAllocation.ProviderFundingAllocations.Add(provider);

            return fundingAllocation;
        }

        public static FundingAllocation WithProviderAndFundingAllocationLines(this FundingAllocation fundingAllocation, List<FundingAllocationLine> fundingAllocationLines )
        {
            var providerFundingId = fundingAllocationLines.First().ProviderFundingId;
            var provider = new ProviderFundingAllocation(
                fundingAllocationLines.First().ProviderFundingId, fundingAllocation.FundingId)
            {
                ProviderFunding = new ProviderFunding(providerFundingId, 0, string.Empty, string.Empty)
            };

            provider.ProviderFunding.FundingAllocationLines.AddRange(fundingAllocationLines);
            fundingAllocation.ProviderFundingAllocations.Add(provider);

            return fundingAllocation;
        }


        private static FundingAllocation WithPropertiesFrom(this FundingAllocation target,
            FundingAllocation source)
        {
            target.CrmEntityId = source.CrmEntityId;
            target.Contract = source.Contract;
            target.ContractId = source.ContractId;
            target.FundingAllocationStatus = source.FundingAllocationStatus;
            target.FundingAllocationSubStatus = source.FundingAllocationSubStatus;
            target.ReleaseGroupId = source.ReleaseGroupId;

            return target;
        }
    }
}
