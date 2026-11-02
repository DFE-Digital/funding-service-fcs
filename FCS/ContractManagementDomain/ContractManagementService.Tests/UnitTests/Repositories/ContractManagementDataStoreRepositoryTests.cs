using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Linq;
using ContractManagement.DataStore;
using ContractManagement.DataStore.Model;
using ContractManagement.DataStore.Repositories;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using SFA.FCT.CrossDomain.Integration.Entities.Data;

namespace ContractManagementService.Tests.UnitTests.Repositories
{
    [TestClass, TestCategory("UnitTest")]
    public class ContractManagementDataStoreRepositoryTests
    {
        [TestMethod]
        public void FundingStreamPeriodLegalDeliverableRepository_FiltersByFundingStreamPeriodAndProfileFlag()
        {
            var deliverables = new[]
            {
                new FundingStreamPeriodLegalDeliverable("FSP1", 1, true, "Profile", 1),
                new FundingStreamPeriodLegalDeliverable("FSP1", 2, false, "Not profile", 2),
                new FundingStreamPeriodLegalDeliverable("FSP2", 3, true, "Other stream", 3)
            };
            var context = new Mock<IContractManagementDbContext>();
            context.SetupGet(db => db.FundingStreamPeriodLegalDeliverables)
                .Returns(CreateDbSet(deliverables).Object);
            var repository = new FundingStreamPeriodLegalDeliverableRepository(context.Object);

            CollectionAssert.AreEqual(new[] { 1, 2 }, repository.GetLegalDeliverablesForFsp("FSP1").ToArray());
            CollectionAssert.AreEqual(
                new[] { deliverables[0], deliverables[2] },
                repository.GetAllProfileLegalFspDeliverables().ToArray());
        }

        [TestMethod]
        public void PolicyConfigRepository_ReturnsContractAndRegionNames()
        {
            var context = new Mock<IContractManagementDbContext>();
            context.SetupGet(db => db.ContractTypes).Returns(
                CreateDbSet(new ContractType("Contract A"), new ContractType("Contract B")).Object);
            context.SetupGet(db => db.RegionTypes).Returns(
                CreateDbSet(new RegionType(1, "North"), new RegionType(2, "South")).Object);
            var repository = new PolicyConfigRepository(context.Object);

            CollectionAssert.AreEqual(new[] { "Contract A", "Contract B" }, repository.GetAllContractTypes().ToArray());
            CollectionAssert.AreEqual(new[] { "North", "South" }, repository.GetAllRegionTypes().ToArray());
        }

        [TestMethod]
        public void CdaReportFundingStreamPeriodQueryRepository_ExcludesExpiredExtractsAndGroupsFspCodes()
        {
            var context = new Mock<IContractManagementDbContext>();
            context.SetupGet(db => db.CdaExtracts).Returns(CreateDbSet(
                new CdaExtract("open"),
                new CdaExtract("current") { ReportingCloseDate = new DateTime(2025, 1, 1) },
                new CdaExtract("expired") { ReportingCloseDate = new DateTime(2024, 12, 31) }).Object);
            context.SetupGet(db => db.CdaReportFundingStreamPeriods).Returns(CreateDbSet(
                new CdaReportFundingStreamPeriod("open", "FSP1"),
                new CdaReportFundingStreamPeriod("open", "FSP2"),
                new CdaReportFundingStreamPeriod("current", "FSP3"),
                new CdaReportFundingStreamPeriod("expired", "FSP4")).Object);
            var repository = new CdaReportFundingStreamPeriodQueryRepository(context.Object);

            var result = repository.GetAllWithinPublicationCloseDate(new DateTime(2025, 1, 1));

            Assert.AreEqual(2, result.Count);
            CollectionAssert.AreEqual(
                new[] { "FSP1", "FSP2" },
                result.Single(config => config.Description == "open").ReportFspCodes);
            CollectionAssert.AreEqual(
                new[] { "FSP3" },
                result.Single(config => config.Description == "current").ReportFspCodes);
        }

