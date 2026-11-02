namespace OrganisationDomain.Web.Services
{
    using Implementation.DataAccess;
    using Implementation.Mappers;
    using Integration.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities;

    public class LocalOrganisationRetriever : ILocalOrganisationRetriever
    {
        private readonly IOrganisationRepository _organisationRepository;
        private readonly ICpdsMapper _cpdsMapper;

        public LocalOrganisationRetriever(IOrganisationRepository organisationRepository, ICpdsMapper cpdsMapper)
        {
            _organisationRepository = organisationRepository;
            _cpdsMapper = cpdsMapper;
        }

        public organisation GetOrganisationFromLocalDb(int ukprn)
        {
            Organisation organisation = _organisationRepository.GetDetailByUkprn(ukprn);

            if (organisation != null)
            {
                return _cpdsMapper.MapDbEntityToCorpSchema(organisation);
            }

            return null;
        }
    }
}