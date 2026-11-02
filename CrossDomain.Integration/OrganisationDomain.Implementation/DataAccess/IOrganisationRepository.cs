namespace OrganisationDomain.Implementation.DataAccess
{
using System.Collections.Generic;
    using Integration.DataStore.Model;
    using Integration.Entities;

    public interface IOrganisationRepository
    {
        List<ProviderSequence> GetFctProviderSummary();

        Organisation GetDetailByUkprn(int ukprn);

        Organisation GetDetailByOrgId(string orgId);

        void CreateOrganisation(Organisation organisationToCreate);

        void UpdateOrganisation(Organisation organisationToUpdate);
    }
}
