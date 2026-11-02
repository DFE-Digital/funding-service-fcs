namespace OrganisationDomain.Implementation.DataAccess
{
    using System.Collections.Generic;
    using System.Linq;
    using Integration.DataStore;
    using Integration.DataStore.Model;
    using Integration.Entities;

    public class OrganisationRepository : IOrganisationRepository
{
        public IOrganisationDomainDbContext OrganisationDomainDbContext { get; set; }

        public List<ProviderSequence> GetFctProviderSummary()
        {
            var query = from org in OrganisationDomainDbContext.Organisations
                select new ProviderSequence
                {
                    Ukprn = org.Ukprn,
                    Upin = org.Upin,
                    SequenceNumber = org.SequenceNumber,
                };
            return query.ToList();
        }

        public Organisation GetDetailByUkprn(int ukprn)
        {
            return OrganisationDomainDbContext.Organisations.SingleOrDefault(x => x.Ukprn == ukprn);
        }
            
        public Organisation GetDetailByOrgId(string orgId)
        {
            int? organisationId = Organisation.ParseOrganisationId(orgId);
            if (null == organisationId)
            {
                return null;
            }

            return OrganisationDomainDbContext.Organisations.SingleOrDefault(x => x.OrganisationId == organisationId);
        }

        public void CreateOrganisation(Organisation organisationToCreate)
        {
            OrganisationDomainDbContext.Organisations.Add(organisationToCreate);
            OrganisationDomainDbContext.SaveChanges();
        }

        public void UpdateOrganisation(Organisation organisationToUpdate)
        {
            var org = OrganisationDomainDbContext.Organisations.Single(x => x.Ukprn.Equals(organisationToUpdate.Ukprn));

            if (!org.TradingName.Equals(organisationToUpdate.TradingName))
            {
                org.TradingName = organisationToUpdate.TradingName;
            }

            org.SequenceNumber = organisationToUpdate.SequenceNumber;
            org.Status = organisationToUpdate.Status;
            org.Type = organisationToUpdate.Type;

            OrganisationDomainDbContext.SaveChanges();

            //// populate OrganisationId for future mapping
            organisationToUpdate.OrganisationId = org.OrganisationId;
        }
    }
}
