namespace SFA.FCT.ContractManagementService.Test.Integration
{
    using System;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Data.SqlClient;
    using CrossDomain.Integration.Entities.Data;
    using global::ContractManagementService.Tests;
    using Dapper;

    [TestClass]
    public class IntegrityCheckRepositoryTests : IntegrationTestBase
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void IntegrityCheckRepository_ShouldAddItem()
        {
            // arrange
            const string checkName = "TT";
            DateTime runStartDate = DateTime.Now;
            var repository = new IntegrityCheckRepository(GetSqlConnection());

            // act
            IntegrityCheck createdIntegrityCheck = repository.Add(IntegrityCheck.CreateIntegrityCheck(checkName, IntegrityCheck.StatusOptions.Running, runStartDate));
            createdIntegrityCheck = GetIntegrityCheck(createdIntegrityCheck.Id);

            // assert
            Assert.IsTrue(createdIntegrityCheck.Id != 0, "The Id is not set");
            Assert.AreEqual(runStartDate.Date, createdIntegrityCheck.StartDate.Date, "The startDate is not set to the given datetime");
            CleanUp();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void IntegrityCheckRepository_ShouldUpdateItem()
        {
            // arrange
            const string checkName = "TT";
            DateTime runStartDate = DateTime.Now;
            DateTime finishDate = runStartDate.AddDays(1);
            var arrangeRepository = new IntegrityCheckRepository(GetSqlConnection());

            IntegrityCheck createdIntegrityCheck = arrangeRepository.Add(IntegrityCheck.CreateIntegrityCheck(checkName, IntegrityCheck.StatusOptions.Running, runStartDate));
            createdIntegrityCheck = GetIntegrityCheck(createdIntegrityCheck.Id);
            createdIntegrityCheck.Status = IntegrityCheck.StatusOptions.Completed;
            createdIntegrityCheck.FinishDate = finishDate;

            var actRepository = new IntegrityCheckRepository(GetSqlConnection());

            // act
            actRepository.Update(integrityCheck:createdIntegrityCheck);

            // assert
            createdIntegrityCheck = GetIntegrityCheck(createdIntegrityCheck.Id);
            Assert.IsTrue(createdIntegrityCheck.Status == IntegrityCheck.StatusOptions.Completed, "The status has not been set correctly");
            Assert.IsTrue(createdIntegrityCheck.FinishDate.HasValue && createdIntegrityCheck.FinishDate.Value.Date == finishDate.Date, "The FinishDate is not set correctly");
            CleanUp();
        }

        public IntegrityCheck GetIntegrityCheck(int id)
        {
            return GetContractManagementDbContext().IntegrityCheckItems.Single(i => i.Id == id);
        }

        public void CleanUp()
        {
            GetSqlConnection().Execute("truncate table contractmanagement.IntegrityCheck");
        }

        private static SqlConnection GetSqlConnection()
        {
            return new SqlConnection(new AppConfiguration()["ConnectionStrings:ContractManagementDbContext"]);
        }

        private static ContractManagementDbContext GetContractManagementDbContext()
        {
            return new ContractManagementDbContext(new ConnectionInfo(null, GetSqlConnection()));
        }
    }
}
