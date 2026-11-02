namespace FCT.Console.Config.Tests.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class SubnominalPaymentTypesReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SubnominalPaymentTypesReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Subnominal Payment Types");
            SubnominalPaymentTypesReader fundingStreamConfigReader = new SubnominalPaymentTypesReader();

            // act
            IReadOnlyCollection<SubnominalsSheetType> subnominalItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(333, subnominalItems.Count);
            SubnominalsSheetType subnominalsSheetType = subnominalItems.First();

            Assert.AreEqual("10183", subnominalsSheetType.SubnominalCode);
            Assert.AreEqual("SBThroughProjectS", subnominalsSheetType.PaymentSubnominalDesc);
            Assert.AreEqual("Profile", subnominalsSheetType.PaymentType);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SubnominalPaymentTypesReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Subnominal Payment Types");
            SubnominalPaymentTypesReader fundingStreamConfigReader = new SubnominalPaymentTypesReader();

            // act
            IReadOnlyCollection<SubnominalsSheetType> subnominalItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(333, subnominalItems.Count);
            SubnominalsSheetType subnominalsSheetType = subnominalItems.First();

            Assert.AreEqual("10183", subnominalsSheetType.SubnominalCode);
            Assert.AreEqual("SBThroughProjectS", subnominalsSheetType.PaymentSubnominalDesc);
            Assert.AreEqual("Profile", subnominalsSheetType.PaymentType);
        }
    }
}