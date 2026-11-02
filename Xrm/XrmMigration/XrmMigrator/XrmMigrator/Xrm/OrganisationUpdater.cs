namespace XrmMigrator.Xrm
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Common.Entities;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using OrgSvc;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class OrganisationUpdater : IOrganisationUpdater
    {
        public IOrganizationService OrgSvc { get; set; }
        public ILog Logger { get; set; }

        private IOrgServiceRetriever _orgSvcManager;


        public OrganisationUpdater()
        {
            OrgSvc = new OrganizationService(CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString));
        }

        private IEnumerable<OrganisationDto> GetOrganisationsWithNoOrgId()
        {
            using (var context = new XrmServiceContext(OrgSvc))
            {
                var orgs = from a in context.AccountSet
                           where (a.sfa_OrganisationID == null || a.sfa_OrganisationID == "0") && a.sfa_UKPRN != null
                           select new OrganisationDto
                           {
                               OrganisationCrmId = a.AccountId,
                               UkPrn = a.sfa_UKPRN
                           };

                return orgs.ToList();
            }
        }

        public void UpdateOrganisations()
        {
            _orgSvcManager = new OrgServiceRetriever(){Logger = Logger};

            var organisations = GetOrganisationsWithNoOrgId();
            Logger.Log( "# {0} organisations to be updated", organisations.Count());

            Logger.Log("Retrieving Organistaion Ids");
            var result = _orgSvcManager.GetOrganisationIds(organisations);
            Logger.Log( "Retrieved Organistaion Ids");

            using (var context = new XrmServiceContext(OrgSvc))
            {
                foreach (var orgToUpdate in result)
                {
                    var organisation = new Account()
                    {
                        AccountId = orgToUpdate.OrganisationCrmId.Value,
                        Id = orgToUpdate.OrganisationCrmId.Value,
                        sfa_OrganisationID = orgToUpdate.OrganisationId,

                    };

                    context.Attach(organisation);
                    context.UpdateObject(organisation);
                    context.SaveChanges();
                    context.Detach(organisation);

                    Logger.Log("For organisation {0} with Ukprn {1} Organisation Id is {2}", orgToUpdate.OrganisationCrmId,
                  orgToUpdate.UkPrn,
                  orgToUpdate.OrganisationId);
                }
                Logger.Log("Updated Organisation Ids in CRM");
            }

            //foreach (var item in result)
            //{
            //    Logger.Log("For organisation {2} with Ukprn {0} Organisation Id is {1}", item.UkPrn,
            //        item.OrganisationId,
            //        item.OrganisationCrmId);
            //}
        }
    }
}
