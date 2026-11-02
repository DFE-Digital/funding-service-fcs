namespace ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.Services
{
    using DTOs;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using Repositories;
    using System.Threading.Tasks;

    public class RoatpRepositoryService : IRoatpRepositoryService
    {
        private readonly IRoatpProviderRepository _roatpProviderRepository;
        private static readonly string[] ValidProviderTypes = { "MainProvider", "EmployerProvider" };

        public RoatpRepositoryService(IRoatpProviderRepository roatpProviderRepository)
        {
            _roatpProviderRepository = roatpProviderRepository;
        }

        public async Task PopulateValidUkprnsFromRoatp(IReadOnlyCollection<RoatpProvider> allProviders, ConnectionInfo connectionInfo)
        {
            IEnumerable<string> validUkprns = allProviders.Where(HasValidType).Select(rp => rp.Ukprn);
            await _roatpProviderRepository.ReplaceRoatpCache(validUkprns, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);
        }

        private static bool HasValidType(RoatpProvider provider)
        {
            return ValidProviderTypes.Contains(provider.ApplicationType);
        }
    }
}