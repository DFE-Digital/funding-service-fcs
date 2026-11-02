namespace OrganisationDomain.Integration.DataStore.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Model;

    public interface IOrganisationRepository
    {
        IReadOnlyCollection<int> GetUkprnsForOrgsWithNoUkrlpData();

        IReadOnlyCollection<Organisation> GetOrganisations(IReadOnlyCollection<int> ukprns);

        Task<int> GetNumberOfProvidersNotYetBeenRetrievedFromUkrlp();

        void SaveChanges();
    }
}