namespace XrmTestModel
{
    using System;
    using System.Linq;
    using System.Linq.Expressions;
    using DomainObjects;
    using Extensions;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using XrmObjects;

    public class XrmContractAllocation : ContractAllocation, IUseXrmEntity<sfa_contractallocation>, IUseXrmService
    {
        public Guid? EntityId { get; set; }

        public sfa_contractallocation Entity { get; set; }

        public string EntityLogicalName { get; set; }

        public IOrganizationService OrgService { get; set; }

        public IXrmServiceFactory OrgServiceFactory { get; set; }

        public override Contract Contract
        {
            get
            {
                if (base.Contract == null)
                {
                    base.Contract = new XrmContract(OrgServiceFactory).Get(Entity.sfa_ContractId.Id) as Contract;
                }
                return base.Contract;
            }
            set
            {
                base.Contract = value;
            }
        }

        public override FundingStreamPeriod FundingStreamPeriod
        {
            get
            {
                if (base.FundingStreamPeriod == null)
                {
                    base.FundingStreamPeriod = new XrmFundingStreamPeriod(OrgServiceFactory).Get(Entity.sfa_ContractId.Id) as FundingStreamPeriod;
                }
                return base.FundingStreamPeriod;
            }
            set
            {
                base.FundingStreamPeriod = value;
            }
        }
        
        private XrmContractAllocation()
        {
            Entity = new sfa_contractallocation();
            EntityLogicalName = sfa_contractallocation.EntityLogicalName;
        } 

        public XrmContractAllocation(IXrmServiceFactory orgServiceFactory) : this()
        {
            OrgServiceFactory = orgServiceFactory;
            OrgService = OrgServiceFactory.Create();
        }
        
        public XrmContractAllocation(sfa_contractallocation allocationEntity) : this()
        {
            EntityId = allocationEntity.Id;
            Entity = allocationEntity;
        }

        public IUseXrmEntity<sfa_contractallocation> Get()
        {
            return Get(a => a.sfa_contractallocationId == EntityId.Value);
        }

        public IUseXrmEntity<sfa_contractallocation> Get(Guid primaryKey)
        {
            return Get(a => a.sfa_contractallocationId == primaryKey);
        }

        public IUseXrmEntity<sfa_contractallocation> Get(string primaryFieldName)
        {
            return Get(a => a.sfa_contractallocationnumber == primaryFieldName);
        }

        public IUseXrmEntity<sfa_contractallocation> Get(Expression<Func<sfa_contractallocation, bool>> predicate)
        {
            using (var xrmSvcContext = new XrmServiceContext(OrgService))
            {
                var xrmAllocation = xrmSvcContext.sfa_contractallocationSet.Where(predicate).Single();

                if (EntityId == null)
                {
                    EntityId = xrmAllocation.Id;
                }

                TranslateFromXrm(xrmAllocation);

                Entity = xrmAllocation;

            }

            return this;
        }

        public void Save(object parentGuid = null)
        {
            this.SaveEntity(OrgService);

            // Save Deliverables
            foreach (var d in Deliverables.IfNotNull().OfType<IUseXrmEntity<sfa_contractdeliverable>>())
            {
                d.Save();
            }
        }

        public void TranslateFromXrm(sfa_contractallocation xrmEntity)
        {
            ContractAllocationRef = xrmEntity.sfa_contractallocationnumber;
            AllocationValue = xrmEntity.sfa_maximumcontractvalue.GetValueOrDefault();
            FundingStream = xrmEntity.sfa_FundingStreamId != null ? xrmEntity.sfa_FundingStreamId.Name : string.Empty;
        }

        public void TranslateToXrm()
        {
            Entity.sfa_ContractId = ((XrmContract)Contract).GetEntityReference();
            var fundingStreamPeriodId = ((XrmFundingStreamPeriod)FundingStreamPeriod);

            Entity.sfa_FundingStreamPeriodId = fundingStreamPeriodId.GetEntityReference();

            if (fundingStreamPeriodId.FundingStream.HasValue)
            {
                Entity.sfa_FundingStreamId = new EntityReference("sfa_fundingstream", fundingStreamPeriodId.FundingStream.Value);
            }

            Entity.sfa_contractallocationnumber = ContractAllocationRef;
            Entity.sfa_maximumcontractvalue = AllocationValue;

            if (StartDate.HasValue)
            {
                Entity.sfa_startdate = StartDate;
            }
            if (EndDate.HasValue)
            {
                Entity.sfa_enddate = EndDate;
            }
        }

        public void Delete()
        {
            this.DeleteEntity(OrgService);
        }
    }
}
