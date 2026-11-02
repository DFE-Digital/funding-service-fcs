namespace FundingAllocation.DataStore
{
    using Microsoft.EntityFrameworkCore;
    using Microsoft.EntityFrameworkCore.Design;

    public class FundingAllocationDbContextFactory : IDesignTimeDbContextFactory<FundingAllocationContext>
    {
        public FundingAllocationContext CreateDbContext(string[] args)
        {
            var optionsBuilder = new DbContextOptionsBuilder<FundingAllocationContext>();
            optionsBuilder.UseSqlServer("Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=fct-database-debug;Integrated Security=True;");

            return new FundingAllocationContext(optionsBuilder.Options);
        }
    }
}