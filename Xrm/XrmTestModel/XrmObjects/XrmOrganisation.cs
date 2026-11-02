namespace XrmTestModel
{
    using System;
    using System.Linq;
    using System.Linq.Expressions;
    using Extensions;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class XrmOrganisation : Organisation, IUseXrmEntity<Account>, IUseXrmService
    {
        public Guid? EntityId { get; set; }

        public Account Entity { get; set; }

        public string EntityLogicalName { get; set; }

        public IXrmServiceFactory OrgServiceFactory { get; set; }

        public IOrganizationService OrgService { get; set; }

        public XrmOrganisation()
        {
            Entity = new Account();
            EntityLogicalName = Account.EntityLogicalName;
        }

        public XrmOrganisation(IXrmServiceFactory orgServiceFactory) : this()
        {
            OrgServiceFactory = orgServiceFactory;
            OrgService = OrgServiceFactory.Create();
        }

        public IUseXrmEntity<Account> Get()
        {
            return Get(a => a.AccountId == EntityId);
        }

        public IUseXrmEntity<Account> Get(Guid primaryKey)
        {
            return Get(a => a.AccountId == primaryKey);
        }

        public IUseXrmEntity<Account> Get(string primaryFieldName)
        {
            return Get(a => a.sfa_UKPRN == primaryFieldName);
        }

        public IUseXrmEntity<Account> Get(Expression<Func<Account, bool>> predicate)
        {
            using (var xrmSvcContext = new XrmServiceContext(OrgService))
            {
                var xrmOrg = xrmSvcContext.AccountSet.First(predicate);

                if (EntityId == null)
                {
                    EntityId = xrmOrg.Id;
                }

                TranslateFromXrm(xrmOrg);

                Entity = xrmOrg;
            }

            return this;
        }

        public void Save(object parentGuid = null)
        {
            this.SaveEntity(OrgService);
        }

        public void TranslateFromXrm(Account xrmEntity)
        {
            Ukprn = xrmEntity.sfa_UKPRN;
            OrganisationName = xrmEntity.Name;
            OrganisationId = xrmEntity.sfa_OrganisationID;
        }

        public void TranslateToXrm()
        {
            Entity.sfa_UKPRN = Ukprn;
            Entity.Name = OrganisationName;
            Entity.sfa_OrganisationID = OrganisationId;
        }

        public void Delete()
        {
            this.DeleteEntity(OrgService);
        }
    }
}
