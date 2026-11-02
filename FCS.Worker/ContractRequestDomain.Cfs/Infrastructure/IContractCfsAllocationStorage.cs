namespace ContractRequestDomain.Cfs.Infrastructure
{
    using Dto;

    public interface IContractCfsAllocationStorage
    {
        void UploadContract(string key, ContractCfsAllocation extendedContract);

        ContractCfsAllocation GetContract(string key);

        string GetKey(string contractNumber, int version);
    }
}