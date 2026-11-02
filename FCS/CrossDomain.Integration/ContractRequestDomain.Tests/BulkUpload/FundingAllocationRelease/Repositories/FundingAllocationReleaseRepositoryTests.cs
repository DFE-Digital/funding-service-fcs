namespace ContractRequestDomain.Tests.BulkUpload.FundingAllocationRelease.Repositories
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using UnitTests.Common;
    using SFA.FCT.ContractRequestDomain.DataStore.Model;
    using SFA.FCT.ContractRequestDomain.DataStore;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload.FundingAllocationRelease.Repositories;

    [TestClass]
    public class FundingAllocationReleaseRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationReleaseRepository_SetToReleaseInProgress_ShouldAddARowWithReleaseInProgressReleaseStatus()
        {
            // arrange 
            const string fundingTypeCode = "ftc1";
            const string fundingPeriodName = "fpn1";
            const int releaseGroupGroupId = 9;

            DeleteFundingAllocationRelease(releaseGroupGroupId, fundingTypeCode, fundingPeriodName);

            using (var context = new ContractRequestDbContext())
            {
                var repository = new FundingAllocationReleaseRepository();

                var connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                // act
                repository.SetToReleaseInProgress(releaseGroupGroupId, fundingTypeCode, fundingPeriodName, connectionInfo).Wait();

                // assert
                var fundingAllocationRelease = GetFundingAllocationRelease(releaseGroupGroupId, fundingTypeCode, fundingPeriodName);
                Assert.AreEqual(FundingAllocationReleaseStatus.ReleaseInProgress, fundingAllocationRelease.FundingTypeFundingPeriodReleaseStatus);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationReleaseRepository_SetToReleased_ShouldUpdateRowWithReleasedReleaseStatus()
        {
            // arrange 
            const string fundingTypeCode = "ftc1";
            const string fundingPeriodName = "fpn1";
            const int releaseGroupGroupId = 9;

            DeleteFundingAllocationRelease(releaseGroupGroupId, fundingTypeCode, fundingPeriodName);

            using (var context = new ContractRequestDbContext())
            {
                var repository = new FundingAllocationReleaseRepository();
                var connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                repository.SetToReleaseInProgress(releaseGroupGroupId, fundingTypeCode, fundingPeriodName, connectionInfo).Wait();
            }

            using (var context = new ContractRequestDbContext())
            {
                var repository = new FundingAllocationReleaseRepository();
                var connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                // act
                repository.SetToReleased(releaseGroupGroupId, connectionInfo).Wait();

                // assert
                var fundingAllocationRelease = GetFundingAllocationRelease(releaseGroupGroupId, fundingTypeCode, fundingPeriodName);
                Assert.AreEqual(FundingAllocationReleaseStatus.Released, fundingAllocationRelease.FundingTypeFundingPeriodReleaseStatus);
            }
        }

        private static void DeleteFundingAllocationRelease(int releaseGroupGroupId, string fundingTypeCode, string fundingPeriodName)
        {
            using (var dbContext = new ContractRequestDbContext())
            {
                dbContext.FundingAllocationReleases.RemoveWhere(far =>
                    far.ReleaseGroupGroupId == releaseGroupGroupId &&
                    far.FundingTypeCode == fundingTypeCode && far.FundingPeriodName == fundingPeriodName);

                dbContext.SaveChanges();
            }
        }

        private static FundingAllocationRelease GetFundingAllocationRelease(int releaseGroupGroupId, string fundingTypeCode, string fundingPeriodName)
        {
            using (var dbContext = new ContractRequestDbContext())
            {
                return dbContext.FundingAllocationReleases.Single(far =>
                    far.ReleaseGroupGroupId == releaseGroupGroupId &&
                    far.FundingTypeCode == fundingTypeCode && far.FundingPeriodName == fundingPeriodName);
            }
        }
    }
}