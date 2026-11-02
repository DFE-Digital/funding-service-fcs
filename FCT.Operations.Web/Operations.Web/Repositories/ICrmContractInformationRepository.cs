namespace Operations.Web.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dtos;

    public interface ICrmContractInformationRepository
    {
        IReadOnlyCollection<ContractInformation> GetLatestContractInformationByFundingTypeAndFundingPeriod(
            string fundingTypeCode, string fundingPeriodCode);

        Task<bool> CleanupContractData(IReadOnlyCollection<ContractCleanup> contractData);
    }
}