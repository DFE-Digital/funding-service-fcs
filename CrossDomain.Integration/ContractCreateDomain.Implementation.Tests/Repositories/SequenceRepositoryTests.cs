namespace ContractCreateDomain.Implementation.Tests.Repositories
{
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.Implementation.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class SequenceRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void SequenceRepository_ShouldReturnNextNumber()
        {
            const string fundingType = "TEST";
            const string sequenceName = "Contract_TEST_Seq";
            const int expectedNextNumber = 101;
            string sqlConnectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            // arrange
            using (SqlConnection sqlConnection = new SqlConnection(sqlConnectionString))
            {
                sqlConnection.Execute($"DROP SEQUENCE IF EXISTS ContractManagement.{sequenceName}");
                sqlConnection.Execute($"CREATE SEQUENCE ContractManagement.{sequenceName} START WITH {expectedNextNumber} INCREMENT BY 1");
            }

            SequenceRepository nextNumberRepository = new SequenceRepository();

            // act
            int actualNextNumber = nextNumberRepository.GetNextNumber(
                SequenceType.Contract,
                fundingType,
                new ConnectionInfo(null, new SqlConnection(sqlConnectionString))).Result;

            // assert
            Assert.AreEqual(expectedNextNumber, actualNextNumber);
        }
    }
}
