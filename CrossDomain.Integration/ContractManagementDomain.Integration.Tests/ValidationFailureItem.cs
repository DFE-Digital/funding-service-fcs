namespace SFA.FCT.ContractManagementDomain.Integration.Tests
{
    internal class ValidationFailureItem
    {
        public ValidationFailureItem(string contractXml, string message)
        {
            ContractXml = contractXml;
            Message = message;
        }

        public string ContractXml { get; }

        public string Message { get; }
    }
}
