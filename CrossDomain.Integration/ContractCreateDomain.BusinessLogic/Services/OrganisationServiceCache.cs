namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Services
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities;

    public class OrganisationServiceCache
    {
        private readonly Dictionary<int, organisation> _organisations;
        private readonly IOrganisationService _organisationService;

        public OrganisationServiceCache(IOrganisationService organisationService)
        {
            _organisationService = organisationService;
            _organisations = new Dictionary<int, organisation>();
        }

        public organisation GetOrganisationForUkprn(int ukprn)
        {
            if (!_organisations.ContainsKey(ukprn))
            {
                organisation org = _organisationService.GetOrganisationForUkprn(ukprn);
                _organisations.Add(ukprn, org);

                return org;
            }

            return _organisations[ukprn];
        }
    }
}
