namespace XrmTestModel
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Linq.Expressions;
    using Extensions;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class XrmContract : Contract, IUseXrmEntity<sfa_contract>, IUseXrmService
    {
        public Guid? EntityId { get; set; }

        public sfa_contract Entity { get; set; }

        public Guid? ParentContractId { get; set; }

        public string EntityLogicalName { get; set; }

        public IXrmServiceFactory OrgServiceFactory { get; set; }

        public IOrganizationService OrgService { get; set; }

        public XrmContract()
        {
            Entity = new sfa_contract();
            EntityLogicalName = sfa_contract.EntityLogicalName;
        }

        public XrmContract(IXrmServiceFactory orgServiceFactory) : this()
        {
            OrgServiceFactory = orgServiceFactory;
            OrgService = OrgServiceFactory.Create();
        }
        
        public IUseXrmEntity<sfa_contract> Get()
        {
            return Get(c => c.sfa_contractId == EntityId);
        }
        
        public IUseXrmEntity<sfa_contract> Get(Guid primaryKey)
        {
            return Get(c => c.sfa_contractId == primaryKey);
        }

        public IUseXrmEntity<sfa_contract> Get(string primaryFieldName)
        {
            return Get(c => c.sfa_number == primaryFieldName);
        }

        public IUseXrmEntity<sfa_contract> Get(Expression<Func<sfa_contract, bool>> predicate)
        {
            using (var xrmSvcContext = new XrmServiceContext(OrgService))
            {
                var xrmContracts =
                    xrmSvcContext.sfa_contractSet
                        .Where(predicate);

                var contracts = xrmContracts.ToList().Select(c =>
                {
                    ContractNumber = c.sfa_number;
                    ContractType = c.sfa_ContractType != null ? c.sfa_ContractType.Name : null;
                    Description = c.sfa_Description;
                    FundingType = c.sfa_FundingType != null ? c.sfa_FundingType.Name : null;
                    ParentContractNumber = c.sfa_ParentContractId != null ? c.sfa_ParentContractId.Name : null;
                    Version = c.sfa_Version.GetValueOrDefault();
                    SubVersion = c.sfa_SubVersion.GetValueOrDefault();
                    LatestVersion = c.sfa_LatestVersion.GetValueOrDefault();
                    LastApprovedVersion = c.sfa_LastApprovedVersion.GetValueOrDefault();
                    Allocations = GetAllocations(xrmSvcContext, c.sfa_contractId.GetValueOrDefault());
                    ParentContractId = c.sfa_ParentContractId != null ? c.sfa_ParentContractId.Id : Guid.Empty;
                    return c;
                });

                var contract = contracts.Single();

                EntityId = contract.Id;
                Entity = contract;
            }

            return this;
        }

        private IEnumerable<ContractAllocation> GetAllocations(XrmServiceContext xrmSvcContext, Guid contractId)
        {
            return (from a in xrmSvcContext.sfa_contractallocationSet
                join f in xrmSvcContext.sfa_fundingstreamSet on a.sfa_FundingStreamId.Id equals f.sfa_fundingstreamId
                join fsp in xrmSvcContext.sfa_fundingstreamperiodSet on a.sfa_FundingStreamPeriodId.Id equals
                    fsp.sfa_fundingstreamperiodId
                join c in xrmSvcContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                where c.sfa_contractId == contractId
                orderby a.sfa_contractallocationnumber
                select new XrmContractAllocation(a)
                {
                    OrgService = OrgService,
                    OrgServiceFactory = OrgServiceFactory,
                    ContractAllocationRef = a.sfa_contractallocationnumber,
                    Contract = new XrmContract(OrgServiceFactory),
                    AllocationValue = a.sfa_maximumcontractvalue.GetValueOrDefault(),
                    FundingStream = f.sfa_fundingstreamcode,
                    Deliverables =
                        GetContractDeliverablesForAllocation(xrmSvcContext,
                            a.sfa_contractallocationId.GetValueOrDefault())
                }).ToList();
        }

        private IEnumerable<ContractDeliverable> GetContractDeliverablesForAllocation(XrmServiceContext xrmSvcContext,
            Guid allocationId)
        {
            return (from d in xrmSvcContext.sfa_contractdeliverableSet
                where d.sfa_ContractAllocationId.Id == allocationId
                orderby d.sfa_DisplayOrder
                select new XrmContractDeliverable(d)
                {
                    OrgService = OrgService,
                    OrgServiceFactory = OrgServiceFactory,
                    DeliverableCode = d.sfa_DeliverableCode,
                    DeliverableName = d.sfa_deliverablename,
                    PlannedValue = d.sfa_PlannedValue.GetValueOrDefault(),
                    PlannedVolume = d.sfa_PlannedVolume.GetValueOrDefault(),
                    ActualValue = d.sfa_ActualValue.GetValueOrDefault(),
                    ActualVolume = d.sfa_ActualVolume.GetValueOrDefault(),
                    Periods = GetDeliverablePeriodsForDeliverable(xrmSvcContext, d.Id)
                }).ToList();
        }

        private IEnumerable<ContractDeliverablePeriod> GetDeliverablePeriodsForDeliverable(
            XrmServiceContext xrmSvcContext, Guid deliverableId)
        {
            return (from p in xrmSvcContext.sfa_contractdeliverableperiodSet
                join pt in xrmSvcContext.sfa_periodtypeSet on p.sfa_PeriodTypeId.Id equals pt.sfa_periodtypeId
                where p.sfa_ContractDeliverableId.Id == deliverableId
                orderby p.sfa_DisplayOrder
                select new XrmContractDeliverablePeriod(p)
                {
                    OrgService = OrgService,
                    OrgServiceFactory = OrgServiceFactory,
                    Year = p.sfa_Year.GetValueOrDefault(),
                    PeriodNumber = p.sfa_Period.GetValueOrDefault(),
                    PlannedValue = p.sfa_PlannedValue.GetValueOrDefault(),
                    PlannedVolume = p.sfa_PlannedVolume.GetValueOrDefault(),
                    Aggregate = p.sfa_aggregate.GetValueOrDefault()
                }).ToList();
        }

        public void Save(object parentGuid = null)
        {
            if (parentGuid != null)
            {
                ParentContractId = (Guid)parentGuid;
            }

            this.SaveEntity(OrgService);

            // Save Child Contracts
            foreach (var c in ChildContracts.IfNotNull().OfType<IUseXrmEntity<sfa_contract>>())
            {
             //   object x = EntityId ?? Guid.Empty;

                c.Save(EntityId ?? Guid.Empty);
            }

            // Save Allocations
            foreach (var a in Allocations.IfNotNull().OfType<IUseXrmEntity<sfa_contractallocation>>())
            {
                a.Save();
            }
        }

        public void TranslateFromXrm(sfa_contract xrmEntity)
        {
            Entity.sfa_Description = Description;
            Entity.sfa_Version = Version;
            Entity.sfa_SubVersion = SubVersion;
            Entity.sfa_number = ContractNumber;
            Entity.sfa_UKPRN = Ukprn;
        }

        public void TranslateToXrm()
        {
            Entity.sfa_ProviderName = new XrmOrganisation(OrgServiceFactory).Get(Ukprn).GetEntityReference();
            Entity.sfa_Description = Description;
            Entity.sfa_Version = Version;
            Entity.sfa_SubVersion = SubVersion;
            Entity.sfa_number = ContractNumber;
            Entity.sfa_UKPRN = Ukprn;
            Entity.sfa_LastApprovedVersion = LastApprovedVersion;
            Entity.sfa_LatestVersion = LatestVersion;
            if (ContractApprovedDate.HasValue)
            {
                Entity.sfa_ContractApprovalDate = ContractApprovedDate;
            }

            if (ParentContractId.HasValue)
            {
                Entity.sfa_ParentContractId = new EntityReference("sfa_contract", ParentContractId.Value);
            }

            using (var context = new XrmServiceContext(OrgService))
            {
                var ft = (from f in
                    context.sfa_fundingtypeSet
                    where f.sfa_name.Equals(FundingType)
                    select f).FirstOrDefault();

                if (ft != null)
                {
                    Entity.sfa_FundingType = ft.ToEntityReference();
                }

                var ct = (from c in
                    context.sfa_contracttypeSet
                    where c.sfa_name.Equals(ContractType)
                    select c).FirstOrDefault();

                if (ct != null)
                {
                    Entity.sfa_ContractType = ct.ToEntityReference();
                }
            }
        }

        public void Delete()
        {
            foreach (var c in ChildContracts.IfNotNull().OfType<IUseXrmEntity<sfa_contract>>())
            {
                c.Delete();
            }

            this.DeleteEntity(OrgService);
        }
    }
}
