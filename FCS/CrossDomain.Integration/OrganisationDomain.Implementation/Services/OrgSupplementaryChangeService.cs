namespace OrganisationDomain.Implementation.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using Common;
    using Extensions;
    using Integration.DataStore.Model;
    using Integration.DataStore.Repositories;
    using Integration.Entities;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class OrgSupplementaryChangeService : IOrgSupplementaryChangeService
    {
        private readonly ILogger _logger;
        private readonly IOrganisationRepository _organisationRepository;

        public OrgSupplementaryChangeService(ILogger logger, IOrganisationRepository organisationRepository)
        {
            _logger = logger;
            _organisationRepository = organisationRepository;
        }

        public IReadOnlyCollection<OrgChangedData> ChangeOrgSupplementaryData(
            IReadOnlyCollection<OrgSupplementaryData> supplementaryDataChanges)
        {
            IReadOnlyCollection<Organisation> orgsToEvaluateForChange = 
                _organisationRepository.GetOrganisations(supplementaryDataChanges.Select(u => u.Ukprn).ToList());

            Dictionary<int, Organisation> orgDbDictionary = orgsToEvaluateForChange.ToDictionary(o => o.Ukprn);

            var orgChangeDataList = supplementaryDataChanges
                 .Where(sdc => orgDbDictionary.ContainsKey(sdc.Ukprn))
                 .Select(supPresentInOrgDb =>
            {
                Organisation orgInDb = orgDbDictionary[supPresentInOrgDb.Ukprn];
                if (!OrgChangeDataComparer.AreObjectContentsTheSame(supPresentInOrgDb, orgInDb))
                {
                    OrgSupplementaryData orgSupplementaryData = new OrgSupplementaryData(supPresentInOrgDb.Ukprn,
                        supPresentInOrgDb.CompanyNumber, supPresentInOrgDb.CharityNumber, supPresentInOrgDb.LegalAddress);

                    OrgChangedData orgChangedData = new OrgChangedData(orgSupplementaryData: orgSupplementaryData,
                        notificationMessages: OrgChangeDataComparer.GetNotificationMessages(orgSupplementaryData, orgInDb));

                    orgInDb.CompanyRegistrationNumber = supPresentInOrgDb.CompanyNumber;
                    orgInDb.CharityNumber = supPresentInOrgDb.CharityNumber;
                    orgInDb.HasUkrlpBeenCalledSuccessfully = true;
                    orgInDb.Address = supPresentInOrgDb.LegalAddress.ToDbAddress();

                    _logger.LogInformation(OrganisationDomainEventLoggingId.ChangeServiceUpdatingOrganisation,
                        $"Org Supplementary Data Change Service is updating Organisation, UKPRN: {orgInDb.Ukprn}, " +
                        $"Company Number {orgInDb.CompanyRegistrationNumber}, Charity Number {orgInDb.CharityNumber}");

                    return orgChangedData;
                }

                return null;
            }).ToList();

            _organisationRepository.SaveChanges();

            return orgChangeDataList.Where(c => c != null).ToList();
        }
    }
}