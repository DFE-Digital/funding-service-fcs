namespace PaymentGenerationDomain.BusinessLogic
{
    using System;
    using System.Linq;
    using Exceptions;
    using Microsoft.Xrm.Sdk;
    using Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class XrmAllocationManager : IXrmAllocationManager
    {
        #region ReadOnly

        public static readonly Relationship AllocationToDeliverableRelationship =
            new Relationship("sfa_sfa_contractallocation_sfa_contractdelive");

        public static readonly Relationship DeliverableToPeriodRelationship =
            new Relationship("sfa_contractdeliverable_deliverableperiod");

        #endregion

        #region Injected Dependencies

        public IOrganizationService OrgService { get; set; }

        public ILogger Logger { get; set; }

        #endregion

        /// <summary>
        /// This method updates the Payment Transmission Status of an aggregated payment at Allocation Level
        /// </summary>
        /// <remarks>
        /// This query is dependant on the Subnominal Code being stored in the primary field of the Subnominal Aggregation Entity
        /// </remarks>
        /// <param name="allocation">The Aggregated Allocation based on the Corporate Aggregate Payment Schema</param>
        /// <param name="value">The value to update the Posted Payment flag to</param>
        public void UpdatePaymentTransmissionStatus(Allocation allocation, bool value)
        {
            Logger.LogInformation(PaymentGenerationDomainLoggingEventId.UpdateTransmissionStatusStarted,    
                "Updating Payment transmission status for allocation: {0}, Version: {1}, fsp code: {2} to: {1}", 
                allocation.AllocationNumber, allocation.VersionNumber, allocation.FundingStreamPeriodCode, value.ToString());

            using (var xrmContext = new XrmServiceContext(OrgService))
            {
                var allocationSet = from a in xrmContext.sfa_contractallocationSet
                    join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                    join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals
                        d.sfa_ContractAllocationId.Id
                    join dp in xrmContext.sfa_contractdeliverableperiodSet on d.sfa_contractdeliverableId equals
                        dp.sfa_ContractDeliverableId.Id
                    where
                        a.sfa_contractallocationnumber == allocation.AllocationNumber &&
                            c.sfa_LastApprovedVersion == true
                    select new
                    {
                        AllocationId = a.sfa_contractallocationId.Value,
                        DeliverableId = d.sfa_contractdeliverableId.Value,
                        DeliverablePeriodId = dp.sfa_contractdeliverableperiodId,
                        DeliverablePeriod =
                            string.Concat(
                                dp.sfa_Year.GetValueOrDefault(),
                                dp.sfa_Period.GetValueOrDefault().ToString("D" + 2)),
                        ProfileSubnominalCode = dp.sfa_profilesubnominal != null ? dp.sfa_profilesubnominal.Name : null,
                        ReconcilationSubnominalCode =
                            dp.sfa_reconciliationsubnominal != null ? dp.sfa_reconciliationsubnominal.Name : null,
                        CappingSubnominalCode = dp.sfa_CappingSubnominal != null ? dp.sfa_CappingSubnominal.Name : null
                    };

                // Group into the required heirarchy
                var allocations = allocationSet.ToList()
                    .Where(
                        a =>
                            allocation.AllocationPeriods.Any(
                                p => (p.Period == a.DeliverablePeriod && p.Aggregations.Any(
                                    ag =>
                                        (ag.SubnominalCode == a.CappingSubnominalCode) ||
                                            (ag.SubnominalCode == a.ProfileSubnominalCode) ||
                                            (ag.SubnominalCode == a.ReconcilationSubnominalCode)))));

                var groupedAllocations = allocations
                    .GroupBy(dp => new { dp.AllocationId, dp.DeliverableId, dp.DeliverablePeriodId })
                    .GroupBy(d => new { d.Key.AllocationId, d.Key.DeliverableId })
                    .GroupBy(a => new { a.Key.AllocationId });

                Guid allocationId;

                try
                {
                    allocationId = groupedAllocations.Single().Key.AllocationId;
                }
                catch (InvalidOperationException)
                {
                    throw new ContractAllocationNotFoundException(
                        "A unique allocation was not found in the CRM Database. Allocation: " + allocation.AllocationNumber);
                }

                // Grab allocation at the top level of the hierarchy
                var xrmAllocation = new sfa_contractallocation
                {
                    Id = allocationId
                };

                // Iterate through the child deliverables and deliverable periods
                var xrmDeliverableCollection = new EntityCollection
                {
                    EntityName = sfa_contractdeliverable.EntityLogicalName,
                };

                foreach (var d in groupedAllocations.Single())
                {
                    var xrmDeliverable = new sfa_contractdeliverable
                    {
                        Id = d.Key.DeliverableId
                    };

                    xrmDeliverableCollection.Entities.Add(xrmDeliverable);

                    var xrmDeliverablePeriodCollection = new EntityCollection
                    {
                        EntityName = sfa_contractdeliverableperiod.EntityLogicalName,
                    };
                    foreach (var dp in d)
                    {
                        var xrmDeliverablePeriod = new sfa_contractdeliverableperiod
                        {
                            Id = dp.Key.DeliverablePeriodId.Value,
                            sfa_PaymentPosted = value
                        };

                        xrmDeliverablePeriodCollection.Entities.Add(xrmDeliverablePeriod);
                    }

                    xrmDeliverable.RelatedEntities.Add(
                        DeliverableToPeriodRelationship,
                        xrmDeliverablePeriodCollection);
                }

                xrmAllocation.RelatedEntities.Add(
                    AllocationToDeliverableRelationship,
                    xrmDeliverableCollection);

                OrgService.Update(xrmAllocation);
            }
        }
    }
}
