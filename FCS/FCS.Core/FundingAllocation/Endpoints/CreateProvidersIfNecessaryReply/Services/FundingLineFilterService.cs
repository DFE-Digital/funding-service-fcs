namespace FundingAllocation.Endpoints.CreateProvidersIfNecessaryReply.Services
{
    using System.Linq;
    using System.Threading.Tasks;
    using DataStore.Model;
    using Extensions;
    using Repositories;

    public class FundingLineFilterService : IFundingLineFilterService
    {
        private readonly IFundingAllocationRepository _fundingAllocationRepository;

        public FundingLineFilterService(IFundingAllocationRepository fundingAllocationRepository)
        {
            _fundingAllocationRepository = fundingAllocationRepository;
        }

        public async Task FilterOutZeroValuedOfNoInterestLines(FundingAllocation fundingAllocation)
        {
            var lines = fundingAllocation.GetFundingAllocationLines();
            var zeroValueLines = lines.Where(l => !l.HasNonZeroPlannedValue()).ToList();

            if (zeroValueLines.Any())
            {
                var previousPublishedLines =
                    await _fundingAllocationRepository.GetLatestPublishedFundingLines(
                        fundingAllocation.FundingAllocationName, fundingAllocation.FundingId);

                var zeroValuedLinesNotPreviouslyPublished = zeroValueLines.Where(zeroValuedLine =>
                {
                    return previousPublishedLines.NotAny(prevLine =>
                        prevLine.ProviderFundingId.RemoveVersionFromId() ==
                        zeroValuedLine.ProviderFundingId.RemoveVersionFromId() &&
                        prevLine.FundingLineCode == zeroValuedLine.FundingLineCode);
                }).ToList();

                var linePks = zeroValuedLinesNotPreviouslyPublished
                    .Select(l => (l.ProviderFundingId, l.FundingLineCode)).ToList();

                await _fundingAllocationRepository.SetLinesToIsOfNoInterest(linePks);

                fundingAllocation.RemoveLines(zeroValuedLinesNotPreviouslyPublished);
            }
        }
    }
}
