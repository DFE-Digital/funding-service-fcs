namespace OrganisationDomain.Integration.DataStore
{
    using System.Data.Entity;
    using Model;

    public interface IOrganisationDomainDbContext
    {
        IDbSet<Organisation> Organisations { get; set; }

        int SaveChanges();
    }
}
