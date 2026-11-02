namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository
{
    using System;
    using System.Collections.Generic;
    using DataStore;
    using DataStore.Model;
    using System.Data.Entity;
    using System.Data.SqlClient;
    using System.Linq;
    using AllocationDelivery.Messages.DTOs;
    using CrossDomain.Integration.Entities.Data;
    using Dto;
    using MoreLinq;

    public class HeldReportedActualGroupRepository : IHeldReportedActualGroupCommandRepository, IHeldReportedActualGroupQueryRepository
    {
        public void Add(HeldReportedActualGroup heldReportedActualGroup, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                context.HeldReportedActualGroups.Add(heldReportedActualGroup);
                context.SaveChanges();
            }
        }

        public IReadOnlyCollection<AllocationGrpWithCollectionReturns> GetHeldAllocationGrps(ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                return GetHeldAllocationGrps(context);
            }
        }

        public IReadOnlyCollection<SummarisedActualOrgFspGroupKey> GetSummarisedActualOrgFspGroupKeys(ConnectionInfo connectionInfo, IReadOnlyCollection<string> partitionKeys)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                return GetSummarisedActualOrgFspGroupKeys(context, partitionKeys);
            }
        }

        public void SetHeldReportedActualGroupsToProcessed(ConnectionInfo connectionInfo, IReadOnlyCollection<string> partitionKeys)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                SetHeldReportedActualGroupsToProcessed(context, partitionKeys);
            }
        }

        private static IReadOnlyCollection<AllocationGrpWithCollectionReturns> GetHeldAllocationGrps(MonitoringDeliverablesDbContext context)
        {
            var fspGroups = context.HeldReportedActualGroups
                .Where(h => h.ProcessedDate == null)
                .GroupBy(h => new {h.FundingStreamPeriodCode, h.OrganisationIdentifier, h.UoPCode}).ToList();

            return fspGroups.Select(fsp => new AllocationGrpWithCollectionReturns(fsp.Key.FundingStreamPeriodCode, fsp.Key.OrganisationIdentifier, fsp.Key.UoPCode,
                fsp.Select(g => new CollectionReturnWithPartitionKey(collectionReturnCode: g.CollectionReturnCode, collectionType: g.CollectionType, partitionKey: g.PartitionKey)).ToList())).ToList();
        }

        private static void SetHeldReportedActualGroupsToProcessed(DbContext context, IReadOnlyCollection<string> partitionKeys)
        {
            const int batchSize = 20;
            DateTime now = DateTime.UtcNow;
            partitionKeys.Batch(batchSize).ForEach(batch =>
            {
                string csPartitionKeys = string.Join(",", batch.Select(pk => $"'{pk}'"));
                context.Database.ExecuteSqlCommand($"update [MonitoringDeliverables].[HeldReportedActualGroup] set ProcessedDate = @now where PartitionKey in ({csPartitionKeys})", new SqlParameter("@now", now));
            });
        }

        private static IReadOnlyCollection<SummarisedActualOrgFspGroupKey> GetSummarisedActualOrgFspGroupKeys(MonitoringDeliverablesDbContext context, IReadOnlyCollection<string> partitionKeys)
        {
            return context.HeldReportedActualGroups
                .Where(g => partitionKeys.Contains(g.PartitionKey))
                .Select(g => new SummarisedActualOrgFspGroupKey
                {
                    CollectionType = g.CollectionType,
                    CollectionReturnCode = g.CollectionReturnCode,
                    FundingStreamPeriodCode = g.FundingStreamPeriodCode,
                    OrganisationId = g.OrganisationIdentifier,
                    UopCode = g.UoPCode
                }).ToList();
        }
    }
}
