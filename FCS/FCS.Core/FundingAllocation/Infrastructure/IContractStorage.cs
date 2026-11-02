namespace FundingAllocation.Infrastructure
{
    using System.Threading.Tasks;
    using Azure;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public interface IContractStorage
    {
        Task<ETag> StoreContract(string key, ExtendedContractTypeAndIntent extendedContract);

        Task<ExtendedContractTypeAndIntent> GetContract(string key);

        public string GetKey(string contractNumber, int version, int subVersion);
    }
}
