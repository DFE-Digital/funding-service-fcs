namespace PerformanceManagementDomain.Tests.PullFundingClaim
{
    using System;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.PullFundingClaim.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    [TestClass]
    public class FundingClaimCollectionImportInfoRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimCollectionImportInfoRepository_GetLastCompletedImportDate_ShouldReturnMinDateWhenThereArentAny()
        {
            // arrange
            RemoveRows();
            FundingClaimImportInfoRepository repository = new FundingClaimImportInfoRepository();
            using (var context = new PerformanceManagementDbContext())
            {
                // act    
                var date = repository
                    .GetLastCompletedImportDateOrDefault(new ConnectionInfo(connection: context.Database.Connection,
                        transaction: null)).Result;

                // assert
                Assert.AreEqual(DateTime.MinValue, date);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimCollectionImportInfoRepository_GetLastCompletedImportDate_ShouldReturnMostRecentWhenThereAreValues()
        {
            // arrange
            RemoveRows();
            DateTime now = DateTime.Now;

            AddRow(now, "some pct");
            AddRow(now.AddDays(1), "some pct2");
            AddRow(now.AddDays(2), "some pct3");
            FundingClaimImportInfoRepository repository = new FundingClaimImportInfoRepository();
            using (var context = new PerformanceManagementDbContext())
            {
                // act    
                var date = repository
                    .GetLastCompletedImportDateOrDefault(new ConnectionInfo(connection: context.Database.Connection,
                        transaction: null)).Result;

                // assert
                Assert.AreEqual(now.AddDays(2).ToDateTimeWithoutMilliseconds(), date.ToDateTimeWithoutMilliseconds());
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimCollectionImportInfoRepository_AddOrUpdate_ShouldAddRowWhenNotPresent()
        {
            // arrange
            const string periodClaimType = "periodClaimType1";
            const int totalRows = 10;
            RemoveRows();

            FundingClaimImportInfoRepository repository = new FundingClaimImportInfoRepository();
            using (var context = new PerformanceManagementDbContext())
            {
                // act    
                repository.Add(periodClaimType, totalRows, ConnectionInfo.CreateFrom(context.Database.Connection))
                    .Wait();

                // assert
                var row = GetRow(periodClaimType);
                Assert.AreEqual(totalRows, row.TotalRowsToImport);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimCollectionImportInfoRepository_SetToComplete_ShouldCompletedDate()
        {
            // arrange
            const string periodClaimType = "periodClaimType1";
            const int totalRows = 10;
            RemoveRows();
            DateTime now = DateTime.Now;

            AddRow(periodClaimType, totalRows);
            FundingClaimImportInfoRepository repository = new FundingClaimImportInfoRepository();
            using (var context = new PerformanceManagementDbContext())
            {
                // act    
                repository.SetToComplete(periodClaimType, completedDate: now, ConnectionInfo.CreateFrom(context.Database.Connection))
                    .Wait();

                // assert
                var row = GetRow(periodClaimType);
                Assert.AreEqual(now.ToDateTimeWithoutMilliseconds(), row.ImportCompletedDate.Value.ToDateTimeWithoutMilliseconds());
            }
        }

        private static void RemoveRows()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.FundingClaimCollectionImportInfos.ToList().ForEach(f =>
                {
                    context.FundingClaimCollectionImportInfos.Remove(f);
                });

                context.SaveChanges();
            }
        }

        private static void AddRow(DateTime dateTime, string periodClaimType)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.FundingClaimCollectionImportInfos.Add(new FundingClaimCollectionImportInfo(periodClaimType)
                {
                    ImportCompletedDate = dateTime
                });

                context.SaveChanges();
            }
        }

        private static void AddRow(string periodClaimType, int totalRows)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.FundingClaimCollectionImportInfos.Add(new FundingClaimCollectionImportInfo(periodClaimType)
                    {
                        TotalRowsToImport = totalRows
                    }
                );

                context.SaveChanges();
            }
        }

        private static FundingClaimCollectionImportInfo GetRow(string periodClaimType)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                return context.FundingClaimCollectionImportInfos.Single(f => f.PeriodClaimType == periodClaimType);
            }
        }
    }

    internal static class DateTimeExtensions
    {
        public static DateTime ToDateTimeWithoutMilliseconds(this DateTime dateTime)
        {
            return
                new DateTime(dateTime.Year, dateTime.Month, dateTime.Day, dateTime.Hour, dateTime.Minute, dateTime.Second);
        }
    }
}
