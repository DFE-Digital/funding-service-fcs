namespace PaymentManagementDomain.AllocationActualsVerified.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class AllocationActualsRepository : IAllocationActualsRepository
    {
        private readonly IOrganizationService _organizationService;

        private static readonly Relationship AllocationToDeliverableRelationship = new Relationship("sfa_sfa_contractallocation_sfa_contractdelive");
        private static readonly Relationship DeliverableToPeriodRelationship = new Relationship("sfa_contractdeliverable_deliverableperiod");

        public AllocationActualsRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public void WriteAllocationActualsToCrm(ContractAllocationActualsType allocationActual)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(_organizationService))
            {
                // acquire existing CRM data for allocation
                var existingDeliverablePeriods =
                    (from a in xrmContext.sfa_contractallocationSet
                     join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                     join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals d.sfa_ContractAllocationId.Id
                     join dp in xrmContext.sfa_contractdeliverableperiodSet on d.sfa_contractdeliverableId equals dp.sfa_ContractDeliverableId.Id
                     where
                         a.sfa_contractallocationnumber == allocationActual.ContractAllocationNumber &&
                         c.sfa_Version == allocationActual.ContractReference.ContractVersionNumber &&
                         c.sfa_SubVersion == allocationActual.ContractReference.ContractSubVersionNumber
                     select new
                     {
                         AllocationId = a.sfa_contractallocationId,
                         DeliverableId = d.sfa_contractdeliverableId,
                         ParentId = d.sfa_ParentDeliverableId,
                         DeliverablePeriodId = dp.sfa_contractdeliverableperiodId,
                         DeliverableCode = d.sfa_DeliverableCode,
                         DeliverablePeriod = string.Concat(dp.sfa_Year.GetValueOrDefault(), dp.sfa_Period.GetValueOrDefault().ToString("D" + 2)),
                     })
                    .ToList();

                // enrich the received actuals with data from CRM
                var enrichedReceivedActuals =
                    (from actual in allocationActual.ActualsSummary
                     join existingDeliverablePeriod in existingDeliverablePeriods on
                         new
                         {
                             DeliverableCode = actual.DeliverableCode.ToString(),
                             actual.Period
                         }
                         equals
                         new
                         {
                             existingDeliverablePeriod.DeliverableCode,
                             Period = existingDeliverablePeriod.DeliverablePeriod
                         }
                         into allocationActuals
                     from allocation in allocationActuals.DefaultIfEmpty()
                     select new
                     {
                         allocation?.AllocationId,
                         allocation?.DeliverableId,
                         allocation?.ParentId,
                         allocation?.DeliverablePeriodId,
                         actual.ActualValue,
                         actual.ActualVolume,
                         actual.DeliverableCode
                     })
                    .ToList();

                var invalidActuals = enrichedReceivedActuals.Where(a => a.DeliverablePeriodId == null).ToList();
                if (invalidActuals.Any())
                {
                    throw new Exception(string.Format(
                        "Missing Monitoring Deliverables were encountered for Allocation {0}, Deliverable Code(s): {1}",
                        allocationActual.ContractAllocationNumber,
                        string.Join(", ", invalidActuals.Select(i => i.DeliverableCode))));
                }

                // group enriched actuals into allocation -> deliverable -> deliverable period
                var groupedAllocations = enrichedReceivedActuals
                    .GroupBy(dp => new
                    {
                        dp.AllocationId,
                        dp.DeliverableId,
                        dp.ParentId,
                        dp.DeliverablePeriodId,
                        dp.ActualValue,
                        dp.ActualVolume,
                        dp.DeliverableCode
                    })
                    .GroupBy(d => new { d.Key.AllocationId, d.Key.DeliverableId, d.Key.DeliverableCode })
                    .GroupBy(a => new { a.Key.AllocationId })
                    .ToList();

                var allocationGrouping = groupedAllocations.Single();
                sfa_contractallocation xrmAllocation = new sfa_contractallocation { Id = allocationGrouping.Key.AllocationId.Value };

                // construct a new collection of contract deliverable entities
                EntityCollection xrmDeliverableCollection = new EntityCollection { EntityName = sfa_contractdeliverable.EntityLogicalName };
                xrmAllocation.RelatedEntities.Add(AllocationToDeliverableRelationship, xrmDeliverableCollection);

                foreach (var deliverableGrouping in allocationGrouping)
                {
                    sfa_contractdeliverable xrmDeliverable = new sfa_contractdeliverable
                    {
                        Id = deliverableGrouping.Key.DeliverableId.Value,
                        sfa_ParentDeliverableId = deliverableGrouping.First(v => v.Key.DeliverableId == deliverableGrouping.Key.DeliverableId).Key.ParentId,
                        sfa_DeliverableCode = deliverableGrouping.Key.DeliverableCode.ToString()
                    };

                    xrmDeliverableCollection.Entities.Add(xrmDeliverable);

                    EntityCollection xrmDeliverablePeriodCollection = new EntityCollection { EntityName = sfa_contractdeliverableperiod.EntityLogicalName };
                    xrmDeliverable.RelatedEntities.Add(DeliverableToPeriodRelationship, xrmDeliverablePeriodCollection);

                    foreach (var deliverablePeriodGrouping in deliverableGrouping)
                    {
                        xrmDeliverablePeriodCollection.Entities.Add(new sfa_contractdeliverableperiod
                        {
                            Id = deliverablePeriodGrouping.Key.DeliverablePeriodId.Value,
                            sfa_ActualValue = deliverablePeriodGrouping.Key.ActualValue,
                            sfa_ActualVolume = deliverablePeriodGrouping.Key.ActualVolume,
                        });
                    }

                    xrmDeliverable.sfa_ActualValue = deliverableGrouping.Sum(dp => dp.Key.ActualValue);
                    xrmDeliverable.sfa_ActualVolume = deliverableGrouping.Sum(dp => dp.Key.ActualVolume);
                }

                // retrieve and add parent contract deliverables
                IOrderedEnumerable<sfa_contractdeliverable> orderedChildDeliverables =
                    xrmDeliverableCollection.Entities
                    .Cast<sfa_contractdeliverable>()
                    .Where(d => d.sfa_ParentDeliverableId != null)
                    .OrderByDescending(d => d.sfa_ParentDeliverableId.Id);

                foreach (sfa_contractdeliverable childDeliverable in orderedChildDeliverables)
                {
                    sfa_contractdeliverable parentDeliverable =
                        xrmDeliverableCollection.Entities
                        .Cast<sfa_contractdeliverable>()
                        .FirstOrDefault(parent => parent.Id == childDeliverable.sfa_ParentDeliverableId.Id);

                    if (parentDeliverable == null)
                    {
                        parentDeliverable = GetContractDeliverableFromContext(xrmContext, childDeliverable.sfa_ParentDeliverableId.Id);
                        xrmDeliverableCollection.Entities.Add(parentDeliverable);
                    }

                    if (parentDeliverable.sfa_ParentDeliverableId != null)
                    {
                        xrmDeliverableCollection.Entities.AddRange(GetParentDeliverableHierarchy(xrmContext, parentDeliverable.sfa_ParentDeliverableId));
                    }
                }

                // aggregate actual values up to parents
                xrmDeliverableCollection.Entities
                    .Cast<sfa_contractdeliverable>()
                    .Where(d => d.sfa_ParentDeliverableId == null)
                    .Distinct(new ContractDeliverableEqualityComparer())
                    .ToList()
                    .ForEach(d =>
                    {
                        d.sfa_ActualValue = AggregateDeliverableActualValues(d, xrmDeliverableCollection.Entities.Cast<sfa_contractdeliverable>().ToList());
                    });

                _organizationService.Update(xrmAllocation);
            }
        }

        private static sfa_contractdeliverable GetContractDeliverableFromContext(XrmServiceContext xrmContext, Guid deliverableId)
        {
            return (from d in xrmContext.sfa_contractdeliverableSet
                    where d.Id == deliverableId
                    select d)
                .FirstOrDefault();
        }

        private static List<sfa_contractdeliverable> GetParentDeliverableHierarchy(XrmServiceContext xrmContext, EntityReference parentDeliverableId)
        {
            List<sfa_contractdeliverable> parentDeliverableHierarchy = new List<sfa_contractdeliverable>();

            sfa_contractdeliverable parentDeliverable = GetContractDeliverableFromContext(xrmContext, parentDeliverableId.Id);
            parentDeliverableHierarchy.Add(parentDeliverable);

            if (parentDeliverable.sfa_ParentDeliverableId != null)
            {
                parentDeliverableHierarchy.AddRange(GetParentDeliverableHierarchy(xrmContext, parentDeliverable.sfa_ParentDeliverableId));
            }

            return parentDeliverableHierarchy;
        }

        private static decimal? AggregateDeliverableActualValues(sfa_contractdeliverable deliverable, IList<sfa_contractdeliverable> allDeliverables)
        {
            List<sfa_contractdeliverable> childDeliverables =
                allDeliverables
                    .Where(d => d.sfa_ParentDeliverableId != null && d.sfa_ParentDeliverableId.Id == deliverable.Id)
                    .ToList();

            if (childDeliverables.Any())
            {
                deliverable.sfa_ActualValue = childDeliverables.Sum(d => AggregateDeliverableActualValues(d, allDeliverables));
            }

            return deliverable.sfa_ActualValue;
        }

        private class ContractDeliverableEqualityComparer : IEqualityComparer<sfa_contractdeliverable>
        {
            public bool Equals(sfa_contractdeliverable x, sfa_contractdeliverable y)
            {
                return x?.Id == y?.Id;
            }

            public int GetHashCode(sfa_contractdeliverable obj)
            {
                return obj.GetHashCode();
            }
        }
    }
}