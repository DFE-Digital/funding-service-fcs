namespace SFA.FCT.ContractManagementService.Common.Validation
{
    using System.Collections.Generic;

    public static class ValidationHelper
    {
        public static string GetFirstFailureMessageWhenValidationFails(IReadOnlyCollection<MethodWithErrorResult> methodWithErrorResults, ContractIdentifier contractIdentity)
        {
            foreach (MethodWithErrorResult methodWithErrorResult in methodWithErrorResults)
            {
                ValidationResult validationResult = methodWithErrorResult.RuleMethod(contractIdentity);
                if (!validationResult.IsValid)
                {
                    return validationResult.FailureMessage;
                }
            }
            return null;
        }
    }
}
