namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.Data;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class MonthEndRepositoryTests
    {
        [TestCleanup, TestInitialize]
        public void TestCleanup()
        {
            using (var context = new ContractManagementDbContext())
            {
                context.Database.ExecuteSqlCommand("DELETE FROM ContractManagement.MonthEndHistory");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonthEndRepository_StartMonthEnd_ShouldCreateNewMonthEndHistoryRowWithNullEndDate()
        {
            // act
            using (var context = new ContractManagementDbContext())
            {
                var repository = new MonthEndHistoryRepository();
                repository.StartMonthEnd(ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            using (var context = new ContractManagementDbContext())
            {
                List<MonthEndHistory> monthEndHistories = context.MonthEndHistories.ToList();
                Assert.AreEqual(1, monthEndHistories.Count, "An unexpected number of rows were found in the database.");
                Assert.IsNotNull(monthEndHistories.Single().StartTime, "StartTime was null.");
                Assert.IsNull(monthEndHistories.Single().EndTime, "EndTime was not null.");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonthEndRepository_IsMonthEndInProgress_ShouldReturnTrueWhenMonthEndIsInProgress()
        {
            // arrange
            using (var context = new ContractManagementDbContext())
            {
                context.MonthEndHistories.Add(new MonthEndHistory());
                context.SaveChanges();
            }

            // act
            using (var context = new ContractManagementDbContext())
            {
                bool isMonthEndInProgress = new MonthEndHistoryRepository().IsMonthEndInProgress(ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.IsTrue(isMonthEndInProgress, "IsMonthEndInProgress returned false.");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonthEndRepository_IsMonthEndInProgress_ShouldReturnFalseWhenMonthEndIsNotInProgress()
        {
            // arrange
            using (var context = new ContractManagementDbContext())
            {
                context.MonthEndHistories.Add(new MonthEndHistory { EndTime = DateTime.UtcNow });
                context.MonthEndHistories.Add(new MonthEndHistory { EndTime = DateTime.UtcNow });
                context.SaveChanges();
            }

            // act
            using (var context = new ContractManagementDbContext())
            {
                bool isMonthEndInProgress = new MonthEndHistoryRepository().IsMonthEndInProgress(ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.IsFalse(isMonthEndInProgress, "IsMonthEndInProgress returned true.");
            }            
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonthEndRepository_ShouldStopMonthEnd()
        {
            // arrange
            using (var context = new ContractManagementDbContext())
            {
                context.MonthEndHistories.Add(new MonthEndHistory());
                context.SaveChanges();
            }

            using (var context = new ContractManagementDbContext())
            {
                MonthEndHistoryRepository repository = new MonthEndHistoryRepository();
                Assert.IsTrue(repository.IsMonthEndInProgress(ConnectionInfo.CreateFrom(context.Database.Connection)), "Month end was not started");

                // act
                repository.StopMonthEnd(ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            using (var context = new ContractManagementDbContext())
            {
                bool isMonthEndInProgress = new MonthEndHistoryRepository().IsMonthEndInProgress(ConnectionInfo.CreateFrom(context.Database.Connection));

                Assert.IsFalse(isMonthEndInProgress, "IsMonthEndInProgress returned true.");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonthEndRepository_ShouldGetGetCurrentMonthEndStartTime()
        {
            // arrange
            using (var context = new ContractManagementDbContext())
            {
                context.MonthEndHistories.Add(new MonthEndHistory());
                context.SaveChanges();
            }

            DateTime? currentMonthEndStartTime = null;
            using (var context = new ContractManagementDbContext())
            {
                IMonthEndHistoryRepository repository = new MonthEndHistoryRepository();

                // act
                currentMonthEndStartTime = repository.GetCurrentMonthEndStartTime(ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            DateTime? currentMonthEndStartTimeFromDb = null;
            using (var context = new ContractManagementDbContext())
            {
                currentMonthEndStartTimeFromDb = context.MonthEndHistories.First().StartTime;
            }

            // assert
            Assert.IsNotNull(currentMonthEndStartTime, "The current month end start time is null");
            Assert.AreEqual(currentMonthEndStartTimeFromDb, currentMonthEndStartTime, "The current month end start time is not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonthEndRepository_ShouldGetGetCurrentMonthEndStartTimeAsNullWhenTheMonthEndHasBeenStopped()
        {
            // arrange
            using (var context = new ContractManagementDbContext())
            {
                IMonthEndHistoryRepository repository = new MonthEndHistoryRepository();
                repository.StartMonthEnd(ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            using (var context = new ContractManagementDbContext())
            {
                IMonthEndHistoryRepository repository = new MonthEndHistoryRepository();
                repository.StopMonthEnd(ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            DateTime? currentMonthEndStartTime = null;
            using (var context = new ContractManagementDbContext())
            {
                IMonthEndHistoryRepository repository = new MonthEndHistoryRepository();

                // act
                currentMonthEndStartTime = repository.GetCurrentMonthEndStartTime(ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            Assert.IsNull(currentMonthEndStartTime, "The current month end start time is not null");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonthEndRepository_ShouldGetGetCurrentMonthEndStartTimeAsNullWhenThereHasNotBeenAMonthEnd()
        {
            DateTime? currentMonthEndStartTime = null;
            using (var context = new ContractManagementDbContext())
            {
                IMonthEndHistoryRepository repository = new MonthEndHistoryRepository();
                
                // act
                currentMonthEndStartTime = repository.GetCurrentMonthEndStartTime(ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            Assert.IsNull(currentMonthEndStartTime, "The current month end start time is not null");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonthEndRepository_ShouldGetFirstMonthEndStartTimeWhenMoreThanOneMonthEndHasStarted()
        {
            // arrange
            using (var context = new ContractManagementDbContext())
            {
                IMonthEndHistoryRepository repository = new MonthEndHistoryRepository();
                repository.StartMonthEnd(ConnectionInfo.CreateFrom(context.Database.Connection));
                repository.StartMonthEnd(ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            DateTime? currentMonthEndStartTime = null;
            using (var context = new ContractManagementDbContext())
            {
                IMonthEndHistoryRepository repository = new MonthEndHistoryRepository();

                // act
                currentMonthEndStartTime = repository.GetCurrentMonthEndStartTime(ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            Assert.IsNotNull(currentMonthEndStartTime, "The first month end start time cannot be retrieved");
        }
    }
}
