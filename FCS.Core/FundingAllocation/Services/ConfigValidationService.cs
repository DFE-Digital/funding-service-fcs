namespace FundingAllocation.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dto;
    using Extensions;
    using Repositories;

    public class ConfigValidationService : IConfigValidationService
    {
        private readonly IProviderCategoryRepository _providerCategoryRepository;
        private readonly IAllocationFundingStreamConfigRepository _allocationFundingStreamConfigRepository;
        private readonly IContractTypeRepository _contractTypeRepository;
        private readonly IAllocationLineConfigRepository _allocationLineConfigRepository;

        public ConfigValidationService(
            IProviderCategoryRepository providerCategoryRepository,
            IAllocationFundingStreamConfigRepository allocationFundingStreamConfigRepository,
            IContractTypeRepository contractTypeRepository,
            IAllocationLineConfigRepository allocationLineConfigRepository)
        {
            _providerCategoryRepository = providerCategoryRepository;
            _allocationFundingStreamConfigRepository = allocationFundingStreamConfigRepository;
            _contractTypeRepository = contractTypeRepository;
            _allocationLineConfigRepository = allocationLineConfigRepository;
        }

        private enum ValidationResultReason
        {
            NotSet,
            FailedFundingTypePeriodFSPGroup,
            FailedContractType,
            FailedFundingLineConfig,
            Valid
        }
        
        public async Task<ConfigValidationResult> GetAwaitingConfigFilterResult(IReadOnlyCollection<FundingAllocationValidationInput> fundingValidationInputs)
        {
            var validationResultDictionary = new Dictionary<ValidationResultReason, List<string>>();

            foreach (var fundingIdWithMappingInput in fundingValidationInputs)
            {
                var result = await ValidateFunding(fundingIdWithMappingInput);
                validationResultDictionary.GetOrAdd(result, () => new List<string>()).Add(fundingIdWithMappingInput.FundingId);
            }

            return new ConfigValidationResult(
                validationResultDictionary.GetOrAdd(ValidationResultReason.FailedFundingTypePeriodFSPGroup, () => new List<string>()), 
                validationResultDictionary.GetOrAdd(ValidationResultReason.FailedContractType, () => new List<string>()),
                validationResultDictionary.GetOrAdd(ValidationResultReason.FailedFundingLineConfig, () => new List<string>()),
                validationResultDictionary.GetOrAdd(ValidationResultReason.Valid, () => new List<string>()));
        }

        private async Task<ValidationResultReason> ValidateFunding(FundingAllocationValidationInput validationInput)
        {
            var allocationFundingStreamResultOption = await _allocationFundingStreamConfigRepository.TryGetAllocationFundingStreamConfig(
                allocationFundingStreamCode: validationInput.MappingInput.AllocationFundingStreamCode,
                allocationPeriodId: validationInput.MappingInput.AllocationPeriodId);

            return await allocationFundingStreamResultOption.MatchAsync(
                Some: async afsConfig =>
                {
                    var providerCategoryOption = await _providerCategoryRepository.TryGetProviderCategoryExceptionOrDefault(
                        providerType: validationInput.MappingInput.ProviderType,
                        providerSubType: validationInput.MappingInput.ProviderSubType,
                        fundingTypeCode: afsConfig.FundingTypeCode,
                        fundingPeriodCode: afsConfig.FundingPeriodCode,
                        ukprn: validationInput.MappingInput.ContractingUkprn);

                    return await providerCategoryOption.MatchAsync(
                        Some:async providerCategory =>
                        {
                            var contractTypeOption = await _contractTypeRepository.TryGetContractType(
                                afsConfig.FundingTypeCode,
                                afsConfig.FundingPeriodCode, providerCategory);

                            return await contractTypeOption.MatchAsync(
                                Some: async ct =>
                                {
                                    var areFundingLineCodesValid = await AreAllFundingLineCodesValid(
                                        validationInput.MappingInput.AllocationFundingStreamCode,
                                        validationInput.MappingInput.AllocationPeriodId,
                                        validationInput.FundingLineCodes,
                                        providerCategory);

                                    if (areFundingLineCodesValid)
                                    {
                                        return ValidationResultReason.Valid;
                                    }

                                    return ValidationResultReason.FailedFundingLineConfig;
                                },
                                None: () => ValidationResultReason.FailedContractType);
                        },
                        None: () => ValidationResultReason.FailedContractType);
                },
                None: () => Task.FromResult(ValidationResultReason.FailedFundingTypePeriodFSPGroup));
        }

        private async Task<bool> AreAllFundingLineCodesValid(
            string allocationFundingStreamCode,
            string allocationPeriodId,
            IReadOnlyCollection<string> fundingLineCodes,
            string providerCategory)
        {
            foreach (var fundingLineCode in fundingLineCodes)
            {
                var configs = await _allocationLineConfigRepository.GetAllocationLineConfigs(
                    allocationFundingStreamCode,
                    allocationPeriodId,
                    fundingLineCode);

                var allocationLineDeliverableInfo =
                    configs.FirstOrDefault(alc => alc.ProviderCategory == providerCategory) ??
                    configs.FirstOrDefault(alc => alc.ProviderCategory == "DEFAULT");

                if (allocationLineDeliverableInfo == null)
                {
                    return false;
                }
            }

            return fundingLineCodes.Any();
        }
    }
}
