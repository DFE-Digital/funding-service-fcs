namespace SFA.FCT.ContractManagementService.Common.Validation
{
    public class ValidationResult
    {
        public ValidationResult(bool isValid, string failureMessage)
        {
            IsValid = isValid;
            FailureMessage = failureMessage;
        }

        public bool IsValid { get; }

        public string FailureMessage { get; }
    }
}
