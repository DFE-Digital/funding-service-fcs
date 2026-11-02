namespace FCT.Console.Config.Tests.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class FundingTypeFundingPeriodContractTypeReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;


        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodContractTypeReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("FTP-CoT");
            FundingTypeFundingPeriodContractTypeReader fundingTypeFundingPeriodContractTypeReader = new FundingTypeFundingPeriodContractTypeReader();

            // act
            IReadOnlyCollection<FTPCoTSheetType> ftpCoTSheetTypeItems = fundingTypeFundingPeriodContractTypeReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(88, ftpCoTSheetTypeItems.Count, "The number of rows read in is incorrect");

            var assertRow =
                ftpCoTSheetTypeItems.Single(ftpctst => ftpctst.FundingTypeCode == "EDSK"
                                                       && ftpctst.FundingPeriodCode == "AY1920"
                                                       && ftpctst.ContractType == "Contract for Services (ITP)"
                                                       && ftpctst.DefinedContractTermForProvider == "Contractor");

            Assert.IsNotNull(assertRow, "The following record was not read in FundingTypeCode 'EDSK', FundingPeriodCode 'AY1920', ContractType 'Contract for Services (ITP)'");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodContractTypeReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("FTP-CoT");
            FundingTypeFundingPeriodContractTypeReader fundingTypeFundingPeriodContractTypeReader = new FundingTypeFundingPeriodContractTypeReader();

            // act
            IReadOnlyCollection<FTPCoTSheetType> ftpCoTSheetTypeItems = fundingTypeFundingPeriodContractTypeReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(88, ftpCoTSheetTypeItems.Count, "The number of rows read in is incorrect");

            var assertRow =
                ftpCoTSheetTypeItems.Single(ftpctst => ftpctst.FundingTypeCode == "EDSK"
                                                       && ftpctst.FundingPeriodCode == "AY1920"
                                                       && ftpctst.ContractType == "Contract for Services (ITP)"
                                                       && ftpctst.DefinedContractTermForProvider == "Contractor");

            Assert.IsNotNull(assertRow, "The following record was not read in FundingTypeCode 'EDSK', FundingPeriodCode 'AY1920', ContractType 'Contract for Services (ITP)'");
        }
    }
}