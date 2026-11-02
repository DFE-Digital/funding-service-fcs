namespace Operations.Web.Tests.Repositories
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Web.Repositories;

    [TestClass]
    public class ConnectivityRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ConnectivityRepository_ShouldGetAvailabilityCheckResult()
        {
            // arrange
            const string serviceName = "CFS_API_TEST";
            const string suppInfo = "suppInfo";
            ClearServiceFromTable(serviceName);
            InsertRowIntoTable(serviceName, canConnect: true, suppInfo: suppInfo);
            var repository = new ConnectivityRepository();
            
            // act
            var res = repository.GetAvailabilityCheckResult(serviceName).Result;
            
            // assert
            res.IsAvailable.Should().BeTrue();
            res.SupplementaryInfo.Should().Be(suppInfo);
        }

        private void InsertRowIntoTable(string serviceName, bool canConnect, string suppInfo)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            SqlConnection connection = new SqlConnection(connectionString);

            const string sql = @"insert into [Operations].[Connectivity] ([ServiceName]
      ,[CanConnect]
      ,[ErrorInfo]
      ,[SupplementaryInfo]
      ,[LastUpdated])
      values (@serviceName, @canConnect, @errorInfo, @suppInfo, @now)";
            const string errorInfo = null;
            DateTime now = DateTime.Now;

            connection.Execute(sql, new { serviceName, canConnect, errorInfo, suppInfo, now });
        }

        private void ClearServiceFromTable(string serviceName)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            SqlConnection connection = new SqlConnection(connectionString);

            const string sql = "delete from [Operations].[Connectivity] where ServiceName=@serviceName";

            connection.Execute(sql, new {serviceName});
        }
    }
}