        [TestMethod]
        public void FundingTypePeriodFundingStreamPeriodQueryRepository_FiltersByFundingTypeAndCachesResults()
        {
            var fundingTypeCode = Guid.NewGuid().ToString();
            var expected = new FundingTypePeriodFundingStreamPeriod(fundingTypeCode, "2025", "FSP1");
            var context = new Mock<IContractManagementDbContext>();
            context.SetupGet(db => db.FundingTypePeriodFundingStreamPeriodItems)
                .Returns(CreateDbSet(
                    expected,
                    new FundingTypePeriodFundingStreamPeriod("different", "2025", "FSP2")).Object);
            var repository = new FundingTypePeriodFundingStreamPeriodQueryRepository(context.Object);

            var first = repository.GetByFundingType(fundingTypeCode);
            var second = repository.GetByFundingType(fundingTypeCode);

            CollectionAssert.AreEqual(new[] { expected }, first.ToArray());
            Assert.AreSame(first, second);
        }

        [TestMethod]
        public void FundingTypeFundingPeriodQueryRepository_UsesCacheAndLoadsOnCacheMiss()
        {
            var expected = new FundingTypeFundingPeriod { FundingTypeCode = "FT", FundingPeriodName = "2025" };
            var cache = new Mock<IEntityCache<(string FundingTypeCode, string FundingPeriodName), FundingTypeFundingPeriod>>();
            cache.Setup(c => c.GetOrAdd(
                    It.IsAny<(string FundingTypeCode, string FundingPeriodName)>(),
                    It.IsAny<Func<(string FundingTypeCode, string FundingPeriodName), FundingTypeFundingPeriod>>()))
                .Returns((ValueTuple<string, string> key, Func<ValueTuple<string, string>, FundingTypeFundingPeriod> factory) =>
                    factory(key));
            var fundingPeriods = CreateDbSet(expected);
            fundingPeriods.Setup(set => set.Find(It.IsAny<object[]>()))
                .Returns((object[] keys) =>
                    keys.Length == 2 && (string)keys[0] == "FT" && (string)keys[1] == "2025" ? expected : null);
            var context = new Mock<IContractManagementDbContext>();
            context.SetupGet(db => db.FundingTypeFundingPeriodItems).Returns(fundingPeriods.Object);
            var repository = new FundingTypeFundingPeriodQueryRepository(context.Object, cache.Object);

            var result = repository.Get("FT", "2025");

            Assert.AreSame(expected, result);
            cache.Verify(c => c.GetOrAdd(
                ValueTuple.Create("FT", "2025"),
                It.IsAny<Func<(string FundingTypeCode, string FundingPeriodName), FundingTypeFundingPeriod>>()),
                Times.Once);
        }

        [TestMethod]
        public void ApprovedContractAllocationRepository_UpdatesLatestMatchingAllocationAndSaves()
        {
            var approvedContract = new ApprovedContract(
                "C-1", 1, 0, "FT", "2025", 12345678, "ORG", null, DateTime.UtcNow, null);
            var allocation = new ApprovedContractAllocation
            {
                ContractAllocationNumber = "A-1",
                ApprovedContractId = approvedContract.ApprovedContractId
            };
            var context = new Mock<IContractManagementDbContext>();
            context.SetupGet(db => db.ApprovedContracts).Returns(CreateDbSet(approvedContract).Object);
            context.SetupGet(db => db.ApprovedContractAllocations).Returns(CreateDbSet(allocation).Object);
            var repository = new ApprovedContractAllocationRepository(context.Object);

            repository.SetOutstandingPaymentsIndicator("A-1", true, ConnectionInfo.CreateDefault());

            Assert.IsTrue(allocation.HasOutstandingPayments.GetValueOrDefault());
            context.Verify(db => db.SaveChanges(), Times.Once);
        }

