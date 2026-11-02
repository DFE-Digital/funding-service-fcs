namespace Operations.Web.Repositories
{
    using System.Threading.Tasks;
    using Dtos;
    using LanguageExt;

    public interface IOrganisationRepository
    { 
        Task<Option<OrganisationInfo>> GetOrganisationInfo(string ukprn);
    }
}