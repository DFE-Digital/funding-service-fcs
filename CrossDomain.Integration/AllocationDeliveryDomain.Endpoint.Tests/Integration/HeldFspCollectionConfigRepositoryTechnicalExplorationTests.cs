namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Castle.Core.Internal;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Dto;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class HeldFspCollectionConfigRepositoryTechnicalExplorationTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public async Task HeldFspCollectionConfigRepository_GetCollectionReturns_ShouldOnlyCallPrivateMethodGetConfigFromDbOnceWhenGetCollectionReturnsIsCalledTwice()
        {
            // arrange
            const int multipleCollectionGroupId1 = 8000;
            const int multipleCollectionGroupId2 = 9000;
            const string fundingStreamPeriodCode = "FSP_Tech_Exp";
            ClearDownHeldFspCollectionConfigForFsp(fundingStreamPeriodCode);

            List<HeldFspCollectionConfig> heldReportedActualGroups = new List<HeldFspCollectionConfig>
            {
                new HeldFspCollectionConfig( multipleCollectionGroupId1, fundingStreamPeriodCode, collectionType: "ILR1619_1", collectionReturnCode: "R01_1"),
                new HeldFspCollectionConfig( multipleCollectionGroupId1, fundingStreamPeriodCode, collectionType: "APPS_1", collectionReturnCode: "APPS16_1"),
                new HeldFspCollectionConfig( multipleCollectionGroupId1, fundingStreamPeriodCode, collectionType: "RND_1", collectionReturnCode: "RND60_1"),
                new HeldFspCollectionConfig( multipleCollectionGroupId2, fundingStreamPeriodCode, collectionType: "ILR1619_2", collectionReturnCode: "R13_2"),
                new HeldFspCollectionConfig( multipleCollectionGroupId2, fundingStreamPeriodCode, collectionType: "APPS_2", collectionReturnCode: "APPS29_2")
            };
            AddItems(heldReportedActualGroups);

            using (var context = new MonitoringDeliverablesDbContext())
            {
                HeldFspCollectionConfigRepository repository = new HeldFspCollectionConfigRepository();

                // act
                IReadOnlyCollection<IReadOnlyCollection<CollectionReturn>> configsFirstCall = await repository.GetCollectionReturns(ConnectionInfo.CreateDefault(), fundingStreamPeriodCode);
                IReadOnlyCollection<IReadOnlyCollection<CollectionReturn>> configsSecondCall = await repository.GetCollectionReturns(ConnectionInfo.CreateDefault(), fundingStreamPeriodCode);
            }
            ClearDownHeldFspCollectionConfigForFsp(fundingStreamPeriodCode); // this is here to prevent config extract compare diffs
        }

        private static void ClearDownHeldFspCollectionConfigForFsp(string fundingStreamPeriodCode)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.HeldFspCollectionConfigs.Where(h => h.FundingStreamPeriodCode == fundingStreamPeriodCode).ToList()
                    .ForEach(h => context.HeldFspCollectionConfigs.Remove(h));

                context.SaveChanges();
            }
        }

        private static void AddItems(List<HeldFspCollectionConfig> heldFspCollectionConfigs)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                foreach (var heldFspCollectionConfig in heldFspCollectionConfigs)
                {
                    context.HeldFspCollectionConfigs.Add(new HeldFspCollectionConfig(heldFspCollectionConfig.MultipleCollectionGroupId,
                        heldFspCollectionConfig.FundingStreamPeriodCode,
                        heldFspCollectionConfig.CollectionType,
                        heldFspCollectionConfig.CollectionReturnCode));
                }

                context.SaveChanges();
            }
        }
    }
}