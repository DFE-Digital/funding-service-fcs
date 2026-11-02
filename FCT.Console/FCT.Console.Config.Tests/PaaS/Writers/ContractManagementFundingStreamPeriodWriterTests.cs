namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System;
    using System.Collections.Generic;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;
    using UnitTests.Common;
    using System.Linq;

    [TestClass]
    public class ContractManagementFundingStreamPeriodWriterTests
    {
        private const string FundingStreamPeriodCode = "TestFundingStreamCode";

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractManagementFundingStreamPeriodWriter_ShouldInsertNewRowToPaas()
        {
            // Arrange
            CleanUp();
            var today = DateTime.UtcNow.Date;

            IList<FundingStreamPeriodSheetType> rows = new List<FundingStreamPeriodSheetType>()
            {
                CreateSheet(PolicyStatus.Approved, today)
            };

            // Act
            ContractManagementFundingStreamPeriodWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // Assert
            using (var context = new ContractManagementDbContext())
            {
                FundingStreamPeriod foundEntity = context.FundingStreamPeriods.Find(FundingStreamPeriodCode);
                Assert.IsNotNull(foundEntity, "FundingStreamPeriod was not added");
                Assert.AreEqual(today, foundEntity.StartDate, "Incorrect start date");
            }
            CleanUp();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractManagementFundingStreamPeriodWriter_ShouldUpdateRowWhenKeyAlreadyExists()
        {
            // Arrange
            CleanUp();
            var today = DateTime.UtcNow.Date;
            var tomorrow = DateTime.UtcNow.Date.AddDays(1);
            CreateAndPersistFundingStreamPeriod(today);

            IList<FundingStreamPeriodSheetType> rows = new List<FundingStreamPeriodSheetType>()
            {
                CreateSheet(PolicyStatus.Approved, tomorrow)
            };

            // Act
            ContractManagementFundingStreamPeriodWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // Assert
            using (var context = new ContractManagementDbContext())
            {
                FundingStreamPeriod foundEntity = context.FundingStreamPeriods.Find(FundingStreamPeriodCode);
                Assert.IsNotNull(foundEntity, "FundingStreamPeriod  was not populated");
                Assert.AreEqual(tomorrow, foundEntity.StartDate, "start date was not correctly updated");
            }
            CleanUp();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractManagementFundingStreamPeriodWriter_ShouldRemoveRow()
        {
            // Arrange
            CleanUp();
            var today = DateTime.UtcNow.Date;
            CreateAndPersistFundingStreamPeriod(today);

            IList<FundingStreamPeriodSheetType> rows = new List<FundingStreamPeriodSheetType>()
            {
                CreateSheet(PolicyStatus.Removed, today)
            };

            // Act
            ContractManagementFundingStreamPeriodWriter.WriteToPaaSDatabase(rows, WriterBehaviour.Delete);

            // Assert
            using (var context = new ContractManagementDbContext())
            {
                FundingStreamPeriod foundEntity = context.FundingStreamPeriods.Find(FundingStreamPeriodCode);
                Assert.IsNull(foundEntity, "FundingStreamPeriod  was not removed");
            }
        }

        private static void CleanUp()
        {
            using (var context = new ContractManagementDbContext())
            {
                context.FundingStreamPeriods.RemoveWhere(fsp => fsp.FundingStreamPeriodCode == FundingStreamPeriodCode);
                context.SaveChanges();
            }
        }

        private static FundingStreamPeriodSheetType CreateSheet(PolicyStatus policyStatus, DateTime startDateTime)
        {
            return new FundingStreamPeriodSheetType()
            {
                FundingStreamPeriodCode = FundingStreamPeriodCode,
                StartDate = startDateTime,
                PolicyStatus = policyStatus
            };
        }

        private static void CreateAndPersistFundingStreamPeriod(DateTime startDate)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.FundingStreamPeriods.Add(new FundingStreamPeriod(FundingStreamPeriodCode, startDate: startDate));
                context.SaveChanges();
            }
        }
    }
}