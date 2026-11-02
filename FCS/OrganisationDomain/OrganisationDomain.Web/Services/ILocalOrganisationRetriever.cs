namespace OrganisationDomain.Web.Services
{
    using SFA.FCT.CrossDomain.Integration.Entities;

    public interface ILocalOrganisationRetriever
    {
        organisation GetOrganisationFromLocalDb(int ukprn);
    }
}