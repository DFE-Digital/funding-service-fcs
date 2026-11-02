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
    public class HeldFspCollectionConfigRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public async Task HeldFspCollectionConfigRepository_GetCollectionReturns_ShouldGetListOfAListOfCollectionReturns()
        {
            // arrange
            const int multipleCollectionGroupId1 = 8000;
            const int multipleCollectionGroupId2 = 9000;
            const string fundingStreamPeriodCode = "FSP_List";
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
                var configs = await repository.GetCollectionReturns(ConnectionInfo.CreateFrom(context.Database.Connection), fundingStreamPeriodCode);

                // assert
                Assert.IsNotNull(configs, "no configs retreived");
                Assert.AreEqual(2, configs.Count, "Incorrect number of configs retreived");

                IReadOnlyCollection<CollectionReturn> first = configs.First();
                Assert.AreEqual(3, first.Count, "Incorrect number of Config CollectionReturns retreived in first group id");
                Assert.IsNotNull(first.Single(x => x.CollectionType == "ILR1619_1" && x.CollectionReturnCode == "R01_1"), "Incorrect CollectionReturn in first group id");
                Assert.IsNotNull(first.Single(x => x.CollectionType == "APPS_1" && x.CollectionReturnCode == "APPS16_1"), "Incorrect CollectionReturn in first group id");
                Assert.IsNotNull(first.Single(x => x.CollectionType == "RND_1" && x.CollectionReturnCode == "RND60_1"), "Incorrect CollectionReturn in first group id");


                IReadOnlyCollection<CollectionReturn> last = configs.Last();
                Assert.AreEqual(2, last.Count, "Incorrect number of Config CollectionReturns retreived in second group id");
                Assert.IsNotNull(last.Single(x => x.CollectionType == "ILR1619_2" && x.CollectionReturnCode == "R13_2"), "Incorrect CollectionReturn in second group id");
                Assert.IsNotNull(last.Single(x => x.CollectionType == "APPS_2" && x.CollectionReturnCode == "APPS29_2"), "Incorrect CollectionReturn in second group id");
            }

            ClearDownHeldFspCollectionConfigForFsp(fundingStreamPeriodCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task HeldFspCollectionConfigRepository_GetCollectionReturns_ShouldReturnAnEmptyListOfAListOfCollectionReturns()
        {
            // arrange
            const int multipleCollectionGroupId1 = 8000;
            const int multipleCollectionGroupId2 = 9000;
            const string fundingStreamPeriodCode = "FSP_Empty_List";
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
            ClearDownHeldFspCollectionConfigForFsp(fundingStreamPeriodCode);

            using (var context = new MonitoringDeliverablesDbContext())
            {
                HeldFspCollectionConfigRepository repository = new HeldFspCollectionConfigRepository();

                // act
                var configs = await repository.GetCollectionReturns(ConnectionInfo.CreateFrom(context.Database.Connection), fundingStreamPeriodCode);

                // assert
                Assert.AreEqual(0, configs.Count, "Incorrect number of configs returned");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task HeldFspCollectionConfigRepository_GetCollectionReturns_ShouldGetCorrectFspListOfAListOfCollectionReturns()
        {
            // arrange
            const int multipleCollectionGroupId1_FSP1 = 18000;
            const int multipleCollectionGroupId2_FSP1 = 19000;
            const string fundingStreamPeriodCode_FSP1 = "FSP1";
            ClearDownHeldFspCollectionConfigForFsp(fundingStreamPeriodCode_FSP1);

            const int multipleCollectionGroupId1_FSP2 = 28000;
            const int multipleCollectionGroupId2_FSP2 = 29000;
            const string fundingStreamPeriodCode_FSP2 = "FSP2";
            ClearDownHeldFspCollectionConfigForFsp(fundingStreamPeriodCode_FSP2);

            List<HeldFspCollectionConfig> heldReportedActualGroups_FSP1 = new List<HeldFspCollectionConfig>
            {
                new HeldFspCollectionConfig( multipleCollectionGroupId1_FSP1, fundingStreamPeriodCode_FSP1, collectionType: "ILR1619_FSP1_1", collectionReturnCode: "R01_1_1"),
                new HeldFspCollectionConfig( multipleCollectionGroupId1_FSP1, fundingStreamPeriodCode_FSP1, collectionType: "APPS_FSP1_1", collectionReturnCode: "APPS16_1_1"),
                new HeldFspCollectionConfig( multipleCollectionGroupId1_FSP1, fundingStreamPeriodCode_FSP1, collectionType: "RND_FSP1_1", collectionReturnCode: "RND60_1_1"),
                new HeldFspCollectionConfig( multipleCollectionGroupId2_FSP1, fundingStreamPeriodCode_FSP1, collectionType: "ILR1619_FSP1_2", collectionReturnCode: "R13_1_2"),
                new HeldFspCollectionConfig( multipleCollectionGroupId2_FSP1, fundingStreamPeriodCode_FSP1, collectionType: "APPS_FSP1_2", collectionReturnCode: "APPS29_1_2")
            };
            AddItems(heldReportedActualGroups_FSP1);

            List<HeldFspCollectionConfig> heldReportedActualGroups_FSP2 = new List<HeldFspCollectionConfig>
            {
                new HeldFspCollectionConfig( multipleCollectionGroupId1_FSP2, fundingStreamPeriodCode_FSP2, collectionType: "ILR1619_FSP2_1", collectionReturnCode: "R01_2_1"),
                new HeldFspCollectionConfig( multipleCollectionGroupId1_FSP2, fundingStreamPeriodCode_FSP2, collectionType: "APPSAPPS_FSP3_1_3", collectionReturnCode: "APPS16_2_1"),
                new HeldFspCollectionConfig( multipleCollectionGroupId1_FSP2, fundingStreamPeriodCode_FSP2, collectionType: "RND_FSP2_1", collectionReturnCode: "RND60_2_1"),
                new HeldFspCollectionConfig( multipleCollectionGroupId2_FSP2, fundingStreamPeriodCode_FSP2, collectionType: "ILR1619_FSP2_2", collectionReturnCode: "R13_2_2"),
                new HeldFspCollectionConfig( multipleCollectionGroupId2_FSP2, fundingStreamPeriodCode_FSP2, collectionType: "APPS_FSP2_2", collectionReturnCode: "APPS29_2_2")
            };
            AddItems(heldReportedActualGroups_FSP2);


            using (var context = new MonitoringDeliverablesDbContext())
            {
                HeldFspCollectionConfigRepository repository = new HeldFspCollectionConfigRepository();

                // act
                var configs = await repository.GetCollectionReturns(ConnectionInfo.CreateFrom(context.Database.Connection), fundingStreamPeriodCode_FSP1);

                // assert
                Assert.IsNotNull(configs, "no configs retreived");
                Assert.AreEqual(2, configs.Count, "Incorrect number of configs retreived");

                IReadOnlyCollection<CollectionReturn> first = configs.First();
                Assert.AreEqual(3, first.Count, "Incorrect number of Config CollectionReturns retreived in first group id");
                Assert.IsNotNull(first.Single(x => x.CollectionType == "ILR1619_FSP1_1" && x.CollectionReturnCode == "R01_1_1"), "Incorrect CollectionReturn in first group id");
                Assert.IsNotNull(first.Single(x => x.CollectionType == "APPS_FSP1_1" && x.CollectionReturnCode == "APPS16_1_1"), "Incorrect CollectionReturn in first group id");
                Assert.IsNotNull(first.Single(x => x.CollectionType == "RND_FSP1_1" && x.CollectionReturnCode == "RND60_1_1"), "Incorrect CollectionReturn in first group id");


                IReadOnlyCollection<CollectionReturn> last = configs.Last();
                Assert.AreEqual(2, last.Count, "Incorrect number of Config CollectionReturns retreived in second group id");
                Assert.IsNotNull(last.Single(x => x.CollectionType == "ILR1619_FSP1_2" && x.CollectionReturnCode == "R13_1_2"), "Incorrect CollectionReturn in second group id");
                Assert.IsNotNull(last.Single(x => x.CollectionType == "APPS_FSP1_2" && x.CollectionReturnCode == "APPS29_1_2"), "Incorrect CollectionReturn in second group id");
            }

            ClearDownHeldFspCollectionConfigForFsp(fundingStreamPeriodCode_FSP1);
            ClearDownHeldFspCollectionConfigForFsp(fundingStreamPeriodCode_FSP2);
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