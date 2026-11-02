namespace XrmMigrator.Xrm
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.ServiceModel;
    using Dto;
    using Events;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class DeliverableMigrator : IDeliverableMigrator
    {
        public IOrganizationService OrgSvc { get; set; }

        public void MigrateDeliverables(IObserver<DeliverableMigrationEvent> eventStream)
        {
            using (var context = new XrmServiceContext(OrgSvc))
            {
                var deliverables = from d in context.sfa_fundingstreamperioddeliverableSet
                    join pd in context.sfa_fundingstreamperioddeliverableSet on d.sfa_ParentDeliverableId.Id equals
                        pd.sfa_fundingstreamperioddeliverableId
                    select new
                    {
                        FundingStreamId = d.sfa_FundingStreamId,
                        FundingStreamPeriodId = d.sfa_FundingStreamPeriodId,
                        DeliverableCode = d.sfa_DeliverableCode,
                        ParentDeliverableId = pd.sfa_fundingstreamperioddeliverableId,
                        ParentDeliverableCode = pd.sfa_DeliverableCode
                    };

                // Materialise Deliverables
                var fspDeliverables = deliverables.ToList();

                // Query Contract Deliverables from CRM with no ParentId
                var contractDeliverables = from d in context.sfa_contractdeliverableSet
                    join a in context.sfa_contractallocationSet on d.sfa_ContractAllocationId.Id equals
                        a.sfa_contractallocationId
                    where d.sfa_ParentDeliverableId == null
                    where d.sfa_DeliverableCode != "1"
                    select new
                    {
                        AllocationNumber = a.sfa_contractallocationnumber,
                        FundingStreamPeriodId = a.sfa_FundingStreamPeriodId,
                        DeliverableCode = d.sfa_DeliverableCode,
                        AllocationId = d.sfa_ContractAllocationId.Id,
                        DeliverableId = d.sfa_contractdeliverableId.Value
                    };

                int processedDeliverables = 0;

                // Enumerate through all orphaned deliverables
                foreach (var deliverable in contractDeliverables)
                {

                    // Find corresponding FSP Deliverable
                    var matchingfspDeliverable =
                        fspDeliverables.Where(
                            d =>
                                d.DeliverableCode.ToString() == deliverable.DeliverableCode &&
                                    d.FundingStreamPeriodId.Id == deliverable.FundingStreamPeriodId.Id);

                    // Check if a unique Funding Stream Period Deliverable was found
                    // This will have no matches on the Top Level Deliverables due to the inner join
                    if (matchingfspDeliverable.Count() != 1)
                    {
                        // Raise Warning
                        eventStream.OnNext(new DeliverableMigrationEvent
                        {
                            AllocationNumber = deliverable.AllocationNumber,
                            DeliverableCode = deliverable.DeliverableCode,
                            Result = EventResult.Warning,
                            Type = EventType.UpdatingRecord,
                            Processed = processedDeliverables,
                            Message =
                                string.Format(
                                    "No unique matching deliverable found within Policy Configuration - this may be due to the Deliverable being the parent deliverable for the Contract Allocation")
                        });

                        continue;
                    }

                    try
                    {
                        // Find Corresponding Contract Deliverable Id of Parent on the allocation
                        var matchingContractParentDeliverableId =
                            context.sfa_contractdeliverableSet.Single(
                                d =>
                                    d.sfa_ContractAllocationId.Id == deliverable.AllocationId &&
                                        d.sfa_DeliverableCode == matchingfspDeliverable.First().ParentDeliverableCode.ToString())
                            ;

                        // Update Contract Deliverable - set Parent Id
                        var deliverableToUpdate = new sfa_contractdeliverable
                        {
                            Id = deliverable.DeliverableId,
                            sfa_contractdeliverableId = deliverable.DeliverableId,
                            sfa_ParentDeliverableId = matchingContractParentDeliverableId.ToEntityReference()
                        };

                        // Attach, Update, Save and Detatch Entity
                        context.Attach(deliverableToUpdate);
                        context.UpdateObject(deliverableToUpdate);
                        context.SaveChanges();
                        context.Detach(deliverableToUpdate);

                        // Increment Processed Deliverables
                        processedDeliverables++;

                        // Sent Event back to the event stream
                        eventStream.OnNext(new DeliverableMigrationEvent
                        {
                            AllocationNumber = deliverable.AllocationNumber,
                            DeliverableCode = deliverable.DeliverableCode,
                            Result = EventResult.Updated,
                            Type = EventType.UpdatingRecord,
                            Processed = processedDeliverables,
                            Message = string.Format("Deliverable Succesfully Processed")
                        });

                    }
                    catch (InvalidOperationException)
                    {
                        // Sent Error back to event stream - no matching Contract Deliverable could be found
                        eventStream.OnNext(new DeliverableMigrationEvent
                        {
                            AllocationNumber = deliverable.AllocationNumber,
                            DeliverableCode = deliverable.DeliverableCode,
                            Result = EventResult.Error,
                            Processed = processedDeliverables,
                            Message =
                                string.Format(
                                    "No matching parent deliverable could be found on the allocation for deliverable code: {0}",
                                    matchingfspDeliverable.First().DeliverableCode)
                        });
                    }

                    catch (FaultException<OrganizationServiceFault> ex)
                    {
                        eventStream.OnNext(new DeliverableMigrationEvent
                        {
                            AllocationNumber = deliverable.AllocationNumber,
                            DeliverableCode = deliverable.DeliverableCode,
                            Result = EventResult.Error,
                            Processed = processedDeliverables,
                            Message =
                                string.Format(
                                    "A CRM Error was encountered during the operation, Message: {0}, Inner Exception: {1}",
                                    ex.Message,
                                    ex.InnerException)
                        });
                    }
                }

                eventStream.OnCompleted();
            }
        }

        public void PopulateSubnominalCodes(IObserver<DeliverablePeriodMigrationEvent> eventStream, IEnumerable<DeliverablePeriodSubnominal> subnominals)
        {
            int recordsProcessed = 0;

            using (var xrmContext = new XrmServiceContext(OrgSvc))
            {
                var groupedSubnominals =
                    subnominals
                        .GroupBy(cds => new { cds.AllocationNumber, cds.Period, cds.SubnominalCode, cds.SubnominalType })
                        .GroupBy(a => new { a.Key.AllocationNumber });

                foreach (var allocationSubnominal in groupedSubnominals)
                {
                    var allocationSet = AllocationDeliverablePeriods(xrmContext,
                        allocationSubnominal.Key.AllocationNumber);

                    foreach (var subnominalGroup in allocationSubnominal)
                    {
                        var subnominalAggregateKey = string.Concat(subnominalGroup.Key.SubnominalCode,
                            "_",
                            subnominalGroup.Key.AllocationNumber,
                            "_",
                            subnominalGroup.Key.Period);

                        var subnominalId = (from s in xrmContext.sfa_subnominalaggregationSet
                                            join sa in xrmContext.sfa_sfa_subnominalaggregation_sfa_contractaSet on s.sfa_subnominalaggregationId equals sa.sfa_subnominalaggregationid
                                            join a in xrmContext.sfa_contractallocationSet on sa.sfa_contractallocationid equals a.sfa_contractallocationId
                            where s.sfa_SubnominalAggregateKey == subnominalAggregateKey
                            select s.Id).SingleOrDefault();

                        if (subnominalId == default(Guid))
                        {
                            eventStream.OnNext(new DeliverablePeriodMigrationEvent
                            {
                                AllocationNumber = subnominalGroup.Key.AllocationNumber,
                                DeliverableCode = "Unknown",
                                Message = "Subnominal Aggregation Not found in CRM, Aggregate Key: " + subnominalAggregateKey,
                                Period = subnominalGroup.Key.Period,
                                SubnominalCode = subnominalGroup.Key.SubnominalCode,
                                SubnominalType = subnominalGroup.Key.SubnominalType,
                                Processed = recordsProcessed,
                                Result = EventResult.Error
                            });

                            continue;
                        }

                        var deliverablePeriods = from dp in allocationSet
                            where dp.DeliverablePeriod == subnominalGroup.Key.Period
                                && subnominalGroup.Any(sdp => sdp.DeliverableCode == dp.DeliverableCode)
                            select dp;


                        IEnumerable<AllocationDeliverablePeriod> deliverablePeriodsToBeUpdated = null;

                        switch (subnominalGroup.Key.SubnominalType)
                        {
                            case SubnominalType.Profile:
                                deliverablePeriodsToBeUpdated = deliverablePeriods.Where(dp => dp.ProfileSubnominalCode == null);
                                break;
                            case SubnominalType.Reconcilation:
                                deliverablePeriodsToBeUpdated = deliverablePeriods.Where(dp => dp.ReconcilationSubnominalCode == null);
                                break;
                            case SubnominalType.Capping:
                                deliverablePeriodsToBeUpdated = deliverablePeriods.Where(dp => dp.CappingSubnominalCode == null);
                                break;
                        }

                        if (deliverablePeriodsToBeUpdated == null || !deliverablePeriodsToBeUpdated.Any()) continue;

                        foreach (var deliverablePeriod in deliverablePeriodsToBeUpdated)
                        {
                            var xrmDeliverablePeriod = new sfa_contractdeliverableperiod
                            {
                                Id = deliverablePeriod.DeliverablePeriodId.GetValueOrDefault()
                            };

                            switch (subnominalGroup.Key.SubnominalType)
                            {
                                case SubnominalType.Profile:
                                    xrmDeliverablePeriod.sfa_profilesubnominal = new EntityReference(sfa_subnominalaggregation.EntityLogicalName,
                                        subnominalId);
                                    break;
                                case SubnominalType.Reconcilation:
                                    xrmDeliverablePeriod.sfa_reconciliationsubnominal = new EntityReference(sfa_subnominalaggregation.EntityLogicalName,
                                        subnominalId);
                                    break;
                                case SubnominalType.Capping:
                                    xrmDeliverablePeriod.sfa_CappingSubnominal = new EntityReference(sfa_subnominalaggregation.EntityLogicalName,
                                        subnominalId);
                                    break;
                            }

                            xrmContext.Attach(xrmDeliverablePeriod);
                            xrmContext.UpdateObject(xrmDeliverablePeriod);
                        }

                        xrmContext.SaveChanges();

                        recordsProcessed = recordsProcessed + deliverablePeriodsToBeUpdated.Count();

                        eventStream.OnNext(new DeliverablePeriodMigrationEvent
                        {
                            AllocationNumber = subnominalGroup.Key.AllocationNumber,
                            Message = "Updated " + deliverablePeriodsToBeUpdated.Count() + " Deliverable Period(s) for Aggregate Key: " + subnominalAggregateKey,
                            Period = subnominalGroup.Key.Period,
                            SubnominalCode = subnominalGroup.Key.SubnominalCode,
                            SubnominalType = subnominalGroup.Key.SubnominalType,
                            Result = EventResult.Updated,
                            Type = EventType.UpdatingRecord,
                            Processed = recordsProcessed
                        });

                        xrmContext.ClearChanges();
                    }
                }

                eventStream.OnCompleted();
            }
        }

        private static AllocationDeliverablePeriod[] AllocationDeliverablePeriods(XrmServiceContext xrmContext, string allocationNumber)
        {
            var allocationSet = (from a in xrmContext.sfa_contractallocationSet
                join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals
                    d.sfa_ContractAllocationId.Id
                join dp in xrmContext.sfa_contractdeliverableperiodSet on d.sfa_contractdeliverableId equals
                    dp.sfa_ContractDeliverableId.Id
                where
                    a.sfa_contractallocationnumber == allocationNumber &&
                        c.sfa_LastApprovedVersion.Value
                select new AllocationDeliverablePeriod
                {
                    AllocationId = a.sfa_contractallocationId,
                    DeliverableId = d.sfa_contractdeliverableId,
                    DeliverablePeriodId = dp.sfa_contractdeliverableperiodId,
                    DeliverableCode = d.sfa_DeliverableCode,
                    DeliverablePeriod =
                        string.Concat(
                            dp.sfa_Year.GetValueOrDefault(),
                            dp.sfa_Period.GetValueOrDefault().ToString("D" + 2)),
                    ProfileSubnominalCode = dp.sfa_profilesubnominal,
                    ReconcilationSubnominalCode = dp.sfa_reconciliationsubnominal,
                    CappingSubnominalCode = dp.sfa_CappingSubnominal
                }).ToArray<AllocationDeliverablePeriod>();

            return allocationSet;
        }
    }
}
