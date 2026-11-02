namespace AllocationDeliveryService.Tests.IntegrationTests
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.Globalization;
    using System.Linq;
    using ContractManagementService.DTOs;
    using ContractManagementService.Repositories;
    using Dapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Entities;

    [TestClass]
    public class AllocationDeliveryEntryQueryRepositoryTests
    {
        private IAllocationDeliveryEntryQueryRepository _repository;
        private SqlConnection _connection;
        private const string AllocRefPrefix = "ADEQRTA";
        private const string ContractRefPrefix = "ADEQRTC";
        private const int PageSize = 10;


        [TestInitialize]
        public void Setup()
        {
            _connection = new SqlConnection(new AppConfiguration()["ConnectionStrings:AllocationDeliveryDBContext"]);
            
            _repository = new AllocationDeliveryEntryQueryRepository(new AppConfiguration());

            Cleanup();
        }

        public void Cleanup()
        {
            _connection.Execute("DELETE FROM AllocationDelivery.AllocationDeliveryEntryData");
            _connection.Execute("DELETE FROM AllocationDelivery.AllocationDeliveryEntry");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationDeliveryEntryQueryRepository_GetNextPageNumber_NullReqPage_ShouldReturnNull()
        {
            // act
            int? actual = _repository.GetNextPageNumber(null);

            // assert
            Assert.IsNull(actual);
        }

        [TestMethod, TestCategory("IntegrationTest"), ExpectedException(typeof(ArgumentOutOfRangeException))]
        public void AllocationDeliveryEntryQueryRepository_GetNextPageNumber_NonArchivedCurrentPage_ShouldReturnNull()
        {
            // arrange
            // ensure there are at least 20 entries in feed
            AddEntries(20);
            int pageCount = GetPageCount();

            // act
            var actual = _repository.GetNextPageNumber(pageCount);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationDeliveryEntryQueryRepository_GetNextPageNumber_FinalArchivedPage_ShouldReturnNull()
        {
            // arrange
            // ensure there are at least 30 entries in feed
            AddEntries(30);
            int pageCount = GetPageCount();

            // act
            var actual = _repository.GetNextPageNumber(pageCount - 1);

            // assert
            Assert.IsNull(actual);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationDeliveryEntryQueryRepository_GetNextPageNumber_ArchivedPageWithNextArchivedPage_ShouldReturnNextPageNumber()
        {
            // arrange
            // ensure there are at least 30 entries in feed
            AddEntries(30);
            int pageCount = GetPageCount();
            int expected = pageCount - 1;

            // act
            var actual = _repository.GetNextPageNumber(pageCount - 2);

            // assert
            Assert.IsNotNull(actual);
            Assert.AreEqual(expected, actual);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationDeliveryEntryQueryRepository_GetPrevPageNumber_PageZero_ShouldReturnNull()
        {
            // arrange
            // ensure there are at least 10 entries in feed
            AddEntries(10);

            // act
            var actual = _repository.GetPreviousPageNumber(0);

            // assert
            Assert.IsNull(actual);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationDeliveryEntryQueryRepository_GetPrevPageNumber_ArchivedPageWithPrev_ShouldReturnPrevPageNumber()
        {
            // arrange
            // ensure there are at least 30 entries in feed
            AddEntries(30);
            int expected = 0;

            // act
            var actual = _repository.GetPreviousPageNumber(1);

            // assert
            Assert.IsNotNull(actual);
            Assert.AreEqual(expected, actual);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationDeliveryEntryQueryRepository_GetEntitiesForPage_ShouldReturnAllEntitiesInPage()
        {
            // arrange
            // ensure there are at least 20 entries in feed
            AddEntries(20);
            int pageCount = GetPageCount();

            // act
            var actual = _repository.GetEntitiesForPage(pageCount - 1);

            // assert
            Assert.AreEqual(PageSize,
                actual.Rows.Count(
                    ade =>
                        ade.ContractNumber.StartsWith(ContractRefPrefix) &&
                        ade.AllocationNumber.StartsWith(AllocRefPrefix)));

        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationDeliveryEntryQueryRepository_GetEntitiesForLatestPage_ShouldReturnAllEntitiesInLatestPage_WhenTheCountIsDivisibleByThePageSize()
        {
            // arrange
            // ensure there are at least 10 entries in feed
            int numItemsInLatestPage = GetNumEntriesInLatestPage();
            int expected = numItemsInLatestPage == 0 ? 10 : numItemsInLatestPage;
            AddEntries(10);

            // act
            var actual = new AllocationDeliveryEntryQueryRepository(new AppConfiguration()).GetEntitiesForLatestPage();

            // assert
            Assert.AreEqual(expected,
                actual.Rows.Count(
                    ade =>
                        ade.ContractNumber.StartsWith(ContractRefPrefix) &&
                        ade.AllocationNumber.StartsWith(AllocRefPrefix)));
            
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationDeliveryEntryQueryRepository_GetEntitiesForLatestPage_ShouldReturnAllEntitiesInLatestPage()
        {
            // arrange
            AddEntries(12);

            // act
            var items = new AllocationDeliveryEntryQueryRepository(new AppConfiguration()).GetEntitiesForLatestPage().Rows;

            // assert
            Assert.AreEqual(2, items.Count);
            Assert.AreEqual(AllocRefPrefix + 11, items.Last().AllocationNumber, "The last item is not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationDeliveryEntryQueryRepository_GetEntitiesForLatestPage_ShouldReturnAllEntitiesInLatestPage_WhenThereAreNoOtherPages()
        {
            // arrange
            AddEntries(4);

            // act
            IList<AllocationDeliveryEntry> items = new AllocationDeliveryEntryQueryRepository(new AppConfiguration()).GetEntitiesForLatestPage().Rows;

            // assert
            Assert.AreEqual(4, items.Count);
            // check the order is still ascending
            Assert.AreEqual(AllocRefPrefix + 0, items.First().AllocationNumber, "The first item is not correct");
            Assert.AreEqual(AllocRefPrefix + 3, items.Last().AllocationNumber, "The last item is not correct");

            // check the data is correct
            string allocationNumberOfLastItemFromBytes = items.Last().GetAllocationDeliveryPerformanceXml().DeserializeXml<AllocationDeliveryPerformance>()
                .contractAllocationNumber;

            Assert.AreEqual(AllocRefPrefix + 3, allocationNumberOfLastItemFromBytes, "The last item is not correct - from bytes");

            string allocationNumberOfFirstItemFromBytes = items.First().GetAllocationDeliveryPerformanceXml().DeserializeXml<AllocationDeliveryPerformance>()
                .contractAllocationNumber;

            Assert.AreEqual(AllocRefPrefix + 0, allocationNumberOfFirstItemFromBytes, "The first item is not correct - from bytes");
        }

        private int GetPageCount()
        {
            var totalEntries = GetAllocationDeliveryEntriesCount();
            int pageCount = (int)Math.Floor(totalEntries / (double)10);

            if (totalEntries > 0)
            {
                // if don't have a remainder then we need to make the reduce the pageCount
                int remainder = totalEntries % 10;
                if (remainder == 0)
                {
                    pageCount--;
                }
            }

            return pageCount;
        }

        private int GetNumEntriesInLatestPage()
        {
            const int pageSize = 10;
            var totalEntries = GetAllocationDeliveryEntriesCount();
            int remainder = totalEntries % pageSize;

            if (remainder == 0)
            {
                return pageSize;
            }

            return remainder;
        }

        private void AddEntries(int numEntries)
        {
            for (int i = 0; i < numEntries; i++)
            {
                var corporateAllocationDelivery = new AllocationDeliveryPerformance
                {
                    Contract = new contractReferenceTYPE
                    {
                        contractNumber = ContractRefPrefix + i,
                    },
                    contractAllocationNumber = AllocRefPrefix + i
                };
                var entry = Create(corporateAllocationDelivery, AllocationDeliveryEntryCategory.NewContractAllocationApproved);

                AllocationDeliveryEntrySetup.InsertAllocationDeliveryEntryAndBytes(entry, corporateAllocationDelivery);
            }
        }

        private int GetAllocationDeliveryEntriesCount()
        {
            const string sql = "SELECT count(1) FROM[AllocationDelivery].[AllocationDeliveryEntry]";

            return _connection.ExecuteScalar<int>(sql);
        }


        public static AllocationDeliveryEntry Create(AllocationDeliveryPerformance allocationDeliveryPerformance, AllocationDeliveryEntryCategory category)
        {
            AllocationDeliveryEntry allocationDeliveryEntry = new AllocationDeliveryEntry();
            //allocationDeliveryEntry.SetAllocationDeliveryPerformance(allocationDeliveryPerformance, allocationDeliveryEntry);
            allocationDeliveryEntry.Identifier = Guid.NewGuid();
            allocationDeliveryEntry.AllocationNumber = allocationDeliveryPerformance.contractAllocationNumber;
            allocationDeliveryEntry.VersionNumber = allocationDeliveryPerformance.Contract.contractVersionNumber;
            allocationDeliveryEntry.SubVersionNumber = allocationDeliveryPerformance.Contract.contractSubVersionNumber;
            allocationDeliveryEntry.ContractNumber = allocationDeliveryPerformance.Contract.contractNumber;
            allocationDeliveryEntry.SchemaVersion = allocationDeliveryPerformance.schemaVersion.ToString(CultureInfo.InvariantCulture);
            allocationDeliveryEntry.AllocationDeliveryCategory = category;

            return allocationDeliveryEntry;
        }
    }
}