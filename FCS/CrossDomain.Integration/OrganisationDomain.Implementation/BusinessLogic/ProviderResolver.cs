namespace OrganisationDomain.Implementation.BusinessLogic
{
    using System.Data.Entity.Infrastructure;
    using System.Linq;
    using System.Threading.Tasks;
    using System.Xml.Linq;
    using Common;
    using DataAccess;
    using Integration.DataStore.Model;
    using Mappers;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ProviderResolver : IProviderResolver
    {
        public ICpdsMapper Mapper { get; set; }

        private ICpdsOrganisationRetriever _cpdsOrganisationRetriever;

        public ProviderResolver(ICpdsOrganisationRetriever cpdsOrganisationRetriever)
        {
            _cpdsOrganisationRetriever = cpdsOrganisationRetriever;
        }

        public IOrganisationRepository Repository { get; set; }

        public ICpdsOrganisationRetriever OrganisationRetriever => _cpdsOrganisationRetriever;

        public ILogger Logger { get; set; }

        public IOrgSupplementaryDataService OrgSupplementaryDataService { get; set; }

        public async Task<organisation> GetByUkprn(int ukprn)
        {
            Logger.LogInformation(OrganisationDomainEventLoggingId.GetOrganisationHandlerMessageReceived, $"Entered GetByUkprn {ukprn}, OrganisationRetriever: {OrganisationRetriever}, Repository: {Repository}");

            var orgDbEntity = Repository.GetDetailByUkprn(ukprn);
            if (orgDbEntity == null)
            {
                Logger.LogInformation(OrganisationDomainEventLoggingId.GetOrganisationHandlerMessageReceived, $"Not found org in rep {ukprn}, OrganisationRetriever: {OrganisationRetriever} ");
                XNamespace ns = "http://xpims.lsc.gov.uk/ProviderDataSetV2";

                // get org from CPDS (async), if org does not exist in CPDS return null instead of organisation
                XDocument provider = OrganisationRetriever.GetProviderByUkprn(ukprn);


                if (provider?.Root?.Elements(ns + "Provider").FirstOrDefault() == null)
                {
                    return null;
                }

                // update database. 
                orgDbEntity = Mapper.MapProviderXmlToDbEntity(provider);

                await UpdateOrgWithSupplementaryData(orgDbEntity, ukprn);

                try
                {
                    Repository.CreateOrganisation(orgDbEntity);
                }
                catch (DbUpdateException ex)
                {
                    if (ex.InnerException != null && (ex.InnerException.InnerException.Message.Contains("Cannot insert duplicate key")
                                                      && ex.InnerException.InnerException.Message.Contains("IX_Ukprn")))
                    {
                        orgDbEntity = Repository.GetDetailByUkprn(ukprn);
                    }
                    else
                    {
                        throw;
                    }
                }
            }

            // get additional org info from any other external sources (async), ignore not found responses
            // consolidate org info (CPDS and other external sources)
            var org = Mapper.MapDbEntityToCorpSchema(orgDbEntity);
            Logger.LogInformation(OrganisationDomainEventLoggingId.GetOrganisationHandlerMessageReceived, $" created org {ukprn}");

            return org;
        }

        private async Task UpdateOrgWithSupplementaryData(Organisation orgDbEntity, int ukprn)
        {
            OrgSupplementaryDataServiceResult orgSupplementaryDataServiceResult = await OrgSupplementaryDataService.GetDataForUkprn(ukprn);
          
            if (orgSupplementaryDataServiceResult.IsSuccessful)
            {
                orgDbEntity.CompanyRegistrationNumber = orgSupplementaryDataServiceResult.CompanyRegNumber;
                orgDbEntity.CharityNumber = orgSupplementaryDataServiceResult.CharityNumber;
                orgDbEntity.HasUkrlpBeenCalledSuccessfully = true;
                orgDbEntity.Address = new Address
                {
                    Line1 = orgSupplementaryDataServiceResult.LegalAddress.Line1,
                    Line2 = orgSupplementaryDataServiceResult.LegalAddress.Line2,
                    Line3 = orgSupplementaryDataServiceResult.LegalAddress.Line3,
                    Line4 = orgSupplementaryDataServiceResult.LegalAddress.Line4,
                    Town = orgSupplementaryDataServiceResult.LegalAddress.Town,
                    County = orgSupplementaryDataServiceResult.LegalAddress.County,
                    Postcode = orgSupplementaryDataServiceResult.LegalAddress.Postcode
                };
            }
        }

        public organisation GetByOrgId(string orgId)
        {
            var orgDbEntity = Repository.GetDetailByOrgId(orgId);
            return orgDbEntity == null ? null : Mapper.MapDbEntityToCorpSchema(orgDbEntity);
        }
    }
}
