namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Services
{
    public interface IContractSyntaxBusinessRuleService
    {
        bool ShouldFundingTypePreventContractsWithTheSameUkprnForNewOrNewAmendmentIntent(string fundingType);
    }
}