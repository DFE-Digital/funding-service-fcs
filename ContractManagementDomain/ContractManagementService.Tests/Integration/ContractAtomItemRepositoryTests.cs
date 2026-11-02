namespace SFA.FCT.ContractManagementService.Test.Integration
{
    using System;
    using System.Data.SqlClient;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Dapper;
    using global::ContractManagementService.Tests;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.AspNetCore;
    using Microsoft.AspNetCore.Hosting;
    using Microsoft.AspNetCore.TestHost;

    [TestClass]
    public class ContractAtomItemRepositoryTests
    {
        private IServiceProvider Container { get; set; }

        [TestMethod, TestCategory("IntegrationTest_NA")]
        public void ApprovedContractAtomItemRepository_ShouldCreateRowInAtomFeedItemTable()
        {
            DeleteItemsFromTable();
            SetupIoC();
            var repository = Container.GetService<IApprovedContractAtomItemRepository>();
            var content = Guid.NewGuid().ToString();
            const string businessKey = "Some String";
            var item = AtomFeedItem.CreateAtomFeedItem(content, businessKey, AtomItemType.ApprovedContract, xml => true);
            
            repository.Add(item);
            var itemFromDb = GetItem(item.Id);
            Assert.AreEqual(businessKey,  itemFromDb.BusinessKey);
        }

        [TestMethod, TestCategory("IntegrationTest_NA")]
        public void DraftContractAtomItemRepository_ShouldCreateRowInAtomFeedItemTable()
        {
            SetupIoC();
            var repository = Container.GetService<IDraftContractAtomItemRepository>();
            var content = Guid.NewGuid().ToString();
            const string businessKey = "Some String";
            var item = AtomFeedItem.CreateAtomFeedItem(content, businessKey, AtomItemType.DraftContract, xml => true);

            repository.Add(item);
            var itemFromDb = GetItem(item.Id);
            Assert.AreEqual(businessKey, itemFromDb.BusinessKey);
        }

        [TestMethod, TestCategory("IntegrationTest_NA")]
        public void WithdrawContractAtomItemRepository_ShouldCreateRowInAtomFeedItemTable()
        {
            SetupIoC();
            var repository = Container.GetService<IWithdrawnContractAtomItemRepository>();
            var content = Guid.NewGuid().ToString();
            const string businessKey = "Some String";
            var item = AtomFeedItem.CreateAtomFeedItem(content, businessKey, AtomItemType.WithdrawnContract, xml => true);

            repository.Add(item);
            var itemFromDb = GetItem(item.Id);
            Assert.AreEqual(businessKey, itemFromDb.BusinessKey);
        }

        [TestMethod, TestCategory("IntegrationTest_NA")]
        public void ClosedContractAtomItemRepository_ShouldCreateRowInAtomFeedItemTable()
        {
            SetupIoC();
            var repository = Container.GetService<IApprovalOnwardsContractAtomItemRepository>();
            var content = Guid.NewGuid().ToString();
            const string businessKey = "Some String";
            var item = AtomFeedItem.CreateAtomFeedItem(content, businessKey, AtomItemType.ClosedContract, xml => true);

            repository.Add(item);
            var itemFromDb = GetItem(item.Id);
            Assert.AreEqual(businessKey, itemFromDb.BusinessKey);
        }

        private AtomFeedItem GetItem(int id)
        {
            const string sql = @"select * from  [ContractManagement].[AtomFeedItem]" +
                         "where id = @id";
            
            return Connection.QuerySingle<AtomFeedItem>(sql, new {id});
        }

        private void DeleteItemsFromTable()
        {
            const string sql = @"delete from  [ContractManagement].[AtomFeedItem]";

            Connection.Execute(sql);
        }

        protected void SetupIoC()
        {
            var server = new TestServer(
                WebHost.CreateDefaultBuilder()
                    .UseStartup<Startup>()
            );
            Container = server.Host.Services;
        }

        private SqlConnection Connection => new SqlConnection(ConnectionString);
        private string ConnectionString => new AppConfiguration()["ConnectionStrings:ContractManagementDbContext"];
    }
}
