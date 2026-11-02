
namespace Datafix.Tests.Tests.R105
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Configuration;
    using Infrastructure;
    using Datafix.Tests.Automation.Releases.R105;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Dapper;
    using System.Data.SqlClient;

    [TestClass]
    public class SeedParkingInfoTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void SeedParkingInfo_ShouldCreateRows()
        {
            // arrange
            const int pageNumber = 1;
            const string fundingIdNotInParkingInfoBeforeSeedAndParked = "fundingIdNotInParkingInfoBeforeSeedAndParked";
            const string fundingIdNotInParkingInfoBeforeSeedAndDiscarded = "fundingIdNotInParkingInfoBeforeSeedAndDiscarded";
            const string fundingIdNotInParkingInfoBeforeSeedAndNotParkedOrDiscarded = "fundingIdNotInParkingInfoBeforeSeedAndNotParkedOrDiscarded";
            ClearDown();
            var readId = CreateParentRows(pageNumber);

            CreateFundingAllocationAndParkInfoRows("fundingIdInParkingInfoBeforeSeed1", null, null, readId, pageNumber);
            CreateFundingAllocationAndParkInfoRows("fundingIdInParkingInfoBeforeSeed2", null, null, readId, pageNumber);
            CreateFundingAllocationAndParkInfoRows("fundingIdInParkingInfoBeforeSeed3", null, null, readId, pageNumber);
            CreateFundingAllocationAndParkInfoRows("fundingIdInParkingInfoBeforeSeed4", null, null, readId, pageNumber);
            CreateFundingAllocationAndParkInfoRows("fundingIdInParkingInfoBeforeSeed5", "Withdrawn", "Withdrawn", readId, pageNumber);
            CreateFundingAllocationAndParkInfoRows("fundingIdInParkingInfoBeforeSeed6", "ContractApproved", "ContractApproved", readId, pageNumber);
            CreateFundingAllocationAndParkInfoRows("fundingIdInParkingInfoBeforeSeed7", "Parked", "AwaitingOutcome", readId, pageNumber);

            CreateFundingAllocationOnly($"{fundingIdNotInParkingInfoBeforeSeedAndParked}{1}", "Parked", "AwaitingContractTypeConfig", readId, pageNumber);
            CreateFundingAllocationOnly($"{fundingIdNotInParkingInfoBeforeSeedAndParked}{2}", "Parked", "AwaitingProvider", readId, pageNumber);

            CreateFundingAllocationOnly($"{fundingIdNotInParkingInfoBeforeSeedAndDiscarded}{1}", "Discarded", "NonMaterialUpdate", readId, pageNumber);
            CreateFundingAllocationOnly($"{fundingIdNotInParkingInfoBeforeSeedAndDiscarded}{2}", "Discarded", "Superseded", readId, pageNumber);

            CreateFundingAllocationOnly($"{fundingIdNotInParkingInfoBeforeSeedAndNotParkedOrDiscarded}{1}", null, null, readId, pageNumber);
            CreateFundingAllocationOnly($"{fundingIdNotInParkingInfoBeforeSeedAndNotParkedOrDiscarded}{2}", "ContractApproved", "ContractApproved", readId, pageNumber);
            
            Assert.AreEqual(7, GetParkingInfoFundingIds().Count, "Incorrect number of rows in ParkingInfo before act");
            
            var seed = new SeedParkingInfo();

            // act
            seed.ApplyDataFix();

            // assert
            var parkingInfoFundingIdsAfterAct = GetParkingInfoFundingIds();
            Assert.AreEqual(11, parkingInfoFundingIdsAfterAct.Count, "Incorrect number of rows in ParkingInfo after act");

            Assert.IsTrue(parkingInfoFundingIdsAfterAct.Contains($"{fundingIdNotInParkingInfoBeforeSeedAndParked}{1}"));
            Assert.IsTrue(parkingInfoFundingIdsAfterAct.Contains($"{fundingIdNotInParkingInfoBeforeSeedAndParked}{2}"));

            Assert.IsTrue(parkingInfoFundingIdsAfterAct.Contains($"{fundingIdNotInParkingInfoBeforeSeedAndDiscarded}{1}"));
            Assert.IsTrue(parkingInfoFundingIdsAfterAct.Contains($"{fundingIdNotInParkingInfoBeforeSeedAndDiscarded}{2}"));

            Assert.IsFalse(parkingInfoFundingIdsAfterAct.Contains($"{fundingIdNotInParkingInfoBeforeSeedAndNotParkedOrDiscarded}{1}"));
            Assert.IsFalse(parkingInfoFundingIdsAfterAct.Contains($"{fundingIdNotInParkingInfoBeforeSeedAndNotParkedOrDiscarded}{2}"));
        }


        private static void ClearDown()
        {
            using (var connection = new SqlConnectionWithRetry(ConnectionString))
            {
                const string sql = "DELETE FROM [FundingAllocation].[FeedRead]";
                connection.Execute(sql);
            }
        }

        private static int CreateParentRows(int pageNumber)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                const string sqlFeedRead = @"INSERT INTO [FundingAllocation].[FeedRead] ([CreatedDate]) 
                                             VALUES ( getutcdate());
                                             SELECT CAST(SCOPE_IDENTITY() AS INT)";
                var readId = connection.QuerySingle<int>(sqlFeedRead);

                const string sqlFundingAllocationPageControl = @"INSERT INTO [FundingAllocation].[FundingAllocationPageControl]  
                                                                 ([ReadId],[PageNumber]) VALUES (@ReadId, @PageNumber)";

                connection.Execute(sqlFundingAllocationPageControl, param: new { readId, pageNumber });
                return readId;
            }
        }

        private static void CreateFundingAllocationAndParkInfoRows(string fundingId, string status, string subStatus, int readId, int pageNumber)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                const string sql = @"INSERT INTO [FundingAllocation].[FundingAllocation] 
                                                      ([FundingId],[Status],[SubStatus],[ReadId],[PageNumber]) 
                                                      VALUES (@fundingId, @status, @subStatus, @readId, @pageNumber);

                                                      INSERT INTO [FundingAllocation].[ParkingInfo] 
                                                      ([FundingAllocationId],[LastParked]) 
                                                      VALUES (@fundingId, getutcdate())";

                connection.Execute(sql, param: new { fundingId, status, subStatus, readId, pageNumber });
            }
        }

        private static void CreateFundingAllocationOnly(string fundingId, string status, string subStatus, int readId, int pageNumber)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                const string sql = @"INSERT INTO [FundingAllocation].[FundingAllocation] 
                                                      ([FundingId],[Status],[SubStatus],[ReadId],[PageNumber]) 
                                                      VALUES (@fundingId, @status, @subStatus, @readId, @pageNumber)";

                connection.Execute(sql, param: new { fundingId, status, subStatus, readId, pageNumber });
            }
        }

        private static IReadOnlyCollection<string> GetParkingInfoFundingIds()
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                const string sql = @"SELECT [FundingAllocationId] FROM [FundingAllocation].[ParkingInfo]";
                return connection.Query<string>(sql).ToList();
            }
        }
        
        private static string ConnectionString => ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
    }
}