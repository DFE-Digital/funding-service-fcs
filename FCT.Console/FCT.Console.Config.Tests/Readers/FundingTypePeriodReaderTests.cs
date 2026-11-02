namespace FCT.Console.Config.Tests.Readers
{
    using System;
    using System.Globalization;
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using Synchronizers.Readers;

    [TestClass]
    public class FundingTypePeriodTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Funding Type Period");
            FundingTypePeriodReader fundingTypePeriodConfigReader = new FundingTypePeriodReader();

            // act
            IReadOnlyCollection<FundingTypePeriodSheetType> fundingTypePeriodItems = fundingTypePeriodConfigReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(102, fundingTypePeriodItems.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_ShouldReadApprovalType()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Funding Type Period");
            FundingTypePeriodReader fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            IReadOnlyCollection<FundingTypePeriodSheetType> fundingTypePeriodItems = fundingTypePeriodReader.ReadConfig(worksheetReader);

            // assert
            FundingTypePeriodSheetType rowInSheet =  fundingTypePeriodItems.ToArray()[5];
            // Advanced Learner Loans
            Assert.AreEqual("16-19 Funding - AY1819", rowInSheet.FundingTypeFundingPeriodName, "the funding type period name is not correctly read");
            Assert.AreEqual("Electronic", rowInSheet.ApprovalType, "the approval type is not correctly read");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_ShouldReadCaseloadAssignmentAndInternalApproval()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Funding Type Period");
            FundingTypePeriodReader fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            IReadOnlyCollection<FundingTypePeriodSheetType> fundingTypePeriodItems = fundingTypePeriodReader.ReadConfig(worksheetReader);

            // assert
            foreach(FundingTypePeriodSheetType row in fundingTypePeriodItems)
            {
                if(row.FundingTypeName == "Apprenticeship Levy")
                {
                    Assert.AreEqual(row.SkipCaseloadAssignment,true,"FundingTypePeriod: SkipCaseloadAssignment value incorrect for Apprenticeship Levy");
                    Assert.AreEqual(row.SkipReviewAndInternalApproval, true, "FundingTypePeriod: SkipReviewAndInternalApproval value incorrect for Apprenticeship Levy");
                }
                else
                {
                    Assert.AreEqual(row.SkipCaseloadAssignment, false, "FundingTypePeriod: SkipCaseloadAssignment value incorrect");
                    Assert.AreEqual(row.SkipReviewAndInternalApproval, false, "FundingTypePeriod: SkipReviewAndInternalApproval value incorrect");
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_ShouldReadTemplateName()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Funding Type Period");
            FundingTypePeriodReader fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            IReadOnlyCollection<FundingTypePeriodSheetType> fundingTypePeriodItems =
                fundingTypePeriodReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual("A1_1619FUND",
                fundingTypePeriodItems.Single(ftp => ftp.FundingTypeCode == "1619FUND" && ftp.FundingPeriod == "AY1718").TemplateName);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_ShouldReadAmendmentTemplate()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Funding Type Period");
            FundingTypePeriodReader fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            IReadOnlyCollection<FundingTypePeriodSheetType> fundingTypePeriodItems =
                fundingTypePeriodReader.ReadConfig(worksheetReader);

            // assert
            var assertAmendmentTemplate = fundingTypePeriodItems.SingleOrDefault(ftp => ftp.FundingTypeCode == "LEVY" && ftp.FundingPeriod == "LEVY1799")
                                            .AmendmentTemplate;

            Assert.AreEqual("LEVY1799_Amendment", assertAmendmentTemplate);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_ShouldReadContractingActivityCloseDate()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Funding Type Period");
            FundingTypePeriodReader fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            IReadOnlyCollection<FundingTypePeriodSheetType> fundingTypePeriodItems =
                fundingTypePeriodReader.ReadConfig(worksheetReader);

            // assert
            var contractingActivityCloseDate = fundingTypePeriodItems.FirstOrDefault(ftp => ftp.FundingTypeCode=="AGE" && ftp.FundingPeriod =="FY1516")?.ContractingActivityCloseDate;
            Assert.AreEqual(DateTime.ParseExact("18/06/2017 00:00:00","dd/MM/yyyy hh:mm:ss",CultureInfo.InvariantCulture), contractingActivityCloseDate.GetValueOrDefault());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_ShouldReadAreContractsOpenEnded()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Funding Type Period");
            FundingTypePeriodReader fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            IReadOnlyCollection<FundingTypePeriodSheetType> fundingTypePeriodItems =
                fundingTypePeriodReader.ReadConfig(worksheetReader);

            // assert
            bool areContractsOpenEndedLevy1799 =
                fundingTypePeriodItems.First(ft => ft.FundingTypeCode == "LEVY" && ft.FundingPeriod == "LEVY1799")
                    .AreContractsOpenEnded;
            Assert.IsTrue(areContractsOpenEndedLevy1799, "Unexpected AreContractsOpenEnded returned for LEVY-LEVY1799");

            fundingTypePeriodItems
                .Where(ft => ft.FundingTypeCode != "LEVY" && ft.FundingPeriod != "LEVY1799")
                .ForEach(ft =>
                {
                    Assert.IsFalse(ft.AreContractsOpenEnded,
                        $"Unexpected AreContractsOpenEnded returned for {ft.FundingTypeCode} - {ft.FundingPeriod}");
                });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_ShouldReadAllowUseOfDeliveryOrgsColumn()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Funding Type Period");
            FundingTypePeriodReader fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            IReadOnlyCollection<FundingTypePeriodSheetType> fundingTypePeriodItems =
                fundingTypePeriodReader.ReadConfig(worksheetReader);

            bool expectedTrue_1619FUND_AY1718 = GetAllowUseOfDeliveryOrgsValue(fundingTypePeriodItems, "1619FUND", "AY1718");

            bool expectedFalse_AEB_AY1819 = GetAllowUseOfDeliveryOrgsValue(fundingTypePeriodItems, "AEB", "AY1819");
            bool expectedFalse_LEVY_LEVY1799 = GetAllowUseOfDeliveryOrgsValue(fundingTypePeriodItems, "LEVY", "LEVY1799");
            bool expectedFalse_EOF_EOF1420 = GetAllowUseOfDeliveryOrgsValue(fundingTypePeriodItems, "EOF", "EOF1420");

            // assert
            Assert.IsTrue(expectedTrue_1619FUND_AY1718, "AllowUseOfDeliveryOrgs should be true for Funding Type '1619FUND', Funding Period 'AY1718'");

            Assert.IsFalse(expectedFalse_AEB_AY1819, "AllowUseOfDeliveryOrgs should be false Funding Type 'AEB', Funding Period 'AY1819'");
            Assert.IsFalse(expectedFalse_LEVY_LEVY1799, "AllowUseOfDeliveryOrgs should be false for Funding Type 'LEVY', Funding Period 'LEVY1799'");
            Assert.IsFalse(expectedFalse_EOF_EOF1420, "AllowUseOfDeliveryOrgs should be false for Funding Type 'EOF', Funding Period 'EOF1420'");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_ShouldReadAllowNewAmendmentColumn()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Funding Type Period");
            FundingTypePeriodReader fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            IReadOnlyCollection<FundingTypePeriodSheetType> fundingTypePeriodItems =
                fundingTypePeriodReader.ReadConfig(worksheetReader);

            bool expectedTrue_24LOANS_AY1617 = GetAllowNewAmendmentValue(fundingTypePeriodItems, "24+LOANS", "AY1617");

            bool expectedFalse_EDSK_AY1920 = GetAllowNewAmendmentValue(fundingTypePeriodItems, "EDSK", "AY1920");

            // assert
            Assert.IsTrue(expectedTrue_24LOANS_AY1617, "AllowNewAmendment should be true for Funding Type '24+LOANS', Funding Period 'AY1617'");
            Assert.IsFalse(expectedFalse_EDSK_AY1920, "AllowNewAmendment should be false for Funding Type 'EDSK', Funding Period 'AY1920'");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_ShouldReadIncludeAllContractsOnSummaryOfFundingColumn()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Funding Type Period");
            FundingTypePeriodReader fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            IReadOnlyCollection<FundingTypePeriodSheetType> fundingTypePeriodItems =
                fundingTypePeriodReader.ReadConfig(worksheetReader);

            bool expectedTrue_AEB_AY1718 = GetIncludeAllContractsOnSummaryOfFundingValue(fundingTypePeriodItems, "AEB", "AY1718");

            bool expectedFalse_EDSK_AY1920 = GetIncludeAllContractsOnSummaryOfFundingValue(fundingTypePeriodItems, "EDSK", "AY1920");

            // assert
            Assert.IsTrue(expectedTrue_AEB_AY1718, "IncludeAllContractsOnSummaryOfFunding should be true for Funding Type 'AEB', Funding Period 'AY1718'");
            Assert.IsFalse(expectedFalse_EDSK_AY1920, "IncludeAllContractsOnSummaryOfFunding should be false for Funding Type 'EDSK', Funding Period 'AY1920'");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_ShouldReadOnlyGenerateFundingAgreementForNewOrUpdatedAllocations()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Funding Type Period");
            FundingTypePeriodReader fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            IReadOnlyCollection<FundingTypePeriodSheetType> fundingTypePeriodItems =
                fundingTypePeriodReader.ReadConfig(worksheetReader);

            bool expectedTrue_AEB_AY1718 = GetIncludeAllContractsOnSummaryOfFundingValue(fundingTypePeriodItems, "AEB", "AY1718");

            bool expectedFalse_MAIN_AY1819 = GetIncludeAllContractsOnSummaryOfFundingValue(fundingTypePeriodItems, "MAIN", "AY1819");

            // assert
            Assert.IsTrue(expectedTrue_AEB_AY1718, 
                "OnlyGenerateFundingAgreementForNewOrUpdatedAllocations should be true for Funding Type 'AEB', Funding Period 'AY1718'");
            Assert.IsFalse(expectedFalse_MAIN_AY1819,
                "OnlyGenerateFundingAgreementForNewOrUpdatedAllocations should be false for Funding Type 'MAIN', Funding Period 'AY1819'");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_ShouldReadOnlyFtpGroupAndRelatedItems()
        {
            // arrange
            const string fundingTypeCode = "DADA";
            const string fundingPeriod = "AY2122";
            const string expectedFtpGroupCode = "DADA2020";
            const string expectedPrecedingFtpFundingType = "DADA";
            const string expectedPrecedingFtpFundingPeriod = "AY2021";

            _reader = GetWorkbookReader();
            var worksheetReader = _reader.WorksheetReader("Funding Type Period");
            var fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            var fundingTypeFundingPeriodItems = fundingTypePeriodReader.ReadConfig(worksheetReader);

            var fundingTypeFundingPeriod = fundingTypeFundingPeriodItems
                .Single(ftp => ftp.FundingTypeCode == fundingTypeCode && ftp.FundingPeriod == fundingPeriod);


            // assert
            Assert.AreEqual(expectedFtpGroupCode, fundingTypeFundingPeriod.FtpGroupCode, "Incorrect FtpGroupCode");
            Assert.AreEqual(expectedPrecedingFtpFundingType, fundingTypeFundingPeriod.PrecedingFtpFundingType, "Incorrect PrecedingFtpFundingType");
            Assert.AreEqual(expectedPrecedingFtpFundingPeriod, fundingTypeFundingPeriod.PrecedingFtpFundingPeriod, "Incorrect expectedPrecedingFtpFundingPeriod");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_ShouldReadOnlyAllAmendmentsRequireSigning()
        {
            // arrange
            _reader = GetWorkbookReader();
            var worksheetReader = _reader.WorksheetReader("Funding Type Period");
            var fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            var fundingTypeFundingPeriodItems = fundingTypePeriodReader.ReadConfig(worksheetReader);

            // assert
            Assert.IsTrue(fundingTypeFundingPeriodItems
                .Single(ftp => ftp.FundingTypeCode == "NLG" && ftp.FundingPeriod == "AY2122")
                .AllAmendmentsRequireSigning, "AllAmendmentsRequireSigning should be true");

            Assert.IsNull(fundingTypeFundingPeriodItems
                .Single(ftp => ftp.FundingTypeCode == "24+LOANS" && ftp.FundingPeriod == "AY1516")
                .AllAmendmentsRequireSigning, "AllAmendmentsRequireSigning should be null");

            Assert.IsFalse(fundingTypeFundingPeriodItems
                .Single(ftp => ftp.FundingTypeCode == "CCF" && ftp.FundingPeriod == "FY2122")
                .AllAmendmentsRequireSigning, "AllAmendmentsRequireSigning should be false");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Type Period");
            FundingTypePeriodReader fundingTypePeriodConfigReader = new FundingTypePeriodReader();

            // act
            IReadOnlyCollection<FundingTypePeriodSheetType> fundingTypePeriodItems = fundingTypePeriodConfigReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(102, fundingTypePeriodItems.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_Json_ShouldReadApprovalType()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Type Period");
            FundingTypePeriodReader fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            IReadOnlyCollection<FundingTypePeriodSheetType> fundingTypePeriodItems = fundingTypePeriodReader.ReadConfig(worksheetReader);

            // assert
            FundingTypePeriodSheetType rowInSheet = fundingTypePeriodItems.ToArray()[5];
            // Advanced Learner Loans
            Assert.AreEqual("16-19 Funding - AY1819", rowInSheet.FundingTypeFundingPeriodName, "the funding type period name is not correctly read");
            Assert.AreEqual("Electronic", rowInSheet.ApprovalType, "the approval type is not correctly read");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_Json_ShouldReadCaseloadAssignmentAndInternalApproval()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Type Period");
            FundingTypePeriodReader fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            IReadOnlyCollection<FundingTypePeriodSheetType> fundingTypePeriodItems = fundingTypePeriodReader.ReadConfig(worksheetReader);

            // assert
            foreach (FundingTypePeriodSheetType row in fundingTypePeriodItems)
            {
                if (row.FundingTypeName == "Apprenticeship Levy")
                {
                    Assert.AreEqual(row.SkipCaseloadAssignment, true, "FundingTypePeriod: SkipCaseloadAssignment value incorrect for Apprenticeship Levy");
                    Assert.AreEqual(row.SkipReviewAndInternalApproval, true, "FundingTypePeriod: SkipReviewAndInternalApproval value incorrect for Apprenticeship Levy");
                }
                else
                {
                    Assert.AreEqual(row.SkipCaseloadAssignment, false, "FundingTypePeriod: SkipCaseloadAssignment value incorrect");
                    Assert.AreEqual(row.SkipReviewAndInternalApproval, false, "FundingTypePeriod: SkipReviewAndInternalApproval value incorrect");
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_Json_ShouldReadTemplateName()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Type Period");
            FundingTypePeriodReader fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            IReadOnlyCollection<FundingTypePeriodSheetType> fundingTypePeriodItems =
                fundingTypePeriodReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual("A1_1619FUND", 
                fundingTypePeriodItems.Single(ftp => ftp.FundingTypeCode == "1619FUND" && ftp.FundingPeriod == "AY1718").TemplateName);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_Json_ShouldReadAmendmentTemplate()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Type Period");
            FundingTypePeriodReader fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            IReadOnlyCollection<FundingTypePeriodSheetType> fundingTypePeriodItems =
                fundingTypePeriodReader.ReadConfig(worksheetReader);

            // assert
            var assertAmendmentTemplate = fundingTypePeriodItems.SingleOrDefault(ftp => ftp.FundingTypeCode == "LEVY" && ftp.FundingPeriod == "LEVY1799")
                                            .AmendmentTemplate;

            Assert.AreEqual("LEVY1799_Amendment", assertAmendmentTemplate);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_Json_ShouldReadContractingActivityCloseDate()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Type Period");
            FundingTypePeriodReader fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            IReadOnlyCollection<FundingTypePeriodSheetType> fundingTypePeriodItems =
                fundingTypePeriodReader.ReadConfig(worksheetReader);

            // assert
            var contractingActivityCloseDate = fundingTypePeriodItems.FirstOrDefault(ftp => ftp.FundingTypeCode == "AGE" && ftp.FundingPeriod == "FY1516")?.ContractingActivityCloseDate;
            Assert.AreEqual(DateTime.ParseExact("18/06/2017 00:00:00", "dd/MM/yyyy hh:mm:ss", CultureInfo.InvariantCulture), contractingActivityCloseDate.GetValueOrDefault());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_Json_ShouldReadAreContractsOpenEnded()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Type Period");
            FundingTypePeriodReader fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            IReadOnlyCollection<FundingTypePeriodSheetType> fundingTypePeriodItems =
                fundingTypePeriodReader.ReadConfig(worksheetReader);

            // assert
            bool areContractsOpenEndedLevy1799 =
                fundingTypePeriodItems.First(ft => ft.FundingTypeCode == "LEVY" && ft.FundingPeriod == "LEVY1799")
                    .AreContractsOpenEnded;
            Assert.IsTrue(areContractsOpenEndedLevy1799, "Unexpected AreContractsOpenEnded returned for LEVY-LEVY1799");

            fundingTypePeriodItems
                .Where(ft => ft.FundingTypeCode != "LEVY" && ft.FundingPeriod != "LEVY1799")
                .ForEach(ft =>
                {
                    Assert.IsFalse(ft.AreContractsOpenEnded,
                        $"Unexpected AreContractsOpenEnded returned for {ft.FundingTypeCode} - {ft.FundingPeriod}");
                });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_Json_ShouldReadAllowUseOfDeliveryOrgsColumn()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Type Period");
            FundingTypePeriodReader fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            IReadOnlyCollection<FundingTypePeriodSheetType> fundingTypePeriodItems =
                fundingTypePeriodReader.ReadConfig(worksheetReader);

            bool expectedTrue_1619FUND_AY1718 = GetAllowUseOfDeliveryOrgsValue(fundingTypePeriodItems, "1619FUND", "AY1718");

            bool expectedFalse_AEB_AY1819 = GetAllowUseOfDeliveryOrgsValue(fundingTypePeriodItems, "AEB", "AY1819");
            bool expectedFalse_LEVY_LEVY1799 = GetAllowUseOfDeliveryOrgsValue(fundingTypePeriodItems, "LEVY", "LEVY1799");
            bool expectedFalse_EOF_EOF1420 = GetAllowUseOfDeliveryOrgsValue(fundingTypePeriodItems, "EOF", "EOF1420");

            // assert
            Assert.IsTrue(expectedTrue_1619FUND_AY1718, "AllowUseOfDeliveryOrgs should be true for Funding Type '1619FUND', Funding Period 'AY1718'");

            Assert.IsFalse(expectedFalse_AEB_AY1819, "AllowUseOfDeliveryOrgs should be false Funding Type 'AEB', Funding Period 'AY1819'");
            Assert.IsFalse(expectedFalse_LEVY_LEVY1799, "AllowUseOfDeliveryOrgs should be false for Funding Type 'LEVY', Funding Period 'LEVY1799'");
            Assert.IsFalse(expectedFalse_EOF_EOF1420, "AllowUseOfDeliveryOrgs should be false for Funding Type 'EOF', Funding Period 'EOF1420'");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_Json_ShouldReadAllowNewAmendmentColumn()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Type Period");
            FundingTypePeriodReader fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            IReadOnlyCollection<FundingTypePeriodSheetType> fundingTypePeriodItems =
                fundingTypePeriodReader.ReadConfig(worksheetReader);

            bool expectedTrue_24LOANS_AY1617 = GetAllowNewAmendmentValue(fundingTypePeriodItems, "24+LOANS", "AY1617");

            bool expectedFalse_EDSK_AY1920 = GetAllowNewAmendmentValue(fundingTypePeriodItems, "EDSK", "AY1920");

            // assert
            Assert.IsTrue(expectedTrue_24LOANS_AY1617, "AllowNewAmendment should be true for Funding Type '24+LOANS', Funding Period 'AY1617'");
            Assert.IsFalse(expectedFalse_EDSK_AY1920, "AllowNewAmendment should be false for Funding Type 'EDSK', Funding Period 'AY1920'");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_Json_ShouldReadIncludeAllContractsOnSummaryOfFundingColumn()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Type Period");
            FundingTypePeriodReader fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            IReadOnlyCollection<FundingTypePeriodSheetType> fundingTypePeriodItems =
                fundingTypePeriodReader.ReadConfig(worksheetReader);

            bool expectedTrue_AEB_AY1718 = GetIncludeAllContractsOnSummaryOfFundingValue(fundingTypePeriodItems, "AEB", "AY1718");

            bool expectedFalse_EDSK_AY1920 = GetIncludeAllContractsOnSummaryOfFundingValue(fundingTypePeriodItems, "EDSK", "AY1920");

            // assert
            Assert.IsTrue(expectedTrue_AEB_AY1718, "IncludeAllContractsOnSummaryOfFunding should be true for Funding Type 'AEB', Funding Period 'AY1718'");
            Assert.IsFalse(expectedFalse_EDSK_AY1920, "IncludeAllContractsOnSummaryOfFunding should be false for Funding Type 'EDSK', Funding Period 'AY1920'");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_Json_ShouldReadOnlyGenerateFundingAgreementForNewOrUpdatedAllocations()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Type Period");
            FundingTypePeriodReader fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            IReadOnlyCollection<FundingTypePeriodSheetType> fundingTypePeriodItems =
                fundingTypePeriodReader.ReadConfig(worksheetReader);

            bool expectedTrue_AEB_AY1718 = GetIncludeAllContractsOnSummaryOfFundingValue(fundingTypePeriodItems, "AEB", "AY1718");

            bool expectedFalse_MAIN_AY1819 = GetIncludeAllContractsOnSummaryOfFundingValue(fundingTypePeriodItems, "MAIN", "AY1819");

            // assert
            Assert.IsTrue(expectedTrue_AEB_AY1718,
                "OnlyGenerateFundingAgreementForNewOrUpdatedAllocations should be true for Funding Type 'AEB', Funding Period 'AY1718'");
            Assert.IsFalse(expectedFalse_MAIN_AY1819,
                "OnlyGenerateFundingAgreementForNewOrUpdatedAllocations should be false for Funding Type 'MAIN', Funding Period 'AY1819'");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_Json_ShouldReadOnlyFtpGroupAndRelatedItems()
        {
            // arrange
            const string fundingTypeCode = "DADA";
            const string fundingPeriod = "AY2122";
            const string expectedFtpGroupCode = "DADA2020";
            const string expectedPrecedingFtpFundingType = "DADA";
            const string expectedPrecedingFtpFundingPeriod = "AY2021";

            _jsonReader = GetJsonWorkbookReader();
            var worksheetReader = _jsonReader.WorksheetReader("Funding Type Period");
            var fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            var fundingTypeFundingPeriodItems = fundingTypePeriodReader.ReadConfig(worksheetReader);

            FundingTypePeriodSheetType fundingTypeFundingPeriod = fundingTypeFundingPeriodItems
                .Single(ftp => ftp.FundingTypeCode == fundingTypeCode && ftp.FundingPeriod == fundingPeriod);


            // assert
            Assert.AreEqual(expectedFtpGroupCode, fundingTypeFundingPeriod.FtpGroupCode, "Incorrect FtpGroupCode");
            Assert.AreEqual(expectedPrecedingFtpFundingType, fundingTypeFundingPeriod.PrecedingFtpFundingType, "Incorrect PrecedingFtpFundingType");
            Assert.AreEqual(expectedPrecedingFtpFundingPeriod, fundingTypeFundingPeriod.PrecedingFtpFundingPeriod, "Incorrect expectedPrecedingFtpFundingPeriod");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodReader_Json_ShouldReadOnlyAllAmendmentsRequireSigning()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            var worksheetReader = _jsonReader.WorksheetReader("Funding Type Period");
            var fundingTypePeriodReader = new FundingTypePeriodReader();

            // act
            var fundingTypeFundingPeriodItems = fundingTypePeriodReader.ReadConfig(worksheetReader);

            // assert
            Assert.IsTrue(fundingTypeFundingPeriodItems
                .Single(ftp => ftp.FundingTypeCode == "NLG" && ftp.FundingPeriod == "AY2122")
                .AllAmendmentsRequireSigning, "AllAmendmentsRequireSigning should be true");

            Assert.IsNull(fundingTypeFundingPeriodItems
                .Single(ftp => ftp.FundingTypeCode == "24+LOANS" && ftp.FundingPeriod == "AY1516")
                .AllAmendmentsRequireSigning, "AllAmendmentsRequireSigning should be null");

            Assert.IsFalse(fundingTypeFundingPeriodItems
                .Single(ftp => ftp.FundingTypeCode == "CCF" && ftp.FundingPeriod == "FY2122")
                .AllAmendmentsRequireSigning, "AllAmendmentsRequireSigning should be false");
        }

        private bool GetAllowUseOfDeliveryOrgsValue(IReadOnlyCollection<FundingTypePeriodSheetType> rows ,string fundingTypeCode, string fundingPeriod)
        {
            return 
                rows
                .Single(ftp => ftp.FundingTypeCode == fundingTypeCode && ftp.FundingPeriod == fundingPeriod)
                .AllowUseOfDeliveryOrgs;
        }

        private bool GetAllowNewAmendmentValue(IReadOnlyCollection<FundingTypePeriodSheetType> rows, string fundingTypeCode, string fundingPeriod)
        {
            return
                rows
                    .Single(ftp => ftp.FundingTypeCode == fundingTypeCode && ftp.FundingPeriod == fundingPeriod)
                    .AllowNewAmendment;
        }

        private bool GetIncludeAllContractsOnSummaryOfFundingValue(IReadOnlyCollection<FundingTypePeriodSheetType> rows, string fundingTypeCode, string fundingPeriod)
        {
            return
                rows
                    .Single(ftp => ftp.FundingTypeCode == fundingTypeCode && ftp.FundingPeriod == fundingPeriod)
                    .IncludeAllContractsOnSummaryOfFunding;
        }
    }
}
