namespace ContractCreateDomain.IncrementContractVersionEndpoint.Services
{
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public interface IContractStorage
    {
        void UploadContract(string key, ExtendedContractType extendedContract);

        void RemoveContract(string key);

        ExtendedContractType GetContract(string key);

        string GetKey(string contractNumber, int version);
    }
}