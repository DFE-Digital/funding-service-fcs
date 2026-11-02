namespace SFA.FCT.ContractManagementDomain.Integration.PublishContractWithdrawalEndpoint
{
    public interface IContractXmlValidator
    {
        bool IsValid(string xml);
    }
}