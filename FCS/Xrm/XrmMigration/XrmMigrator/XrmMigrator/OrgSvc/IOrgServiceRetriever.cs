namespace XrmMigrator.OrgSvc
{
    using System.Collections.Generic;
    using Common.Entities;

    internal interface IOrgServiceRetriever
    {
        IEnumerable<OrganisationDto> GetOrganisationIds(IEnumerable<OrganisationDto> ukprns);
    }
}
