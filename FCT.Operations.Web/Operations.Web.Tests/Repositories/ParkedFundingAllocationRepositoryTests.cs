namespace Operations.Web.Tests.Repositories
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Web.Repositories;
    using FluentAssertions;

    [TestClass]
    public class ParkedFundingAllocationRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ParkedFundingAllocationRepository_GetSubStatusCounts_ShouldReturnCorrectSubStatusCount()
        {
            // arrange
            const string subStatusAwaitingOutcome = "AwaitingOutcome";
            const int pageNumber = 1;
            ClearAllFundingAllocationRows();

            var readId= InsertFeedReadRowAndGetReadId();
            InsertPageControl(readId, pageNumber);

            InsertFundingAllocationRow($"FundingId_AwaitingOutcome", "Parked", subStatusAwaitingOutcome, readId);
            InsertFundingAllocationRow($"FundingId_AwaitingRelease", "Scheduling", "AwaitingRelease", readId);
            InsertFundingAllocationRow($"FundingId_ContractApprove", "ContractApproved", "ContractApproved", readId);

            var repository = new ParkedFundingAllocationRepository();

            // act
            var rows = repository.GetSubStatusCounts().Result;

            // assert
            Assert.AreEqual(1, rows.Count, "The number of rows returned is not right");
            Assert.AreEqual(1, rows.First().Count, "Returned substatus count is incorrect" );
            Assert.AreEqual(subStatusAwaitingOutcome, rows.First().SubStatus, "Returned substatus name is incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ParkedFundingAllocationRepository_GetSubStatusCounts_ShouldReturnAnEmptyCollection()
        {
            // arrange
            const int pageNumber = 1;
            ClearAllFundingAllocationRows();

            var readId = InsertFeedReadRowAndGetReadId();
            InsertPageControl(readId, pageNumber);

            InsertFundingAllocationRow($"FundingId_AwaitingRelease", "Scheduling", "AwaitingRelease", readId);
            InsertFundingAllocationRow($"FundingId_ContractApprove", "ContractApproved", "ContractApproved", readId);

            var repository = new ParkedFundingAllocationRepository();

            // act
            var rows = repository.GetSubStatusCounts().Result;

            // assert
            Assert.AreEqual(0, rows.Count, "The number of rows returned is not right");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ParkedFundingAllocationRepository_GetAwaitingProviderDetails_ShouldReturnTheRightRows()
        {
            // arrange
            const int pageNumber = 1;
            const int ukprn = 87654321;
            const string providerType = "Furth";
            const string providerSubType = "01GFE";
            const string parkedFundingId = "1619-AS-2122-Contract-LocalAuthority-10000951-1_1";
            const string providerFundingId = "1619-AS-2021-10026200-3_2";
            DateTime now = DateTime.UtcNow;

            ClearAllFundingAllocationRows();

            var readId = InsertFeedReadRowAndGetReadId();
            InsertPageControl(readId, pageNumber);

            InsertFundingAllocationRow("FundingId_AwaitingRelease", "Scheduling", "AwaitingRelease", readId);
            InsertFundingAllocationRow("FundingId_ContractApprove", "ContractApproved", "ContractApproved", readId);
            InsertFundingAllocationRow(parkedFundingId, "Parked", "AwaitingProvider", readId, ukprn:ukprn);
            InsertProviderFunding(providerFundingId, providerType, providerSubType);
            InsertProviderFundingAllocation(providerFundingId, parkedFundingId);
            InsertParkingInfo(parkedFundingId, now);

            var repository = new ParkedFundingAllocationRepository();

            // act
            var rows = repository.GetAwaitingProviderDetails().Result;

            // assert
            rows.Count.Should().Be(1);
            var row = rows.Single();
            row.Ukprn.Should().Be(ukprn.ToString());
            row.ProviderType.Should().Be(providerType);
            row.ProviderSubType.Should().Be(providerSubType);
            row.LastParked.ToDateTimeWithoutMilliseconds().Should().Be(now.ToDateTimeWithoutMilliseconds());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ParkedFundingAllocationRepository_GetAwaitingFundingLineDetails_ShouldReturnTheRightRows()
        {
            // arrange
            const int pageNumber = 1;
            const int ukprn = 87654321;
            const string parkedFundingId = "1619-AS-2122-Contract-LocalAuthority-10000951-1_1";
            const string parkedFundingId2 = "1619-AS-2122-Contract-LocalAuthority-10000952-1_1";
            const string allocationFundingStream = "1619";
            const string cfsPeriod = "AS-2122";

            ClearAllFundingAllocationRows();

            var readId = InsertFeedReadRowAndGetReadId();
            InsertPageControl(readId, pageNumber);

            InsertFundingAllocationRow("FundingId_AwaitingRelease", "Scheduling", "AwaitingRelease", readId);
            InsertFundingAllocationRow("FundingId_ContractApprove", "ContractApproved", "ContractApproved", readId);
            InsertFundingAllocationRow(parkedFundingId, "Parked", "AwaitingFundingLineConfig", readId, ukprn: ukprn, period:cfsPeriod, allocationFundingStream:allocationFundingStream);
            InsertFundingAllocationRow(parkedFundingId2, "Parked", "AwaitingFundingLineConfig", readId, ukprn: ukprn, period: cfsPeriod, allocationFundingStream: allocationFundingStream);

            var repository = new ParkedFundingAllocationRepository();

            // act
            var rows = repository.GetAwaitingFundingLineDetails().Result;

            // assert
            rows.Count.Should().Be(1);
            var row = rows.Single();
            row.CfsFundingPeriod.Should().Be(cfsPeriod);
            row.CfsFundingStream.Should().Be(allocationFundingStream);
            row.CountOfFAs.Should().Be(2);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ParkedFundingAllocationRepository_GetAwaitingFundingAllocationDetails_ShouldReturnTheRightRows()
        {
            // arrange
            const int pageNumber = 1;
            const int ukprn = 87654321;
            const string parkedFundingId = "1619-AS-2122-Contract-LocalAuthority-10000951-1_1";
            const string parkedFundingId2 = "1619-AS-2122-Contract-LocalAuthority-10000952-1_1";
            const string allocationFundingStream = "1619";
            const string cfsPeriod = "AS-2122";

            ClearAllFundingAllocationRows();

            var readId = InsertFeedReadRowAndGetReadId();
            InsertPageControl(readId, pageNumber);

            InsertFundingAllocationRow("FundingId_AwaitingRelease", "Scheduling", "AwaitingRelease", readId);
            InsertFundingAllocationRow("FundingId_ContractApprove", "ContractApproved", "ContractApproved", readId);
            InsertFundingAllocationRow(parkedFundingId, "Parked", "AwaitingFundingAllocationConfig", readId, ukprn: ukprn, period: cfsPeriod, allocationFundingStream: allocationFundingStream);
            InsertFundingAllocationRow(parkedFundingId2, "Parked", "AwaitingFundingAllocationConfig", readId, ukprn: ukprn, period: cfsPeriod, allocationFundingStream: allocationFundingStream);

            var repository = new ParkedFundingAllocationRepository();

            // act
            var rows = repository.GetAwaitingFundingAllocationDetails().Result;

            // assert
            rows.Count.Should().Be(1);
            var row = rows.Single();
            row.CfsFundingPeriod.Should().Be(cfsPeriod);
            row.CfsFundingStream.Should().Be(allocationFundingStream);
            row.CountOfFAs.Should().Be(2);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ParkedFundingAllocationRepository_GetAwaitingContractTypeDetails_ShouldReturnTheRightRows()
        {
            // arrange
            const int pageNumber = 1;
            const int ukprn1 = 87654321;
            const int ukprn2 = 87654322;
            const string providerType = "Furth";
            const string providerSubType = "01GFE";
            const string parkedFundingId = "1619-AS-2122-Contract-LocalAuthority-10000951-1_1";
            const string parkedFundingId2 = "1619-AS-2122-Contract-LocalAuthority-10000952-1_1";
            const string providerFundingId = "1619-AS-2021-10026200-3_2";
            const string providerFundingId2 = "1619-AS-2021-10026201-3_2";
            DateTime now = DateTime.UtcNow;
            const string allocationFundingStream = "1619";
            const string cfsPeriod = "AS-2122";
            const string fcsFundingTypeCode = "EDSK";
            const string fcsPeriod = "AY2122";

            ClearAllFundingAllocationRows();

            var readId = InsertFeedReadRowAndGetReadId();
            InsertPageControl(readId, pageNumber);

            InsertFundingAllocationRow("FundingId_AwaitingRelease", "Scheduling", "AwaitingRelease", readId);
            InsertFundingAllocationRow("FundingId_ContractApprove", "ContractApproved", "ContractApproved", readId);
            InsertFundingAllocationRow(parkedFundingId, "Parked", "AwaitingContractTypeConfig", readId, ukprn: ukprn1, period: cfsPeriod, allocationFundingStream: allocationFundingStream);
            InsertFundingAllocationRow(parkedFundingId2, "Parked", "AwaitingContractTypeConfig", readId, ukprn: ukprn2, period: cfsPeriod, allocationFundingStream: allocationFundingStream);
            InsertProviderFunding(providerFundingId, providerType, providerSubType);
            InsertProviderFunding(providerFundingId2, providerType, providerSubType);
            InsertProviderFundingAllocation(providerFundingId, parkedFundingId);
            InsertProviderFundingAllocation(providerFundingId2, parkedFundingId2);
            InsertAllocationFundingStreamConfig(allocationFundingStream, cfsPeriod, fcsFundingTypeCode, fcsPeriod);
            InsertParkingInfo(parkedFundingId, now);
            InsertParkingInfo(parkedFundingId2, now.AddDays(1));

            var repository = new ParkedFundingAllocationRepository();

            // act
            var rows = repository.GetAwaitingContractTypeDetails().Result;

            // assert
            rows.Count.Should().Be(2);
            var rowForUkprn1 = rows.Single(r => r.Ukprn == ukprn1.ToString());
            rowForUkprn1.FcsFundingType.Should().Be(fcsFundingTypeCode);
            rowForUkprn1.FcsFundingPeriod.Should().Be(fcsPeriod);
            rowForUkprn1.ProviderSubType.Should().Be(providerSubType);
            rowForUkprn1.ProviderType.Should().Be(providerType);
            rowForUkprn1.LastParked.ToDateTimeWithoutMilliseconds().Should().Be(now.ToDateTimeWithoutMilliseconds());
            var rowForUkprn2 = rows.Single(r => r.Ukprn == ukprn2.ToString());
            rowForUkprn2.FcsFundingType.Should().Be(fcsFundingTypeCode);
            rowForUkprn2.FcsFundingPeriod.Should().Be(fcsPeriod);
            rowForUkprn2.ProviderSubType.Should().Be(providerSubType);
            rowForUkprn2.ProviderType.Should().Be(providerType);
            rowForUkprn2.LastParked.ToDateTimeWithoutMilliseconds().Should().Be(now.AddDays(1).ToDateTimeWithoutMilliseconds());
        }


        [TestMethod, TestCategory("IntegrationTest")]
        public void ParkedFundingAllocationRepository_GetUnknownProviderTypeSubtypeDetails_ShouldReturnTheRightRows()
        {
            // arrange
            const int pageNumber = 1;
            const int ukprn1 = 87654321;
            const int ukprn2 = 87654322;
            const string providerType = "Local authority maintained schools";
            const string providerSubType = "Community school";
            const string parkedFundingId = "1619-AS-2122-Contract-LocalAuthority-10000951-1_1";
            const string parkedFundingId2 = "1619-AS-2122-Contract-LocalAuthority-10000952-1_1";
            const string providerFundingId = "1619-AS-2021-10026200-3_2";
            const string providerFundingId2 = "1619-AS-2021-10026201-3_2";
            const string allocationFundingStream = "1619";
            const string cfsPeriod = "AS-2223";
            ClearAllFundingAllocationRows();

            var readId = InsertFeedReadRowAndGetReadId();
            InsertPageControl(readId, pageNumber);

            InsertFundingAllocationRow(parkedFundingId, "Parked", "AwaitingContractTypeConfig", readId, ukprn: ukprn1, period: cfsPeriod, allocationFundingStream: allocationFundingStream);
            InsertFundingAllocationRow(parkedFundingId2, "Parked", "AwaitingContractTypeConfig", readId, ukprn: ukprn2, period: cfsPeriod, allocationFundingStream: allocationFundingStream);
            InsertProviderFunding(providerFundingId, providerType, providerSubType);
            InsertProviderFunding(providerFundingId2, providerType, providerSubType);
            InsertProviderFundingAllocation(providerFundingId, parkedFundingId);
            InsertProviderFundingAllocation(providerFundingId2, parkedFundingId2);

            var repository = new ParkedFundingAllocationRepository();

            // act
            var rows = repository.GetUnknownProviderTypeSubtypeDetails().Result;

            // assert
            rows.Count.Should().Be(1);
            var row = rows.First();
            row.CfsFundingPeriod.Should().Be(cfsPeriod);
            row.ProviderType.Should().Be(providerType);
            row.ProviderSubType.Should().Be(providerSubType);
            row.ProviderType.Should().Be(providerType);
        }

        private static void ClearAllFundingAllocationRows()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = "delete FROM [FundingAllocation].[FundingAllocation]";

                connection.Execute(sql);

                const string sqlDeleteProviderFunding = "delete FROM [FundingAllocation].[ProviderFunding]";

                connection.Execute(sqlDeleteProviderFunding);

                const string sqlDeleteAllocationFunding = "delete FROM [FundingAllocation].[AllocationFundingStreamConfig]";

                connection.Execute(sqlDeleteAllocationFunding);

                const string sqlDeleteProviderTypeConfig = "delete FROM [FundingAllocation].[ProviderTypeConfig]";

                connection.Execute(sqlDeleteProviderTypeConfig);
            }
        }

        private static void InsertFundingAllocationRow(string fundingId, string status, string subStatus, int readId, int pageNumber = 1, int ukprn = 12345678, string period = "AS-2122", string allocationFundingStream = "1619")
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"INSERT INTO [FundingAllocation].[FundingAllocation]
                                           ([FundingId]
                                           ,[Status]
                                           ,[SubStatus]
		                                   ,ReadId
                                           ,PageNumber
                                           ,Ukprn
                                           ,AllocationFundingStream
                                           ,Period)
                                     VALUES
                                           (@fundingId, @status, @subStatus, @readId, @pageNumber, @ukprn, @allocationFundingStream, @period)";

                connection.Execute(sql, param: new { fundingId, status, subStatus, readId, pageNumber, ukprn, allocationFundingStream, period});
            }
        }

        private static void InsertProviderFunding(string providerFundingId, string providerType, string providerSubType, int ukprn = 12345678)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"INSERT INTO [FundingAllocation].[ProviderFunding]
                                           ([ProviderFundingId]
                                           ,[DeliveryUkprn]
                                           ,[ProviderType]
		                                   ,[ProviderSubType])
                                     VALUES
                                           (@providerFundingId, @ukprn, @providerType, @providerSubType)";

                connection.Execute(sql, param: new { providerFundingId, ukprn, providerType, providerSubType});
            }
        }

        private static void InsertProviderFundingAllocation(string providerFundingId, string fundingId)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"INSERT INTO [FundingAllocation].[ProviderFundingAllocation]
                                           ([ProviderFundingId]
                                           ,[FundingId])
                                     VALUES
                                           (@providerFundingId, @fundingId)";

                connection.Execute(sql, param: new { providerFundingId, fundingId });
            }
        }

        private static void InsertAllocationFundingStreamConfig(string allocationFundingStreamCode, string allocationPeriodId, string fundingTypeCode, string fundingPeriod)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"INSERT INTO [FundingAllocation].[AllocationFundingStreamConfig]
                                           ([AllocationFundingStreamCode]
                                          ,[AllocationPeriodId]
                                          ,[FundingTypeCode]
                                          ,[FundingPeriodCode]
                                          ,[FSPGroupCode])
                                     VALUES
                                           (@allocationFundingStreamCode, @allocationPeriodId, @fundingTypeCode, @fundingPeriod, '16-19ED2122')";

                connection.Execute(sql, param: new { allocationFundingStreamCode, allocationPeriodId, fundingTypeCode, fundingPeriod });
            }
        }

        private static void InsertParkingInfo(string fundingId, DateTime lastParked)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"INSERT INTO [FundingAllocation].[ParkingAndDiscardedInfo]
                                           ([FundingAllocationId],
                                            LastParked)
                                     VALUES
                                           (@fundingId, @lastParked)";

                connection.Execute(sql, param: new { fundingId, lastParked });
            }
        }

        private static int InsertFeedReadRowAndGetReadId()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"INSERT INTO [FundingAllocation].[FeedRead]
                                           ([CreatedDate])
                                     VALUES (GETDATE());
                                     SELECT CAST(SCOPE_IDENTITY() AS INT)";

                return connection.QuerySingle<int>(sql);
            }
        }

        private static int InsertPageControl(int readId, int pageNumber)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"INSERT INTO [FundingAllocation].[FundingAllocationPageControl]
                                           (Readid,
                                            PageNumber)
                                     VALUES (@readId, @pageNumber)";

                return connection.Execute(sql, param:new {readId, pageNumber});
            }
        }
    }
}