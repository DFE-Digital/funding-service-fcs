namespace Operations.Web.Repositories
{
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Threading.Tasks;
    using Dapper;
    using Dtos;
    using OrganisationDomain.Integration.DataStore;
    using System.Linq;
    using System.Data.Entity;
    using LanguageExt;

    public class OrganisationRepository : IOrganisationRepository
    {
        public async Task<Option<OrganisationInfo>> GetOrganisationInfo(string ukprn)
        {
            using (var context = new OrganisationDomainDbContext())
            {
                var rows = await context.Organisations.ToListAsync();

                var tradingName = (from res in rows
                                   where res.Ukprn.ToString() == ukprn
                                   select res.TradingName).SingleOrDefault();

                return tradingName != null ? new OrganisationInfo(ukprn, tradingName) : new Option<OrganisationInfo>();

            }          
        }
    }
}