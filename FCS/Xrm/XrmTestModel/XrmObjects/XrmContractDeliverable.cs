
namespace XrmTestModel
{
    using System;
    using System.Linq;
    using System.Linq.Expressions;
    using Extensions;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class XrmContractDeliverable : ContractDeliverable, IUseXrmEntity<sfa_contractdeliverable>, IUseXrmService
    {
        public Guid? EntityId { get; set; }

        public sfa_contractdeliverable Entity { get; set; }

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

        public override ContractAllocation Allocation
        {
            get
            {
                if (base.Allocation == null)
                {
                    base.Allocation = new XrmContractAllocation(OrgServiceFactory).Get(Entity.sfa_ContractAllocationId.Id) as ContractAllocation;
                }
                return base.Allocation;
            }
            set
            {
                base.Allocation = value;
            }
        }

        public override ContractDeliverable ParentDeliverable
        {
            get
            {
                if (base.ParentDeliverable == null && Entity.sfa_ParentDeliverableId != null)
                {
                    base.ParentDeliverable = new XrmContractDeliverable(OrgServiceFactory).Get(Entity.sfa_ParentDeliverableId.Id) as ContractDeliverable;
                }
                return base.ParentDeliverable;
            }
            set
            {
                base.ParentDeliverable = value;
            }
        }

        private XrmContractDeliverable()
        {
            Entity = new sfa_contractdeliverable();
            EntityLogicalName = sfa_contractdeliverable.EntityLogicalName;
        }

        public XrmContractDeliverable(IXrmServiceFactory orgServiceFactory) : this()
        {
            OrgServiceFactory = orgServiceFactory;
            OrgService = OrgServiceFactory.Create();
        }

        public XrmContractDeliverable(sfa_contractdeliverable contractEntity) : this()
        {
            EntityId = contractEntity.Id;
            Entity = contractEntity;
        }

        public IUseXrmEntity<sfa_contractdeliverable> Get()
        {
            return Get(d => d.sfa_contractdeliverableId == EntityId.Value);
        }
        public IUseXrmEntity<sfa_contractdeliverable> Get(Guid primaryKey)
        {
            return Get(d => d.sfa_contractdeliverableId == primaryKey);
        }

        public IUseXrmEntity<sfa_contractdeliverable> Get(string primaryFieldName)
        {
            return Get(d => d.sfa_deliverablename == primaryFieldName);
        }

        public IUseXrmEntity<sfa_contractdeliverable> Get(Expression<Func<sfa_contractdeliverable, bool>> predicate)
        {
            using (var xrmSvcContext = new XrmServiceContext(OrgService))
            {
                var xrmDeliverable = xrmSvcContext.sfa_contractdeliverableSet.Where(predicate).Single();

                if (EntityId == null)
                {
                    EntityId = xrmDeliverable.Id;
                }

                TranslateFromXrm(xrmDeliverable);

                Entity = xrmDeliverable;

            }

            return this;
        }

        public void Save(object parentGuid = null)
        {
            // Save Deliverables

            this.SaveEntity(OrgService);

            foreach (var d in Deliverables.IfNotNull().OfType<IUseXrmEntity<sfa_contractdeliverable>>())
            {
                d.Save();
            }

            // Save Periods

            foreach (var p in Periods.IfNotNull().OfType<IUseXrmEntity<sfa_contractdeliverableperiod>>())
            {
                p.Save();
            }
        }

        public void TranslateFromXrm(sfa_contractdeliverable xrmEntity)
        {
            ParentDeliverable = xrmEntity.sfa_ParentDeliverableId != null
                ? new XrmContractDeliverable(OrgServiceFactory).Get(xrmEntity.sfa_ParentDeliverableId.Id) as
                    XrmContractDeliverable
                : null;
            DeliverableCode = xrmEntity.sfa_DeliverableCode;
            DeliverableName = xrmEntity.sfa_deliverablename;
            PlannedValue = xrmEntity.sfa_PlannedValue.GetValueOrDefault();
            PlannedVolume = xrmEntity.sfa_PlannedVolume.GetValueOrDefault();
        }

        public void TranslateToXrm()
        {
            Entity.sfa_ContractAllocationId = ((XrmContractAllocation)Allocation).GetEntityReference();

            if (ParentDeliverable != null)
            {
                Entity.sfa_ParentDeliverableId = ((XrmContractDeliverable) ParentDeliverable).GetEntityReference();
            }

            Entity.sfa_DeliverableCode = DeliverableCode;
            Entity.sfa_deliverablename = DeliverableName;
            Entity.sfa_PlannedValue = PlannedValue;
            Entity.sfa_PlannedVolume = PlannedVolume;
            Entity.sfa_DisplayOrder = int.Parse(DeliverableCode);
        }

        public void Delete()
        {
            this.DeleteEntity(OrgService);
        }
    }
}
