namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Services
{ 
    using System.Collections.Generic;
    using System.Linq;
    using MoreLinq;
    using Dto;
    using Repository;
    using Storage;
    using CrossDomain.Integration.Entities.Data;

    public class HeldReportedActualGroupService : IHeldReportedActualGroupEvaluator, IHeldPartitionKeyQueryService
    {
        private readonly IHeldReportedActualGroupQueryRepository _heldReportedActualGroupQueryRepository;
        private readonly IAzureRepository<ActualsCollectionTypeSummary> _actualsCollectionTypeSummaryRepository;
        private readonly IHeldFspCollectionConfigRepository _heldFspCollectionConfigRepository;
        private readonly IClosedCollectionRepository _ClosedCollectionRepository;

        public HeldReportedActualGroupService(IHeldReportedActualGroupQueryRepository heldReportedActualGroupQueryRepository,
            IAzureRepository<ActualsCollectionTypeSummary> actualsCollectionTypeSummaryRepository,
            IHeldFspCollectionConfigRepository heldFspCollectionConfigRepository, IClosedCollectionRepository closedCollectionRepository)
        {
            _heldReportedActualGroupQueryRepository = heldReportedActualGroupQueryRepository;
            _heldFspCollectionConfigRepository = heldFspCollectionConfigRepository;
            _ClosedCollectionRepository = closedCollectionRepository;
            _actualsCollectionTypeSummaryRepository = actualsCollectionTypeSummaryRepository;
        }

        public bool AreAnyHeldReportedActualGroupsReadyToBeProcessed(ConnectionInfo connectionInfo)
        {
            IReadOnlyCollection<HeldActualsForAllocationGrpIdentifier> partitionKeyGroups = GetPartitionKeyGroups(connectionInfo);
            return partitionKeyGroups.Any();
        }

        public IReadOnlyCollection<HeldActualsForAllocationGrpIdentifier> GetPartitionKeyGroups(ConnectionInfo connectionInfo)
        {
            IReadOnlyCollection<AllocationGrpWithCollectionReturns> heldAllocationGrps = _heldReportedActualGroupQueryRepository.GetHeldAllocationGrps(connectionInfo);

            if (heldAllocationGrps.Any())
            {
                List<CollectionReturnWithPartitionKey> emptyCollectionsFromAzureStorage = GetEmptyCollectionsFromActualsCollectionTypeSummaryAzureStorage();
                List<CollectionReturnWithPartitionKey> emptyCollectionsFromPaasTable = GetEmptyCollectionsFromClosedCollectionsPaasTable();

                IList<AllocationGrpWithCollectionReturns> heldAllocationGrpsEnrichedWithEmptyCollections = new List<AllocationGrpWithCollectionReturns>();
                heldAllocationGrps.ForEach(heldAllocationGrp =>
                    {
                        List<CollectionReturnWithPartitionKey> enrichedCollectionReturns = new List<CollectionReturnWithPartitionKey>(heldAllocationGrp.CollectionReturns);
                        enrichedCollectionReturns.AddRange(emptyCollectionsFromAzureStorage);
                        enrichedCollectionReturns.AddRange(emptyCollectionsFromPaasTable);

                        heldAllocationGrpsEnrichedWithEmptyCollections.Add(new AllocationGrpWithCollectionReturns(
                            fundingStreamPeriodCode:heldAllocationGrp.FundingStreamPeriodCode,
                            orgId: heldAllocationGrp.OrgId,
                            uopCode: heldAllocationGrp.UopCode,
                            collectionReturns: enrichedCollectionReturns));
                    }
                );

                var heldAllocGrpsWithEmptyCollectionsGroupedByFsp = heldAllocationGrpsEnrichedWithEmptyCollections
                    .GroupBy(h => h.FundingStreamPeriodCode)
                    .ToDictionary(g => g.Key, g => g.SelectMany(i => i.CollectionReturns).ToHashSet());
                   
                List <HeldActualsForAllocationGrpIdentifier> partitionKeyGroups = new List<HeldActualsForAllocationGrpIdentifier>();
                heldAllocationGrpsEnrichedWithEmptyCollections.ForEach(heldEnrichedAllocationGrp =>
                {
                    IReadOnlyCollection<IReadOnlyCollection<CollectionReturn>> collectionReturnGroupsRequiredForFsp = _heldFspCollectionConfigRepository.GetCollectionReturns(connectionInfo, heldEnrichedAllocationGrp.FundingStreamPeriodCode).Result;

                    var setOfCollectionReturnsForFsp = heldAllocGrpsWithEmptyCollectionsGroupedByFsp[heldEnrichedAllocationGrp.FundingStreamPeriodCode];
                        
                    collectionReturnGroupsRequiredForFsp.ForEach(collectionReturnGroupRequiredForFsp =>
                   {
                       if (collectionReturnGroupRequiredForFsp.All(collectionReturnRequired =>
                           setOfCollectionReturnsForFsp.Contains(collectionReturnRequired)))
                       {
                           IReadOnlyCollection<string> partitionKeys = heldEnrichedAllocationGrp.CollectionReturns
                               .Where(collectionReturnGroupRequiredForFsp.Contains)
                               .Where(h => !string.IsNullOrEmpty(h.PartionKey)) // remove the the empty pks that came from the azure or paas table
                               .Select(h => h.PartionKey)
                               .ToList();
                           partitionKeyGroups.Add(new HeldActualsForAllocationGrpIdentifier(partitionKeys, heldEnrichedAllocationGrp.FundingStreamPeriodCode));
                       }
                   });
                });

                // remove ones where config for the FSP says that they can be processed but the individual returns are not included in the config
                return partitionKeyGroups.Where(p => p.PartitionKeys.Any()).ToList();
            }

            // we haven't got any held Allocations..return an empty
            return new List<HeldActualsForAllocationGrpIdentifier>();
        }

        private List<CollectionReturnWithPartitionKey> GetEmptyCollectionsFromActualsCollectionTypeSummaryAzureStorage()
        {
            return _actualsCollectionTypeSummaryRepository.GetRows()
                .Where(r => r.TotalRows == 0)
                .Select(r => 
                    new CollectionReturnWithPartitionKey(collectionReturnCode: r.CollectionReturnCode, collectionType: r.CollectionType, partitionKey: null))
                .ToList();
        }

        private List<CollectionReturnWithPartitionKey> GetEmptyCollectionsFromClosedCollectionsPaasTable()
        {
            return _ClosedCollectionRepository.GetClosedCollections()
                .Where(cc => cc.TotalRowCount == 0)
                .Select(r => 
                    new CollectionReturnWithPartitionKey(collectionReturnCode: r.CollectionReturnCode, collectionType: r.CollectionType, partitionKey: null))
                .ToList();
        }
    }
}