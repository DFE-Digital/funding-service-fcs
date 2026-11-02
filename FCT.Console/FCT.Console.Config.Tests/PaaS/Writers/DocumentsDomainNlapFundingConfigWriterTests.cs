namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.DocumentsDomain.DataStore;
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;
    using UnitTests.Common;

    [TestClass]
    public class DocumentsDomainNlapFundingConfigWriterTests
    {
        [TestCleanup]
        public void CleanUp()
        {
            const int ukprn = 12345;

            using (var context = new DocumentsDomainDbContext())
            {
                context.NlapFundingConfigs.RemoveWhere(n => n.Ukprn == ukprn);
                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentsDomainNlapFundingConfigWriter_ShouldWriteRowToStorage()
        {
            const int ukprn = 12345;

            // arrange
            using (DocumentsDomainDbContext context = new DocumentsDomainDbContext())
            {
                context.NlapFundingConfigs.RemoveWhere(n => n.Ukprn == ukprn);
                context.SaveChanges();
            }

            NlapFundingConfigSheet sheet = new NlapFundingConfigSheet
            {
                PolicyStatus = PolicyStatus.Approved,
                Ukprn = ukprn,
                NewStarts2021Funding1618 = 1.1m,
                NewStarts2021FundingAdult = 2.2m,
                NewStartsEstimatedFutureFunding1618 = 3.3m,
                NewStartsEstimatedFutureFundingAdult = 4.4m
            };
        
            // act
            DocumentsDomainNlapFundingConfigWriter.WriteToPaasDatabase(new []{ sheet }, WriterBehaviour.AddOrUpdate);

            // assert
            using (DocumentsDomainDbContext context = new DocumentsDomainDbContext())
            {
                NlapFundingConfig storedEntity = context.NlapFundingConfigs.SingleOrDefault(n => n.Ukprn == ukprn);

                Assert.IsNotNull(storedEntity, "Entity not stored");
                Assert.AreEqual(1.1m, storedEntity.NewStarts2021Funding1618, "NewStarts2021Funding1618 incorrect");
                Assert.AreEqual(2.2m, storedEntity.NewStarts2021FundingAdult, "NewStarts2021FundingAdult incorrect");
                Assert.AreEqual(3.3m, storedEntity.NewStartsEstimatedFutureFunding1618, "NewStartsEstimatedFutureFunding1618 incorrect");
                Assert.AreEqual(4.4m, storedEntity.NewStartsEstimatedFutureFundingAdult, "NewStartsEstimatedFutureFundingAdult incorrect");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentsDomainNlapFundingConfigWriter_ShouldUpdateRowInStorage()
        {
            const int ukprn = 12345;

            // arrange
            using (DocumentsDomainDbContext context = new DocumentsDomainDbContext())
            {
                context.NlapFundingConfigs.RemoveWhere(n => n.Ukprn == ukprn);
                context.NlapFundingConfigs.Add(new NlapFundingConfig(ukprn, 9m, 9m, 9m, 9m));
                context.SaveChanges();
            }

            NlapFundingConfigSheet sheet = new NlapFundingConfigSheet
            {
                PolicyStatus = PolicyStatus.Approved,
                Ukprn = ukprn,
                NewStarts2021Funding1618 = 1.1m,
                NewStarts2021FundingAdult = 2.2m,
                NewStartsEstimatedFutureFunding1618 = 3.3m,
                NewStartsEstimatedFutureFundingAdult = 4.4m
            };

            // act
            DocumentsDomainNlapFundingConfigWriter.WriteToPaasDatabase(new[] { sheet }, WriterBehaviour.AddOrUpdate);

            // assert
            using (DocumentsDomainDbContext context = new DocumentsDomainDbContext())
            {
                NlapFundingConfig storedEntity = context.NlapFundingConfigs.Single(n => n.Ukprn == ukprn);

                Assert.AreEqual(1.1m, storedEntity.NewStarts2021Funding1618, "NewStarts2021Funding1618 incorrect");
                Assert.AreEqual(2.2m, storedEntity.NewStarts2021FundingAdult, "NewStarts2021FundingAdult incorrect");
                Assert.AreEqual(3.3m, storedEntity.NewStartsEstimatedFutureFunding1618, "NewStartsEstimatedFutureFunding1618 incorrect");
                Assert.AreEqual(4.4m, storedEntity.NewStartsEstimatedFutureFundingAdult, "NewStartsEstimatedFutureFundingAdult incorrect");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentsDomainNlapFundingConfigWriter_ShouldDeleteRowFromStorage()
        {
            const int ukprn = 12345;

            // arrange
            using (DocumentsDomainDbContext context = new DocumentsDomainDbContext())
            {
                context.NlapFundingConfigs.RemoveWhere(n => n.Ukprn == ukprn);
                context.NlapFundingConfigs.Add(new NlapFundingConfig(ukprn, 9m, 9m, 9m, 9m));
                context.SaveChanges();
            }

            NlapFundingConfigSheet sheet = new NlapFundingConfigSheet
            {
                PolicyStatus = PolicyStatus.Removed,
                Ukprn = ukprn,
                NewStarts2021Funding1618 = 1.1m,
                NewStarts2021FundingAdult = 2.2m,
                NewStartsEstimatedFutureFunding1618 = 3.3m,
                NewStartsEstimatedFutureFundingAdult = 4.4m
            };

            // act
            DocumentsDomainNlapFundingConfigWriter.WriteToPaasDatabase(new[] { sheet }, WriterBehaviour.Delete);

            // assert
            using (DocumentsDomainDbContext context = new DocumentsDomainDbContext())
            {
                NlapFundingConfig storedEntity = context.NlapFundingConfigs.SingleOrDefault(n => n.Ukprn == ukprn);

                Assert.IsNull(storedEntity, "Entity still present in storage");
            }
        }
    }
}