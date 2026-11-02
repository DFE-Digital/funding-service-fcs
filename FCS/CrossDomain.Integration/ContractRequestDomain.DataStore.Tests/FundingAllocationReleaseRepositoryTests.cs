namespace ContractRequestDomain.DataStore.Tests
{
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.DataStore;
    using SFA.FCT.ContractRequestDomain.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class FundingAllocationReleaseRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationReleaseRepository_IsReleaseInProgress_ShouldReturnTrueWhenInProgress()
        {
            // arrange
            const string fundingTypeCode = "EDSK";
            const string fundingPeriod = "AY2122";
            const int releaseGroupGroupId = 8;
            RemoveFundingAllocationRelease(releaseGroupGroupId, fundingTypeCode, fundingPeriod);
            InsertFundingAllocationRelease(releaseGroupGroupId, fundingTypeCode, fundingPeriod, "ReleaseInProgress");

            using (var context = new ContractRequestDbContext())
            {
                // act
                var isReleaseInProgress = new FundingAllocationReleaseRepository().IsReleaseInProgress(fundingTypeCode, fundingPeriod,
                    ConnectionInfo.CreateFrom(context.GetConnection()));

                // assert
                isReleaseInProgress.Should().BeTrue();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationReleaseRepository_IsReleaseInProgress_ShouldReturnFalseWhenNotInProgress()
        {
            // arrange
            const string fundingTypeCode = "EDSK";
            const string fundingPeriod = "AY2122";
            const int releaseGroupGroupId = 8;
            RemoveFundingAllocationRelease(releaseGroupGroupId, fundingTypeCode, fundingPeriod);
            InsertFundingAllocationRelease(releaseGroupGroupId, fundingTypeCode, fundingPeriod, "Released");

            using (var context = new ContractRequestDbContext())
            {
                // act
                var isReleaseInProgress = new FundingAllocationReleaseRepository().IsReleaseInProgress(fundingTypeCode, fundingPeriod,
                    ConnectionInfo.CreateFrom(context.GetConnection()));

                // assert
                isReleaseInProgress.Should().BeFalse();
            }
        }

        private static void RemoveFundingAllocationRelease(int releaseGroupGroupId, string fundingTypeCode, string fundingPeriod)
        {
            const string sql = @"delete from [ContractRequest].[FundingAllocationRelease] 
                                 where [FundingTypeCode] = @fundingTypeCode
                                 and [FundingPeriodName] = @fundingPeriod
                                 and [ReleaseGroupGroupId] = @releaseGroupGroupId";

            Connection.Execute(sql,
                param: new { fundingTypeCode, fundingPeriod, releaseGroupGroupId });

        }

        private static void InsertFundingAllocationRelease(int releaseGroupGroupId, string fundingTypeCode, string fundingPeriod, string status)
        {
            const string sql = @"Insert into [ContractRequest].[FundingAllocationRelease] 
                                 ([FundingTypeCode]
                                  ,[FundingPeriodName]
                                  ,[ReleaseStatus]
                                  ,[ReleaseGroupGroupId])
                                 values( @fundingTypeCode,
                                         @fundingPeriod,
                                         @status,
                                         @releaseGroupGroupId)";

            Connection.Execute(sql,
                param: new { fundingTypeCode, fundingPeriod, status, releaseGroupGroupId });

        }

        private static SqlConnection Connection =>
            new SqlConnection(ConfigurationManager.ConnectionStrings["ContractRequestDbContext"].ConnectionString);
    }
}
