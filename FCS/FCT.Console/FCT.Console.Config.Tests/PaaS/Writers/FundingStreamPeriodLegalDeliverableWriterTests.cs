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

    [TestClass]
    public class FundingStreamPeriodLegalDeliverableWriterTests
    {
        private const string TestFundingStreamPeriodCode = "TestFundingStreamCode";
        private const int TestDeliverableCode = 0;

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodLegalDeliverableWriter_ShouldInsertNewRowToPaas()
        {
            // Arrange
            CleanUp();
            CreateAndPersistFundingStreamPeriod(DateTime.UtcNow.Date);
            IList<FundingStreamPeriodDeliverablesSheetType> rows = new List<FundingStreamPeriodDeliverablesSheetType>()
            {
                CreateSheet(PolicyStatus.Approved, allowProfile: true, deliverableName: "", displayOrder: 1)
            };

            // Act
            FundingStreamPeriodLegalDeliverableWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // Assert
            using (var context = new ContractManagementDbContext())
            {
                FundingStreamPeriodLegalDeliverable foundEntity = context.FundingStreamPeriodLegalDeliverables.Find(TestFundingStreamPeriodCode, TestDeliverableCode);
                Assert.IsNotNull(foundEntity);
            }
            CleanUp();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodLegalDeliverableWriter_ShouldUpdateRowWhenKeyAlreadyExists()
        {
            // Arrange
            CleanUp();
            CreateAndPersistFundingStreamPeriod(DateTime.UtcNow.Date);
            CreateAndPersistFundingStreamPeriodLegalDeliverable();

            var createdDateBeforeAct = GetCreatedDateForFundingStreamPeriodLegalDeliverable();
            IList<FundingStreamPeriodDeliverablesSheetType> rows = new List<FundingStreamPeriodDeliverablesSheetType>()
            {
                CreateSheet(PolicyStatus.Approved, allowProfile: true, deliverableName: "", displayOrder: 1)
            };

            // Act
            FundingStreamPeriodLegalDeliverableWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // Assert
            var createdDateAfterAct = GetCreatedDateForFundingStreamPeriodLegalDeliverable();

            using (var context = new ContractManagementDbContext())
            {
                FundingStreamPeriodLegalDeliverable foundEntity = context.FundingStreamPeriodLegalDeliverables.Find(TestFundingStreamPeriodCode, TestDeliverableCode);
                Assert.IsNotNull(foundEntity, "The FundingStreamPeriodLegalDeliverable was not populated");
                Assert.AreNotEqual(createdDateBeforeAct, createdDateAfterAct, "The FundingStreamPeriodLegalDeliverable was not updated. The created date did not change");
            }
            CleanUp();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodLegalDeliverableWriter_ShouldPopulateANumberOfDifferentFields()
        {
            // Arrange
            CleanUp();
            CreateAndPersistFundingStreamPeriod(DateTime.UtcNow.Date);
            const string deliverableName = "deliverable name";
            const int displayOrder = 10;

            IList<FundingStreamPeriodDeliverablesSheetType> rows = new List<FundingStreamPeriodDeliverablesSheetType>()
            {
                CreateSheet(PolicyStatus.Approved, allowProfile: true, deliverableName: deliverableName, displayOrder: displayOrder)
            };

            // Act
            FundingStreamPeriodLegalDeliverableWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // Assert
            using (var context = new ContractManagementDbContext())
            {
                FundingStreamPeriodLegalDeliverable foundEntity = context.FundingStreamPeriodLegalDeliverables.Find(TestFundingStreamPeriodCode, TestDeliverableCode);
                Assert.IsNotNull(foundEntity, "The FundingStreamPeriodLegalDeliverable was not populated");
                Assert.IsTrue(foundEntity.AllowProfile, "The FundingStreamPeriodLegalDeliverable did not have allowProfile set to true");
                Assert.AreEqual(deliverableName, foundEntity.DeliverableName, "The FundingStreamPeriodLegalDeliverable DeliverableName was not set correctly");
                Assert.AreEqual(displayOrder, foundEntity.DisplayOrder, "The FundingStreamPeriodLegalDeliverable DisplayOrder was not set correctly");
            }
            CleanUp();
        }

        private FundingStreamPeriodDeliverablesSheetType CreateSheet(PolicyStatus policyStatus, bool allowProfile, string deliverableName,  int displayOrder)
        {
            return new FundingStreamPeriodDeliverablesSheetType()
            {
                FundingStreamPeriodCode = TestFundingStreamPeriodCode,
                DeliverableCode = TestDeliverableCode,
                AllowProfile = allowProfile,
                PolicyStatus = policyStatus,
                DeliverableName = deliverableName,
                DisplayOrder = displayOrder
            };
        }

        private void CleanUp()
        {
            using (var context = new ContractManagementDbContext())
            {
                var foundFspEntity = context.FundingStreamPeriods.Find(TestFundingStreamPeriodCode);
                if (foundFspEntity != null)
                {
                    context.FundingStreamPeriods.Remove(foundFspEntity);
                    context.SaveChanges();
                }
            }
        }

        private static void CreateAndPersistFundingStreamPeriod(DateTime startDate)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.FundingStreamPeriods.Add(new FundingStreamPeriod(TestFundingStreamPeriodCode, startDate: startDate));
                context.SaveChanges();
            }
        }

        private void CreateAndPersistFundingStreamPeriodLegalDeliverable()
        {
            using (var context = new ContractManagementDbContext())
            {
                context.FundingStreamPeriodLegalDeliverables.Add(new FundingStreamPeriodLegalDeliverable(TestFundingStreamPeriodCode, TestDeliverableCode, allowProfile: true, deliverableName: "", displayOrder: 0));
                context.SaveChanges();
            }
        }

        private static DateTime GetCreatedDateForFundingStreamPeriodLegalDeliverable()
        {
            using (var context = new ContractManagementDbContext())
            {
                string getCreatedDateQuery = "SELECT [CreatedDate] FROM[ContractManagement].[FundingStreamPeriodLegalDeliverable] " +
                                                   $"WHERE[FundingStreamPeriodCode] =  '{TestFundingStreamPeriodCode}' " +
                                                   $"AND [DeliverableCode] = {TestDeliverableCode}";

                return context.Database.SqlQuery<DateTime>(getCreatedDateQuery).FirstAsync().Result;
            }
        }
    }
}

