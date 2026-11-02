namespace ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.Services
{
    using DTOs;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System.Collections.Generic;
    using System.Threading.Tasks;

    public interface IRoatpRepositoryService
    {
        Task PopulateValidUkprnsFromRoatp(IReadOnlyCollection<RoatpProvider> providers, ConnectionInfo connectionInfo);
    }
}