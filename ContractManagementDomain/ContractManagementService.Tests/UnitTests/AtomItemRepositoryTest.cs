namespace SFA.FCT.ContractManagementService.Test.UnitTests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Data.SqlClient;
    using CrossDomain.Integration.Entities.Data;
    using global::ContractManagementService.Tests;

    [TestClass]
    public class AtomItemRepositoryTest
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AtomItemRepository_ShouldThrowAnExceptionWhenThePageNumberIsOutOfRange()
        {
            // arrange
            RemoveItemsFromTable();
            CreateAtomFeedItems(25);
            bool exceptionThrown = false;

            using (var context = GetContractManagementDbContext())
            {
                ApprovedContractAtomItemRepository repository = new ApprovedContractAtomItemRepository(context);

                try
                {
                    int currentPageNumber = 3;

                    // act
                    repository.GetNextPageNumber(--currentPageNumber);
                }
                catch (ArgumentOutOfRangeException)
                {
                    exceptionThrown = true;
                }
            }
                
            // assert
            Assert.AreEqual(true, exceptionThrown, "An exception was not thrown");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AtomItemRepository_ShouldThrowAnExceptionWhenThePageNumberIsOutOfRangeTooLow()
        {
            // arrange
            RemoveItemsFromTable();
            CreateAtomFeedItems(25);
            bool exceptionThrown = false;
            using (var context = GetContractManagementDbContext())
            {
                ApprovedContractAtomItemRepository repository = new ApprovedContractAtomItemRepository(context);

                try
                {
                    int currentPageNumber = 0;

                    // act
                    repository.GetNextPageNumber(--currentPageNumber);
                }
                catch (ArgumentOutOfRangeException)
                {
                    exceptionThrown = true;
                }
            }
               
            // assert
            Assert.AreEqual(true, exceptionThrown, "An exception was not thrown");
        }

        private static void CreateAtomFeedItems(int numItems)
        {
            IList<AtomFeedItem> listOfItems = new List<AtomFeedItem>();

            for (int i = 0; i < numItems; i++)
            {
                listOfItems.Add(AtomFeedItem.CreateAtomFeedItem("Some obj str", $"Key{i}", AtomItemType.ApprovedContract, xml => true));
            }

            using (var context = GetContractManagementDbContext())
            {
                listOfItems.ToList().ForEach(i => context.AtomFeedItems.Add(i));

                context.SaveChanges();
            }
        }

        private static void RemoveItemsFromTable()
        {
            using (var context = GetContractManagementDbContext())
            {
                context.AtomFeedItems.ToList().ForEach(a => context.AtomFeedItems.Remove(a));

                context.SaveChanges();
            }
        }

        private static ContractManagementDbContext GetContractManagementDbContext()
        {
            var sqlConnection = new SqlConnection(new AppConfiguration()["ConnectionStrings:ContractManagementDbContext"]);
            return new ContractManagementDbContext(new ConnectionInfo(null, sqlConnection));
        }
    }
}
