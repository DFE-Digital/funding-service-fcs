namespace FCT.Console.Config.Tests.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class FundingStreamPeriodReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodReader_ShouldReadInAllRowsInGeneratePayments()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Funding Stream Period");
            FundingStreamPeriodReader fundingStreamConfigReader = new FundingStreamPeriodReader();

            // act
            IReadOnlyCollection<FundingStreamPeriodSheetType> fundingStreamPeriodItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(249, fundingStreamPeriodItems.Count, "The number of rows read in is incorrect");
            bool isGeneratePayments =
                fundingStreamPeriodItems.Single(fsp => fsp.FundingStreamPeriodCode == "SSF1718").GeneratePayments;
            Assert.AreEqual(false, isGeneratePayments, "The SSF1718 FSP GeneratePayments should be set to false");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodReader_ShouldReadPaymentCappingLevelAndPaymentCappingPeriod()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Funding Stream Period");
            FundingStreamPeriodReader fundingStreamConfigReader = new FundingStreamPeriodReader();

            // act
            IReadOnlyCollection<FundingStreamPeriodSheetType> fundingStreamPeriodItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            FundingStreamPeriodSheetType thirdRowInSheet =  fundingStreamPeriodItems.ToArray()[0];
            Assert.AreEqual("Financial Year", thirdRowInSheet.PaymentCappingPeriod, "the payment capping period is not correctly read");
            Assert.AreEqual("Deliverable Group", thirdRowInSheet.PaymentCappingLevel, "the payment capping level is not correctly read");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodReader_ShouldReadDefaultedValues()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Funding Stream Period");
            FundingStreamPeriodReader fundingStreamConfigReader = new FundingStreamPeriodReader();

            // act
            IReadOnlyCollection<FundingStreamPeriodSheetType> fundingStreamPeriodItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            FundingStreamPeriodSheetType fundingStreamPeriodRowApps1819 = fundingStreamPeriodItems.Single(fsp => fsp.FundingStreamPeriodCode == "APPS1819");
            Assert.AreEqual(true, fundingStreamPeriodRowApps1819.GeneratePayments, "The GeneratePayments value has not been correctly read");
            Assert.AreEqual(true, fundingStreamPeriodRowApps1819.MultiCollectionReturns, "The MultiCollectionReturns value has not been correctly read");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodReader_ShouldReadDocumentDomainValues()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Funding Stream Period");
            FundingStreamPeriodReader fundingStreamConfigReader = new FundingStreamPeriodReader();

            // act
            IReadOnlyCollection<FundingStreamPeriodSheetType> fundingStreamPeriodItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            FundingStreamPeriodSheetType fundingStreamPeriodRow = fundingStreamPeriodItems.Single(fsp => fsp.FundingStreamPeriodCode == "16-18APPS1718");
            Assert.AreEqual("16-18 Apprenticeships", fundingStreamPeriodRow.SummaryOfFundingDisplayName, "the ContractDocumentDisplayName has not be read correctly");
            Assert.AreEqual(1, fundingStreamPeriodRow.ContractDocumentDisplayOrder, "the ContractDocumentDislayOrder has not been correctly read");
            
            Assert.IsTrue(fundingStreamPeriodRow.ShouldGenerateFundingAgreement, "The ShouldGenerateFundingAgreement should be true");
            Assert.IsFalse(fundingStreamPeriodRow.ShouldUseContractAllocationDescription, "The ShouldUseContractAllocationDescription should be false");
            Assert.AreEqual("A2_MAIN{0}", fundingStreamPeriodRow.Template, "The Template is incorrect");
            Assert.AreEqual(string.Empty, fundingStreamPeriodRow.ExtraPagesTemplate, "The ExtraPagesTemplate is incorrect");
            Assert.AreEqual("16-18 Apprenticeships", fundingStreamPeriodRow.FundingAgreementDisplayName, "The FundingAgreementDisplayName is incorrect");

            FundingStreamPeriodSheetType fundingStreamPeriodRowAllb = fundingStreamPeriodItems.Single(fsp => fsp.FundingStreamPeriodCode == "ALLB1920");
            Assert.AreEqual("LOANS1920", fundingStreamPeriodRowAllb.FSPGroup, "The FSPGroup is incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodReader_ShouldReadFspReportingName()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Funding Stream Period");
            FundingStreamPeriodReader fundingStreamConfigReader = new FundingStreamPeriodReader();

            // act
            IReadOnlyCollection<FundingStreamPeriodSheetType> fundingStreamPeriodItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            FundingStreamPeriodSheetType fundingStreamPeriodRow = fundingStreamPeriodItems.Single(fsp => fsp.FundingStreamPeriodCode == "AEBC-CSO2021");
            Assert.AreEqual("AEB (Colleges) - COVID-19 Skills Offer 20/21", fundingStreamPeriodRow.FspReportingName, "the FspReportingName has not be read correctly");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodReader_Json_ShouldReadInAllRowsInGeneratePayments()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Stream Period");
            FundingStreamPeriodReader fundingStreamConfigReader = new FundingStreamPeriodReader();

            // act
            IReadOnlyCollection<FundingStreamPeriodSheetType> fundingStreamPeriodItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(249, fundingStreamPeriodItems.Count, "The number of rows read in is incorrect");
            bool isGeneratePayments =
                fundingStreamPeriodItems.Single(fsp => fsp.FundingStreamPeriodCode == "SSF1718").GeneratePayments;
            Assert.AreEqual(false, isGeneratePayments, "The SSF1718 FSP GeneratePayments should be set to false");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodReader_Json_ShouldReadPaymentCappingLevelAndPaymentCappingPeriod()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Stream Period");
            FundingStreamPeriodReader fundingStreamConfigReader = new FundingStreamPeriodReader();

            // act
            IReadOnlyCollection<FundingStreamPeriodSheetType> fundingStreamPeriodItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            FundingStreamPeriodSheetType thirdRowInSheet = fundingStreamPeriodItems.ToArray()[0];
            Assert.AreEqual("Financial Year", thirdRowInSheet.PaymentCappingPeriod, "the payment capping period is not correctly read");
            Assert.AreEqual("Deliverable Group", thirdRowInSheet.PaymentCappingLevel, "the payment capping level is not correctly read");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodReader_Json_ShouldReadDefaultedValues()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Stream Period");
            FundingStreamPeriodReader fundingStreamConfigReader = new FundingStreamPeriodReader();

            // act
            IReadOnlyCollection<FundingStreamPeriodSheetType> fundingStreamPeriodItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            FundingStreamPeriodSheetType fundingStreamPeriodRowApps1819 = fundingStreamPeriodItems.Single(fsp => fsp.FundingStreamPeriodCode == "APPS1819");
            Assert.AreEqual(true, fundingStreamPeriodRowApps1819.GeneratePayments, "The GeneratePayments value has not been correctly read");
            Assert.AreEqual(true, fundingStreamPeriodRowApps1819.MultiCollectionReturns, "The MultiCollectionReturns value has not been correctly read");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodReader_Json_ShouldReadDocumentDomainValues()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Stream Period");
            FundingStreamPeriodReader fundingStreamConfigReader = new FundingStreamPeriodReader();

            // act
            IReadOnlyCollection<FundingStreamPeriodSheetType> fundingStreamPeriodItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            FundingStreamPeriodSheetType fundingStreamPeriodRow = fundingStreamPeriodItems.Single(fsp => fsp.FundingStreamPeriodCode == "16-18APPS1718");
            Assert.AreEqual("16-18 Apprenticeships", fundingStreamPeriodRow.SummaryOfFundingDisplayName, "the ContractDocumentDisplayName has not be read correctly");
            Assert.AreEqual(1, fundingStreamPeriodRow.ContractDocumentDisplayOrder, "the ContractDocumentDislayOrder has not been correctly read");

            Assert.IsTrue(fundingStreamPeriodRow.ShouldGenerateFundingAgreement, "The ShouldGenerateFundingAgreement should be true");
            Assert.IsFalse(fundingStreamPeriodRow.ShouldUseContractAllocationDescription, "The ShouldUseContractAllocationDescription should be false");
            Assert.AreEqual("A2_MAIN{0}", fundingStreamPeriodRow.Template, "The Template is incorrect");
            Assert.AreEqual(string.Empty, fundingStreamPeriodRow.ExtraPagesTemplate, "The ExtraPagesTemplate is incorrect");
            Assert.AreEqual("16-18 Apprenticeships", fundingStreamPeriodRow.FundingAgreementDisplayName, "The FundingAgreementDisplayName is incorrect");

            FundingStreamPeriodSheetType fundingStreamPeriodRowAllb = fundingStreamPeriodItems.Single(fsp => fsp.FundingStreamPeriodCode == "ALLB1920");
            Assert.AreEqual("LOANS1920", fundingStreamPeriodRowAllb.FSPGroup, "The FSPGroup is incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodReader_Json_ShouldReadFspReportingName()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Stream Period");
            FundingStreamPeriodReader fundingStreamConfigReader = new FundingStreamPeriodReader();

            // act
            IReadOnlyCollection<FundingStreamPeriodSheetType> fundingStreamPeriodItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            FundingStreamPeriodSheetType fundingStreamPeriodRow = fundingStreamPeriodItems.Single(fsp => fsp.FundingStreamPeriodCode == "AEBC-CSO2021");
            Assert.AreEqual("AEB (Colleges) - COVID-19 Skills Offer 20/21", fundingStreamPeriodRow.FspReportingName, "the FspReportingName has not be read correctly");
        }
    }
}
