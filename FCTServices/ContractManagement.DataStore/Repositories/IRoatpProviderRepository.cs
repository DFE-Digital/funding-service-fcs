namespace ContractManagement.DataStore.Repositories
{
    using System.Collections.Generic;

    public interface IRoatpProviderRepository
    {
        void ReplaceRoatpCache(IEnumerable<string> providersOnRoatp);

        bool IsProviderOnRoatp(string ukprn);
    }
}