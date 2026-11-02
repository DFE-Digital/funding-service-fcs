namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Services
{
    using CrossDomain.Integration.Entities;
    using System.Collections.Generic;
    using System.Linq;

    public class ContractSyntaxBusinessRuleService : IContractSyntaxBusinessRuleService
    {
        private readonly IEnumerable<string> _fundingTypesThatDontAllowMultipleContractWithTheSameUkprnWhenIntentIsNewOrIsNewAmendment = new List<string>
        {
            FundingTypes.ESF
        };
        
        public bool ShouldFundingTypePreventContractsWithTheSameUkprnForNewOrNewAmendmentIntent(string fundingType)
        {
            return _fundingTypesThatDontAllowMultipleContractWithTheSameUkprnWhenIntentIsNewOrIsNewAmendment.Contains(fundingType);
        }
    }
}
