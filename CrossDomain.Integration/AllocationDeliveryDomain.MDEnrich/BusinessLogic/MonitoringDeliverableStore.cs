
using SFA.FCT.AllocationDeliveryDomain.Common;
using SFA.FCT.AllocationDeliveryDomain.MDEnrich.DataStore;
using SFA.FCT.AllocationDeliveryDomain.MDEnrich.DataStore.Model;
using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
using SFA.FCT.Framework.Logging.Interfaces;

namespace SFA.FCT.AllocationDeliveryDomain.MDEnrich.BusinessLogic
{
    using System.Collections.Generic;

    public class MonitoringDeliverableStore : IMonitoringDeliverableStore
    {
        public IMonitoringDeliverablesDbContext Context { get; set; }

        public ILogger Logger { get; set; }

        public void RemoveAllocation(allocationType allocation)
        {
            string organisationId = allocation.contractorReference.organisationIdentifier;
            string fundingStreamPeriodCode = allocation.fundingStreamPeriod.fundingStreamPeriodCode;
            string uopCode = allocation.uopCode ?? string.Empty;

            int deletedRecords =
                Context.Database.ExecuteSqlCommand(
                    "EXEC MonitoringDeliverables.DeleteAllDeliverablePeriodsForAllocation @p0, @p1, @p2",
                    organisationId,
                    fundingStreamPeriodCode,
                    uopCode);

            Logger.LogInformation(AllocationDeliverDomainEventLoggingId.DeletingAllocationDeliverables,
                "Deleted {0} deliverable periods for allocation with OrganisationId: {1}, FundingStreamPeriodCode: {2}, UopCode: {3}",
                deletedRecords, organisationId, fundingStreamPeriodCode, uopCode);
        }

        public void StoreAllocation(allocationType allocation)
        {
            string organisationId = allocation.contractorReference.organisationIdentifier;
            string fundingStreamPeriodCode = allocation.fundingStreamPeriod.fundingStreamPeriodCode;
            string uopCode = allocation.uopCode ?? string.Empty;

            var flattenedDeliverables = allocation.FlattenDeliverables(allocation.contractDeliverables);

            flattenedDeliverables.ForEach(d =>
            {
                d.contractDeliverablePeriods.ForEach(dp =>
                {
                    AllocationDeliverablePeriod allocationDeliverablePeriodItem = new AllocationDeliverablePeriod
                    {
                        //Key fields
                        OrganisationId = organisationId,
                        FundingStreamPeriodCode = fundingStreamPeriodCode,
                        UopCode = uopCode,
                        DeliverableCode = d.deliverable.deliverableCode,
                        Period = dp.period.periodValue

                        //Enrichment fields (for validation / publish)
                    };
                    Context.AllocationDeliverablePeriods.Add(allocationDeliverablePeriodItem);
                });              
            });

            Logger.LogInformation(AllocationDeliverDomainEventLoggingId.InsertingAllocationDeliverables,
                "Inserted {0} deliverable periods for allocation with OrganisationId: {1}, FundingStreamPeriodCode: {2}, UopCode: {3}", 
                flattenedDeliverables.Count,organisationId, fundingStreamPeriodCode, uopCode);
        }

        public IEnumerable<AllocationDeliverablePeriod> GetAllocationDeliverablePeriods(string organisationId, string fundingStreamPeriodCode, string uopCode)
        {
            throw new System.NotImplementedException();
        }
    }
}
