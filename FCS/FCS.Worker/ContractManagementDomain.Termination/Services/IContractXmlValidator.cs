namespace ContractManagementDomain.Termination.Services
{
    public interface IContractXmlValidator
    {
        bool IsValid(string xml);
    }
}