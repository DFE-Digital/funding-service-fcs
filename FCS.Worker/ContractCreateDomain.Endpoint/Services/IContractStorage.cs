namespace ContractCreateDomain.Endpoint.Services
{
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public interface IContractStorage
    {
        void UploadContract(string key, ExtendedContractTypeAndIntent extendedContract);
        string GetKey(string contractNumber, int version, int subVersion);
    }
}