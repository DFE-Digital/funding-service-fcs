namespace FundingAllocation.Endpoints.ReleaseGroup.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dto;
    using FundingAllocation.Services;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public class FundingAllocationGroupingService : IFundingAllocationGroupingService
    {
        private readonly IReleaseGroupFundingAllocationRepository _fundingAllocationRepository;
        private readonly ICfsToFcsCodeMappingService _cfsToFcsCodeMappingService;

        public FundingAllocationGroupingService(IReleaseGroupFundingAllocationRepository fundingAllocationRepository, ICfsToFcsCodeMappingService cfsToFcsCodeMappingService)
        {
            _fundingAllocationRepository = fundingAllocationRepository;
            _cfsToFcsCodeMappingService = cfsToFcsCodeMappingService;
        }

        public async Task<FundingAllocationContractGroup[]> GetFundingAllocationContractGroups(IEnumerable<string> fundingIds)
        {
            var groupingInfos = await _fundingAllocationRepository.GetFundingAllocationGroupingInfos(fundingIds);

            var contractItemsMappingResults = new List<(string fundingId, ContractItemsMappingResult contractItemsMappingResult, string contractingUkprn)>();

            foreach (var groupingInfo in groupingInfos)
            {
                var contractItemsMappingResult = await _cfsToFcsCodeMappingService.GetContractItemsMappingResult(groupingInfo
                    .GetContractItemsMappingInput);
                contractItemsMappingResults.Add((groupingInfo.FundingId, contractItemsMappingResult, groupingInfo.ContractingUkprn));
            }

            return contractItemsMappingResults.GroupBy(r =>
                    new
                    {
                        r.contractItemsMappingResult.FundingTypeCode,
                        r.contractItemsMappingResult.FundingPeriodCode,
                        r.contractingUkprn,
                        r.contractItemsMappingResult
                    })
                .Select(grp =>
                    new FundingAllocationContractGroup(
                        int.Parse(grp.Key.contractingUkprn),
                        fundingType:grp.Key.FundingTypeCode,
                        fundingPeriod:grp.Key.FundingPeriodCode,
                        grp.Select(r => r.fundingId).ToList(),
                        grp.Key.contractItemsMappingResult))
                .ToArray();
        }
    }
}