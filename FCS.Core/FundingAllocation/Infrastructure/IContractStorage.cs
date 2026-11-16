namespace FundingAllocation.Infrastructure
{
    using Azure; // for ETag
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using System.Threading;
    using System.Threading.Tasks;

    public interface IContractStorage
    {
        /// <summary>
        /// Stores the contract under the given key. Overwrites if it already exists.
        /// </summary>
        Task<ETag> StoreContract(
            string key,
            ExtendedContractTypeAndIntent extendedContract,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets the contract previously stored under the given key.
        /// </summary>
        Task<ExtendedContractTypeAndIntent> GetContract(
            string key,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Builds a deterministic storage key from number and versions.
        /// </summary>
        string GetKey(string contractNumber, int version, int subVersion);
    }
}
