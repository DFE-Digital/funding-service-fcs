namespace FundingAllocation.Tests.Endpoints.CheckForReadComplete
{
    using System;
    using System.Data.SqlClient;
    using System.Linq;
    using DataStore;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Repositories;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class FeedReadRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FeedReadRepository_IsReadComplete_ShouldReturnFalseWhenPagesYetToRead()
        {
            //arrange
            const string fundingId = "Some F id";
            const string ukprn = "11111111";
            const int pageNumber = 12;
            ClearFundingAllocationForPage(pageNumber);
            ClearPageControl();
            int readId = CreateFeedReadRow();
            InsertPageControl(readId, pageNumber, null);
            InsertFundingAllocation(fundingId, pageNumber, 1, ukprn, readId);
            FundingAllocationContext context = new FundingAllocationContext(FundingAllocationContextOptions);
            FeedReadRepository readRepository = new FeedReadRepository(context);

            // act
            var readCompleteResult = readRepository.IsReadComplete(fundingId).Result;

            // assert
            readCompleteResult.IsComplete.Should().Be(false);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FeedReadRepository_IsReadComplete_ShouldReturnFalseWhenProvidersYetToLoad()
        {
            //arrange
            const string fundingId = "Some F id2";
            const string ukprn = "11111111";
            const int pageNumber = 12;
            ClearFundingAllocationForPage(pageNumber);
            ClearPageControl();
            int readId = CreateFeedReadRow();
            InsertPageControl(readId, pageNumber, Guid.NewGuid().ToString());
            InsertFundingAllocation(fundingId, pageNumber, 1, ukprn, readId);
            FundingAllocationContext context = new FundingAllocationContext(FundingAllocationContextOptions);
            FeedReadRepository readRepository = new FeedReadRepository(context);

            // act
            var readCompleteResult = readRepository.IsReadComplete(fundingId).Result;

            // assert
            readCompleteResult.IsComplete.Should().Be(false);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FeedReadRepository_IsReadComplete_ShouldReturnTrueWhenProvidersLoadedAndPagesLoaded()
        {
            //arrange
            const string fundingId = "Some F id3";
            const string providerFundingid = "Some pf id2";
            const string ukprn = "11111111";
            const int pageNumber = 12;
            ClearFundingAllocationForPage(pageNumber);
            ClearPageControl();
            ClearProviderFunding(providerFundingid);
            int readId = CreateFeedReadRow();
            InsertPageControl(readId, pageNumber, Guid.NewGuid().ToString());
            InsertFundingAllocation(fundingId, pageNumber, 1, ukprn, readId);
            InsertProviderFunding(fundingId, providerFundingid);
            FundingAllocationContext context = new FundingAllocationContext(FundingAllocationContextOptions);
            FeedReadRepository readRepository = new FeedReadRepository(context);

            // act
            var readCompleteResult = readRepository.IsReadComplete(fundingId).Result;

            // assert
            readCompleteResult.IsComplete.Should().Be(true);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FeedReadRepository_SetToCompleteIfNotAlready_ShouldReturnTrueWhenReadIsNotComplete()
        {
            //arrange
            ClearFeedReads();
            int feedReadId = InsertFeedRead();
            FundingAllocationContext context = new FundingAllocationContext(FundingAllocationContextOptions);
            FeedReadRepository readRepository = new FeedReadRepository(context);

            // act
            var result = readRepository.SetToCompleteIfNotAlready(feedReadId).Result;

            // assert
            result.Should().Be(true);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FeedReadRepository_SetToCompleteIfNotAlready_ShouldReturnFalseWhenReadIsComplete()
        {
            //arrange
            ClearFeedReads();
            int feedReadId = InsertFeedRead(isReadComplete:true);
            FundingAllocationContext context = new FundingAllocationContext(FundingAllocationContextOptions);
            FeedReadRepository readRepository = new FeedReadRepository(context);

            // act
            var result = readRepository.SetToCompleteIfNotAlready(feedReadId).Result;

            // assert
            result.Should().Be(false);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FeedReadRepository_HasLastJobCompleted_ShouldBeFalseWhenJobHasNotCompleted()
        {
            //arrange
            ClearFeedReads();
            InsertFeedRead(isReadComplete: true, true);
            var feedId = InsertFeedRead(isReadComplete: true,false);

            var context = new FundingAllocationContext(FundingAllocationContextOptions);
            var readRepository = new FeedReadRepository(context);

            // act
            var lastJobCompleted = readRepository.HasLastJobCompleted().Result;

            // assert
            lastJobCompleted.Should().Be(false);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FeedReadRepository_HasLastJobCompleted_ShouldBeTrueWhenJobHasCompleted()
        {
            //arrange
            ClearFeedReads();
            InsertFeedRead(isReadComplete: true, true);
            InsertFeedRead(isReadComplete: true, true);

            var context = new FundingAllocationContext(FundingAllocationContextOptions);
            var readRepository = new FeedReadRepository(context);

            // act
            var lastJobCompleted = readRepository.HasLastJobCompleted().Result;

            // assert
            lastJobCompleted.Should().Be(true);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FeedReadRepository_HasLastJobCompleted_ShouldBeTrueWhenNoOtherJobs()
        {
            //arrange
            ClearFeedReads();

            var context = new FundingAllocationContext(FundingAllocationContextOptions);
            var readRepository = new FeedReadRepository(context);

            // act
            var lastJobCompleted = readRepository.HasLastJobCompleted().Result;

            // assert
            lastJobCompleted.Should().Be(true);
        }

        private void InsertProviderFunding(string fundingId, string providerFundingId)
        {
            using var context = new FundingAllocationContext(FundingAllocationContextOptions);
            context.ProviderFundingAllocations.Add(new ProviderFundingAllocation(providerFundingId: providerFundingId,
                fundingId: fundingId)
            {
                ProviderFunding = new ProviderFunding(providerFundingId, 1,
                    "t",
                    "st")
            });

            context.SaveChanges();
        }

        private void ClearFundingAllocationForPage(int pageNumber)
        {
            using var context = new FundingAllocationContext(FundingAllocationContextOptions);
            var readIds = context.FundingAllocations.Where(fa => fa.PageNumber == pageNumber)
                .Select(fa => fa.ReadId).ToList();
            readIds.ForEach(id =>
                {
                    context.FeedReads.Where(r => r.ReadId == id).ToList()
                        .ForEach(r => context.FeedReads.Remove(r));
                });
                
            context.SaveChanges();
        }

        private void ClearProviderFunding(string providerFundingId)
        {
            using var context = new FundingAllocationContext(FundingAllocationContextOptions);
            context.Database.ExecuteSqlRaw($"DELETE FROM [FundingAllocation].[ProviderFunding] WHERE [ProviderFundingId] = '{providerFundingId}'");

            context.SaveChanges();
        }

        private void InsertFundingAllocation(string fundingId, int pageNumber, int providerFundingCount, string ukprn, int feedReadId)
        {
            using var context = new FundingAllocationContext(FundingAllocationContextOptions);
            context.FundingAllocations.Add(new FundingAllocation(fundingId, "1_2", "AS-2021", "1619", ukprn, 0,
                pageNumber, 1, providerFundingCount, feedReadId));
            context.SaveChanges();
        }

        private void InsertPageControl(int readId, int pageNumber, string latestBookmark)
        {
            using var context = new FundingAllocationContext(FundingAllocationContextOptions);
            context.FundingAllocationPageControls.Add(new FundingAllocationPageControl(readId, pageNumber)
            {
                LatestBookmarkOnPage = latestBookmark
            });
            context.SaveChanges();
        }

        private int CreateFeedReadRow()
        {
            using var context = new FundingAllocationContext(FundingAllocationContextOptions);
            var feedRead = new FeedRead();
            context.FeedReads.Add(feedRead);
            context.SaveChanges();

            return feedRead.ReadId;
        }

        private void ClearPageControl()
        {
            using var context = new FundingAllocationContext(FundingAllocationContextOptions);
            context.Database.ExecuteSqlRaw("DELETE FROM [FundingAllocation].[FundingAllocationPageControl]");
            
            context.SaveChanges();
        }

        private void ClearFeedReads()
        {
            using var context = new FundingAllocationContext(FundingAllocationContextOptions);
            context.Database.ExecuteSqlRaw("DELETE FROM [FundingAllocation].[FeedRead]");

            context.SaveChanges();
        }

        private int InsertFeedRead(bool isReadComplete = false, bool isJobCompleted = false)
        {
            using var context = new FundingAllocationContext(FundingAllocationContextOptions);
            var feedRead = new FeedRead
            {
                CfsReadCompletedDate = isReadComplete ? (DateTime?) DateTime.Now : null,
                JobCompletedDate = isJobCompleted ? (DateTime?) DateTime.Now : null
            };

            context.FeedReads.Add(feedRead);
            context.SaveChanges();

            return feedRead.ReadId;
        }

        private DbContextOptions<FundingAllocationContext> FundingAllocationContextOptions =>
         new DbContextOptionsBuilder<FundingAllocationContext>()
            .UseSqlServer(new SqlConnection(AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"]))
            .Options;
    }
}
