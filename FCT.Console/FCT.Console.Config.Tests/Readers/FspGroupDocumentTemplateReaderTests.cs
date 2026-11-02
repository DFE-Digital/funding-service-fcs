namespace FCT.Console.Config.Tests.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using FCT.Console.Config.Excel;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class FspGroupDocumentTemplateReaderTests : TestBase
    {
        //private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
          // _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FspGroupDocumentTemplateReader_ShouldReadInAllRowsAndRetrieveTemplateName()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("FSP Group Document Templates");
            FspGroupDocumentTemplateReader fspGroupDocumentTemplateReader = new FspGroupDocumentTemplateReader();

            // act
            IReadOnlyCollection<FspGroupDocumentTemplateSheetType> documentTemplateItems = fspGroupDocumentTemplateReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(392, documentTemplateItems.Count, "The number of rows read in is incorrect");
            var assertRow =
                documentTemplateItems.Single(dti => dti.FundingTypeCode == "EDSK"
                                                    && dti.FundingPeriodCode == "AY1920"
                                                    && dti.DocumentComponentCode == "S1"
                                                    && dti.ContractType == "DEFAULT"
                                                    && dti.FspGroupCode == "16-18TRN1920"
                                                    && dti.PolicyStatus == PolicyStatus.Approved);
           
            Assert.IsNotNull(assertRow, "Document Template doesn't exist");
            Assert.AreEqual("EDSK1920_S1_1618TRN_COFG", assertRow.Template, "Incorrect Template text");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FspGroupDocumentTemplateReader_Json_ShouldReadInAllRowsAndRetrieveTemplateName()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("FSP Group Document Templates");
            FspGroupDocumentTemplateReader fspGroupDocumentTemplateReader = new FspGroupDocumentTemplateReader();

            // act
            IReadOnlyCollection<FspGroupDocumentTemplateSheetType> documentTemplateItems = fspGroupDocumentTemplateReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(392, documentTemplateItems.Count, "The number of rows read in is incorrect");
            var assertRow =
                documentTemplateItems.Single(dti => dti.FundingTypeCode == "EDSK"
                                                    && dti.FundingPeriodCode == "AY1920"
                                                    && dti.DocumentComponentCode == "S1"
                                                    && dti.ContractType == "DEFAULT"
                                                    && dti.FspGroupCode == "16-18TRN1920"
                                                    && dti.PolicyStatus == PolicyStatus.Approved);

            Assert.IsNotNull(assertRow, "Document Template doesn't exist");
            Assert.AreEqual("EDSK1920_S1_1618TRN_COFG", assertRow.Template, "Incorrect Template text");
        }
    }
}