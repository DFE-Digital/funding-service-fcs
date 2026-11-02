namespace FCT.Console.Config.Tests.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using FCT.Console.Config.Excel;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class ContractTypeReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTypeReader_ShouldReadAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Contract Type");
            ContractTypeReader contractTypeReader = new ContractTypeReader();

            // act
            IReadOnlyCollection<ContractTypeSheetType> contractTypeSheetTypes =
                contractTypeReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(37, contractTypeSheetTypes.Count);
            Assert.AreEqual("16-19 Conditions of Funding Agreement (GFEC/SC)", contractTypeSheetTypes.First().ContractType);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTypeReader_Json_ShouldReadAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Contract Type");
            ContractTypeReader contractTypeReader = new ContractTypeReader();

            // act
            IReadOnlyCollection<ContractTypeSheetType> contractTypeSheetTypes =
                contractTypeReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(37, contractTypeSheetTypes.Count);
            Assert.AreEqual("16-19 Conditions of Funding Agreement (GFEC/SC)", contractTypeSheetTypes.First().ContractType);
        }

    }
}