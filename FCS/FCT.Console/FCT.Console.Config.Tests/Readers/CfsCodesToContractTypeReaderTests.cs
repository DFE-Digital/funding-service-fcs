namespace FCT.Console.Config.Tests.Readers
{
    using System.Linq;
    using Config.Excel;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class CfsCodesToContractTypeReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CfsCodesToContractTypeReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            var worksheetReader = _reader.WorksheetReader("PC-CT");
            var cfsCodesToContractTypeReader = new CfsCodesToContractTypeReader();

            // act
            var cfsCodesToContractTypeRows = cfsCodesToContractTypeReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(81, cfsCodesToContractTypeRows.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CfsCodesToContractTypeReader_ShouldReadCorrectValues()
        {
            // arrange
            _reader = GetWorkbookReader();
            var worksheetReader = _reader.WorksheetReader("PC-CT");
            var cfsCodesToContractTypeReader = new CfsCodesToContractTypeReader();

            // act
            var cfsCodesToContractTypeRows = cfsCodesToContractTypeReader.ReadConfig(worksheetReader);

            // assert
            var cfsCodesToContractTypeRow = cfsCodesToContractTypeRows
                .Single(cctctr => cctctr.FundingTypeCode == "EDSK"
                && cctctr.FundingPeriodCode == "AY2021"
                && cctctr.ProviderCategory == "ITP");

            Assert.AreEqual("Contract for Services (ITP)", cfsCodesToContractTypeRow.ContractType, "The ContractType has not been read correctly");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CfsCodesToContractTypeReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            var worksheetReader = _jsonReader.WorksheetReader("PC-CT");
            var cfsCodesToContractTypeReader = new CfsCodesToContractTypeReader();

            // act
            var cfsCodesToContractTypeRows = cfsCodesToContractTypeReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(81, cfsCodesToContractTypeRows.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CfsCodesToContractTypeReader_Json_ShouldReadCorrectValues()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            var worksheetReader = _jsonReader.WorksheetReader("PC-CT");
            var cfsCodesToContractTypeReader = new CfsCodesToContractTypeReader();

            // act
            var cfsCodesToContractTypeRows = cfsCodesToContractTypeReader.ReadConfig(worksheetReader);

            // assert
            var cfsCodesToContractTypeRow = cfsCodesToContractTypeRows
                .Single(cctctr => cctctr.FundingTypeCode == "EDSK"
                                  && cctctr.FundingPeriodCode == "AY2021"
                                  && cctctr.ProviderCategory == "ITP");

            Assert.AreEqual("Contract for Services (ITP)", cfsCodesToContractTypeRow.ContractType, "The ContractType has not been read correctly");
        }
    }
}