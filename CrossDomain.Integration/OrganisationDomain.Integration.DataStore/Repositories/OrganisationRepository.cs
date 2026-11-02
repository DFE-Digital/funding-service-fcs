namespace OrganisationDomain.Integration.DataStore.Repositories
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using System.Threading.Tasks;
    using Model;

    public class OrganisationRepository : IOrganisationRepository
    {
        private readonly IOrganisationDomainDbContext _organisationDomainDbContext;

        public OrganisationRepository(IOrganisationDomainDbContext organisationDomainDbContext)
        {
            _organisationDomainDbContext = organisationDomainDbContext;
        }

        public IReadOnlyCollection<int> GetUkprnsForOrgsWithNoUkrlpData()
        {
            return _organisationDomainDbContext.Organisations
                                               .Where(o => !o.HasUkrlpBeenCalledSuccessfully)
                                               .Select(o => o.Ukprn)
                                               .ToList();
        }

        public IReadOnlyCollection<Organisation> GetOrganisations(IReadOnlyCollection<int> ukprns)
        {
            return _organisationDomainDbContext.Organisations.Where(o => ukprns.Contains(o.Ukprn)).ToList();
        }

        public async Task<int> GetNumberOfProvidersNotYetBeenRetrievedFromUkrlp()
        {
            return await 
                _organisationDomainDbContext
                .Organisations
                .CountAsync(o => !o.HasUkrlpBeenCalledSuccessfully)
                .ConfigureAwait(false);
        }

        public void SaveChanges()
        {
            _organisationDomainDbContext.SaveChanges();
        }

        public override string ToString()
        {
            return (_organisationDomainDbContext as OrganisationDomainDbContext).Database.Connection.ConnectionString;
        }
    }
}