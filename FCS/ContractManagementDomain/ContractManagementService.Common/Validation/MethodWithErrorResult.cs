namespace SFA.FCT.ContractManagementService.Common.Validation
{
    using System;

    public class MethodWithErrorResult
    {
        public MethodWithErrorResult(Func<ContractIdentifier, ValidationResult> ruleMethod)
        {
            RuleMethod = ruleMethod;
        }

        public Func<ContractIdentifier, ValidationResult> RuleMethod { get; }
    }
}
