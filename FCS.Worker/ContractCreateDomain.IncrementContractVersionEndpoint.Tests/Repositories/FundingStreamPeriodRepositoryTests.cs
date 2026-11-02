namespace ContractCreateDomain.IncrementContractVersionEndpoint.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using IncrementContractVersionEndpoint.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class FundingStreamPeriodRepositoryTests
    {
        private const string FspCodeToTest = "FspCodeLEVY";
        private const string LegalDeliverable1 = "LegalDeliverable1";
        private const string LegalDeliverable2 = "LegalDeliverable2";

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodRepository_Find_ShouldReturnFundingStreamPeriodValuesIncludingLegalDeliverables()
        {
            // arrange
            ClearDown();
            CreateFspAndLegalDels();

            FundingStreamPeriodRepository repository = new FundingStreamPeriodRepository();
            
            using (var context = new ContractManagementDbContext())
            {
                ConnectionInfo connectionInfo = new ConnectionInfo(context.Database.CurrentTransaction?.UnderlyingTransaction, context.Database.Connection);

                // act
                FundingStreamPeriod fundingStreamPeriod = repository.Find(FspCodeToTest, connectionInfo).Result;

                // assert
                Assert.IsNotNull(fundingStreamPeriod, "Unexpected null value returned");
                Assert.AreEqual(FspCodeToTest, fundingStreamPeriod.FundingStreamPeriodCode, "Unexpected FundingStreamPeriodCode returned");
                Assert.AreEqual(new DateTime(2019, 08, 01, 0, 0, 0), fundingStreamPeriod.StartDate, "Unexpected StartDate returned");
                Assert.AreEqual(DateTimeKind.Utc, fundingStreamPeriod.StartDate.Kind, "Unexpected StartDate DateTimeKind returned");
                Assert.IsNotNull(fundingStreamPeriod.LegalDeliverables, "Unexpected number of Legal Deliverables returned");
                Assert.AreEqual(2, fundingStreamPeriod.LegalDeliverables.Count, "Unexpected number of Legal Deliverables returned");
                Assert.IsTrue(fundingStreamPeriod.LegalDeliverables.Any(ld => ld.DeliverableCode == 1), "Expected Legal Deliverable not returned");
                Assert.IsTrue(fundingStreamPeriod.LegalDeliverables.Any(ld => ld.DeliverableCode == 8), "Expected Legal Deliverable not returned");
            }
            ClearDown();
        }

        private void CreateFspAndLegalDels()
        {
            List<FundingStreamPeriodLegalDeliverable> legalDels = new List<FundingStreamPeriodLegalDeliverable>
            {
                new FundingStreamPeriodLegalDeliverable(FspCodeToTest, 1, true, LegalDeliverable1, 1),
                new FundingStreamPeriodLegalDeliverable(FspCodeToTest, 8, true, LegalDeliverable2, 8)
            };

            using (var context = new ContractManagementDbContext())
            {
                context.FundingStreamPeriods.Add(new FundingStreamPeriod(FspCodeToTest, new DateTime(2019, 08, 01, 0, 0, 0)));

                legalDels.ForEach(d => context.FundingStreamPeriodLegalDeliverables.Add(d));

                context.SaveChanges();
            }
        }

        public void ClearDown()
        {
            using (var context = new ContractManagementDbContext())
            {
                var legalDelsToDelete = context.FundingStreamPeriodLegalDeliverables.Where(dc => dc.FundingStreamPeriodCode == FspCodeToTest).ToList();
                var fspToDelete = context.FundingStreamPeriods.Where(fsp => fsp.FundingStreamPeriodCode == FspCodeToTest).ToList();

                legalDelsToDelete.ForEach(dtd => context.FundingStreamPeriodLegalDeliverables.Remove(dtd));
                fspToDelete.ForEach(fsp => context.FundingStreamPeriods.Remove(fsp));

                context.SaveChanges();
            }
        }
    }
}