namespace Operations.Web.Controllers
{
    using System.Threading.Tasks;
    using System.Web.Http;
    using Repositories;
    using Dtos;
    using LanguageExt;

    [RoutePrefix("fcs-organisation")]
    public class OrganisationController : ApiController
    {
        private readonly IOrganisationRepository _organisationRepository;

        public OrganisationController(IOrganisationRepository organisationRepository)
        {
            _organisationRepository = organisationRepository;
        }

        [HttpGet, Route("{id}")]
        public async Task<IHttpActionResult> GetOrganisationInfo([FromUri]string id)
        {
            Option<OrganisationInfo> organisationInfo = await _organisationRepository.GetOrganisationInfo(id).ConfigureAwait(false);

            IHttpActionResult result = organisationInfo.Match(
                Some: Ok,
                None: () => (IHttpActionResult)NotFound());

            return result;
        }
    }
}