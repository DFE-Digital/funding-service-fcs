namespace FCT.Console.Config.Tests.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class SubnominalsReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SubnominalsReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Subnominal");
            SubnominalsReader fundingStreamConfigReader = new SubnominalsReader();

            // act
            IReadOnlyCollection<SubnominalsSheetType> subnominalItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(272, subnominalItems.Count);
            SubnominalsSheetType subnominalsSheetType = subnominalItems.First();

            Assert.AreEqual("10183", subnominalsSheetType.SubnominalCode);
            Assert.AreEqual("SBThroughProjectS", subnominalsSheetType.PaymentSubnominalDesc);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SubnominalsReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Subnominal");
            SubnominalsReader fundingStreamConfigReader = new SubnominalsReader();

            // act
            IReadOnlyCollection<SubnominalsSheetType> subnominalItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(272, subnominalItems.Count);
            SubnominalsSheetType subnominalsSheetType = subnominalItems.First();

            Assert.AreEqual("10183", subnominalsSheetType.SubnominalCode);
            Assert.AreEqual("SBThroughProjectS", subnominalsSheetType.PaymentSubnominalDesc);
        }
    }
}