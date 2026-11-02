namespace FundingAllocation.Tests.Endpoints.EnrichProviderFunding
{
    using System.Data.SqlClient;
    using System.Linq;
    using DataStore;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Endpoints.EnrichProviderFunding.Repositories;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using FundingAllocation.Tests.TestHelpers.Extensions;

    [TestClass]
    public class ProviderFundingAllocationRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ProviderFundingAllocationRepository_ShouldCreateNewEntity()
        {
            const string fundingId = "PSG-AY-2021-Payment-AcademyTrust-10000001-1_0";
            const string providerFundingId = "PSG-AY-2021-10000005-1_0";
            const int pageNumber = 1;

            // arrange
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var arrangeContext = new FundingAllocationContext(options);

            arrangeContext.Database.ExecuteSqlRaw($"DELETE FROM FundingAllocation.FeedRead");
            arrangeContext.Database.ExecuteSqlRaw($"DELETE FROM FundingAllocation.ProviderFundingAllocation");
            arrangeContext.Database.ExecuteSqlRaw($"DELETE FROM FundingAllocation.ProviderFunding");
            arrangeContext.CreateFeedRead(out var feedReadId)
                .AddAllAndSave(new FundingAllocationPageControl(feedReadId, pageNumber));
            arrangeContext.FundingAllocations.Add(new FundingAllocation(
                fundingId, "", "", "",
                "", -1, pageNumber, -1,
                1, feedReadId));

            arrangeContext.SaveChanges();

            var repository = new ProviderFundingAllocationRepository(new FundingAllocationContext(options));

            var providerFundingAllocation = new ProviderFundingAllocation(providerFundingId, fundingId)
            {
                ProviderFunding = new ProviderFunding(providerFundingId, 10000005, "FURTH", "01GFE")
            };

            // act
            repository.Create(providerFundingAllocation).Wait();

            // assert
            using var assertContext = new FundingAllocationContext(options);

            var storedEntity = assertContext.ProviderFundingAllocations
                .Where(p => p.ProviderFundingId == providerFundingId)
                .Include(pfa => pfa.ProviderFunding).SingleOrDefault();

            storedEntity.Should().NotBeNull("an entity should be stored in the database");
            storedEntity.ProviderFundingId.Should().Be(providerFundingId, "ProviderFundingId should be stored correctly");
            storedEntity.FundingId.Should().Be(fundingId, "FundingId should be stored correctly");
            storedEntity.ProviderFunding.DeliveryUkprn.Should().Be(10000005, "DeliveryUkprn should be stored correctly");
        }

        private int CreateFeedReadRow()
        {
            using var context = new FundingAllocationContext(FundingAllocationContextOptions);
            var feedRead = new FeedRead();
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
