namespace XrmTestModel
{
    using System;
    using System.Linq;
    using System.Linq.Expressions;
    using Extensions;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class XrmSubnominalAggregation : SubnominalAggregation, IUseXrmEntity<sfa_subnominalaggregation>, IUseXrmService
    {
        public sfa_subnominalaggregation Entity { get; set; }

        public Guid? EntityId { get; set; }

        public string EntityLogicalName { get; set; }

        public IXrmServiceFactory OrgServiceFactory { get; set; }

        public IOrganizationService OrgService { get; set; }

       public XrmSubnominalAggregation()
        {
            Entity = new sfa_subnominalaggregation();
            EntityLogicalName = sfa_subnominalaggregation.EntityLogicalName;
        }

       public XrmSubnominalAggregation(IXrmServiceFactory orgServiceFactory)
            : this()
        {
            OrgServiceFactory = orgServiceFactory;
            OrgService = OrgServiceFactory.Create();
        }

        public IUseXrmEntity<sfa_subnominalaggregation> Get()
        {
            return Get(s => s.sfa_subnominalaggregationId == EntityId.Value);
        }

        public IUseXrmEntity<sfa_subnominalaggregation> Get(Guid primaryKey)
        {
            return Get(s => s.sfa_subnominalaggregationId == primaryKey);
        }

        public IUseXrmEntity<sfa_subnominalaggregation> Get(string primaryFieldName)
        {
            return Get(c => c.sfa_name == primaryFieldName);
        }

        public IUseXrmEntity<sfa_subnominalaggregation> Get(Expression<Func<sfa_subnominalaggregation, bool>> predicate)
        {
            using (var xrmSvcContext = new XrmServiceContext(OrgService))
            {
                var xrmSubnominalaggregation = xrmSvcContext.sfa_subnominalaggregationSet.Where(predicate).Single();

                if (EntityId == null)
                {
                    EntityId = xrmSubnominalaggregation.Id;
                }

                TranslateFromXrm(xrmSubnominalaggregation);

                Entity = xrmSubnominalaggregation;

            }

            return this;
        }

        public void Save(object parentGuid = null)
        {
            this.SaveEntity(OrgService);
        }

        public void TranslateFromXrm(sfa_subnominalaggregation xrmEntity)
        {
            SubnominalCode = xrmEntity.sfa_SubnominalCode;
            SubnominalAggregateKey = xrmEntity.sfa_SubnominalAggregateKey;
        }

        public void TranslateToXrm()
        {
            Entity.sfa_SubnominalCode = SubnominalCode;
            Entity.sfa_name = SubnominalCode;
            Entity.sfa_SubnominalAggregateKey = SubnominalAggregateKey;
        }

        public void Delete()
        {
            this.DeleteEntity(OrgService);
        }


    }
}
