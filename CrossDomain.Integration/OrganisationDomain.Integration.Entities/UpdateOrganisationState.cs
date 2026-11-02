namespace OrganisationDomain.Integration.Entities
{
    public enum UpdateOrganisationState
    {
        Started = 0,
        CpdsSummaryLoaded,
        OrgUpdatesProcessed,
        OrgDetailsReceived,
        OrgDetailsProcessed
    }
}
