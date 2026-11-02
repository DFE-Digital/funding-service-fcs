namespace SFA.FCT.ContractManagementDomain.Integration.PublishContractWithdrawalEndpoint
{
    using ContractManagementService.Common.Services;

    public class ContractXmlValidator : IContractXmlValidator
    {
        public bool IsValid(string xml)
        {
            return CorporateSchemaContractValidator.IsContractXmlValid(xml);
        }
    }
}
