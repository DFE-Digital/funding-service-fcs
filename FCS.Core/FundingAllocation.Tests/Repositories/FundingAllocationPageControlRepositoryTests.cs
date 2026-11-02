namespace FundingAllocation.Tests.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using DataStore;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestHelpers.Extensions;
    using static TestHelpers.DbOptionsFactory;
    using static TestHelpers.FundingAllocationHelper;

    [TestClass]
    public class FundingAllocationPageControlRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationPageControlRepository_InsertPage_ShouldInsert()
        {
            // arrange
            const int pageNumber = 2;

            using var context = new FundingAllocationContext(DbContextOptions);
            context.FundingAllocationPageControls.ToList().ForEach(c =>
            {
                context.FundingAllocationPageControls.Remove(c);
            });
            context.SaveChanges();

            context.CreateFeedRead(out var readId);

            FundingAllocationPageControlRepository repository = new FundingAllocationPageControlRepository(context);

            // act
            repository.InsertPage(readId, pageNumber).Wait();

            // assert
            using var contextRead = new FundingAllocationContext(DbContextOptions);
            var row = contextRead.FundingAllocationPageControls.Single();
            Assert.AreEqual(pageNumber, row.PageNumber, "The page number is incorrect");
            Assert.AreEqual(readId, row.ReadId, "The readId is incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationPageControlRepository_SetLatestBookmark_ShouldUpdateBookmark()
        {
            const int pageNumber = 100;
            const string latestBookmark = "PSG-AY-1920-Information-LocalAuthority-201-1_0";
            
            // arrange
            using var arrangeContext = new FundingAllocationContext(DbContextOptions);
            arrangeContext.FundingAllocationPageControls
                .ToList()
                .ForEach(c => arrangeContext.FundingAllocationPageControls.Remove(c));

            arrangeContext.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));

            FundingAllocationPageControlRepository repository = new FundingAllocationPageControlRepository(arrangeContext);

            // act
            repository.SetLatestBookmark(readId, pageNumber, latestBookmark).Wait();

            // assert
            using var assertContext = new FundingAllocationContext(DbContextOptions);
            var storedEntity = assertContext.FundingAllocationPageControls.Find(readId, pageNumber);

            storedEntity.LatestBookmarkOnPage.Should().Be(latestBookmark, "LatestBookmarkOnPage should be updated");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationPageControlRepository_GetLatest_ShouldReturnCorrectVal()
        {
            // arrange
            using var contextSetup = new FundingAllocationContext(DbContextOptions);
            contextSetup.FundingAllocationPageControls.ToList().ForEach(pc =>
            {
                contextSetup.FundingAllocationPageControls.Remove(pc);
            });
            contextSetup.SaveChanges();

            var arrangeLatestReadId = -1;
            var arrangeLatestPageNumber = -1;
            var pageNumber = 1;
            Enumerable.Range(1, 3).ToList().ForEach( x => 
            {
                contextSetup.CreateFeedRead(out var feedReadId);
                Enumerable.Range(1, 4).ToList().ForEach(i =>
                {
                    contextSetup.AddAllAndSave(new FundingAllocationPageControl(feedReadId, pageNumber++));
                });
                arrangeLatestPageNumber = pageNumber-1;
                arrangeLatestReadId = feedReadId;
            });
            contextSetup.SaveChanges();

            using var context = new FundingAllocationContext(DbContextOptions);
          
            FundingAllocationPageControlRepository repository = new FundingAllocationPageControlRepository(context);

            // act
            var latest = repository.GetLatest().Result;

            // assert
            Assert.AreEqual(arrangeLatestReadId, latest.ReadId, "The read id is not correct");
            Assert.AreEqual(arrangeLatestPageNumber, latest.PageNumber, "The page number is not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationPageControlRepository_IsThereAnyNewDataToConsume_ShouldBeTrueWhenNewDataToConsume()
        {
            // Arrange
            List<string> fundingIdsOnPageOneInDb = new List<string> {"NFF-AS-2122-Contract-LocalAuthority-10026487-2_1"};
            List<string> fundingIdsOnPageOneInFeed = new List<string> { "NFF-AS-2122-Contract-LocalAuthority-10026487-3_1" };
            const int pageOne = 1;
            var context = new FundingAllocationContext(DbContextOptions);

            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var feedReadId)
                .AddAllAndSave(new FundingAllocationPageControl(feedReadId, pageOne));

            var fundingAllocations = fundingIdsOnPageOneInDb
                .Select(fid => FundingAllocationWithFundingId(fid)
                    .WithReadId(feedReadId)
                    .WithPageNumber(pageOne)).ToArray();

            context.AddAllAndSave(fundingAllocations);

            var repository = new FundingAllocationPageControlRepository(context);
            
            // Act
            var isNewDataToConsume = repository.IsThereAnyNewDataToConsume(fundingIdsOnPageOneInFeed, pageOne).Result;

            // Assert
            isNewDataToConsume.Should().BeTrue();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationPageControlRepository_IsThereAnyNewDataToConsume_ShouldBeTrueWhenNoneInPaas()
        {
            // Arrange
            List<string> fundingIdsOnPageOneInDb = new List<string>();
            List<string> fundingIdsOnPageOneInFeed = new List<string> { "NFF-AS-2122-Contract-LocalAuthority-10026487-2_1", "NFF-AS-2122-Contract-LocalAuthority-10026487-3_1" };
            const int pageOne = 1;
            var context = new FundingAllocationContext(DbContextOptions);

            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var feedReadId);
            var fundingAllocations = fundingIdsOnPageOneInDb
                .Select(fid => FundingAllocationWithFundingId(fid)
                    .WithReadId(feedReadId)
                    .WithPageNumber(pageOne)).ToArray();

            context.AddAllAndSave(fundingAllocations);

            var repository = new FundingAllocationPageControlRepository(context);

            // Act
            var isNewDataToConsume = repository.IsThereAnyNewDataToConsume(fundingIdsOnPageOneInFeed, pageOne).Result;

            // Assert
            isNewDataToConsume.Should().BeTrue();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationPageControlRepository_IsThereAnyNewDataToConsume_ShouldBeFalseWhenNoNewDataToConsume()
        {
            // Arrange
            List<string> fundingIdsOnPageOneInDb = new List<string>
            {
                "NFF-AS-2122-Contract-LocalAuthority-10026487-2_1, NFF-AS-2122-Contract-LocalAuthority-10026487-3_1"
            };
            const int pageOne = 1;
            var context = new FundingAllocationContext(DbContextOptions);

            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var feedReadId)
                .AddAllAndSave(new FundingAllocationPageControl(feedReadId, pageOne));
            var fundingAllocations = fundingIdsOnPageOneInDb
                .Select(fid => FundingAllocationWithFundingId(fid)
                    .WithReadId(feedReadId)
                    .WithPageNumber(pageOne)).ToArray();

            context.AddAllAndSave(fundingAllocations);

            var repository = new FundingAllocationPageControlRepository(context);

            // Act
            var isNewDataToConsume = repository.IsThereAnyNewDataToConsume(fundingIdsOnPageOneInDb, pageOne).Result;

            // Assert
            isNewDataToConsume.Should().BeFalse();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationPageControlRepository_IsThereAnyNewDataToConsume_ShouldBeTrueWhenNoNewDataToConsumeMaxSize()
        {
            // Arrange
            var fundingIdsOnPageOneInDb = Enumerable.Range(1, 499)
                .Select(version => $"NFF-AS-2122-Contract-LocalAuthority-10026487-2_{version}").ToList();

            List<string> fundingIdsOnPageOneInFeed = new List<string>(fundingIdsOnPageOneInDb)
            {
                "NFF-AS-2122-Contract-LocalAuthority-10026487-2_500"
            };
            const int pageOne = 1;
            var context = new FundingAllocationContext(DbContextOptions);

            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var feedReadId)
                .AddAllAndSave(new FundingAllocationPageControl(feedReadId, pageOne));
            var fundingAllocations = fundingIdsOnPageOneInDb
                .Select(fid => FundingAllocationWithFundingId(fid)
                    .WithReadId(feedReadId)
                    .WithPageNumber(pageOne)).ToArray();

            context.AddAllAndSave(fundingAllocations);

            var repository = new FundingAllocationPageControlRepository(context);

            // Act
            var isNewDataToConsume = repository.IsThereAnyNewDataToConsume(fundingIdsOnPageOneInFeed, pageOne).Result;

            // Assert
            isNewDataToConsume.Should().BeTrue();
        }
    }
}
