namespace ContractManagementDomain.Termination.Services
{
    using SFA.FCT.ContractManagementService.Common.Services;

    public class ContractXmlValidator : IContractXmlValidator
    {
        public bool IsValid(string xml)
        {
            return CorporateSchemaContractValidator.IsContractXmlValid(xml);
        }
    }
}
