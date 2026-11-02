namespace FCT.Console.Config.Repositories
{
    using Dapper;
    using Operations.DataStore;
    using Dtos;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Operations.DataStore.Model;

    public static class DeployedConfigVersionRepository
    {
        public static DeployedConfigVersionInfo GetLatestDeployedConfigVersionInfo()
        {
            var connectionString = new SqlConnection(ConfigurationManager.ConnectionStrings["OperationsDbContext"].ConnectionString);
            using (var context = new OperationsDbContext(connectionString))
            {
                var result = context.DeployedConfigVersions
                             .OrderByDescending(res => res.Id)
                             .Select(res => new DeployedConfigVersionInfo
                             {
                                 Version = res.Version,
                                 Checksum = res.Checksum
                             })
                             .Take(1).SingleOrDefault();
                return result;
            }
        }

        public static void AddDeployedConfigVersion(DeployedConfigVersionInfo deployedConfigVersionInfo)
        {
            var connectionString = new SqlConnection(ConfigurationManager.ConnectionStrings["OperationsDbContext"].ConnectionString);

            using (var context = new OperationsDbContext(connectionString))
            {
                context.DeployedConfigVersions.Add(new DeployedConfigVersion(deployedConfigVersionInfo.Version, deployedConfigVersionInfo.Checksum));
                context.SaveChanges();
            }
        }
    }
}