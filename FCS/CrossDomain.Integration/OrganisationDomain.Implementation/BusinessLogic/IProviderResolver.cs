namespace OrganisationDomain.Implementation.BusinessLogic
{
    using DataAccess;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using System.Threading.Tasks;

    public interface IProviderResolver
    {
        ICpdsOrganisationRetriever OrganisationRetriever { get;}

        IOrganisationRepository Repository { get; set; }

        Task<organisation> GetByUkprn(int ukprn);

        organisation GetByOrgId(string orgId);
    }
}
