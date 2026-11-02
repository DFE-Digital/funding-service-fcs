namespace FundingAllocation.Endpoints.ReleaseGroup.Services
{
    using System;
    using System.Threading.Tasks;
    using Dto;
    using Repositories;
    using LanguageExt;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using Extensions;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public class ContractNumbersAndVersionIntentService : IContractNumbersAndVersionIntentService
    {
        private readonly IContractNumberQueryRepository _contractNumberQueryRepository;
        private readonly IFundingTypeRepository _fundingTypeRepository;

        public ContractNumbersAndVersionIntentService(IContractNumberQueryRepository contractNumberQueryRepository, IFundingTypeRepository fundingTypeRepository)
        {
            _contractNumberQueryRepository = contractNumberQueryRepository;
            _fundingTypeRepository = fundingTypeRepository;
        }

        public async Task<(string contractNumber, string masterContractNumber, int version)> GetContractNumberReferencesAndVersion(ContractIntent contractIntent, Option<CrmContractInfo> contractInfoOption, string fundingTypeCode)
        {
            string masterContractNumber = string.Empty;
            if (contractIntent == ContractIntent.RevisedNew)
            {
                return contractInfoOption.Match(
                    Some: cci => (cci.Number, cci.MasterContractNumber, cci.Version + 1),
                    None: () => throw new InvalidOperationException("The CrmContractInfo is required for ContractIntent.RevisedNew"));
            }

            if (contractIntent == ContractIntent.NewAmendment)
            {
                var contractInfo = contractInfoOption.Match(
                    Some: cci => cci,
                    None: () => throw new InvalidOperationException("The CrmContractInfo is required for ContractIntent.NewAmendment"));

                masterContractNumber = contractInfo.MasterContractNumber;
            }

            var contractNumber = await _contractNumberQueryRepository.GetNextContractNumberForFundingType(fundingTypeCode);
            if (masterContractNumber.IsEmpty())
            {
                var masterContractNumberPart = await _contractNumberQueryRepository.GetNextMasterContractNumber();
                masterContractNumber = $"DFE-{masterContractNumberPart}";
            }
            
            var contractNumberPrefix = await _fundingTypeRepository.GetContractNumberPrefix(fundingTypeCode);

            return ($"{contractNumberPrefix}-{contractNumber}", masterContractNumber, 1);
        }
    }
}