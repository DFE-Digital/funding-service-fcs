namespace FCT.Operations.Integrity.Tests.Repositories
{
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Operations.Integrity.Repositories;

    [TestClass]
    public class IntegrityCheckChangeTrackingRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void IntegrityCheckChangeTrackingRepository_ShouldGetCurrentVersion()
        {
            const string integrityCheckerName = "TEST_INTEGRITY_CHECKER";
            const long expectedCurrentVersion = 100;

            // arrange
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["OperationsDbContext"].ConnectionString))
            {
                connection.Execute("DELETE FROM Operations.IntegrityCheckChangeTracking WHERE Name = @name",
                    new { name = integrityCheckerName });
                connection.Execute("INSERT INTO Operations.IntegrityCheckChangeTracking (Name, CurrentVersion) VALUES (@name, @currentVersion)",
                    new { name = integrityCheckerName, currentVersion = expectedCurrentVersion });
            }

            var repository = new IntegrityCheckChangeTrackingRepository(new LocalConfig());

            // act
            long retrievedCurrentVersion = repository.GetCurrentVersion(integrityCheckerName);

            // assert
            Assert.AreEqual(expectedCurrentVersion, retrievedCurrentVersion, "CurrentVersion was not retrieved correctly");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void IntegrityCheckChangeTrackingRepository_ShouldGetZeroWhenCurrentVersionIsNull()
        {
            const string integrityCheckerName = "TEST_INTEGRITY_CHECKER";

            // arrange
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["OperationsDbContext"].ConnectionString))
            {
                connection.Execute("DELETE FROM Operations.IntegrityCheckChangeTracking WHERE Name = @name",
                    new { name = integrityCheckerName });
                connection.Execute("INSERT INTO Operations.IntegrityCheckChangeTracking (Name, CurrentVersion) VALUES (@name, NULL)",
                    new { name = integrityCheckerName });
            }

            var repository = new IntegrityCheckChangeTrackingRepository(new LocalConfig());

            // act
            long retrievedCurrentVersion = repository.GetCurrentVersion(integrityCheckerName);

            // assert
            Assert.AreEqual(0, retrievedCurrentVersion, "CurrentVersion was not retrieved correctly");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void IntegrityCheckChangeTrackingRepository_ShouldUpdateCurrentVersion()
        {
            const string integrityCheckerName = "TEST_INTEGRITY_CHECKER";
            const long originalCurrentVersion = 100;
            const long latestCurrentVersion = 200;

            // arrange
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["OperationsDbContext"].ConnectionString))
            {
                connection.Execute("DELETE FROM Operations.IntegrityCheckChangeTracking WHERE Name = @name",
                    new { name = integrityCheckerName });
                connection.Execute("INSERT INTO Operations.IntegrityCheckChangeTracking (Name, CurrentVersion) VALUES (@name, @currentVersion)",
                    new { name = integrityCheckerName, currentVersion = originalCurrentVersion });
            }

            var repository = new IntegrityCheckChangeTrackingRepository(new LocalConfig());

            // act
            repository.Update(integrityCheckerName, latestCurrentVersion);

            // assert
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["OperationsDbContext"].ConnectionString))
            {
                long storedCurrentVersion = connection.ExecuteScalar<long>("SELECT CurrentVersion FROM Operations.IntegrityCheckChangeTracking WHERE Name = @name",
                    new { name = integrityCheckerName });

                Assert.AreEqual(latestCurrentVersion, storedCurrentVersion, "CurrentVersion was not updated correctly");
            }
        }
    }
}
