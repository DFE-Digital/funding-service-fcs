namespace ContractCreateDomain.Endpoint.XrmService.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using DTOs;
    using Infrastructure.Extensions;
    using Microsoft.Xrm.Sdk;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging.NullObjects;

    public class XrmAllocationEvidenceManager : IXrmAllocationEvidenceManager
    {
        public static readonly Relationship AllocationToDeliverableRelationship = new Relationship("sfa_sfa_contractallocation_sfa_contractdelive");
        public static readonly Relationship DeliverableToPeriodRelationship = new Relationship("sfa_contractdeliverable_deliverableperiod");
        public static readonly Relationship StagingEntityToDeliverableRelationship = new Relationship("sfa_sfa_stagingentity_sfa_contractdeliverable");
        private readonly IFundingStreamDeliverablePeriodRepository _fundingStreamDeliverablePeriodRepository;

        public XrmAllocationEvidenceManager(IFundingStreamDeliverablePeriodRepository fundingStreamDeliverablePeriodRepository)
        {
            _fundingStreamDeliverablePeriodRepository = fundingStreamDeliverablePeriodRepository;
            Logger = new LoggerNullObject();
        }

        public ILogger Logger { get; set; }

        public IOrganizationService OrganizationService { get; set; }

        public void AggregateDeliverablePeriodsIntoDeliverableInCrm(AllocationDto allocation)
        {
            List<ContractCreateDomain.Endpoint.XrmService.DTOs.Deliverable> deliverables = allocation.Deliverables;
            allocation.Deliverables.ForEach(DeliverablePeriodsAtDeliverableLevelAggregator);

            allocation.Deliverables.Where(d => d.ParentDeliverableId == null).ToList().ForEach(d =>
            {
                d.ActualValue = AggregateActualsForAGivenDeliverable(d, deliverables);
            });

            OrganizationService.Update(UpdateAllocationWithUpdatedDeliverables(allocation));
        }

        private sfa_contractallocation UpdateAllocationWithUpdatedDeliverables(AllocationDto allocation)
        {
            sfa_contractallocation crmAllocation = new sfa_contractallocation
            {
                Id = allocation.CrmGuid
            };

            EntityCollection relatedDeliverablesUpdated = new EntityCollection();
            relatedDeliverablesUpdated.EntityName = sfa_contractdeliverable.EntityLogicalName;
            Relationship allocationToDeliverable = new Relationship("sfa_sfa_contractallocation_sfa_contractdelive");

            IEnumerable<sfa_contractdeliverable> sfaContractdeliverables = allocation.Deliverables.Select(d => new sfa_contractdeliverable()
            {
                Id = d.Id,
                sfa_ActualValue = d.ActualValue
            });

            relatedDeliverablesUpdated.Entities.AddRange(sfaContractdeliverables);
            crmAllocation.RelatedEntities.Add(allocationToDeliverable, relatedDeliverablesUpdated);
            return crmAllocation;
        }

        private void DeliverablePeriodsAtDeliverableLevelAggregator(ContractCreateDomain.Endpoint.XrmService.DTOs.Deliverable deliverable)
        {
            IList<DeliverablePeriod> deliverablePeriods = deliverable.DeliverablePeriods;
            deliverable.ActualValue = deliverablePeriods.SumIfAny(dp => dp.ActualValue);
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

        private static decimal? AggregateActualsForAGivenDeliverable(ContractCreateDomain.Endpoint.XrmService.DTOs.Deliverable deliverable, IList<ContractCreateDomain.Endpoint.XrmService.DTOs.Deliverable> deliverables)
        {
            List<ContractCreateDomain.Endpoint.XrmService.DTOs.Deliverable> childDeliverables =
                deliverables
                    .Where(d => d.ParentDeliverableId != null && d.ParentDeliverableId == deliverable.Id)
                    .ToList();

            if (childDeliverables.Any())
            {
                deliverable.ActualValue = childDeliverables.SumIfAny(d => AggregateActualsForAGivenDeliverable(d, deliverables));
            }

            return deliverable.ActualValue;
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

        private static sfa_contractdeliverable GetContractDeliverableFromContext(XrmServiceContext xrmContext, Guid deliverableId)
        {
            return (from d in xrmContext.sfa_contractdeliverableSet
                    where d.Id == deliverableId
                    select d)
                    .FirstOrDefault();
        }

        public sfa_contractallocation GetSpecificAllocationFromCrm(XrmServiceContext xrmContext, string allocationNumber, int contractVersionNumber, int contractSubVersionNumber)
        {
            try
            {
                var data = from a in xrmContext.sfa_contractallocationSet
                           join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                           where
                               c.sfa_Version == contractVersionNumber &&
                               c.sfa_SubVersion == contractSubVersionNumber &&
                               a.sfa_contractallocationnumber == allocationNumber
                           select a;
                sfa_contractallocation sfaContractallocation = data.First();
                return sfaContractallocation;
            }
            catch (Exception ex)
            {
                Logger.LogError(
                    1,
                    "GetAllocationIDFromCRM-Exception occured when trying to search for an Allocation in CRM. Allocation Ref:{0}, Version:{1}, Error Message: {2} ",
                    allocationNumber,
                    contractVersionNumber,
                    ex.ToString());
                throw;
            }
        }

        public AllocationDto GetDeliverablesAndPeriods(XrmServiceContext xrmContext, Guid allocationId, allocationType allocation)
        {
            List<contractDeliverableType> flattenedDeliverables =
                allocation.FlattenDeliverables(allocation.contractDeliverables);

            var dataset = (
                from deliverable in xrmContext.sfa_contractdeliverableSet
                join deliverablePeriod in xrmContext.sfa_contractdeliverableperiodSet
                    on deliverable.Id equals deliverablePeriod.sfa_ContractDeliverableId.Id
                where deliverable.sfa_ContractAllocationId.Id.Equals(allocationId)
                select new
                {
                    deliverable,
                    deliverablePeriod
                }).ToList();

            // Group into the required heirarchy
            List<Deliverable> deliverables = new List<Deliverable>();

            foreach (var d in dataset)
            {
                var del = deliverables.FirstOrDefault(de => de.DeliverableCode.Equals(d.deliverable.sfa_DeliverableCode));

                var dp = new DeliverablePeriod
                {
                    Id = d.deliverablePeriod.sfa_contractdeliverableperiodId ?? Guid.Empty,
                    PeriodNumber = d.deliverablePeriod.sfa_Period,
                    Year = d.deliverablePeriod.sfa_Year,
                    ActualValue = d.deliverablePeriod.sfa_ActualValue,
                    ActualVolume = d.deliverablePeriod.sfa_ActualVolume,
                    BalancingPaymentValue = d.deliverablePeriod.sfa_BalancingPaymentAmount,
                    CappedPaymentValue = d.deliverablePeriod.sfa_CappedPaymentAmount,
                    NetPaymentValue = d.deliverablePeriod.sfa_NetPaymentAmount,
                    PaymentPosted = d.deliverablePeriod.sfa_PaymentPosted,
                    ProfilePaymentValue = d.deliverablePeriod.sfa_ProfilePaymentAmount,
                    ReconciliationPaymentValue = d.deliverablePeriod.sfa_ReconciliationPaymentAmount,
                    CappingSubnominalId = (d.deliverablePeriod.sfa_CappingSubnominal != null ? d.deliverablePeriod.sfa_CappingSubnominal.Id : Guid.Empty),
                    ProfileSubnominalId = (d.deliverablePeriod.sfa_profilesubnominal != null ? d.deliverablePeriod.sfa_profilesubnominal.Id : Guid.Empty),
                    ReconcilliationSubnominalId = (d.deliverablePeriod.sfa_reconciliationsubnominal != null ? d.deliverablePeriod.sfa_reconciliationsubnominal.Id : Guid.Empty),
                    Modified = false
                };

                if (del == null)
                {
                    del = new Deliverable
                    {
                        Id = d.deliverable.Id,
                        DeliverableCode = d.deliverable.sfa_DeliverableCode,
                        ParentDeliverableId = d.deliverable.sfa_ParentDeliverableId?.Id,
                        ActualValue = d.deliverable.sfa_ActualValue
                    };

                    // Find and add the monitoring and legal flags form the allocation object
                    var allocationDeliverable = flattenedDeliverables.First(cd => cd.deliverable.deliverableCode.ToString() == del.DeliverableCode);

                    del.IsLegal = allocationDeliverable.deliverable.isLegal;
                    del.IsMonitoring = allocationDeliverable.deliverable.isMonitoring;

                    deliverables.Add(del);
                }

                del.DeliverablePeriods.Add(dp);
            }

            AllocationDto dto = new AllocationDto()
            {
                Deliverables = deliverables,
                CrmGuid = allocationId
            };

            return dto;
        }

        public AllocationDto CopyPreviousDeliverablePeriodActualsInCrm(allocationType allocation)
        {
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                var crmCurrentAllocation = GetSpecificAllocationFromCrm(
                    xrmContext,
                    allocation.contractAllocationNumber,
                    allocation.contractReference.contractVersionNumber,
                    allocation.contractReference.contractSubVersionNumber);

                var crmPreviousAllocation = GetLastApprovedAllocationFromCrm(
                    xrmContext,
                    allocation.contractAllocationNumber);
                AllocationDto allocationDto = GetDeliverablesAndPeriods(xrmContext, crmCurrentAllocation.Id, allocation);
                List<Deliverable> currentDeliverables = allocationDto.Deliverables;

                // Check to see if there is anything to be copied from the old contract (ie. if this is an amended contract with an 
                // additional allocation, then there will no no previous deliverables....)
                if (crmPreviousAllocation != null)
                {
                    List<Deliverable> previousDeliverables = GetDeliverablesAndPeriods(xrmContext, crmPreviousAllocation.Id, allocation).Deliverables;

                    var mergeDeliverables = DeliverableMerger.MergeDeliverables(currentDeliverables, previousDeliverables);

                    var modifiedDeliverables = mergeDeliverables.Where(m => m.DeliverablePeriods.Any(mdp => mdp.Modified)).ToList();

                    var doSave = false;

                    // Grab allocation at the top level of the hierarchy
                    var xrmAllocation = new sfa_contractallocation { Id = crmCurrentAllocation.Id };

                    // Iterate through the child deliverables and deliverable periods
                    var xrmDeliverableCollection = new EntityCollection { EntityName = sfa_contractdeliverable.EntityLogicalName };

                    foreach (var cd in modifiedDeliverables)
                    {
                        doSave = true;
                        var xrmDeliverable = new sfa_contractdeliverable { Id = cd.Id };
                        xrmDeliverableCollection.Entities.Add(xrmDeliverable);

                        var xrmDeliverablePeriodCollection = new EntityCollection { EntityName = sfa_contractdeliverableperiod.EntityLogicalName };

                        foreach (var dp in cd.DeliverablePeriods.Where(dpm => dpm.Modified))
                        {
                            var xrmDeliverablePeriod = new sfa_contractdeliverableperiod
                            {
                                Id = dp.Id,
                                sfa_ActualValue = dp.ActualValue,
                                sfa_ActualVolume = dp.ActualVolume
                            };

                            if (dp.CappingSubnominalId != Guid.Empty)
                                xrmDeliverablePeriod.sfa_CappingSubnominal =
                                    new EntityReference(sfa_subnominalaggregation.EntityLogicalName,
                                        dp.CappingSubnominalId);

                            if (dp.ReconcilliationSubnominalId != Guid.Empty)
                                xrmDeliverablePeriod.sfa_reconciliationsubnominal =
                                    new EntityReference(sfa_subnominalaggregation.EntityLogicalName,
                                        dp.ReconcilliationSubnominalId);

                            if (dp.ProfileSubnominalId != Guid.Empty)
                                xrmDeliverablePeriod.sfa_profilesubnominal =
                                    new EntityReference(sfa_subnominalaggregation.EntityLogicalName,
                                        dp.ProfileSubnominalId);

                            xrmDeliverablePeriodCollection.Entities.Add(xrmDeliverablePeriod);
                        }

                        xrmDeliverable.RelatedEntities.Add(DeliverableToPeriodRelationship, xrmDeliverablePeriodCollection);
                    }


                    if (doSave)
                    {
                        xrmAllocation.RelatedEntities.Add(AllocationToDeliverableRelationship, xrmDeliverableCollection);

                        OrganizationService.Update(xrmAllocation);
                    }
                }

                return allocationDto;
            }
        }

        private EntityReference GetPeriodTypeFromCrm(XrmServiceContext xrmContext, string periodTypeCode)
        {
            var periodType = xrmContext.sfa_periodtypeSet.FirstOrDefault(p => p.sfa_periodtypecode == periodTypeCode);
            return periodType != null ? periodType.ToEntityReference() : null;
        }

        private sfa_contractallocation GetLastApprovedAllocationFromCrm(XrmServiceContext xrmContext, string allocationNumber)
        {
            var allReplacedContractsForGivenAllocation = from allocation in xrmContext.sfa_contractallocationSet
                                                         join contract in xrmContext.sfa_contractSet on allocation.sfa_ContractId.Id equals contract.sfa_contractId
                                                         where allocation.sfa_contractallocationnumber == allocationNumber &&
                                                                 contract.sfa_ContractStatus.Value == (int)sfa_contractstatus.Replaced
                                                         select new
                                                         {
                                                             ContractVersion = contract.sfa_Version,
                                                             Allocation = allocation
                                                         };

            var latestPreviouslyApprovedAllocation = allReplacedContractsForGivenAllocation.ToList().OrderByDescending(x => x.ContractVersion).FirstOrDefault();

            return latestPreviouslyApprovedAllocation?.Allocation;
        }

        private List<contractDeliverableType> FlattenDeliverable(IList<contractDeliverableType> deliverables)
        {
            var results = new List<contractDeliverableType>();
            foreach (var contractDeliverableType in deliverables)
            {
                results.Add(contractDeliverableType);
                if (contractDeliverableType.contractDeliverables != null &&
                    contractDeliverableType.contractDeliverables.Any())
                {
                    results.AddRange(FlattenDeliverable(contractDeliverableType.contractDeliverables));
                }
            }

            return results;
        }

        private class ContractDeliverableEqualityComparer : IEqualityComparer<sfa_contractdeliverable>
        {
            public bool Equals(sfa_contractdeliverable x, sfa_contractdeliverable y)
            {
                return x.Id == y.Id;
            }

            public int GetHashCode(sfa_contractdeliverable obj)
            {
                return obj.GetHashCode();
            }
        }
    }
}
