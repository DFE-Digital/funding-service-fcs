namespace XrmTestModel.XrmObjects
{
    using System;
    using System.Linq;
    using System.Linq.Expressions;
    using DomainObjects;
    using Extensions;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class XrmFundingStreamPeriod : FundingStreamPeriod, IUseXrmEntity<sfa_fundingstreamperiod>, IUseXrmService
    {
        public sfa_fundingstreamperiod Entity { get; set; }

        public Guid? EntityId { get; set; }

        public string EntityLogicalName { get; set; }

        public IXrmServiceFactory OrgServiceFactory { get; set; }

        public IOrganizationService OrgService { get; set; }

          private XrmFundingStreamPeriod()
        {
            Entity = new sfa_fundingstreamperiod();
            EntityLogicalName = sfa_fundingstreamperiod.EntityLogicalName;
        } 

        public XrmFundingStreamPeriod(IXrmServiceFactory orgServiceFactory) : this()
        {
            OrgServiceFactory = orgServiceFactory;
            OrgService = OrgServiceFactory.Create();
        }

        public XrmFundingStreamPeriod(sfa_fundingstreamperiod fspEntity)
            : this()
        {
            EntityId = fspEntity.Id;
            Entity = fspEntity;
        }

        public IUseXrmEntity<sfa_fundingstreamperiod> Get()
        {
            return Get(f => f.sfa_FundingStreamCodeId.Id == EntityId);
        }

        public IUseXrmEntity<sfa_fundingstreamperiod> Get(Guid primaryKey)
        {
            return Get(f => f.sfa_FundingStreamCodeId.Id == primaryKey);
        }

        public IUseXrmEntity<sfa_fundingstreamperiod> Get(string primaryFieldName)
        {
            return Get(f => f.sfa_fundingstreamperiodcode == primaryFieldName);
        }

        public IUseXrmEntity<sfa_fundingstreamperiod> Get(Expression<Func<sfa_fundingstreamperiod, bool>> predicate)
        {
            using (var xrmSvcContext = new XrmServiceContext(OrgService))
            {
                var xrmfundingStreamPeriod = xrmSvcContext.sfa_fundingstreamperiodSet.Where(predicate).Single();

                if (EntityId == null)
                {
                    EntityId = xrmfundingStreamPeriod.Id;
                }

                TranslateFromXrm(xrmfundingStreamPeriod);

                Entity = xrmfundingStreamPeriod;

            }

            return this;
        }

        public void Save(object parentGuid = null)
        {
            this.SaveEntity(OrgService);
        }

        public void TranslateFromXrm(sfa_fundingstreamperiod xrmEntity)
        {
            Code = xrmEntity.sfa_fundingstreamperiodcode;
            FundingStream = xrmEntity.sfa_FundingStreamCodeId != null ? xrmEntity.sfa_FundingStreamCodeId.Id : Guid.Empty;
        }

        public void TranslateToXrm()
        {
            Entity.sfa_fundingstreamperiodcode = Code;

            if (FundingStream.HasValue)
            {
                Entity.sfa_FundingStreamCodeId = new EntityReference("sfa_fundingstream", FundingStream.Value);
            }
        }

        public void Delete()
        {
            this.DeleteEntity(OrgService);
        }

       
    }
}
