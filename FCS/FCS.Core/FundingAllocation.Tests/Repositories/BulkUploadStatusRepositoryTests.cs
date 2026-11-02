namespace FundingAllocation.Tests.Repositories
{
    using System;
    using System.Linq;
    using DataStore;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Repositories;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class BulkUploadStatusRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void BulkUploadStatusRepository_SetToInProgress_ShouldAddRowWithInProgressStatus()
        {
            var messageId = Guid.NewGuid().ToString();
            const string fundingTypeCode = "ftc1";
            const string fundingPeriodName = "fpn1";

            // arrange
            var arrangeContext = new FundingAllocationContext(TestHelpers.DbOptionsFactory.DbContextOptions);
 
            arrangeContext.Database.ExecuteSqlRaw("DELETE FROM FundingAllocation.BulkUploadStatus");

            var repository = new BulkUploadStatusRepository(new FundingAllocationContext(TestHelpers.DbOptionsFactory.DbContextOptions));

            // act
            repository.SetToInProgress(Guid.NewGuid(), fundingTypeCode, fundingPeriodName).Wait();

            // assert
            using var assertContext = new FundingAllocationContext(TestHelpers.DbOptionsFactory.DbContextOptions);
            var storedEntity = assertContext.BulkUploadStatuses.SingleOrDefault(bus =>
                bus.FundingTypeCode == fundingTypeCode && bus.FundingPeriodName == fundingPeriodName);

            var expectedStatus = BulkUploadStatus.UploadStatus.InProgress.ToString();

            storedEntity.Should().NotBeNull();
            storedEntity.Status.Should().Be(expectedStatus);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void BulkUploadStatusRepository_SetToLoaded_ShouldUpdateRowToLoadedStatus()
        {
            var messageId = Guid.NewGuid().ToString();
            const string fundingTypeCode = "ftc1";
            const string fundingPeriodName = "fpn1";
            var arrangeStatus = BulkUploadStatus.UploadStatus.InProgress.ToString();

            // arrange
            var arrangeContext = new FundingAllocationContext(TestHelpers.DbOptionsFactory.DbContextOptions);
            Guid batchId = Guid.NewGuid();
            arrangeContext.Database.ExecuteSqlRaw("DELETE FROM FundingAllocation.BulkUploadStatus");
            arrangeContext.BulkUploadStatuses.Add(new BulkUploadStatus(batchId, fundingTypeCode, fundingPeriodName, arrangeStatus));
            arrangeContext.SaveChanges();

            var repository = new BulkUploadStatusRepository(new FundingAllocationContext(TestHelpers.DbOptionsFactory.DbContextOptions));

            // act
            repository.SetToLoaded(batchId.ToString()).Wait();

            // assert
            using var assertContext = new FundingAllocationContext(TestHelpers.DbOptionsFactory.DbContextOptions);
            var storedEntity = assertContext.BulkUploadStatuses.SingleOrDefault(bus =>
                bus.FundingTypeCode == fundingTypeCode && bus.FundingPeriodName == fundingPeriodName);

            var expectedStatus = BulkUploadStatus.UploadStatus.Loaded.ToString();

            storedEntity.Should().NotBeNull();
            storedEntity.Status.Should().Be(expectedStatus);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void BulkUploadStatusRepository_IsBulkUploadInProgress_ShouldReturnTrueWhenInProgress()
        {
            // arrange
            const string fundingTypeCode = "EDSK";
            const string fundingPeriodName = "AY2122";
            var arrangeStatus = BulkUploadStatus.UploadStatus.InProgress.ToString();

            var arrangeContext = new FundingAllocationContext(TestHelpers.DbOptionsFactory.DbContextOptions);

            arrangeContext.Database.ExecuteSqlRaw("DELETE FROM FundingAllocation.BulkUploadStatus");
            arrangeContext.BulkUploadStatuses.Add(new BulkUploadStatus(Guid.NewGuid(), fundingTypeCode, fundingPeriodName, arrangeStatus));
            arrangeContext.SaveChanges();

            var repository = new BulkUploadStatusRepository(new FundingAllocationContext(TestHelpers.DbOptionsFactory.DbContextOptions));

            // act
            var assertIsInProgress = repository.IsInProgress(fundingTypeCode, fundingPeriodName).Result;

            // assert
            assertIsInProgress.Should().BeTrue();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void BulkUploadStatusRepository_IsBulkUploadInProgress_ShouldReturnFalseWhenLoaded()
        {
            // arrange
            const string fundingTypeCode = "EDSK";
            const string fundingPeriodName = "AY2122";
            var arrangeStatus = BulkUploadStatus.UploadStatus.Loaded.ToString();

            var arrangeContext = new FundingAllocationContext(TestHelpers.DbOptionsFactory.DbContextOptions);

            arrangeContext.Database.ExecuteSqlRaw("DELETE FROM FundingAllocation.BulkUploadStatus");
            arrangeContext.BulkUploadStatuses.Add(new BulkUploadStatus(Guid.NewGuid(), fundingTypeCode, fundingPeriodName, arrangeStatus));
            arrangeContext.SaveChanges();

            var repository = new BulkUploadStatusRepository(new FundingAllocationContext(TestHelpers.DbOptionsFactory.DbContextOptions));

            // act
            var assertIsInProgress = repository.IsInProgress(fundingTypeCode, fundingPeriodName).Result;

            // assert
            assertIsInProgress.Should().BeFalse();
        }
    }
}