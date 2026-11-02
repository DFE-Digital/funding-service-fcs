namespace FundingAllocation.Tests.Endpoints.ReleaseGroup.Repositories
{
    using System.Data.SqlClient;
    using DataStore;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Endpoints.ReleaseGroup.Repositories;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class FundingTypeRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeRepository_ShouldGetContractNumberPrefix()
        {
            const string fundingTypeCode = "TEST-FT";
            const string contractNumberPrefix = "ABC";

            // arrange
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var context = new FundingAllocationContext(options);

            context.Database.ExecuteSqlRaw($"DELETE FROM FundingAllocation.FundingTypeConfig WHERE FundingTypeCode = '{fundingTypeCode}'");
            context.FundingTypeConfigRows.Add(new FundingTypeConfig(fundingTypeCode, contractNumberPrefix));
            context.SaveChanges();

            var repository = new FundingTypeRepository(new FundingAllocationContext(options));

            // act
            string prefix = repository.GetContractNumberPrefix(fundingTypeCode).Result;

            // assert
            prefix.Should().Be(contractNumberPrefix);
            context.Database.ExecuteSqlRaw($"DELETE FROM FundingAllocation.FundingTypeConfig WHERE FundingTypeCode = '{fundingTypeCode}'");
        }

    }
}
