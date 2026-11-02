namespace FundingAllocation.Tests.Endpoints.ReleaseGroup.Repositories
{
    using System;
    using System.Linq;
    using DataStore;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Endpoints.ReleaseGroup.Repositories;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class FundingStreamPeriodRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodRepository_ShouldGetStartAndEndDates()
        {
            // arrange
            const string fundingStreamPeriodCode = "Test-fsp";
            DateTime startDate = DateTime.Now.Date;
            DateTime endDate = startDate.AddYears(1);
            RemoveFsp(fundingStreamPeriodCode);
            InsertFsp(fundingStreamPeriodCode, startDate, endDate);
            FundingStreamPeriodRepository repository = new FundingStreamPeriodRepository(new FundingAllocationContext(GetContextOptions()));

            // act
            var fspDateInfo = repository.GetFspStartAndEndDate(fundingStreamPeriodCode).Result;

            // assert
            fspDateInfo.startDate.Should().Be(startDate);
            fspDateInfo.endDate.Should().Be(endDate);
        }

        private void RemoveFsp(string fspCode)
        {
            FundingAllocationContext context = new FundingAllocationContext(GetContextOptions());
            context.FundingStreamPeriodConfigRows.Where(fsp => fsp.FundingStreamPeriodCode == fspCode)
                .ToList()
                .ForEach(fsp => context.FundingStreamPeriodConfigRows.Remove(fsp));

            context.SaveChanges();
        }

        private void InsertFsp(string fspCode, DateTime startDate, DateTime endDate)
        {
            FundingAllocationContext context = new FundingAllocationContext(GetContextOptions());
            context.FundingStreamPeriodConfigRows.Add(new FundingStreamPeriodConfig(fspCode, "FS -test", "Prefix",
                startDate, endDate));

            context.SaveChanges();
        }

        private static DbContextOptions<FundingAllocationContext> GetContextOptions()
        {
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];

            return new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new Microsoft.Data.SqlClient.SqlConnection(connectionString))
                .Options;
        }
    }
}
