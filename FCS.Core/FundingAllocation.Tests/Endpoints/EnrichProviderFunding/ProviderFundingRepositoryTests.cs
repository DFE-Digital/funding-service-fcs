namespace FundingAllocation.Tests.Endpoints.EnrichProviderFunding
{
    using System;
    using System.Data.SqlClient;
    using System.Linq;
    using DataStore;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Endpoints.EnrichProviderFunding.Repositories;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestHelpers.Extensions;

    [TestClass]
    public class ProviderFundingRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ProviderFundingRepository_IsProviderFundingInDb_ShouldReturnTrueWhenProviderPresent()
        {
            // arrange
            const string providerFundingId = "1619-AS-2021-10001302-2_5";
            ClearProviderFundings();
            InsertProviderFunding(providerFundingId);
            ProviderFundingRepository repository = new ProviderFundingRepository(new LoggingContext(GetContextOptions()));

            // act
            var isProviderFundingInDb = repository.IsProviderFundingInDb(providerFundingId).Result;

            // assert
            isProviderFundingInDb.Should().BeTrue();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ProviderFundingRepository_IsProviderFundingInDb_ShouldReturnFalseWhenProviderNotPresent()
        {
            // arrange
            const string providerFundingId = "1619-AS-2021-10001302-2_5";
            const string otherProviderFundingId = "1619-AS-2021-10001304-2_5";
            ClearProviderFundings();
            InsertProviderFunding(otherProviderFundingId);
            ProviderFundingRepository repository = new ProviderFundingRepository(new LoggingContext(GetContextOptions()));

            // act
            var isProviderFundingInDb = repository.IsProviderFundingInDb(providerFundingId).Result;

            // assert
            isProviderFundingInDb.Should().BeFalse();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ProviderFundingRepository_Create_ShouldCreateProviderFunding()
        {
            // arrange
            const string providerFundingId = "1619-AS-2021-10001302-2_5";
            const int ukprn = 12345678;
            const string providerType = "some pt";
            const string providerSubType = "some pst";
            const string lineCode = "some line code";
            ClearProviderFundings();
            ProviderFundingRepository repository = new ProviderFundingRepository(new LoggingContext(GetContextOptions()));
            var providerFunding = new ProviderFunding(providerFundingId, ukprn, providerType, providerSubType);
            providerFunding.FundingAllocationLines.Add(new FundingAllocationLine(providerFundingId, lineCode));

            // act
            repository.Create(providerFunding).Wait();
            
            // assert
            var providerFundingInDb = GetProviderFunding(providerFundingId);

            providerFundingInDb.Should().NotBeNull();
            providerFundingInDb.DeliveryUkprn.Should().Be(ukprn);
            providerFundingInDb.ProviderType.Should().Be(providerType);
            providerFundingInDb.ProviderSubType.Should().Be(providerSubType);
            providerFundingInDb.FundingAllocationLines.Count.Should().Be(1);
            providerFundingInDb.FundingAllocationLines.Single().FundingLineCode.Should().Be(lineCode);
        }

        private void InsertProviderFunding(string providerFundingId)
        {
            using var context = new FundingAllocationContext(GetContextOptions());
            context.ProviderFundings.Add(new ProviderFunding(providerFundingId, 1, string.Empty, string.Empty));
            context.SaveChanges();
        }

        private void ClearProviderFundings()
        {
            using var context = new FundingAllocationContext(GetContextOptions());
            context.ProviderFundings.RemoveAll();
            context.SaveChanges();
        }

        private ProviderFunding GetProviderFunding(string providerFundingId)
        {
            using var context = new FundingAllocationContext(GetContextOptions());
            return context.ProviderFundings.AsNoTracking()
                .Include(pf => pf.FundingAllocationLines)
                .SingleOrDefault(pf => pf.ProviderFundingId == providerFundingId);
        }

        private static DbContextOptions<FundingAllocationContext> GetContextOptions()
        {
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];

            return new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;
        }

        private class LoggingContext : FundingAllocationContext
        {
            public LoggingContext(DbContextOptions<FundingAllocationContext> options) : base(options)
            {
            }

            protected override void OnConfiguring(DbContextOptionsBuilder options)
            {
                options.LogTo(Console.WriteLine);
                base.OnConfiguring(options);
            }
        }
    }
}
