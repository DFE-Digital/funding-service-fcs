namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Repositories
{
    using DataStore.Models;
    using Optional;

    public interface IContractReferenceConfigRepository
    {
        Option<ContractReferenceConfig> GetContractReferenceConfig(int ukprn, string fundingStreamPeriodCode);
    }
}
