namespace ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.Repositories
{
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System.Threading.Tasks;


    public interface IRoatpProviderRepository
    {
        Task ReplaceRoatpCache(IEnumerable<string> providersOnRoatp, ConnectionInfo connectionInfo);

        Task<bool> IsProviderOnRoatp(string ukprn, ConnectionInfo connectionInfo);
    }
}