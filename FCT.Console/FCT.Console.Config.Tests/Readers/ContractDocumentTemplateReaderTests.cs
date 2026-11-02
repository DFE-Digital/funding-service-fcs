namespace FCT.Console.Config.Tests.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class ContractDocumentTemplateReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractDocumentTemplateReader_ShouldReadInAllRowsAndRetrieveTemplateName()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Contract Document Templates");
            ContractDocumentTemplateReader contractDocumentTemplateReader = new ContractDocumentTemplateReader();

            // act
            IReadOnlyCollection<ContractDocumentTemplateSheetType> documentTemplateItems = contractDocumentTemplateReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(159, documentTemplateItems.Count, "The number of rows read in is incorrect");
            var assertRow =
                documentTemplateItems.Single(dti => dti.FundingTypeCode == "EDSK"
                                                    && dti.FundingPeriodCode == "AY1920"
                                                    && dti.DocumentComponentCode == "TAC"
                                                    && dti.ContractType == "Conditions of Funding (Grant) (Trust)");

            Assert.IsNotNull(assertRow, "Document Template doesn't exist");
            Assert.AreEqual("EDSK1920_TAC_COFG_TRUST", assertRow.Template, "Incorrect Template text");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractDocumentTemplateReader_Json_ShouldReadInAllRowsAndRetrieveTemplateName()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Contract Document Templates");
            ContractDocumentTemplateReader contractDocumentTemplateReader = new ContractDocumentTemplateReader();

            // act
            IReadOnlyCollection<ContractDocumentTemplateSheetType> documentTemplateItems = contractDocumentTemplateReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(159, documentTemplateItems.Count, "The number of rows read in is incorrect");
            var assertRow =
                documentTemplateItems.Single(dti => dti.FundingTypeCode == "EDSK"
                                                    && dti.FundingPeriodCode == "AY1920"
                                                    && dti.DocumentComponentCode == "TAC"
                                                    && dti.ContractType == "Conditions of Funding (Grant) (Trust)");

            Assert.IsNotNull(assertRow, "Document Template doesn't exist");
            Assert.AreEqual("EDSK1920_TAC_COFG_TRUST", assertRow.Template, "Incorrect Template text");
        }
    }
}
