namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation
{
    using System.Linq;
    using Rules;
    using CrossDomain.Integration.Entities.ContractRequest;

    public static class ContractRequestValidationExtensions
    {
        public static bool HasMasterAndContractNumber(this contractRequestType contractRequest)
        {
            return contractRequest.errorInfo == null || !contractRequest.errorInfo.Any(
                x => x.Value == ValidationRuleErrorMessages.MustSpecifyContractNumber
                || x.Value == ValidationRuleErrorMessages.MustSpecifyMasterContractNumber);
        }
    }
}
