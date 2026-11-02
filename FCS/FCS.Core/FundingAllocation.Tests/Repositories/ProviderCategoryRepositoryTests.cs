namespace FundingAllocation.Tests.Repositories
{
    using System.Data.SqlClient;
    using Dapper;
    using DataStore;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Repositories;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ProviderCategoryRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ProviderCategoryRepository_GetProviderCategoryExceptionOrDefault_ShouldReturnExceptionWhenPresent()
        {
            // arrange
            using var context = new FundingAllocationContext(DbContextOptions);
            ProviderCategoryException providerCategoryException = new ProviderCategoryException("test-ft-code", "test-period-code", "test-ukprn", "test-category");
            ClearProviderCategoryException(context, providerCategoryException);
            CreateProviderCategoryException(context, providerCategoryException);
            ProviderCategoryRepository repository = new ProviderCategoryRepository(context);
            
            // act
            var category = repository.GetProviderCategoryExceptionOrDefault(
                "test-provider-type",
                "test-provider-sub-type",
                providerCategoryException.FundingTypeCode,
                providerCategoryException.FundingPeriodCode,
                providerCategoryException.UKPRN).Result;

            // assert
            category.Should().Be(providerCategoryException.Category);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ProviderCategoryRepository_GetProviderCategoryExceptionOrDefault_ShouldReturnDefaultWhenExceptionNotPresent()
        {
            // arrange
            using var context = new FundingAllocationContext(DbContextOptions);
            ProviderCategoryException providerCategoryException = new ProviderCategoryException("test-ft-code", "test-period-code", "test-ukprn", "test-category");
            ClearProviderCategoryException(context, providerCategoryException);
            CreateProviderCategoryException(context, providerCategoryException);
            ProviderTypeConfig providerTypeConfig = new ProviderTypeConfig("Schoo-test", "08SSF-test", "SSF-test");
            ClearProviderTypeConfig(context, providerTypeConfig);
            CreateProviderTypeConfig(context, providerTypeConfig);
            ProviderCategoryRepository repository = new ProviderCategoryRepository(context);

            // act
            var category = repository.GetProviderCategoryExceptionOrDefault(
                providerTypeConfig.Type,
                providerTypeConfig.Subtype,
                providerCategoryException.FundingTypeCode,
                providerCategoryException.FundingPeriodCode,
                "some-other-ukprn").Result;

            // assert
            category.Should().Be(providerTypeConfig.Category);
        }

        private void CreateProviderTypeConfig(FundingAllocationContext context, ProviderTypeConfig providerTypeConfig)
        {
            const string sql =
                @"Insert into [FundingAllocation].[ProviderTypeConfig]
                  ([Type],
                   [SubType],
                   [Category])
                  Values (@type, @subType, @category)";

            context.Database.GetDbConnection().Execute(sql, providerTypeConfig);
        }

        private void ClearProviderTypeConfig(FundingAllocationContext context, ProviderTypeConfig providerTypeConfig)
        {
            const string sql =
                @"Delete from [FundingAllocation].[ProviderTypeConfig]
                  Where
                  [Type] = @type
                  and [SubType] = @subType";

            context.Database.GetDbConnection().Execute(sql, providerTypeConfig);
        }

        private static void CreateProviderCategoryException(FundingAllocationContext context, ProviderCategoryException providerCategoryException)
        {
            const string sql =
                @"Insert into [FundingAllocation].[ProviderCategoryException]
                  ([FundingTypeCode],
                   [FundingPeriodCode],
                   [UKPRN],
                   [Category])
                  Values (@fundingTypeCode, @fundingPeriodCode, @ukprn, @category)";

            context.Database.GetDbConnection().Execute(sql, providerCategoryException);
        }

        private static void ClearProviderCategoryException(FundingAllocationContext context, ProviderCategoryException providerCategoryException)
        {
            const string sql =
                @"Delete from [FundingAllocation].[ProviderCategoryException]
                  Where
                  [FundingTypeCode] = @fundingTypeCode
                  and [FundingPeriodCode] = @fundingPeriodCode
                  and [UKPRN] = @uKPRN";

            context.Database.GetDbConnection().Execute(sql, providerCategoryException);
        }

        private DbContextOptions<FundingAllocationContext> DbContextOptions => new DbContextOptionsBuilder<FundingAllocationContext>()
            .UseSqlServer(new SqlConnection(AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"]))
            .Options;
    }
}
