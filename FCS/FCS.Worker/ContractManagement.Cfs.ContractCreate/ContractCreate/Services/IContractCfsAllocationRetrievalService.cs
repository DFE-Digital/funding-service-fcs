namespace ContractManagement.Cfs.ContractCreate.Services
{
    using Dtos;

    public interface IContractCfsAllocationRetrievalService
    {
        ContractCfsAllocation GetContractCfsAllocation(string key);
        string GetKey(string contractNumber, int version);
    }
}