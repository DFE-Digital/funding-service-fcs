namespace FundingAllocation.Tests.TestHelpers
{
    using System.Data.SqlClient;
    using DataStore;
    using Microsoft.EntityFrameworkCore;

    public static class DbOptionsFactory
    {
        public static  DbContextOptions<FundingAllocationContext> DbContextOptions => new DbContextOptionsBuilder<FundingAllocationContext>()
            .UseSqlServer(new SqlConnection(AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"]))
            .Options;
    }
}
