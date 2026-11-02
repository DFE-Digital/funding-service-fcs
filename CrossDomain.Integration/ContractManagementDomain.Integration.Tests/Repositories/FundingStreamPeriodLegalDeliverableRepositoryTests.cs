namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;

    [TestClass]
    public class FundingStreamPeriodLegalDeliverableRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodLegalDeliverableRepository_ShouldGetDeliverables()
        {
            // arrange
            const string testFsp = "Test Fsp";
            IReadOnlyCollection<int> deliverables = new List<int> {1, 2, 5};

            ClearFspDeliverableTableForFsp(testFsp);
            ClearFspTableForFsp(testFsp);

            using (var context = new ContractManagementDbContext())
            {
                context.FundingStreamPeriods.Add(
                    new FundingStreamPeriod(testFsp, DateTime.Now.Date));

                deliverables.ForEach(d =>
                    {
                        context.FundingStreamPeriodLegalDeliverables.Add(
                            new FundingStreamPeriodLegalDeliverable(
                                fundingStreamPeriodCode: testFsp, deliverableCode: d, allowProfile: true, deliverableName: "", displayOrder: 0));
                    });

                context.SaveChanges();
            }

            IReadOnlyCollection<int> deliverablesReturned = null;
            using (var context = new ContractManagementDbContext())
            {
                FundingStreamPeriodLegalDeliverableRepository repository = new FundingStreamPeriodLegalDeliverableRepository(context);

                // act   
                deliverablesReturned = repository.GetLegalDeliverablesForFsp(testFsp);
            }

            // assert
            Assert.AreEqual(deliverables.Count, deliverablesReturned.Count);

            ClearFspDeliverableTableForFsp(testFsp);
            ClearFspTableForFsp(testFsp);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodLegalDeliverableRepository_ShouldGetAllProfileLegalFspDeliverables()
        {
            const string testFsp = "Test Fsp";
            const int aggregateDeliverable = 1;
            const int profileDeliverable = 2;

            ClearFspDeliverableTableForFsp(testFsp);
            ClearFspTableForFsp(testFsp);

            using (var context = new ContractManagementDbContext())
            {
                context.FundingStreamPeriods.Add(
                    new FundingStreamPeriod(testFsp, DateTime.Now.Date));

                context.FundingStreamPeriodLegalDeliverables.Add(
                   new FundingStreamPeriodLegalDeliverable(
                       fundingStreamPeriodCode: testFsp, deliverableCode: aggregateDeliverable, allowProfile: false, deliverableName: "", displayOrder: 0));

                context.FundingStreamPeriodLegalDeliverables.Add(
                    new FundingStreamPeriodLegalDeliverable(
                        fundingStreamPeriodCode: testFsp, deliverableCode: profileDeliverable, allowProfile: true, deliverableName: "", displayOrder: 0));

                context.SaveChanges();
            }

            using (var context = new ContractManagementDbContext())
            {
                FundingStreamPeriodLegalDeliverableRepository repository = new FundingStreamPeriodLegalDeliverableRepository(context);

                // act   
                IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> allProfileLegalFspDeliverables = repository.GetAllProfileLegalFspDeliverables();

                // assert
                Assert.IsFalse(allProfileLegalFspDeliverables.Any(d => d.FundingStreamPeriodCode == testFsp && d.DeliverableCode == aggregateDeliverable),
                    "Aggregate (non-profile) deliverable should not be in profile legal fsp deliverables returned");
                Assert.IsTrue(allProfileLegalFspDeliverables.Any(d => d.FundingStreamPeriodCode == testFsp && d.DeliverableCode == profileDeliverable), 
                    "Profile deliverable should be in profile legal FSP deliverables returned");
            }

            ClearFspDeliverableTableForFsp(testFsp);
            ClearFspTableForFsp(testFsp);
        }

        private void ClearFspTableForFsp(string fspCode)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.FundingStreamPeriods.Where(fsp => fsp.FundingStreamPeriodCode == fspCode)
                    .ForEach(fsp => context.FundingStreamPeriods.Remove(fsp));

                context.SaveChanges();
            }
        }


        private void ClearFspDeliverableTableForFsp(string fsp)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.FundingStreamPeriodLegalDeliverables.Where(d => d.FundingStreamPeriodCode == fsp)
                    .ForEach(d => context.FundingStreamPeriodLegalDeliverables.Remove(d));

                context.SaveChanges();
            }
        }
    }
}
