namespace FCT.Operations.DataStore
{
    using Microsoft.EntityFrameworkCore;
    using Microsoft.EntityFrameworkCore.Design;

    public class OperationsDbContextFactory : IDesignTimeDbContextFactory<OperationsContext>
    {
        public OperationsContext CreateDbContext(string[] args)
        {
            var optionsBuilder = new DbContextOptionsBuilder<OperationsContext>();
            optionsBuilder.UseSqlServer("Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=fct-database-debug3;Integrated Security=True;");

            return new OperationsContext(optionsBuilder.Options);
        }
    }
}