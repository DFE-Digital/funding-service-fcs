namespace PerformanceManagement.DataStore.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Repositories;
    using System;

    [TestClass]
    public class FundingClaimCollectionImportInfoRepositoryTests
    {
        [TestInitialize]
        public void Initialize()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                foreach (FundingClaimCollectionImportInfo fundingClaimCollectionImportInfo in context.FundingClaimCollectionImportInfos)
                {
                    context.FundingClaimCollectionImportInfos.Remove(fundingClaimCollectionImportInfo);
                }

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimCollectionImportInfoRepository_ShouldAddEntity()
        {
            // arrange
            const string periodClaimType = "1617-Final";

            // act
            using (var context = new PerformanceManagementDbContext())
            {
                FundingClaimCollectionImportInfoRepository repository =
                    new FundingClaimCollectionImportInfoRepository(context);

                repository.AddEntity(new FundingClaimCollectionImportInfo(periodClaimType));

                context.SaveChanges();
            }

            // assert
            FundingClaimCollectionImportInfo fundingClaimCollectionImportInfo = null;
            using (var context = new PerformanceManagementDbContext())
            {
                FundingClaimCollectionImportInfoRepository repository =
                    new FundingClaimCollectionImportInfoRepository(context);

                fundingClaimCollectionImportInfo = repository.FindByKey(new[] {periodClaimType});

                context.SaveChanges();
            }

            Assert.IsNotNull(fundingClaimCollectionImportInfo);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimCollectionImportInfoRepository_ShouldUpdateEntity()
        {
            // arrange
            const string periodClaimType = "1617-Final";
            const int rowsToImport = 100;
            DateTime testDateTime = DateTime.Now;


            using (var context = new PerformanceManagementDbContext())
            {
                FundingClaimCollectionImportInfoRepository repository =
                    new FundingClaimCollectionImportInfoRepository(context);

                repository.AddEntity(new FundingClaimCollectionImportInfo(periodClaimType));

                context.SaveChanges();
            }

            // act
            FundingClaimCollectionImportInfo fundingClaimCollectionImportInfo = null;
            using (var context = new PerformanceManagementDbContext())
            {
                FundingClaimCollectionImportInfoRepository repository =
                    new FundingClaimCollectionImportInfoRepository(context);

                fundingClaimCollectionImportInfo = repository.FindByKey(new[] {periodClaimType});
                fundingClaimCollectionImportInfo.ImportCompletedDate = testDateTime;
                fundingClaimCollectionImportInfo.TotalRowsToImport = rowsToImport;
                context.SaveChanges();
            }

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                FundingClaimCollectionImportInfoRepository repository =
                    new FundingClaimCollectionImportInfoRepository(context);

                fundingClaimCollectionImportInfo = repository.FindByKey(new[] {periodClaimType});
            }

            Assert.AreEqual(rowsToImport, fundingClaimCollectionImportInfo.TotalRowsToImport,
                "The TotalRowsToImport property has not been updated");
            Assert.AreEqual(testDateTime.Date, fundingClaimCollectionImportInfo.ImportCompletedDate.Value.Date,
                "The ImportCompletedDate property has not been updated");
        }
    }
}
