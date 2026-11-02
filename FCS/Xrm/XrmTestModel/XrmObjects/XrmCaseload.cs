namespace XrmTestModel
{
    using System;
    using System.Linq;
    using System.Linq.Expressions;
    using Extensions;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class XrmCaseload : Caseload, IUseXrmEntity<sfa_caseload>, IUseXrmService
    {
        public sfa_caseload Entity { get; set; }

        public Guid? EntityId { get; set; }

        public string EntityLogicalName { get; set; }

        public IXrmServiceFactory OrgServiceFactory { get; set; }

        public IOrganizationService OrgService { get; set; }

        public override Organisation Organisation
        {
            get
            {
                if (base.Organisation == null)
                {
                    base.Organisation =
                        new XrmOrganisation(OrgServiceFactory).Get(Entity.sfa_OrganisationId.Id) as Organisation;
                }
                return base.Organisation;
            }
            set
            {
                base.Organisation = value;
            }
        }

        public XrmCaseload()
        {
            Entity = new sfa_caseload();
            EntityLogicalName = sfa_caseload.EntityLogicalName;
        }

        public XrmCaseload(IXrmServiceFactory orgServiceFactory)
            : this()
        {
            OrgServiceFactory = orgServiceFactory;
            OrgService = OrgServiceFactory.Create();
        }

        public IUseXrmEntity<sfa_caseload> Get()
        {
            return Get(c => c.sfa_caseloadId == EntityId.Value);
        }

        public IUseXrmEntity<sfa_caseload> Get(Guid primaryKey)
        {
            return Get(c => c.sfa_caseloadId == primaryKey);
        }

        public IUseXrmEntity<sfa_caseload> Get(string primaryFieldName)
        {
            return Get(c => c.sfa_UKPRN == primaryFieldName);
        }

        public IUseXrmEntity<sfa_caseload> Get(Expression<Func<sfa_caseload, bool>> predicate)
        {
            using (var xrmSvcContext = new XrmServiceContext(OrgService))
            {
                var xrmCaseload = xrmSvcContext.sfa_caseloadSet.Where(predicate).Single();

                if (EntityId == null)
                {
                    EntityId = xrmCaseload.Id;
                }

                TranslateFromXrm(xrmCaseload);

                Entity = xrmCaseload;

            }

            return this;
        }

        public void Save(object parentGuid = null)
        {
            this.SaveEntity(OrgService);
        }

        public void TranslateFromXrm(sfa_caseload xrmEntity)
        {


        }

        public void TranslateToXrm()
        {
            Entity.sfa_OrganisationId = ((XrmOrganisation) Organisation).GetEntityReference();
        }

        public void Delete()
        {
            this.DeleteEntity(OrgService);
        }

        
    }
}
