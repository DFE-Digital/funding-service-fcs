namespace SFA.FCT.DocumentsDomain.DataStore.Repositories
{
    using Models;
    using Optional;

    public interface INlapFundingConfigRepository
    {
        Option<NlapFundingConfig> FindByUkprn(int ukprn);
    }
}
