namespace XrmTestModel
{
    using System;
    using System.Linq;
    using System.Linq.Expressions;
    using Extensions;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class XrmContractDeliverablePeriod : ContractDeliverablePeriod, IUseXrmEntity<sfa_contractdeliverableperiod>, IUseXrmService
    {
        public Guid? EntityId { get; set; }

        public sfa_contractdeliverableperiod Entity { get; set; }

        public string EntityLogicalName { get; set; }

        public IOrganizationService OrgService { get; set; }

        public IXrmServiceFactory OrgServiceFactory { get; set; }

        public override ContractDeliverable Deliverable
        {
            get
            {
                if (base.Deliverable == null && Entity.sfa_ContractDeliverableId != null)
                {
                    base.Deliverable = new XrmContractDeliverable(OrgServiceFactory).Get(Entity.sfa_ContractDeliverableId.Id) as ContractDeliverable;
                }
                return base.Deliverable;
            }
            set
            {
                base.Deliverable = value;
            }
        }

        public override SubnominalAggregation ProfileSubnominal
        {
            get
            {
                if (base.ProfileSubnominal == null && Entity.sfa_profilesubnominal != null)
                {
                    base.ProfileSubnominal = new XrmSubnominalAggregation(OrgServiceFactory).Get(Entity.sfa_profilesubnominal.Id) as XrmSubnominalAggregation;
                }
                return base.ProfileSubnominal;
            }
            set
            {
                base.ProfileSubnominal = value;
            }
        }

        public override SubnominalAggregation CappingSubnominal
        {
            get
            {
                if (base.CappingSubnominal == null && Entity.sfa_CappingSubnominal != null)
                {
                    base.CappingSubnominal = new XrmSubnominalAggregation(OrgServiceFactory).Get(Entity.sfa_CappingSubnominal.Id) as XrmSubnominalAggregation;
                }
                return base.CappingSubnominal;
            }
            set
            {
                base.CappingSubnominal = value;
            }
        }

        public override SubnominalAggregation ReconcilationSubnominal
        {
            get
            {
                if (base.ReconcilationSubnominal == null && Entity.sfa_reconciliationsubnominal != null)
                {
                    base.ReconcilationSubnominal = new XrmSubnominalAggregation(OrgServiceFactory).Get(Entity.sfa_reconciliationsubnominal.Id) as XrmSubnominalAggregation;
                }
                return base.ReconcilationSubnominal;
            }
            set
            {
                base.ReconcilationSubnominal = value;
            }
        }

        private XrmContractDeliverablePeriod()
        {
            Entity = new sfa_contractdeliverableperiod();
            EntityLogicalName = sfa_contractdeliverableperiod.EntityLogicalName;
        }

        public XrmContractDeliverablePeriod(IXrmServiceFactory orgServiceFactory) : this()
        {
            OrgServiceFactory = orgServiceFactory;
            OrgService = OrgServiceFactory.Create();
        }

        public XrmContractDeliverablePeriod(sfa_contractdeliverableperiod periodEntity)
        {
            EntityId = periodEntity.Id;
            Entity = periodEntity;
        }

        public IUseXrmEntity<sfa_contractdeliverableperiod> Get()
        {
            return Get(p => p.sfa_contractdeliverableperiodId == EntityId.Value);
        }

        public IUseXrmEntity<sfa_contractdeliverableperiod> Get(Guid primaryKey)
        {
            return Get(p => p.sfa_contractdeliverableperiodId == EntityId.Value);
        }

        public IUseXrmEntity<sfa_contractdeliverableperiod> Get(string primaryFieldName)
        {
            return Get(p => p.sfa_name == primaryFieldName);
        }

        public IUseXrmEntity<sfa_contractdeliverableperiod> Get(Expression<Func<sfa_contractdeliverableperiod, bool>> predicate)
        {
            using (var xrmSvcContext = new XrmServiceContext(OrgService))
            {
                var xrmDeliverablePeriod = xrmSvcContext.sfa_contractdeliverableperiodSet.First(predicate);

                if (EntityId == null)
                {
                    EntityId = xrmDeliverablePeriod.Id;
                }

                TranslateFromXrm(xrmDeliverablePeriod);

                Entity = xrmDeliverablePeriod;

            }

            return this;
        }

        public void Save(object parentGuid = null)
        {
            this.SaveEntity(OrgService);
        }

        public void TranslateFromXrm(sfa_contractdeliverableperiod xrmEntity)
        {
            Year = xrmEntity.sfa_Year.GetValueOrDefault();
            PeriodNumber = xrmEntity.sfa_Period.GetValueOrDefault();
            PlannedValue = xrmEntity.sfa_PlannedValue.GetValueOrDefault();
            PlannedVolume = xrmEntity.sfa_PlannedVolume.GetValueOrDefault();
            Aggregate = xrmEntity.sfa_aggregate.GetValueOrDefault();
            PaymentPosted = xrmEntity.sfa_PaymentPosted.GetValueOrDefault();
            ActualValue = xrmEntity.sfa_ActualValue.GetValueOrDefault();
            ActualVolume = xrmEntity.sfa_ActualVolume.GetValueOrDefault();
            ReconcilationPayment = xrmEntity.sfa_ReconciliationPaymentAmount.GetValueOrDefault();
        }

        public void TranslateToXrm()
        {
            Entity.sfa_ContractDeliverableId = ((XrmContractDeliverable)Deliverable).GetEntityReference();
            Entity.sfa_profilesubnominal = ProfileSubnominal != null ? ((XrmSubnominalAggregation)ProfileSubnominal).GetEntityReference() : null;
            Entity.sfa_CappingSubnominal = CappingSubnominal != null ? ((XrmSubnominalAggregation) CappingSubnominal).GetEntityReference() : null;
            Entity.sfa_reconciliationsubnominal = ReconcilationSubnominal != null ? ((XrmSubnominalAggregation)ReconcilationSubnominal).GetEntityReference() : null;
            Entity.sfa_Year = Year;
            Entity.sfa_Period = PeriodNumber;
            Entity.sfa_PlannedValue = PlannedValue;
            Entity.sfa_PlannedVolume = PlannedVolume;
            Entity.sfa_aggregate = Aggregate;
            Entity.sfa_PaymentPosted = PaymentPosted;
            Entity.sfa_ActualValue = ActualValue;
            Entity.sfa_ActualVolume = ActualVolume;
            Entity.sfa_ReconciliationPaymentAmount = ReconcilationPayment;
            Entity.sfa_DisplayOrder = int.Parse(string.Concat(Year,
                PeriodNumber.ToString("D" + 2)));
        }

        public void Delete()
        {
            this.DeleteEntity(OrgService);
        }
    }
}
