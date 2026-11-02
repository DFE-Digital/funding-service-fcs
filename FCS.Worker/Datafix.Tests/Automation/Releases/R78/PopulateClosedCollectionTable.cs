namespace Datafix.Tests.Automation.Releases.R78
{
    using System.Linq;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using System;
    using System.Collections.Generic;

    public class PopulateClosedCollectionTable : IApplyDataFix
    {
        public string Release => "R78";

        public int StoryNumber => 24329;

        public string Name => "Populate ClosedCollection table with data from Azure tables";

        public int Order => 1;

        public void ApplyDataFix()
        {
            var azureTableStore = new AzureTableStore();
            var environmentContext = new EnvironmentContext();

            var closedCollectionHistoryRepository =
                new AzureRepository<ClosedCollectionHistory>(azureTableStore, environmentContext);

            var actualsCollectionTypeSummaryRepository =
                new AzureRepository<ActualsCollectionTypeSummary>(azureTableStore, environmentContext);

            var allClosedCollections = closedCollectionHistoryRepository.GetRows().ToList();
            var allActualsCollectionTypeSummaries = actualsCollectionTypeSummaryRepository.GetRows().ToList();

            using (var context = new MonitoringDeliverablesDbContext())
            {
                allClosedCollections.ForEach(cc =>
                {
                    var closedTime = cc.LastClosedTime;

                    var actualsCollectionTypeSummariesForAClosedCollectionType = allActualsCollectionTypeSummaries
                        .Where(aacts => aacts.CollectionType == cc.CollectionType).ToList();

                    AddAllClosedCollectionsForACollectionType(actualsCollectionTypeSummariesForAClosedCollectionType,
                        closedTime, context);

                    context.SaveChanges();
                });
            }
        }

        private static void AddAllClosedCollectionsForACollectionType(
            List<ActualsCollectionTypeSummary> actualsCollectionTypeSummaries,
            DateTime closedTime,
            MonitoringDeliverablesDbContext context)
        {
            actualsCollectionTypeSummaries.ForEach(acts =>
            {
                context.ClosedCollections.Add(
                    new ClosedCollection(
                            acts.CollectionType,
                            acts.CollectionReturnCode,
                            closedTime,
                            acts.TotalRows)
                    { RetrievedRowCount = acts.CurrentNumberOfRows }
                );
            });

        }
    }
}