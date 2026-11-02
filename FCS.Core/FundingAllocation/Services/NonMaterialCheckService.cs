namespace FundingAllocation.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dto;
    using Extensions;
    using Repositories;

    public class NonMaterialCheckService : INonMaterialCheckService
    {
        private readonly IFundingAllocationRepository _fundingAllocationRepository;
        private readonly string _fundingStreamCode = "LOANS";
        private readonly string _LoanGrantFundingCode = "LOANS-002";
        private readonly string _LoanContractFundingCode = "LOANS-003";

        public NonMaterialCheckService(IFundingAllocationRepository fundingAllocationRepository)
        {
            _fundingAllocationRepository = fundingAllocationRepository;
        }

        public async Task<FilterCheckResult> GetFilterCheckResult(IReadOnlyCollection<string> fundingIds)
        {
            var fundingNameDictionary = fundingIds.ToDictionary(fundingId => fundingId.RemoveVersionFromId(), fundingId => fundingId);

            var latestContractApprovedFundingAllocationIdAndNames =
                await _fundingAllocationRepository.GetLatestContractApprovedFundingAllocationIds(fundingNameDictionary
                    .Keys);
            var materiallyEquivalentFundingIds = new List<string>();

            foreach (var fundingIdAndName in latestContractApprovedFundingAllocationIdAndNames)
            {
                var fundingAllocations = await _fundingAllocationRepository.GetFundingAllocations(new List<string>
                    {fundingIdAndName.FundingId, fundingNameDictionary[fundingIdAndName.FundingAllocationName]});
                var fundingAllocationDictionary = fundingAllocations.ToDictionary(fa => fa.FundingId);

                var latestContractApprovedFundingAllocation = fundingAllocationDictionary[fundingIdAndName.FundingId];

                var currentFundingAllocation = fundingAllocationDictionary[fundingNameDictionary[fundingIdAndName.FundingAllocationName]];

                if (currentFundingAllocation.IsMateriallyEquivalentTo(latestContractApprovedFundingAllocation))
                {
                    materiallyEquivalentFundingIds.Add(currentFundingAllocation.FundingId);
                }
            }

            var fundingIdsForContractControl = fundingIds.WhereNotIn(materiallyEquivalentFundingIds).ToList();

            return new FilterCheckResult(fundingIdsForContractControl, materiallyEquivalentFundingIds);
        }

        public async Task<FilterCheckResult> GetLoanFilterCheckResult(IReadOnlyCollection<string> fundingIds)
        {
            var loanFundingIds = fundingIds.Where(fundingId => fundingId.ToUpper().Contains(_fundingStreamCode)).ToList();

            var fundingLineValues =
                await _fundingAllocationRepository.GetFundingLinePlannedValueForFundingAllocationIds(loanFundingIds);
            var materiallyEquivalentFundingIds = new List<string>();

            if (fundingLineValues != null && fundingLineValues.Any())
            {
                // Grouping the records by FundingId
                var fundingLineRecords = fundingLineValues
                    .GroupBy(record => record.FundingId)
                    .Select(group => new
                    {
                        FundingId = group.Key,
                        Records = group.ToList()
                    });

                // Validate each group of records
                foreach (var fundingLine in fundingLineRecords)
                {
                    // Check for the specific case where LOAN-002 and LOAN-003 should not have the same value
                    var LoanGrantValue = fundingLine.Records.FirstOrDefault(r => r.FundingLineCode == _LoanGrantFundingCode);
                    var LoanContractValue = fundingLine.Records.FirstOrDefault(r => r.FundingLineCode == _LoanContractFundingCode);

                    if (LoanGrantValue != null && LoanContractValue != null)
                    {
                        if (LoanGrantValue.FundingValue != 0)
                        {
                            if (LoanContractValue.FundingValue != 0)
                            {
                                if (!string.IsNullOrEmpty(Convert.ToString(LoanGrantValue.FundingValue)) && !string.IsNullOrEmpty(Convert.ToString(LoanContractValue.FundingValue)))
                                {
                                    Console.WriteLine($"[Error] FundingLineCode {_LoanGrantFundingCode} and {_LoanContractFundingCode} both have the FundingValue as : {Convert.ToString(LoanGrantValue.FundingValue)} and {Convert.ToString(LoanContractValue.FundingValue)}");
                                    materiallyEquivalentFundingIds.Add(fundingLine.FundingId);
                                }
                            }
                        }
                    }
                }
            }
            var fundingIdsForContractControl = fundingIds.WhereNotIn(materiallyEquivalentFundingIds).ToList();

            return new FilterCheckResult(fundingIdsForContractControl, materiallyEquivalentFundingIds);
        }

    }
}
