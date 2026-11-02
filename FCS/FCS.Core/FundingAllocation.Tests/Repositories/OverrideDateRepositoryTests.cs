namespace FundingAllocation.Tests.Repositories
{
    using System;
    using System.Data.SqlClient;
    using Dapper;
    using DataStore;
    using FluentAssertions;
    using FundingAllocation.Repositories;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class OverrideDateRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void OverrideDateRepository_ShouldReturnDateFromTableIfThereIsOne()
        {
            // arrange
            DateTime date = DateTime.Now.Date;
            ClearOverrideTable();
            InsertDateIntoOverrideTable(date);
            OverrideDateRepository repository = new OverrideDateRepository(new FundingAllocationContext(DbContextOptions));

            // act
            var dateReturned = repository.GetDate().Result;
            // assert
            dateReturned.Should().Be(date);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void OverrideDateRepository_ShouldReturnDateIfTableIsEmpty()
        {
            // arrange
            DateTime date = DateTime.Now.Date;
            ClearOverrideTable();
            OverrideDateRepository repository = new OverrideDateRepository(new FundingAllocationContext(DbContextOptions));

            // act
            var dateReturned = repository.GetDate().Result;
            // assert
            dateReturned.Date.Should().Be(date);
        }

        private void ClearOverrideTable()
        {
            const string sql = @"Delete from [OverrideDate].[OverrideDate]";
            FundingAllocationContext context = new FundingAllocationContext(DbContextOptions);
            
            context.Database.GetDbConnection().Execute(sql);
        }

        private void InsertDateIntoOverrideTable(DateTime date)
        {
            const string sql = @"Insert into [OverrideDate].[OverrideDate]
                                 values(@date)";
            FundingAllocationContext context = new FundingAllocationContext(DbContextOptions);

            context.Database.GetDbConnection().Execute(sql, param:new {date});
        }

        private DbContextOptions<FundingAllocationContext> DbContextOptions => new DbContextOptionsBuilder<FundingAllocationContext>()
            .UseSqlServer(new SqlConnection(AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"]))
            .Options;
    }
}
