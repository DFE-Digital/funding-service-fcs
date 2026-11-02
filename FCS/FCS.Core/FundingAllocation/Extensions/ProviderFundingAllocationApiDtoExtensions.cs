namespace FundingAllocation.Extensions
{
    using System.Linq;
    using DataStore.Model;
    using Dto;

    public static class ProviderFundingAllocationApiDtoExtensions
    {
        public static ProviderFunding ToProviderFunding(this ProviderFundingAllocationApiDto dto)
        {
            var providerFunding = new ProviderFunding(providerFundingId: dto.ProviderFundingId,
                deliveryUkprn: dto.DeliveryUkprn, providerType: dto.ProviderType,
                providerSubType: dto.ProviderSubType);
            
            providerFunding.FundingAllocationLines.AddRange(dto.FundingAllocationLines
                .Select(ToFundingAllocationLine)
                .ToList());

            return providerFunding;

            FundingAllocationLine ToFundingAllocationLine(FundingAllocationLineApiDto lineDto)
            {
                var fundingAllocationLine = new FundingAllocationLine(dto.ProviderFundingId, lineDto.FundingLineCode);
                fundingAllocationLine.FundingAllocationProfilePeriods.AddRange(lineDto.FundingAllocationProfilePeriods
                    .Select(pp => new FundingAllocationProfilePeriod(dto.ProviderFundingId, lineDto.FundingLineCode, pp.GetPeriod(), pp.PlannedValue)));
                return fundingAllocationLine;
            }
        }
    }
}
