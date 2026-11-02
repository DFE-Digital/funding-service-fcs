namespace SFA.FCT.CrossDomain.Integration.Common.SchemaValidator
{
    using System.Collections.Generic;

    public class SchemaValidatorResultset 
    {
        public bool IsValid { get; }
        public IReadOnlyCollection<string> ValidationErrors { get; }

        public SchemaValidatorResultset(bool isValid, IReadOnlyCollection<string> validationErrors)
        {
            IsValid = isValid;
            ValidationErrors = validationErrors;
        }
    }
}
