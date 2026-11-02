namespace FundingAllocation.Tests.Endpoints.ReleaseGroup.Repositories
{
    using System;
    using System.Data.SqlClient;
    using Dapper;
    using DataStore;
    using FluentAssertions;
    using FundingAllocation.Endpoints.ReleaseGroup.Repositories;
    using FundingAllocation.Repositories;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Common;

    [TestClass]
    public class FundingTypeFundingPeriodRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodRepository_GetAmendmentInfo_ShouldReturnCorrectValuesIncludingNullFtpGroupCode()
        {
            // arrange
            const string fundingTypeCode = "ftc";
            const string fundingPeriod = "fp";
            const string ftpGroupCode = null;
            const bool allowNewAmendment = true;
            const string precedingFtpFundingPeriod = "PrecedingFtpFundingPeriod";
            const string precedingFtpFundingType = "PrecedingFtpFundingType";
            var dateMock = new Mock<IOverrideDateRepository>();
            dateMock.Setup(m => m.GetDate()).ReturnsAsync(DateTime.Now);

            using var context = new FundingAllocationContext(DbContextOptions());
            context.Database.ExecuteSqlRaw("DELETE FROM FundingAllocation.FundingTypeFundingPeriodConfig");

            const string sql = @"INSERT INTO [FundingAllocation].[FundingTypeFundingPeriodConfig]
                                       ([FundingTypeCode]
                                       ,[FundingPeriod]
                                       ,[FtpGroupCode]
                                       ,[IncludeAllContractsOnSummaryOfFunding]
                                       ,[AllowNewAmendment]
                                       ,[PrecedingFtpFundingPeriod]
                                       ,[PrecedingFtpFundingType])
                                 VALUES (@fundingTypeCode, @fundingPeriod, @ftpGroupCode, 0, @allowNewAmendment, 
                                         @precedingFtpFundingPeriod, @precedingFtpFundingType)";

            context.Database.GetDbConnection().Execute
                (sql, new { fundingTypeCode, fundingPeriod, ftpGroupCode, allowNewAmendment, precedingFtpFundingPeriod, precedingFtpFundingType });

            var repository = new FundingTypeFundingPeriodRepository(new FundingAllocationContext(DbContextOptions()), dateMock.Object);

            // act
            var intentFundingTypeFundingPeriod = repository.GetAmendmentInfo(fundingTypeCode, fundingPeriod).Result;

            // assert
            Assert.IsNull(intentFundingTypeFundingPeriod.FtpGroupCode, "FtpGroupCode is not null");
            Assert.AreEqual(allowNewAmendment, intentFundingTypeFundingPeriod.AllowNewAmendment, "AllowNewAmendment is not correct");
            Assert.AreEqual(precedingFtpFundingPeriod, intentFundingTypeFundingPeriod.PrecedingFtpFundingPeriod, "PrecedingFtpFundingPeriod is not correct");
            Assert.AreEqual(precedingFtpFundingType, intentFundingTypeFundingPeriod.PrecedingFtpFundingType, "PrecedingFtpFundingType is not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodRepository_GetAmendmentInfo_ShouldReturnCorrectValuesIncludingNotNullFtpGroupCode()
        {
            // arrange
            const string fundingTypeCode = "ftc";
            const string fundingPeriod = "fp";
            const string ftpGroupCode = "FTP Group Code";
            const bool allowNewAmendment = true;
            const string precedingFtpFundingPeriod = "PrecedingFtpFundingPeriod";
            const string precedingFtpFundingType = "PrecedingFtpFundingType";
            var dateMock = new Mock<IOverrideDateRepository>();
            dateMock.Setup(m => m.GetDate()).ReturnsAsync(DateTime.Now);

            using var context = new FundingAllocationContext(DbContextOptions());
            context.Database.ExecuteSqlRaw("DELETE FROM FundingAllocation.FundingTypeFundingPeriodConfig");

            const string sql = @"INSERT INTO [FundingAllocation].[FundingTypeFundingPeriodConfig]
                                       ([FundingTypeCode]
                                       ,[FundingPeriod]
                                       ,[FtpGroupCode]
                                       ,[IncludeAllContractsOnSummaryOfFunding]
                                       ,[AllowNewAmendment]
                                       ,[PrecedingFtpFundingPeriod]
                                       ,[PrecedingFtpFundingType])
                                 VALUES (@fundingTypeCode, @fundingPeriod, @ftpGroupCode, 0, @allowNewAmendment, 
                                         @precedingFtpFundingPeriod, @precedingFtpFundingType)";

            context.Database.GetDbConnection().Execute
                (sql, new { fundingTypeCode, fundingPeriod, ftpGroupCode, allowNewAmendment, precedingFtpFundingPeriod, precedingFtpFundingType });

            var repository = new FundingTypeFundingPeriodRepository(new FundingAllocationContext(DbContextOptions()), dateMock.Object);

            // act
            var actualAmendmentInfo = repository.GetAmendmentInfo(fundingTypeCode, fundingPeriod).Result;

            // assert
            Assert.IsNotNull(actualAmendmentInfo.FtpGroupCode, "FtpGroupCode is null");
            Assert.AreEqual(allowNewAmendment, actualAmendmentInfo.AllowNewAmendment, "AllowNewAmendment is not correct");
            Assert.AreEqual(precedingFtpFundingPeriod, actualAmendmentInfo.PrecedingFtpFundingPeriod, "PrecedingFtpFundingPeriod is not correct");
            Assert.AreEqual(precedingFtpFundingType, actualAmendmentInfo.PrecedingFtpFundingType, "PrecedingFtpFundingType is not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodRepository_DoAllAmendmentsRequireSigning_ShouldReturnTrueWhenConfigColumnSetToTrue()
        {
            // arrange
            const string fundingTypeCode = "DADA";
            const string fundingPeriod = "AY2122";
            const bool allAmendmentsRequireSigning = true;
            var dateMock = new Mock<IOverrideDateRepository>();
            dateMock.Setup(m => m.GetDate()).ReturnsAsync(DateTime.Now);

            DeleteFundingTypeFundingPeriodConfig();
            InsertFundingTypeFundingPeriodConfig(fundingTypeCode, fundingPeriod, allAmendmentsRequireSigning);

            var repository = new FundingTypeFundingPeriodRepository(new FundingAllocationContext(DbContextOptions()), dateMock.Object);

            // act
            var doAllAmendmentsRequireSigning = repository.DoAllAmendmentsRequireSigning(fundingTypeCode, fundingPeriod).Result;

            // assert
            doAllAmendmentsRequireSigning.Should().BeTrue();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodRepository_DoAmendmentTypeToNotificationOnExpiredContract_ShouldReturnTrueWhenConfigColumnSetToTrue()
        {
            // arrange
            const string fundingTypeCode = "EDSK";
            const string fundingPeriod = "AY2223"; 
            var dateMock = new Mock<IOverrideDateRepository>();
            dateMock.Setup(m => m.GetDate()).ReturnsAsync(new DateTime(2023, 11, 1));
            DeleteFundingTypeFundingPeriodConfig();
            InsertexpireDateFundingTypeFundingPeriodConfig(fundingTypeCode, fundingPeriod, new DateTime(2023, 10, 31));
            var repository = new FundingTypeFundingPeriodRepository(new FundingAllocationContext(DbContextOptions()), dateMock.Object);

            // act
            var doNotificationOnExpired = repository.DoAmendmentTypeToNotificationOnExpiredContract(fundingTypeCode, fundingPeriod).Result;

            // assert
            doNotificationOnExpired.Should().BeTrue();
        }

        private DbContextOptions<FundingAllocationContext> DbContextOptions()
        {
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];

            return new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;
        }

        private void DeleteFundingTypeFundingPeriodConfig()
        {
            using var context = new FundingAllocationContext(DbContextOptions());
            context.Database.ExecuteSqlRaw("DELETE FROM FundingAllocation.FundingTypeFundingPeriodConfig");
        }

        private FundingAllocationContext FundingAllocationContext => new FundingAllocationContext(DbContextOptions());

        private void InsertFundingTypeFundingPeriodConfig(string fundingTypeCode, string fundingPeriodCode,
            bool allAmendmentsRequireSigning)
        {
            const string sql = @"INSERT INTO [FundingAllocation].[FundingTypeFundingPeriodConfig]
                                       ([FundingTypeCode]
                                       ,[FundingPeriod]
                                       ,[IncludeAllContractsOnSummaryOfFunding]
                                       ,[AllowNewAmendment]
                                       ,[AllAmendmentsRequireSigning])
                                 VALUES (@fundingTypeCode, @fundingPeriodCode, 1, 0, @allAmendmentsRequireSigning)";

            using var context = new FundingAllocationContext(DbContextOptions());
            context.Database.GetDbConnection().Execute
                (sql, new { fundingTypeCode, fundingPeriodCode, allAmendmentsRequireSigning });
        }
        private void InsertexpireDateFundingTypeFundingPeriodConfig(string fundingTypeCode, string fundingPeriodCode,
           DateTime expireDate)
        {
            const string sql = @"INSERT INTO [FundingAllocation].[FundingTypeFundingPeriodConfig]
                                       ([FundingTypeCode]
                                       ,[FundingPeriod]
                                       ,[IncludeAllContractsOnSummaryOfFunding]
                                       ,[AllowNewAmendment]
                                       ,[AllAmendmentsRequireSigning]
                                       ,[ContractExpiryDate])
                                 VALUES (@fundingTypeCode, @fundingPeriodCode,0,0,0, @expireDate)";

            using var context = new FundingAllocationContext(DbContextOptions());
            context.Database.GetDbConnection().Execute
                (sql, new { fundingTypeCode, fundingPeriodCode, expireDate });
        }
    }
}