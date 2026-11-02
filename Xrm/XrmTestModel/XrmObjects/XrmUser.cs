namespace XrmTestModel
{
    using System;
    using System.Linq;
    using System.Linq.Expressions;
    using Extensions;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class XrmUser : User, IUseXrmEntity<SystemUser>, IUseXrmService
    {
        public SystemUser Entity { get; set; }

        public Guid? EntityId { get; set; }

        public string EntityLogicalName { get; set; }

        public IXrmServiceFactory OrgServiceFactory { get; set; }

        public IOrganizationService OrgService { get; set; }

        public override User Manager
        {
            get { return new XrmUser(OrgServiceFactory).Get(Entity.sfa_Manager.Id) as XrmUser; }
            set
            {
                base.Manager = value;
                Entity.sfa_Manager = ((XrmUser) Manager).GetEntityReference();
            }
        }

        public XrmUser()
        {
            Entity = new SystemUser();
            EntityLogicalName = SystemUser.EntityLogicalName;
        }

        public XrmUser(IXrmServiceFactory orgServiceFactory)
            : this()
        {
            OrgServiceFactory = orgServiceFactory;
            OrgService = OrgServiceFactory.Create();
        }

        public IUseXrmEntity<SystemUser> Get()
        {
            return Get(s => s.SystemUserId == EntityId.Value);
        }

        public IUseXrmEntity<SystemUser> Get(Guid primaryKey)
        {
            return Get(s => s.SystemUserId == primaryKey);
        }

        public IUseXrmEntity<SystemUser> Get(string primaryFieldName)
        {
            return Get(s => s.DomainName == primaryFieldName);
        }

        public IUseXrmEntity<SystemUser> Get(Expression<Func<SystemUser, bool>> predicate)
        {
            using (var xrmSvcContext = new XrmServiceContext(OrgService))
            {
                var xrmUser = xrmSvcContext.SystemUserSet.Where(predicate).Single();

                if (EntityId == null)
                {
                    EntityId = xrmUser.Id;
                }

                TranslateFromXrm(xrmUser);

                Entity = xrmUser;
            }

            return this;
        }

        public void Save(object parentGuid = null)
        {
            this.SaveEntity(OrgService);
        }

        public void TranslateFromXrm(SystemUser xrmEntity)
        {
            FirstName = xrmEntity.FirstName;
            LastName = xrmEntity.LastName;
            Email = xrmEntity.InternalEMailAddress;
            Logon = xrmEntity.DomainName;
        }

        public void TranslateToXrm()
        {
            Entity.FirstName = FirstName;
            Entity.LastName = LastName;
            Entity.InternalEMailAddress = Email;
            Entity.DomainName = Logon;
            Entity.sfa_Manager = ((XrmUser) Manager).GetEntityReference();
        }

        public void Delete()
        {
            this.DeleteEntity(OrgService);
        }
    }
}
