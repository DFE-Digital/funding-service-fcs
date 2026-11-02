namespace ContractManagementDomain.Endpoint.DeleteContract.Repositories
{
    public interface ICrmContractAttributesRepository
    {
        ContractAttributes GetAttributesForContract(string contractNumber, int version);
    }
}
