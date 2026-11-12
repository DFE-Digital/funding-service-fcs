namespace PaymentManagementDomain.PaymentSchedule.DeliverableAggregation
{
    extern alias IntegrationEntities;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using IntegrationEntities::SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Dtos;

    public class CrmDeliverableRepository : ICrmDeliverableRepository
    {
        private readonly IOrganizationService _organizationService;
        private static readonly Relationship AllocationToDeliverableRelationship = new Relationship("sfa_sfa_contractallocation_sfa_contractdelive");

        public CrmDeliverableRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public void UpdateDeliverablesInCrmForAllocation(string allocationNumber, int version, int subVersion, IReadOnlyCollection<DeliverableActual> deliverableActuals)
        {
            var deliverablesFromCrm = GetDeliverablesForAllocation(allocationNumber, version, subVersion);

            UpdateDeliverablesWithActuals(deliverablesFromCrm, deliverableActuals);
        }

        private void UpdateDeliverablesWithActuals(IReadOnlyCollection<SimpleDeliverable> deliverablesFromCrm, IReadOnlyCollection<DeliverableActual> deliverableActuals)
        {
            sfa_contractallocation allocation = new sfa_contractallocation
            {
                Id = deliverablesFromCrm.First().AllocationId                
            };

            EntityCollection deliverableCollection = new EntityCollection { EntityName = sfa_contractdeliverable.EntityLogicalName };

            bool IsDeliverablePresentInPaas(SimpleDeliverable deliverableFromCrm) => deliverableActuals.Any(da => da.DeliverableCode == deliverableFromCrm.DeliverableCode);

            var deliverablesToUpdate = deliverablesFromCrm
                .Where(IsDeliverablePresentInPaas)
                .Select(d => CreateCrmDeliverableWithActualUpdated(d, deliverableActuals.Single(da => da.DeliverableCode == d.DeliverableCode)))
                .ToList();

            deliverableCollection.Entities.AddRange(deliverablesToUpdate);

            allocation.RelatedEntities.Add(AllocationToDeliverableRelationship, deliverableCollection);

            _organizationService.Update(allocation);
        }

        private sfa_contractdeliverable CreateCrmDeliverableWithActualUpdated(SimpleDeliverable simpleDeliverable, DeliverableActual actual)
        {
            return new sfa_contractdeliverable
            {
                Id = simpleDeliverable.Id,
                sfa_ActualValue = actual.Value,
                sfa_ActualVolume = actual.Volume
            };
        }

        private IReadOnlyCollection<SimpleDeliverable> GetDeliverablesForAllocation(
            string allocationNumber,
            int version,
            int subVersion)
        {
            using (var context = new XrmServiceContext(_organizationService))
            {
                var deliverables = (from c in context.sfa_contractSet
                    join a in context.sfa_contractallocationSet on c.sfa_contractId equals a.sfa_ContractId.Id
                    join d in context.sfa_contractdeliverableSet on a.sfa_contractallocationId equals d
                        .sfa_ContractAllocationId.Id
                    where (c.sfa_Version == version &&
                           c.sfa_SubVersion == subVersion &&
                           a.sfa_contractallocationnumber == allocationNumber)
                    select new {Id = d.sfa_contractdeliverableId.Value, d.sfa_DeliverableCode, AllocationId = a.sfa_contractallocationId.Value})
                    .AsEnumerable()
                    .Select(d => new SimpleDeliverable(d.Id, int.Parse(d.sfa_DeliverableCode), d.AllocationId))
                    .ToList();

                return deliverables;
            }
        }

        private class SimpleDeliverable
        {
            public SimpleDeliverable(Guid id, int deliverableCode, Guid allocationId)
            {
                Id = id;
                DeliverableCode = deliverableCode;
                AllocationId = allocationId;
            }

            public Guid Id { get; }

            public int DeliverableCode { get; }

            public Guid AllocationId { get; }
        }
    }
}
