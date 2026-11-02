namespace FCT.Operations.Integrity.Tests.Repositories
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Dapper;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class IntegrityCheckRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void IntegrityCheckRepository_ShouldInsert()
        {
            // arrange 
            const string checkerType = "test add";
            const string status = "InProgress";
            DateTime now = DateTime.Now.Date;
            ClearIntegrityCheckTable();
            IntegrityCheckRepository repository = new IntegrityCheckRepository(new SqlConnection(ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString));
            // act
            repository.Add(IntegrityCheck.CreateIntegrityCheck(checkerType, status, now));

            // assert
            var integrityCheck = GetIntegrityCheck(checkerType);
            integrityCheck.Should().NotBeNull();
            integrityCheck.Status.Should().Be(status);
            integrityCheck.Id.Should().NotBe(0);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void IntegrityCheckRepository_ShouldUpdate()
        {
            // arrange 
            const string checkerType = "test update";
            const string statusAdd = "InProgress";

            const string statusUpdate = "Completed";
            const string outCome = "Success";
            const string link = "xxx_yyy_ANITA_PAAS_EXTRACT_Results.csv";

            var startDate = DateTime.Now.AddDays(-1).Date;
            var finishDate = DateTime.Now.Date;
            ClearIntegrityCheckTable();
            var repository = new IntegrityCheckRepository(new SqlConnection(ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString));

            var integrityCheck = repository.Add(IntegrityCheck.CreateIntegrityCheck(checkerType, statusAdd, startDate));
            integrityCheck.Status = statusUpdate;
            integrityCheck.FinishDate = finishDate;
            integrityCheck.Outcome = outCome;
            integrityCheck.Link = link;

            // act
            repository.Update(integrityCheck);

            // assert
            var assertIntegrityCheck = GetIntegrityCheck(integrityCheck.Id);
            assertIntegrityCheck.Status.Should().Be(statusUpdate);
            assertIntegrityCheck.FinishDate.Should().Be(finishDate);
            assertIntegrityCheck.Outcome.Should().Be(outCome);
            assertIntegrityCheck.Link.Should().Be(link);
        }

        private void ClearIntegrityCheckTable()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"DELETE FROM [ContractManagement].[IntegrityCheck]";
                connection.Execute(sql);
            }
        }

        private IntegrityCheck GetIntegrityCheck(string checkerType)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"SELECT ID, CheckerType, StartDate, Status FROM [ContractManagement].[IntegrityCheck]
                                     where checkerType = @checkerType";
                return connection.Query<IntegrityCheck>(sql, param:new {checkerType})
                    .ToList()
                    .SingleOrDefault();
            }
        }

        private IntegrityCheck GetIntegrityCheck(int id)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"SELECT ID, CheckerType, StartDate, FinishDate, Status, Outcome, Link FROM [ContractManagement].[IntegrityCheck]
                                     where id = @id";
                return connection.Query<IntegrityCheck>(sql, param: new { id })
                    .ToList()
                    .SingleOrDefault();
            }
        }
    }
}
