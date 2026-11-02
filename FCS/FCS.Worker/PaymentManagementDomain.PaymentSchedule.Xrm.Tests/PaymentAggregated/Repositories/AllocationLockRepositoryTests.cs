namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests.PaymentAggregated.Repositories
{
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentSchedule.PaymentAggregated.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class AllocationLockRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationLockRepository_ShouldAquireLockWhenNoOneElseHasIt()
        {
            // arrange
            const string allocationNumber = "Test Al";
            const int version = 1;
            DeleteAllocation(allocationNumber, version);
            InsertAllocation(allocationNumber, version);
            
            string connectionString =
                ConfigurationManager.ConnectionStrings["PaymentManagementPolicyContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                // act
                bool hasLock = new AllocationLockRepository().CanAquireLockOnAllocation(allocationNumber, version,
                    new ConnectionInfo(null, connection));

                // assert
                Assert.IsTrue(hasLock);
            }
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void AllocationLockRepository_ShouldNotAquireLockWhenNoOneElseHasIt()
        {
            // arrange
            const string allocationNumber = "Test Al";
            const int version = 1;
            bool hasExceptionBeenThrown = false;

            // run this code in a sql session
            //@"begin transaction;

            //SELECT AllocationNumber
            //FROM[PaymentSchedule].[Allocation] WITH(ROWLOCK, XLOCK)
            //where AllocationNumber = 'Test Al' and VersionNumber = 1";
           
            // act
            string connectionString =
                ConfigurationManager.ConnectionStrings["PaymentManagementPolicyContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                // act
                bool hasLock = new AllocationLockRepository().CanAquireLockOnAllocation(allocationNumber, version,
                    new ConnectionInfo(null, connection));

                Assert.IsFalse(hasLock);
            }
        }

        private void InsertAllocation(string allocationNumber, int version)
        {
            string connectionString =
                ConfigurationManager.ConnectionStrings["PaymentManagementPolicyContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"Insert into [PaymentSchedule].[Allocation] (AllocationNumber, VersionNumber, ContractVersionNumber, FundingStreamPeriodCode)
                                    values (@allocationNumber, @version, @version, 'TEST-FSP')";

                connection.Execute(sql, new {allocationNumber, version});
            }
        }

        private void DeleteAllocation(string allocationNumber, int version)
        {
            string connectionString =
                ConfigurationManager.ConnectionStrings["PaymentManagementPolicyContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"Delete from [PaymentSchedule].[Allocation] where AllocationNumber = @allocationNumber
                                        and VersionNumber=@version";

                connection.Execute(sql, new { allocationNumber, version });
            }
        }
    }
}
