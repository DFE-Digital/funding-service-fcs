namespace FundingAllocation.Services
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using System.Linq;
    using Dto;
    using Extensions;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public class CfsToFcsCodeMappingService : ICfsToFcsCodeMappingService
    {
        private readonly IContractTypeRepository _contractTypeRepository;
        private readonly IProviderCategoryRepository _providerCategoryRepository;
        private readonly IAllocationFundingStreamConfigRepository _allocationFundingStreamConfigRepository;
        private readonly IAllocationLineConfigRepository _allocationLineConfigRepository;

        public CfsToFcsCodeMappingService(
            IContractTypeRepository contractTypeRepository,
            IProviderCategoryRepository providerCategoryRepository,
            IAllocationFundingStreamConfigRepository allocationFundingStreamConfigRepository,
            IAllocationLineConfigRepository allocationLineConfigRepository)
        {
            _contractTypeRepository = contractTypeRepository;
            _providerCategoryRepository = providerCategoryRepository;
            _allocationFundingStreamConfigRepository = allocationFundingStreamConfigRepository;
            _allocationLineConfigRepository = allocationLineConfigRepository;
        }

        public async Task<FspCodeDeliverable> GetFspCodeDeliverable(ProviderFundingInfo providerFundingInfo)
        {
            var allocationFundingStreamResult = await _allocationFundingStreamConfigRepository.GetAllocationFundingStreamConfig(
                allocationFundingStreamCode: providerFundingInfo.FundingStreamCode,
                allocationPeriodId: providerFundingInfo.FundingPeriodId);

            var providerCategory = await _providerCategoryRepository.GetProviderCategoryExceptionOrDefault(
                providerType:providerFundingInfo.ProviderType,
                providerSubType:providerFundingInfo.ProviderSubType,
                fundingTypeCode:allocationFundingStreamResult.FundingTypeCode,
                fundingPeriodCode:allocationFundingStreamResult.FundingPeriodCode,
                ukprn:providerFundingInfo.ContractingUkprn);

            var allocationLineDeliverableInfos = await _allocationLineConfigRepository.GetAllocationLineConfigs(
                allocationFundingStreamCode:providerFundingInfo.FundingStreamCode,
                allocationPeriodId:providerFundingInfo.FundingPeriodId,
                fundingLineCode:providerFundingInfo.FundingLineCode);

            providerCategory = GetDeliveryUkprnForContracting(providerFundingInfo.ProviderType, providerCategory);

            allocationLineDeliverableInfos.ShouldNotBeEmpty($"Failed to find matching Allocation Line Config for: {providerFundingInfo}");

            var allocationLineDeliverableInfo =
                allocationLineDeliverableInfos.FirstOrDefault(alc => alc.ProviderCategory == providerCategory) ??
                allocationLineDeliverableInfos.First(alc => alc.ProviderCategory == "DEFAULT");

            return new FspCodeDeliverable(
                allocationLineDeliverableInfo.FspCode,
                allocationLineDeliverableInfo.DeliverableCode,
                allocationLineDeliverableInfo.DeliverableName,
                allocationLineDeliverableInfo.DisplayOrder,
                allocationLineDeliverableInfo.FundingStreamCode,
                allocationLineDeliverableInfo.AllocationReferencePrefix);
        }

        public string GetDeliveryUkprnForContracting(string providerType, string providerCategory)
        {
            bool result = false;
            if (providerType == "Local authority maintained schools" || providerType == "Schoo")
            {
                result = true;
            }
            if (result && providerCategory == "LA AA")
            {
                providerCategory = "SSF";
            }
            return providerCategory;
        }

        public async Task<ContractItemsMappingResult> GetContractItemsMappingResult(ContractItemsMappingInput mappingInput)
        {
            return await GetAsyncContractItemsMappingResult(mappingInput);
        }      

        public  async Task<IReadOnlyCollection<LogicalAllocationInfo>> GetLogicalAllocations(
            IEnumerable<DataStore.Model.FundingAllocation> fundingAllocations)
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
                    pal.providerFundingAllocation.ProviderFunding.DeliveryUkprn
                })
                .ToList();

            var fspCodeDeliveryUkprnList = new List<(string fspCode, int deliveryUkprn)>();
            foreach (var providerFundingInfo in providerFundingInfos)
            {
                var fspDel = await GetFspCodeDeliverable(providerFundingInfo.Pfi);
                var deliveryUkprn = providerFundingInfo.DeliveryUkprn;
                fspCodeDeliveryUkprnList.Add((fspDel.FspCode, deliveryUkprn));
            }

            return fspCodeDeliveryUkprnList.GroupBy(fspDel => new { fspDel.fspCode, fspDel.deliveryUkprn })
                .Select(grp => new LogicalAllocationInfo(grp.Key.fspCode, grp.Key.deliveryUkprn)).ToList();
        }

        private async Task<ContractItemsMappingResult> GetAsyncContractItemsMappingResult(ContractItemsMappingInput mappingInput)
        {
            var allocationFundingStreamResult = await _allocationFundingStreamConfigRepository.GetAllocationFundingStreamConfig(
                allocationFundingStreamCode: mappingInput.AllocationFundingStreamCode,
                allocationPeriodId: mappingInput.AllocationPeriodId);

            var providerCategory = await _providerCategoryRepository.GetProviderCategoryExceptionOrDefault(
                providerType: mappingInput.ProviderType,
                providerSubType: mappingInput.ProviderSubType,
                fundingTypeCode: allocationFundingStreamResult.FundingTypeCode,
                fundingPeriodCode: allocationFundingStreamResult.FundingPeriodCode,
                ukprn: mappingInput.ContractingUkprn);
            
            var contractType = await _contractTypeRepository.GetContractType(allocationFundingStreamResult.FundingTypeCode,
                allocationFundingStreamResult.FundingPeriodCode, providerCategory);

            return new ContractItemsMappingResult(
                fundingTypeCode: allocationFundingStreamResult.FundingTypeCode,
                fundingPeriodCode: allocationFundingStreamResult.FundingPeriodCode,
                fspGroupCode: allocationFundingStreamResult.FSPGroupCode,
                contractType: contractType);
        }
    }
}