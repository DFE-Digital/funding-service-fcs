namespace AllocationDeliveryDomain.Endpoint.Tests.DataStore
{
    using System;
    using System.Linq;
    using System.Text;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.AllocationDelivery.DataStore.Extensions;
    using SFA.FCT.AllocationDelivery.DataStore.Model;
    using SFA.FCT.AllocationDelivery.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities;

    [TestClass]
    public class AllocationDeliveryDataStoreUnitTests
    {
        private static AllocationDeliveryPerformance CreatePerformance()
        {
            return new AllocationDeliveryPerformance
            {
                contractAllocationNumber = "ALLOC-1",
                schemaVersion = 1.5m,
                Contract = new contractReferenceTYPE
                {
                    contractNumber = "CON-1",
                    contractVersionNumber = 3,
                    contractSubVersionNumber = 2
                }
            };
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ZipHelper_ShouldRoundTripAString()
        {
            byte[] zipped = ZipHelper.ToZippedBytesFromString("some <xml>text</xml>");

            Assert.AreEqual("some <xml>text</xml>", ZipHelper.ToStringFromZippedBytes(zipped));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ZipHelper_ShouldCompressRepetitiveContent()
        {
            string text = new string('a', 10000);

            byte[] zipped = ZipHelper.ToZippedBytesFromString(text);

            Assert.IsTrue(zipped.Length < text.Length);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ZipHelper_ShouldRoundTripBytes()
        {
            byte[] original = Encoding.UTF8.GetBytes("raw bytes");

            byte[] zipped = ZipHelper.ToZippedBytesFromBytes(original);

            CollectionAssert.AreEqual(original, ZipHelper.ToBytesFromZippedBytes(zipped));
            CollectionAssert.AreNotEqual(original, zipped);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ZipHelper_ShouldRoundTripEmptyBytes()
        {
            byte[] zipped = ZipHelper.ToZippedBytesFromBytes(new byte[0]);

            Assert.AreEqual(0, ZipHelper.ToBytesFromZippedBytes(zipped).Length);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ByteArraySerializer_ShouldRoundTripAnObject()
        {
            byte[] bytes = "value".ConvertObjectToByteArray();

            Assert.IsTrue(bytes.Length > 0);
            Assert.AreEqual("value", bytes.ConvertByteArrayToObject<string>());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ByteArraySerializer_ShouldRoundTripAList()
        {
            var list = new[] { 1, 2, 3 }.ToList();

            var result = list.ConvertObjectToByteArray().ConvertByteArrayToObject<System.Collections.Generic.List<int>>();

            CollectionAssert.AreEqual(list, result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SerializationExtensions_ShouldRoundTripXml()
        {
            string xml = CreatePerformance().SerializeToXml();

            AllocationDeliveryPerformance result = xml.DeserializeXml<AllocationDeliveryPerformance>();

            Assert.IsTrue(xml.Contains("ALLOC-1"));
            Assert.AreEqual("ALLOC-1", result.contractAllocationNumber);
            Assert.AreEqual("CON-1", result.Contract.contractNumber);
            Assert.AreEqual(3, result.Contract.contractVersionNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SerializationExtensions_SerializeToXml_ShouldReturnNull_WhenObjectIsNull()
        {
            AllocationDeliveryPerformance performance = null;

            Assert.IsNull(performance.SerializeToXml());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SerializationExtensions_DeserializeXml_ShouldReturnNull_WhenXmlIsBlank()
        {
            Assert.IsNull(((string)null).DeserializeXml<AllocationDeliveryPerformance>());
            Assert.IsNull(string.Empty.DeserializeXml<AllocationDeliveryPerformance>());
            Assert.IsNull("   ".DeserializeXml<AllocationDeliveryPerformance>());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryEntry_Create_ShouldPopulateTheEntryFromThePerformance()
        {
            AllocationDeliveryEntry entry = AllocationDeliveryEntry.Create(CreatePerformance(), AllocationDeliveryEntryCategory.ContractAllocationActualsReceived);

            Assert.AreNotEqual(Guid.Empty, entry.Identifier);
            Assert.AreEqual("ALLOC-1", entry.AllocationNumber);
            Assert.AreEqual("CON-1", entry.ContractNumber);
            Assert.AreEqual(3, entry.VersionNumber);
            Assert.AreEqual(2, entry.SubVersionNumber);
            Assert.AreEqual("1.5", entry.SchemaVersion);
            Assert.AreEqual(AllocationDeliveryEntryCategory.ContractAllocationActualsReceived, entry.AllocationDeliveryCategory);
            Assert.IsNotNull(entry.AllocationDeliveryEntryData);
            Assert.AreSame(entry, entry.AllocationDeliveryEntryData.AllocationDeliveryEntry);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryEntry_Create_ShouldGenerateADifferentIdentifierEachTime()
        {
            var first = AllocationDeliveryEntry.Create(CreatePerformance(), AllocationDeliveryEntryCategory.NewContractAllocationApproved);
            var second = AllocationDeliveryEntry.Create(CreatePerformance(), AllocationDeliveryEntryCategory.NewContractAllocationApproved);

            Assert.AreNotEqual(first.Identifier, second.Identifier);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryEntry_GetAllocationDeliveryPerformanceXml_ShouldUnzipTheEntryData()
        {
            AllocationDeliveryEntry entry = AllocationDeliveryEntry.Create(CreatePerformance(), AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);

            AllocationDeliveryPerformance result = entry.GetAllocationDeliveryPerformanceXml().DeserializeXml<AllocationDeliveryPerformance>();

            Assert.AreEqual("ALLOC-1", result.contractAllocationNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryEntry_GetAllocationDeliveryPerformanceXml_ShouldPreferTheBytesHeldOnTheEntry()
        {
            AllocationDeliveryEntry entry = AllocationDeliveryEntry.Create(CreatePerformance(), AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);
            entry.CorporateAllocationDeliveryBytes = ZipHelper.ToZippedBytesFromString("<on-entry />");

            Assert.AreEqual("<on-entry />", entry.GetAllocationDeliveryPerformanceXml());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryEntryCategory_GetDescription_ShouldReturnTheDescriptionAttribute()
        {
            Assert.AreEqual("New Contract Allocation Approved", AllocationDeliveryEntryCategory.NewContractAllocationApproved.GetDescription());
            Assert.AreEqual("Amended Contract Allocation Approved", AllocationDeliveryEntryCategory.AmendedContractAllocationApproved.GetDescription());
            Assert.AreEqual("Contract Allocation Actuals Received", AllocationDeliveryEntryCategory.ContractAllocationActualsReceived.GetDescription());
            Assert.AreEqual("Contract Allocation Payment Posted", AllocationDeliveryEntryCategory.ContractAllocationPaymentReceived.GetDescription());
            Assert.AreEqual("Contract Allocation Actuals Updated", AllocationDeliveryEntryCategory.ContractAllocationActualsUpdated.GetDescription());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnumExtensions_GetDescription_ShouldFallBackToTheName_WhenThereIsNoDescription()
        {
            Assert.AreEqual("Sunday", DayOfWeek.Sunday.GetDescription());
            Assert.AreEqual("7", ((DayOfWeek)7).GetDescription());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProcessedMessage_ShouldHoldTheMessageId()
        {
            Assert.AreEqual("abc", new ProcessedMessage("abc").MessageId);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void StoragePage_ShouldStartWithNoRows()
        {
            var page = new StoragePage<string> { PageNumber = 2 };

            Assert.AreEqual(2, page.PageNumber);
            Assert.AreEqual(0, page.Rows.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryEntryQueryRepository_PageSize_ShouldBeTen()
        {
            Assert.AreEqual(10, new AllocationDeliveryEntryQueryRepository(Mock.Of<IFcsConfiguration>()).PageSize);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryEntryQueryRepository_GetPreviousPageNumber_ShouldStepBackOrReturnNull()
        {
            var repository = new AllocationDeliveryEntryQueryRepository(Mock.Of<IFcsConfiguration>());

            Assert.IsNull(repository.GetPreviousPageNumber(0));
            Assert.AreEqual(0, repository.GetPreviousPageNumber(1));
            Assert.AreEqual(4, repository.GetPreviousPageNumber(5));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryEntryQueryRepository_GetNextPageNumber_ShouldReturnNull_WhenNoPageIsRequested()
        {
            var repository = new AllocationDeliveryEntryQueryRepository(Mock.Of<IFcsConfiguration>());

            Assert.IsNull(repository.GetNextPageNumber(null));
        }
    }
}
