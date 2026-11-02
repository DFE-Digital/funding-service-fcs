namespace PaymentGenerationDomain.Integration.DataStore.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using PaymentGenerationDomain.Integration.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class PaymentBatchFeedItemRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentBatchFeedItemRepository_GetNextPageNumber_ShouldReturnTheCorrectNextPageWhenThereIsOne()
        {
            // arrange
            ClearPaymentBatchFeedItemTable();
            DateTime censusEndDate = new DateTime(2018, 8, 1);

            using (var context = new PaymentGenerationDbContext())
            {
                Enumerable.Range(0, 8).ForEach(i =>
                {
                    context.PaymentBatchFeedItems.Add(CreatePaymentBatchFeedItem(i, censusEndDate));
                });

                context.SaveChanges();
            }
           
            using (var context = new PaymentGenerationDbContext())
            {
                PaymentBatchFeedItemRepository repository = new PaymentBatchFeedItemRepository(new LocalConfig());

                // act
                int? nextPageNumber = repository.GetNextPageNumber(1, 2).Result;

                // assert
                Assert.AreEqual(2, nextPageNumber);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentBatchFeedItemRepository_GetNextPageNumber_ShouldReturnNullWhenTheNextPageIsTheLatest()
        {
            // arrange
            ClearPaymentBatchFeedItemTable();
            DateTime censusEndDate = new DateTime(2018, 8, 1);

            using (var context = new PaymentGenerationDbContext())
            {
                Enumerable.Range(0, 6).ForEach(i =>
                {
                    context.PaymentBatchFeedItems.Add(CreatePaymentBatchFeedItem(i, censusEndDate));
                });

                context.SaveChanges();
            }

            using (var context = new PaymentGenerationDbContext())
            {
                PaymentBatchFeedItemRepository repository = new PaymentBatchFeedItemRepository(new LocalConfig());

                // act
                int? nextPageNumber = repository.GetNextPageNumber(1, 2).Result;

                // assert
                Assert.AreEqual(null, nextPageNumber);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentBatchFeedItemRepository_GetEntitiesForLatestPage_ShouldReturnAFullPageWhenNumberOfItemsIsDivisibleByPageSize()
        {
            // arrange
            ClearPaymentBatchFeedItemTable();
            DateTime censusEndDate = new DateTime(2018, 8, 1);

            const int pageSize = 2;
            using (var context = new PaymentGenerationDbContext())
            {
                Enumerable.Range(0, 3 * pageSize).ForEach(i =>
                {
                    context.PaymentBatchFeedItems.Add(CreatePaymentBatchFeedItem(i, censusEndDate));
                });

                context.SaveChanges();
            }

           
            PaymentBatchFeedItemRepository repository = new PaymentBatchFeedItemRepository(new LocalConfig());

            // act
            var storagePage = repository.GetEntitiesForLatestPage(pageSize: pageSize).Result;

            // assert
            Assert.AreEqual(pageSize, storagePage.Rows.Count(), "The number of rows in the latest page is incorrect");
            Assert.IsTrue(storagePage.Rows[0].Id < storagePage.Rows[1].Id, "The rows are not in ascending");
            
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentBatchFeedItemRepository_GetEntitiesForLatestPage_ShouldReturnAPartialPageWhenNumberOfItemsIsNotDivisibleByPageSize()
        {
            // arrange
            ClearPaymentBatchFeedItemTable();
            DateTime censusEndDate = new DateTime(2018, 8, 1);

            const int pageSize = 2;
            using (var context = new PaymentGenerationDbContext())
            {
                Enumerable.Range(0, (3 * pageSize) + 1).ForEach(i =>
                {
                    context.PaymentBatchFeedItems.Add(CreatePaymentBatchFeedItem(i, censusEndDate));
                });

                context.SaveChanges();
            }

            PaymentBatchFeedItemRepository repository = new PaymentBatchFeedItemRepository(new LocalConfig());

            // act
            var storagePage = repository.GetEntitiesForLatestPage(pageSize: pageSize).Result;

            // assert
            Assert.AreEqual(1, storagePage.Rows.Count(), "The number of rows in the latest page is incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentBatchFeedItemRepository_AddItem_ShouldReturnAddedIfUniqueIndexIsNotViolated()
        {
            // arrange
            ClearPaymentBatchFeedItemTable();
            DateTime censusEndDate = new DateTime(2018, 8, 1);

            using (var context = new PaymentGenerationDbContext())
            {
                Enumerable.Range(0, 7).ForEach(i =>
                {
                    context.PaymentBatchFeedItems.Add(CreatePaymentBatchFeedItem(i, censusEndDate));
                });

                context.SaveChanges();
            }

            PaymentBatchFeedItemRepository repository = new PaymentBatchFeedItemRepository(new LocalConfig());
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString);

            // act
            PaymentBatchFeedItemAddResult result = repository.AddItem(CreatePaymentBatchFeedItem(month: 7, censusEndDate: censusEndDate), new ConnectionInfo(null, connection)).Result;

            // assert
            Assert.AreEqual(PaymentBatchFeedItemAddResult.Added, result);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentBatchFeedItemRepository_AddItem_ShouldReturnAlreadyPresentResultIfUniqueIndexIsViolated()
        {
            // arrange
            ClearPaymentBatchFeedItemTable();
            DateTime censusEndDate = new DateTime(2018, 8, 1);
            using (var context = new PaymentGenerationDbContext())
            {
                Enumerable.Range(0, 7).ForEach(i =>
                {
                    context.PaymentBatchFeedItems.Add(CreatePaymentBatchFeedItem(i, censusEndDate));
                });

                context.SaveChanges();
            }

            PaymentBatchFeedItemRepository repository = new PaymentBatchFeedItemRepository(new LocalConfig());
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString);
            // act
            PaymentBatchFeedItemAddResult result = repository.AddItem(CreatePaymentBatchFeedItem(month: 6, censusEndDate:censusEndDate), new ConnectionInfo(null, connection)).Result;

            // assert
            Assert.AreEqual(PaymentBatchFeedItemAddResult.AlreadyPresent, result);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task PaymentBatchFeedItemRepository_GetPaymentPeriod_ShouldReturnPaymentPeriod()
        {
            // arrange
            ClearPaymentBatchFeedItemTable();
            DateTime censusEndDate = new DateTime(2018, 8, 1);
            int feedIdInDatabase = 0;
            using (var context = new PaymentGenerationDbContext())
            {
                PaymentBatchFeedItem paymentBatchFeedItem = CreatePaymentBatchFeedItem(1, censusEndDate);

                context.PaymentBatchFeedItems.Add(paymentBatchFeedItem);

                context.SaveChanges();
                feedIdInDatabase = paymentBatchFeedItem.Id;
            }

            PaymentBatchFeedItemRepository repository = new PaymentBatchFeedItemRepository(new LocalConfig());

            // act
            PaymentPeriod paymentPeriod = await repository.GetPaymentPeriod(feedIdInDatabase);

            // assert
            Assert.IsNotNull(paymentPeriod, "The payment period is not null");
            Assert.AreEqual(censusEndDate, paymentPeriod.CensusEndDate, "The census enddate is not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentBatchFeedItemRepository_GetItemById_ShouldReturnItemWhenExists()
        {
            // arrange
            ClearPaymentBatchFeedItemTable();
            DateTime censusEndDate = new DateTime(2018, 8, 1);

            using (var context = new PaymentGenerationDbContext())
            {
                Enumerable.Range(0, 8).ForEach(i =>
                {
                    context.PaymentBatchFeedItems.Add(CreatePaymentBatchFeedItem(i, censusEndDate));
                });

                context.SaveChanges();
            }

            int assertId;

            using (var context = new PaymentGenerationDbContext())
            {
                assertId = context.PaymentBatchFeedItems.First().Id;
            }

            using (var context = new PaymentGenerationDbContext())
            {
                PaymentBatchFeedItemRepository repository = new PaymentBatchFeedItemRepository(new LocalConfig());

                // act
                var paymentBatchFeedItem = repository.GetItemById(assertId).Result;

                // assert
                Assert.IsNotNull(paymentBatchFeedItem);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentBatchFeedItemRepository_GetItemById_ShouldReturnNullWhenDoesNotExists()
        {
            // arrange
            ClearPaymentBatchFeedItemTable();

            using (var context = new PaymentGenerationDbContext())
            {
                PaymentBatchFeedItemRepository repository = new PaymentBatchFeedItemRepository(new LocalConfig());

                // act
                var paymentBatchFeedItem = repository.GetItemById(1).Result;

                // assert
                Assert.IsNull(paymentBatchFeedItem);
            }
        }


        private void ClearPaymentBatchFeedItemTable()
        {
            using (var context = new PaymentGenerationDbContext())
            {
                context.PaymentBatchFeedItems.ForEach(fi => context.PaymentBatchFeedItems.Remove(fi));

                context.SaveChanges();
            }
        }

        private static PaymentBatchFeedItem CreatePaymentBatchFeedItem(int month, DateTime censusEndDate)
        {
            return PaymentBatchFeedItem.Create(new PaymentPeriod
            {
                PaymentDetails = new List<PaymentDetail>(),
                FinancialPaymentFinancialMonth = month.ToString(),
                FinancialPaymentFinancialYear = "2018",
                CensusEndDate = censusEndDate,

            }, "FSP", "LC");
        }
    }
}
