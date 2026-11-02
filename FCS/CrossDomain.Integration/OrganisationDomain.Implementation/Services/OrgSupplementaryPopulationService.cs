namespace OrganisationDomain.Implementation.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Common;
    using Integration.DataStore.Model;
    using Integration.DataStore.Repositories;
    using Integration.Entities;
    using MoreLinq;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class OrgSupplementaryPopulationService : IOrgSupplementaryPopulationService
    {
        private readonly ILogger _logger;
        private readonly IOrgSupplementaryDataService _orgSupplementaryDataService;
        private readonly IOrganisationRepository _organisationRepository;

        public OrgSupplementaryPopulationService(
            ILogger logger,
            IOrgSupplementaryDataService orgSupplementaryDataService,
            IOrganisationRepository organisationRepository)
        {
            _logger = logger;
            _orgSupplementaryDataService = orgSupplementaryDataService;
            _organisationRepository = organisationRepository;
        }


        public async Task<IReadOnlyCollection<OrgSupplementaryDataExtended>> PopulateOrgSupplementaryData(
            IReadOnlyCollection<int> unsuccessfulUkprns)
        {
            var orgsToPopulate = _organisationRepository.GetOrganisations(unsuccessfulUkprns);

            var tasks = orgsToPopulate.Select(async o => new
            {
                Org = o,
                SupplementaryData = await GetSupplementaryData(o.Ukprn)
            });

            var results = await Task.WhenAll(tasks);

            var finalResult = results
                .Where(s => s.SupplementaryData.IsSuccessful)
                .Select(
                    orgAndData =>
                    {
                        orgAndData.Org.CompanyRegistrationNumber = orgAndData.SupplementaryData.CompanyRegNumber;
                        orgAndData.Org.CharityNumber = orgAndData.SupplementaryData.CharityNumber;
                        orgAndData.Org.HasUkrlpBeenCalledSuccessfully = true;
                        orgAndData.Org.Address = new Address
                        {
                            Line1 = orgAndData.SupplementaryData.LegalAddress.Line1,
                            Line2 = orgAndData.SupplementaryData.LegalAddress.Line2,
                            Line3 = orgAndData.SupplementaryData.LegalAddress.Line3,
                            Line4 = orgAndData.SupplementaryData.LegalAddress.Line4,
                            Town = orgAndData.SupplementaryData.LegalAddress.Town,
                            County = orgAndData.SupplementaryData.LegalAddress.County,
                            Postcode = orgAndData.SupplementaryData.LegalAddress.Postcode
                        };

                        _logger.LogInformation(OrganisationDomainEventLoggingId.PopulationServiceUpdatingOrganisation,
                            $"Org Supplementary Data Population Service is updating Organisation, UKPRN: {orgAndData.Org.Ukprn}, " +
                            $"Company Number {orgAndData.Org.CompanyRegistrationNumber}, Charity Number {orgAndData.Org.CharityNumber}, " +
                            $"Trading Name {orgAndData.Org.TradingName}");

                        return
                            new OrgSupplementaryDataExtended(
                                ukprn: orgAndData.Org.Ukprn,
                                companyNumber: orgAndData.Org.CompanyRegistrationNumber,
                                charityNumber: orgAndData.Org.CharityNumber,
                                tradingName: orgAndData.Org.TradingName,
                                address: new OrgSupplementaryAddress
                                {
                                    Line1 = orgAndData.Org.Address.Line1,
                                    Line2 = orgAndData.Org.Address.Line2,
                                    Line3 = orgAndData.Org.Address.Line3,
                                    Line4 = orgAndData.Org.Address.Line4,
                                    Town = orgAndData.Org.Address.Town,
                                    County = orgAndData.Org.Address.County,
                                    Postcode = orgAndData.Org.Address.Postcode
                                });
                    }).ToList();

            _organisationRepository.SaveChanges();

            return finalResult;
        }

        private async Task<OrgSupplementaryDataServiceResult> GetSupplementaryData(int ukprn)
        {
            return await _orgSupplementaryDataService.GetDataForUkprn(ukprn);
        }
    }
}
