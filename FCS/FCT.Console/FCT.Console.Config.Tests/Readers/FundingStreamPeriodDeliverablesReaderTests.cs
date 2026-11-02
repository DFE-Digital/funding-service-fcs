namespace FCT.Console.Config.Tests.Readers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class FundingStreamPeriodDeliverablesReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodDeliverablesReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("FSP Deliverables");
            FundingStreamPeriodDeliverablesReader fundingStreamConfigReader = new FundingStreamPeriodDeliverablesReader();

            // act
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverablesItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(3558, fundingStreamPeriodDeliverablesItems.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodDeliverablesReader_ShouldReadInAllowCustomDeliverableDesc()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("FSP Deliverables");
            FundingStreamPeriodDeliverablesReader fundingStreamConfigReader = new FundingStreamPeriodDeliverablesReader();

            // act
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverablesItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            // check AllowCustomDeliverableDesc
            Assert.AreEqual(false, fundingStreamPeriodDeliverablesItems.First(f => f.FundingStreamPeriodCode == "16-18APPS1516").AllowCustomDeliverableDesc, "AllowCustomDeliverableDesc not read in correctly");
            Assert.AreEqual(true, fundingStreamPeriodDeliverablesItems.First(f => f.FundingStreamPeriodCode == "ESF1420").AllowCustomDeliverableDesc, "AllowCustomDeliverableDesc not read in correctly");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodDeliverablesReader_ShouldReadInCappingApportionmentPriorityOrder()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("FSP Deliverables");
            FundingStreamPeriodDeliverablesReader fundingStreamConfigReader = new FundingStreamPeriodDeliverablesReader();

            // act
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverablesItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            // check Capping Apportionment Priortiy Order
            Assert.AreEqual(1, fundingStreamPeriodDeliverablesItems.First(f => f.FundingStreamPeriodCode == "16-18APPS1516" && f.DeliverableCode==6).CappingApportionmentPriorityOrder, "Capping Apportionment Priortiy Order not read in correctly for 16-18APPS1516 and deliverable code = 6 ");
            Assert.AreEqual(2, fundingStreamPeriodDeliverablesItems.First(f => f.FundingStreamPeriodCode == "16-18NLA1718" && f.DeliverableCode == 4).CappingApportionmentPriorityOrder, "Capping Apportionment Priortiy Order not read in correctly for 16-18NLA1718 and deliverable code = 4");
            Assert.AreEqual(null, fundingStreamPeriodDeliverablesItems.First(f => f.FundingStreamPeriodCode == "16-18NLA1718" && f.DeliverableCode == 1).CappingApportionmentPriorityOrder, "Capping Apportionment Priortiy Order not read in correctly for 16-18NLA1718 and deliverable code =1");

        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodDeliverablesReader_ShouldReadInAndTranslateMandatoryCol()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("FSP Deliverables");
            FundingStreamPeriodDeliverablesReader fundingStreamConfigReader = new FundingStreamPeriodDeliverablesReader();

            // act
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverablesItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            Assert.AreEqual(true, fundingStreamPeriodDeliverablesItems.First().IsMandatory, "The Mandatory column has not read in correctly");
            Assert.AreEqual(false, fundingStreamPeriodDeliverablesItems.First(f => f.FundingStreamPeriodCode == "ESF1420").IsMandatory, "The Mandatory column has not read in correctly");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodDeliverablesReader_ShouldReadDocumentDomainValues()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("FSP Deliverables");
            FundingStreamPeriodDeliverablesReader fundingStreamConfigReader = new FundingStreamPeriodDeliverablesReader();

            // act
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverablesItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            FundingStreamPeriodDeliverablesSheetType fundingStreamPeriodDeliverablesRow = fundingStreamPeriodDeliverablesItems
                                                                                            .Single(fsp => fsp.FundingStreamPeriodCode == "16-18APPS1718"
                                                                                                        && fsp.DeliverableCode == 2);

            Assert.IsTrue(fundingStreamPeriodDeliverablesRow.AllowProfile, "The allowProfile should be true");
            Assert.IsTrue(fundingStreamPeriodDeliverablesRow.DisplayOnFundingAgreement, "The DisplayOnFundingAgreement should be true");
            Assert.IsTrue(fundingStreamPeriodDeliverablesRow.MandatoryOnFundingAgreement, "The MandatoryOnFundingAgreement should be true");
            Assert.AreEqual(1, fundingStreamPeriodDeliverablesRow.DisplayOrderOnFundingAgreement, "The DisplayOrderOnFundingAgreement has not been read correctly");

            Assert.IsFalse(fundingStreamPeriodDeliverablesRow.AllowCustomDescription, "The AllowCustomDescription should be false");
            Assert.IsTrue(fundingStreamPeriodDeliverablesRow.ShouldDisplayValue, "The ShouldDisplayValue should be true");
            Assert.IsFalse(fundingStreamPeriodDeliverablesRow.ShouldDisplayVolumeAndUnitCost, "The ShouldDisplayVolumeAndUnitCost should be false");

            Assert.AreEqual(string.Empty, fundingStreamPeriodDeliverablesRow.DisplayNameOnSummaryOfFunding, "The DisplayNameOnSummaryOfFunding has not been read correctly");
            Assert.AreEqual("16-18 Apprenticeships", fundingStreamPeriodDeliverablesRow.DisplayNameOnFundingAgreement, "The DisplayNameOnFundingAgreement has not been read correctly");
            Assert.IsFalse(fundingStreamPeriodDeliverablesRow.DisplayOnSummaryOfFunding, "The DisplayOnSummaryOfFunding should be false");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodDeliverablesReader_ShouldReadInIsAllowedToBeAddedCol()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("FSP Deliverables");
            FundingStreamPeriodDeliverablesReader fundingStreamConfigReader = new FundingStreamPeriodDeliverablesReader();

            // act
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverablesItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            var fspDeliverablesItemTrue = fundingStreamPeriodDeliverablesItems.Single(fspd => fspd.FundingStreamPeriodCode == "16-18APPS1516" && fspd.DeliverableCode == 6);
            Assert.AreEqual(true, fspDeliverablesItemTrue.IsAllowedToBeAdded, "The IsAllowedToBeAdded column is not true for fsp '16-18APPS1516' deliverable '6'");

            var fspDeliverablesItemFalse = fundingStreamPeriodDeliverablesItems.Single(fspd => fspd.FundingStreamPeriodCode == "16-18APPS1516" && fspd.DeliverableCode == 5);
            Assert.AreEqual(false, fspDeliverablesItemFalse.IsAllowedToBeAdded, "The IsAllowedToBeAdded column is not false for fsp '16-18APPS1516' deliverable '5'");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodDeliverablesReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("FSP Deliverables");
            FundingStreamPeriodDeliverablesReader fundingStreamConfigReader = new FundingStreamPeriodDeliverablesReader();

            // act
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverablesItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(3558, fundingStreamPeriodDeliverablesItems.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodDeliverablesReader_Json_ShouldReadInAllowCustomDeliverableDesc()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("FSP Deliverables");
            FundingStreamPeriodDeliverablesReader fundingStreamConfigReader = new FundingStreamPeriodDeliverablesReader();

            // act
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverablesItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            // check AllowCustomDeliverableDesc
            Assert.AreEqual(false, fundingStreamPeriodDeliverablesItems.First(f => f.FundingStreamPeriodCode == "16-18APPS1516").AllowCustomDeliverableDesc, "AllowCustomDeliverableDesc not read in correctly");
            Assert.AreEqual(true, fundingStreamPeriodDeliverablesItems.First(f => f.FundingStreamPeriodCode == "ESF1420").AllowCustomDeliverableDesc, "AllowCustomDeliverableDesc not read in correctly");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodDeliverablesReader_Json_ShouldReadInCappingApportionmentPriorityOrder()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("FSP Deliverables");
            FundingStreamPeriodDeliverablesReader fundingStreamConfigReader = new FundingStreamPeriodDeliverablesReader();

            // act
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverablesItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            // check Capping Apportionment Priortiy Order
            Assert.AreEqual(1, fundingStreamPeriodDeliverablesItems.First(f => f.FundingStreamPeriodCode == "16-18APPS1516" && f.DeliverableCode == 6).CappingApportionmentPriorityOrder, "Capping Apportionment Priortiy Order not read in correctly for 16-18APPS1516 and deliverable code = 6 ");
            Assert.AreEqual(2, fundingStreamPeriodDeliverablesItems.First(f => f.FundingStreamPeriodCode == "16-18NLA1718" && f.DeliverableCode == 4).CappingApportionmentPriorityOrder, "Capping Apportionment Priortiy Order not read in correctly for 16-18NLA1718 and deliverable code = 4");
            Assert.AreEqual(null, fundingStreamPeriodDeliverablesItems.First(f => f.FundingStreamPeriodCode == "16-18NLA1718" && f.DeliverableCode == 1).CappingApportionmentPriorityOrder, "Capping Apportionment Priortiy Order not read in correctly for 16-18NLA1718 and deliverable code =1");

        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodDeliverablesReader_Json_ShouldReadInAndTranslateMandatoryCol()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("FSP Deliverables");
            FundingStreamPeriodDeliverablesReader fundingStreamConfigReader = new FundingStreamPeriodDeliverablesReader();

            // act
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverablesItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            Assert.AreEqual(true, fundingStreamPeriodDeliverablesItems.First().IsMandatory, "The Mandatory column has not read in correctly");
            Assert.AreEqual(false, fundingStreamPeriodDeliverablesItems.First(f => f.FundingStreamPeriodCode == "ESF1420").IsMandatory, "The Mandatory column has not read in correctly");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodDeliverablesReader_Json_ShouldReadDocumentDomainValues()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("FSP Deliverables");
            FundingStreamPeriodDeliverablesReader fundingStreamConfigReader = new FundingStreamPeriodDeliverablesReader();

            // act
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverablesItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            FundingStreamPeriodDeliverablesSheetType fundingStreamPeriodDeliverablesRow = fundingStreamPeriodDeliverablesItems
                                                                                            .Single(fsp => fsp.FundingStreamPeriodCode == "16-18APPS1718"
                                                                                                        && fsp.DeliverableCode == 2);

            Assert.IsTrue(fundingStreamPeriodDeliverablesRow.AllowProfile, "The allowProfile should be true");
            Assert.IsTrue(fundingStreamPeriodDeliverablesRow.DisplayOnFundingAgreement, "The DisplayOnFundingAgreement should be true");
            Assert.IsTrue(fundingStreamPeriodDeliverablesRow.MandatoryOnFundingAgreement, "The MandatoryOnFundingAgreement should be true");
            Assert.AreEqual(1, fundingStreamPeriodDeliverablesRow.DisplayOrderOnFundingAgreement, "The DisplayOrderOnFundingAgreement has not been read correctly");

            Assert.IsFalse(fundingStreamPeriodDeliverablesRow.AllowCustomDescription, "The AllowCustomDescription should be false");
            Assert.IsTrue(fundingStreamPeriodDeliverablesRow.ShouldDisplayValue, "The ShouldDisplayValue should be true");
            Assert.IsFalse(fundingStreamPeriodDeliverablesRow.ShouldDisplayVolumeAndUnitCost, "The ShouldDisplayVolumeAndUnitCost should be false");

            Assert.AreEqual(string.Empty, fundingStreamPeriodDeliverablesRow.DisplayNameOnSummaryOfFunding, "The DisplayNameOnSummaryOfFunding has not been read correctly");
            Assert.AreEqual("16-18 Apprenticeships", fundingStreamPeriodDeliverablesRow.DisplayNameOnFundingAgreement, "The DisplayNameOnFundingAgreement has not been read correctly");
            Assert.IsFalse(fundingStreamPeriodDeliverablesRow.DisplayOnSummaryOfFunding, "The DisplayOnSummaryOfFunding should be false");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodDeliverablesReader_Json_ShouldReadInIsAllowedToBeAddedCol()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("FSP Deliverables");
            FundingStreamPeriodDeliverablesReader fundingStreamConfigReader = new FundingStreamPeriodDeliverablesReader();

            // act
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverablesItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            var fspDeliverablesItemTrue = fundingStreamPeriodDeliverablesItems.Single(fspd => fspd.FundingStreamPeriodCode == "16-18APPS1516" && fspd.DeliverableCode == 6);
            Assert.AreEqual(true, fspDeliverablesItemTrue.IsAllowedToBeAdded, "The IsAllowedToBeAdded column is not true for fsp '16-18APPS1516' deliverable '6'");

            var fspDeliverablesItemFalse = fundingStreamPeriodDeliverablesItems.Single(fspd => fspd.FundingStreamPeriodCode == "16-18APPS1516" && fspd.DeliverableCode == 5);
            Assert.AreEqual(false, fspDeliverablesItemFalse.IsAllowedToBeAdded, "The IsAllowedToBeAdded column is not false for fsp '16-18APPS1516' deliverable '5'");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodSubnominalCodeCheckWithDeliverablesReader_ShouldSameAsLastYear()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("FSP Deliverables");
            FundingStreamPeriodDeliverablesReader fundingStreamConfigReader = new FundingStreamPeriodDeliverablesReader();

            // act
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverablesItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            string currentyear = DateTimeExtensions.ToFinancialYearShort(DateTime.Now);
            string previousyear = DateTimeExtensions.ToFinancialYearShort(DateTime.Now.AddYears(-1));
            var datalatest = fundingStreamPeriodDeliverablesItems.Where(x => x.FundingStreamPeriodCode.Contains(currentyear));
            var dataPreviousYear = fundingStreamPeriodDeliverablesItems.Where(x => x.FundingStreamPeriodCode.Contains(previousyear));
            List<string> incorrectValues = new List<string>();
            foreach (var latest in datalatest)
            {
                var fspCode = latest.FundingStreamPeriodCode.Replace(currentyear, previousyear);

                var previousData = dataPreviousYear.Where(x => x.FundingStreamPeriodCode == fspCode && x.DeliverableCode == latest.DeliverableCode).FirstOrDefault();

                if (previousData != null && !string.IsNullOrEmpty(latest.PaymentSubnominalCodeProfile) && latest.PaymentSubnominalCodeProfile != previousData.PaymentSubnominalCodeProfile)
                {
                    incorrectValues.Add(" FSP: " + latest.FundingStreamPeriodCode + " with deliverable code " + latest.DeliverableCode + " and Profile subnominal code : " + latest.PaymentSubnominalCodeProfile);
                }
                if (previousData != null && !string.IsNullOrEmpty(latest.PaymentSubnominalCodeReconciliation) && latest.PaymentSubnominalCodeReconciliation != previousData.PaymentSubnominalCodeReconciliation)
                {
                    incorrectValues.Add(" FSP: " + latest.FundingStreamPeriodCode + " with deliverable code " + latest.DeliverableCode + " and Reconciliation subnominal code : " + latest.PaymentSubnominalCodeReconciliation);
                }
                if (previousData != null && !string.IsNullOrEmpty(latest.PaymentSubnominalCodeCapping) && latest.PaymentSubnominalCodeCapping != previousData.PaymentSubnominalCodeCapping)
                {
                    incorrectValues.Add(" FSP: " + latest.FundingStreamPeriodCode + " with deliverable code " + latest.DeliverableCode + " and Capping subnominal code : " + latest.PaymentSubnominalCodeCapping);
                }
            }
            // assert
            Assert.AreEqual(0, incorrectValues.Count(), "Incorrect subnominal Code for " + string.Join(", ", incorrectValues));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodSubnominalCodeCheckWithDeliverablesReader_ShouldSameAsLastYear2()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("FSP Deliverables");
            FundingStreamPeriodDeliverablesReader fundingStreamConfigReader = new FundingStreamPeriodDeliverablesReader();

            // act
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverablesItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            string currentyear = DateTimeExtensions.ToFinancialYear(DateTime.Now);
            string previousyear = DateTimeExtensions.ToFinancialYear(DateTime.Now.AddYears(-1));
            var datalatest = fundingStreamPeriodDeliverablesItems.Where(x => x.FundingStreamPeriodCode.Contains(currentyear));
            var dataPreviousYear = fundingStreamPeriodDeliverablesItems.Where(x => x.FundingStreamPeriodCode.Contains(previousyear));
            List<string> incorrectValues = new List<string>();
            foreach (var latest in datalatest)
            {
                var fspCode = latest.FundingStreamPeriodCode.Replace(currentyear, previousyear);

                var previousData = dataPreviousYear.Where(x => x.FundingStreamPeriodCode == fspCode && x.DeliverableCode == latest.DeliverableCode).FirstOrDefault();

                if (previousData != null && !string.IsNullOrEmpty(latest.PaymentSubnominalCodeProfile) && latest.PaymentSubnominalCodeProfile != previousData.PaymentSubnominalCodeProfile)
                {
                    incorrectValues.Add(" FSP: " + latest.FundingStreamPeriodCode + " with deliverable code " + latest.DeliverableCode + " and Profile subnominal code : " + latest.PaymentSubnominalCodeProfile);
                }
                if (previousData != null && !string.IsNullOrEmpty(latest.PaymentSubnominalCodeReconciliation) && latest.PaymentSubnominalCodeReconciliation != previousData.PaymentSubnominalCodeReconciliation)
                {
                    incorrectValues.Add(" FSP: " + latest.FundingStreamPeriodCode + " with deliverable code " + latest.DeliverableCode + " and Reconciliation subnominal code : " + latest.PaymentSubnominalCodeReconciliation);
                }
                if (previousData != null && !string.IsNullOrEmpty(latest.PaymentSubnominalCodeCapping) && latest.PaymentSubnominalCodeCapping != previousData.PaymentSubnominalCodeCapping)
                {
                    incorrectValues.Add(" FSP: " + latest.FundingStreamPeriodCode + " with deliverable code " + latest.DeliverableCode + " and Capping subnominal code : " + latest.PaymentSubnominalCodeCapping);
                }
            }
            // assert
            Assert.AreEqual(0, incorrectValues.Count(), "Incorrect subnominal Code for " + string.Join(", ", incorrectValues));
        }

    }

    public static class DateTimeExtensions
    {
        public static string ToFinancialYear(this DateTime dateTime)
        {
            return "" + (dateTime.Month >= 4 ? dateTime.Year : dateTime.Year);
        }

        public static string ToFinancialYearShort(this DateTime dateTime)
        {
            return (dateTime.Month >= 4 ? dateTime.ToString("yy") : dateTime.ToString("yy")) + (dateTime.Month >= 4 ? dateTime.AddYears(1).ToString("yy") : dateTime.ToString("yy"));
        }
    }
}