        [TestMethod]
        public void ApprovedContractAllocationRepository_DoesNotSaveWhenAllocationDoesNotExist()
        {
            var context = new Mock<IContractManagementDbContext>();
            context.SetupGet(db => db.ApprovedContracts).Returns(CreateDbSet<ApprovedContract>().Object);
            context.SetupGet(db => db.ApprovedContractAllocations).Returns(CreateDbSet<ApprovedContractAllocation>().Object);
            var repository = new ApprovedContractAllocationRepository(context.Object);

            repository.SetOutstandingPaymentsIndicator("missing", true, ConnectionInfo.CreateDefault());

            context.Verify(db => db.SaveChanges(), Times.Never);
        }

        [TestMethod]
        public void ProcessedMessageRepository_AddsMessageAndReturnsTrue()
        {
            var addedMessages = new List<ProcessedMessage>();
            var processedMessages = CreateDbSet<ProcessedMessage>();
            processedMessages.Setup(set => set.Add(It.IsAny<ProcessedMessage>()))
                .Callback<ProcessedMessage>(addedMessages.Add)
                .Returns<ProcessedMessage>(message => message);
            var context = new Mock<IContractManagementDbContext>();
            context.SetupGet(db => db.ProcessedMessages).Returns(processedMessages.Object);
            var repository = new ProcessedMessageRepository(context.Object);

            var result = repository.Add("message-1");

            Assert.IsTrue(result);
            Assert.AreEqual("message-1", addedMessages.Single().MessageId);
            context.Verify(db => db.SaveChanges(), Times.Once);
        }

        [TestMethod]
        public void RoatpProviderRepository_ReplaceRoatpCacheDeletesThenInsertsBatchesOfOneHundred()
        {
            var sqlCommands = new List<string>();
            var context = new Mock<IContractManagementDbContext>();
            context.Setup(db => db.ExecuteSql(It.IsAny<string>()))
                .Callback<string>(sqlCommands.Add)
                .Returns(0);
            var repository = new RoatpProviderRepository(context.Object);

            repository.ReplaceRoatpCache(Enumerable.Range(1, 101).Select(number => number.ToString()));

            Assert.AreEqual(3, sqlCommands.Count);
            Assert.AreEqual("DELETE FROM [ContractManagement].[RoatpProvider]", sqlCommands[0]);
            Assert.IsTrue(sqlCommands[1].Contains("('1')"));
            Assert.IsTrue(sqlCommands[1].Contains("('100')"));
            Assert.IsFalse(sqlCommands[1].Contains("('101')"));
            Assert.AreEqual(
                "INSERT INTO [ContractManagement].[RoatpProvider] ([Ukprn]) VALUES ('101')",
                sqlCommands[2]);
        }

        [TestMethod]
        public void RoatpProviderRepository_IsProviderOnRoatp_ReturnsWhetherProviderExists()
        {
            var providers = CreateDbSet(new RoatpProvider("12345678"));
            providers.Setup(set => set.Find(It.IsAny<object[]>()))
                .Returns((object[] keys) => keys[0] as string == "12345678" ? new RoatpProvider("12345678") : null);
            var context = new Mock<IContractManagementDbContext>();
            context.SetupGet(db => db.RoatpProviders).Returns(providers.Object);
            var repository = new RoatpProviderRepository(context.Object);

            Assert.IsTrue(repository.IsProviderOnRoatp("12345678"));
            Assert.IsFalse(repository.IsProviderOnRoatp("87654321"));
        }

        private static Mock<DbSet<T>> CreateDbSet<T>(params T[] values)
            where T : class
        {
            var data = values.AsQueryable();
            var set = new Mock<DbSet<T>>();
            set.As<IQueryable<T>>().SetupGet(query => query.Provider).Returns(data.Provider);
            set.As<IQueryable<T>>().SetupGet(query => query.Expression).Returns(data.Expression);
            set.As<IQueryable<T>>().SetupGet(query => query.ElementType).Returns(data.ElementType);
            set.As<IQueryable<T>>().Setup(query => query.GetEnumerator()).Returns(() => data.GetEnumerator());
            return set;
        }
    }
}
