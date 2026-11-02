namespace XrmMigrator.OrgSvc
{
    using System.Collections.Generic;
    using Common.Entities;

    public class OrgServiceRetriever:IOrgServiceRetriever
    {
        public ILog Logger { get; set; }
        public IEnumerable<OrganisationDto> GetOrganisationIds(IEnumerable<OrganisationDto> organisations)
        {
            var organisationService = new OrganisationService();

            foreach (var organisation in organisations)
            {
               Logger.Log("Retrieving organisation Id for {0} Ukprn.", organisation.UkPrn);
               organisation.OrganisationId= organisationService.OrganisationIdForUkprn(int.Parse(organisation.UkPrn));
            }
            return organisations;
        }
    }
}
