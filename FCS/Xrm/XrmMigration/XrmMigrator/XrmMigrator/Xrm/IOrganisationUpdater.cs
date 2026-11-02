namespace XrmMigrator.Xrm
{
    using Microsoft.Xrm.Sdk;

    internal interface IOrganisationUpdater
    {
        IOrganizationService OrgSvc { get; set; }

        void UpdateOrganisations();

       // IEnumerable<OrganisationDto> GetOrganisationsWithNoOrgId();


    }
}
