namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Common.Extensions;
    using CrossDomain.Integration.Entities.ContractRequest;
    using DTOs;

    /// <summary>
    /// CBR-005
    /// </summary>
    public class ContractTypeForFundingTypeFundingPeriodRule : IRule<contractRequestType>
    {
        private readonly Func<IReadOnlyCollection<FundingTypeFundingPeriodContractTypeDto>> _getFundingTypeFundingPeriodContractTypesFromConfig;

        public ContractTypeForFundingTypeFundingPeriodRule(Func<IReadOnlyCollection<FundingTypeFundingPeriodContractTypeDto>> getFundingTypeFundingPeriodContractTypesFromConfig)
        {
            _getFundingTypeFundingPeriodContractTypesFromConfig = getFundingTypeFundingPeriodContractTypesFromConfig;
        }

        public string ErrorMessage => "Contract Type is not valid for this Funding Type and Period";
        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Contract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType masterContract)
        {
            string fundingPeriod = masterContract.GetFundingPeriod();

            return masterContract.contract.contracts.Where(c =>
                    IsContractTypeValid(c.contractType1, fundingPeriod, c.fundingTypeCode) == false)
                .Select(c => c.correlationId);
        }

        private bool IsContractTypeValid(string contractType, string fundingPeriod, string fundingType)
        {
            var configData = _getFundingTypeFundingPeriodContractTypesFromConfig();
            var contractData = new FundingTypeFundingPeriodContractTypeDto(fundingType, fundingPeriod, contractType);

            return configData.Contains(contractData) ||
                   configData.None(config =>
                       config.FundingPeriodCode == fundingPeriod && config.FundingTypeCode == fundingType);
        }
    }
}
