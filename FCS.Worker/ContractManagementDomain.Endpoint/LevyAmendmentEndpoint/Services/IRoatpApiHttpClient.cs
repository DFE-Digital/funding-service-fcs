namespace ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.Services
{
    using DTOs;
    using System.Collections.Generic;
    using System.Threading.Tasks;

    public interface IRoatpApiHttpClient
    {
        Task<IReadOnlyCollection<RoatpProvider>> GetAllProviders();
    }
}