namespace FCT.Console.Config.Tests.Readers
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using FCT.Console.Config.Excel;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    [TestClass]
    public class ClaimReconciliationBehaviourReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationBehaviourReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Claim Reconciliation Behaviour");
            ClaimReconciliationBehaviourReader claimReconciliationBehaviourReader = new ClaimReconciliationBehaviourReader();

            // act
            IReadOnlyCollection<ClaimReconciliationBehaviourSheetType> claimReconciliationBehaviourCollectionItems = claimReconciliationBehaviourReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(82, claimReconciliationBehaviourCollectionItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationBehaviourReader_ShouldReadArbitaryClaimReconciliationBehaviourRowCorrectly()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Claim Reconciliation Behaviour");
            ClaimReconciliationBehaviourReader claimReconciliationBehaviourReader = new ClaimReconciliationBehaviourReader();

            // act
            IReadOnlyCollection<ClaimReconciliationBehaviourSheetType> claimReconciliationBehaviourCollectionItems = claimReconciliationBehaviourReader.ReadConfig(worksheetReader);

            // assert
            ClaimReconciliationBehaviourSheetType row1819YearEndAebc1819InSheet = claimReconciliationBehaviourCollectionItems.SingleOrDefault(
                                                                                    crbc => crbc.ClaimCollectionCode == "1819-Final" 
                                                                                    && crbc.ClaimReconciliationAllocationGroupCode == "AEBC1819");

            Assert.IsNotNull(row1819YearEndAebc1819InSheet, "The first row was not read correctly");
            Assert.AreEqual("1819-Final", row1819YearEndAebc1819InSheet.ClaimCollectionCode, "The Claim Collection Code was not correctly read");
            Assert.AreEqual("AEBC1819", row1819YearEndAebc1819InSheet.ClaimReconciliationAllocationGroupCode, "The Claim Reconciliation Allocation Group Code was not correctly read");
            Assert.IsTrue(row1819YearEndAebc1819InSheet.DoWeReconcileOverDelivery, "Reconcile Over-Delivery was not correctly read");
            Assert.IsTrue(row1819YearEndAebc1819InSheet.DoWeReconcileUnderDelivery, "Reconcile Under-Delivery was not correctly read");
            Assert.IsTrue(row1819YearEndAebc1819InSheet.IsReconciliationPayable, "Is Reconciliation Payable was not correctly read");
            Assert.AreEqual(0, row1819YearEndAebc1819InSheet.OverDeliveryDeMinimis, "Over-Delivery De Minimis was not correctly read");
            Assert.AreEqual(0, row1819YearEndAebc1819InSheet.UnderDeliveryDeMinimis, "Under-Delivery De Minimis was not correctly read");
            Assert.AreEqual(new DateTime(2020, 05, 31, 0, 0, 0, DateTimeKind.Utc), row1819YearEndAebc1819InSheet.PublicationCloseDate, "Publication Close Date was not correctly read");
            Assert.AreEqual(-3, row1819YearEndAebc1819InSheet.UnderDeliveryTolerancePercentage, "Under Delivery Tolerance Percentage was not correctly read");
            Assert.AreEqual(3, row1819YearEndAebc1819InSheet.OverDeliveryLimitPercentage, "Over Delivery Limit Percentage was not correctly read");
            Assert.AreEqual("F", row1819YearEndAebc1819InSheet.ClaimTypeCode, "Claim Type Code was not correctly read");
            Assert.AreEqual("AY1819", row1819YearEndAebc1819InSheet.FundingPeriod, "Funding Period was not correctly read");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationBehaviourReader_ShouldReadClaimReconciliationBehaviourWithNoOverDeliveryLimiRowCorrectly()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Claim Reconciliation Behaviour");
            ClaimReconciliationBehaviourReader claimReconciliationBehaviourReader = new ClaimReconciliationBehaviourReader();

            // act
            IReadOnlyCollection<ClaimReconciliationBehaviourSheetType> claimReconciliationBehaviourCollectionItems = claimReconciliationBehaviourReader.ReadConfig(worksheetReader);

            // assert
            ClaimReconciliationBehaviourSheetType row = claimReconciliationBehaviourCollectionItems.SingleOrDefault(
                                                                                    crbc => crbc.ClaimCollectionCode == "1819-Final"
                                                                                    && crbc.ClaimReconciliationAllocationGroupCode == "ALLBC1819");

            Assert.IsNotNull(row, "The first row was not read correctly");
            Assert.AreEqual(null, row.OverDeliveryLimitPercentage, "Over Delivery Limit Percentage was not correctly read");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationBehaviourReader_ShouldReadClaimReconciliationBehaviourUnderDeliveryRecoveryAmountRowCorrectly()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Claim Reconciliation Behaviour");
            ClaimReconciliationBehaviourReader claimReconciliationBehaviourReader = new ClaimReconciliationBehaviourReader();

            // act
            IReadOnlyCollection<ClaimReconciliationBehaviourSheetType> claimReconciliationBehaviourCollectionItems = claimReconciliationBehaviourReader.ReadConfig(worksheetReader);

            // assert
            var excessRow = claimReconciliationBehaviourCollectionItems.SingleOrDefault(
                crbc => crbc.ClaimCollectionCode == "1920-Final"
                        && crbc.ClaimReconciliationAllocationGroupCode == "ALLBC1920");

            Assert.IsNotNull(excessRow, "The ExcessRow was not read correctly");
            Assert.AreEqual(UnderDeliveryRecoveryAmount.Excess, excessRow.UnderDeliveryRecoveryAmount, "Under Delivery Recovery Amount Excess was not correctly read");

            var fullRow = claimReconciliationBehaviourCollectionItems.SingleOrDefault(
                crbc => crbc.ClaimCollectionCode == "1617-Final"
                        && crbc.ClaimReconciliationAllocationGroupCode == "AEBC1617");

            Assert.IsNotNull(fullRow, "The FullRow was not read correctly");
            Assert.AreEqual(UnderDeliveryRecoveryAmount.Full, fullRow.UnderDeliveryRecoveryAmount, "Under Delivery Recovery Amount Full was not correctly read");
        }


        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationBehaviourReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Claim Reconciliation Behaviour");
            ClaimReconciliationBehaviourReader claimReconciliationBehaviourReader = new ClaimReconciliationBehaviourReader();

            // act
            IReadOnlyCollection<ClaimReconciliationBehaviourSheetType> claimReconciliationBehaviourCollectionItems = claimReconciliationBehaviourReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(82, claimReconciliationBehaviourCollectionItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationBehaviourReader_Json_ShouldReadArbitaryClaimReconciliationBehaviourRowCorrectly()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Claim Reconciliation Behaviour");
            ClaimReconciliationBehaviourReader claimReconciliationBehaviourReader = new ClaimReconciliationBehaviourReader();

            // act
            IReadOnlyCollection<ClaimReconciliationBehaviourSheetType> claimReconciliationBehaviourCollectionItems = claimReconciliationBehaviourReader.ReadConfig(worksheetReader);

            // assert
            ClaimReconciliationBehaviourSheetType row1819YearEndAebc1819InSheet = claimReconciliationBehaviourCollectionItems.SingleOrDefault(
                                                                                    crbc => crbc.ClaimCollectionCode == "1819-Final"
                                                                                    && crbc.ClaimReconciliationAllocationGroupCode == "AEBC1819");

            Assert.IsNotNull(row1819YearEndAebc1819InSheet, "The first row was not read correctly");
            Assert.AreEqual("1819-Final", row1819YearEndAebc1819InSheet.ClaimCollectionCode, "The Claim Collection Code was not correctly read");
            Assert.AreEqual("AEBC1819", row1819YearEndAebc1819InSheet.ClaimReconciliationAllocationGroupCode, "The Claim Reconciliation Allocation Group Code was not correctly read");
            Assert.IsTrue(row1819YearEndAebc1819InSheet.DoWeReconcileOverDelivery, "Reconcile Over-Delivery was not correctly read");
            Assert.IsTrue(row1819YearEndAebc1819InSheet.DoWeReconcileUnderDelivery, "Reconcile Under-Delivery was not correctly read");
            Assert.IsTrue(row1819YearEndAebc1819InSheet.IsReconciliationPayable, "Is Reconciliation Payable was not correctly read");
            Assert.AreEqual(0, row1819YearEndAebc1819InSheet.OverDeliveryDeMinimis, "Over-Delivery De Minimis was not correctly read");
            Assert.AreEqual(0, row1819YearEndAebc1819InSheet.UnderDeliveryDeMinimis, "Under-Delivery De Minimis was not correctly read");
            Assert.AreEqual(new DateTime(2020, 05, 31, 0, 0, 0, DateTimeKind.Utc), row1819YearEndAebc1819InSheet.PublicationCloseDate, "Publication Close Date was not correctly read");
            Assert.AreEqual(-3, row1819YearEndAebc1819InSheet.UnderDeliveryTolerancePercentage, "Under Delivery Tolerance Percentage was not correctly read");
            Assert.AreEqual(3, row1819YearEndAebc1819InSheet.OverDeliveryLimitPercentage, "Over Delivery Limit Percentage was not correctly read");
            Assert.AreEqual("F", row1819YearEndAebc1819InSheet.ClaimTypeCode, "Claim Type Code was not correctly read");
            Assert.AreEqual("AY1819", row1819YearEndAebc1819InSheet.FundingPeriod, "Funding Period was not correctly read");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationBehaviourReader_Json_ShouldReadClaimReconciliationBehaviourWithNoOverDeliveryLimitRowCorrectly()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Claim Reconciliation Behaviour");
            ClaimReconciliationBehaviourReader claimReconciliationBehaviourReader = new ClaimReconciliationBehaviourReader();

            // act
            IReadOnlyCollection<ClaimReconciliationBehaviourSheetType> claimReconciliationBehaviourCollectionItems = claimReconciliationBehaviourReader.ReadConfig(worksheetReader);

            // assert
            ClaimReconciliationBehaviourSheetType row = claimReconciliationBehaviourCollectionItems.SingleOrDefault(
                                                                                    crbc => crbc.ClaimCollectionCode == "1819-Final"
                                                                                    && crbc.ClaimReconciliationAllocationGroupCode == "ALLBC1819");

            Assert.IsNotNull(row, "The first row was not read correctly");
            Assert.AreEqual(null, row.OverDeliveryLimitPercentage, "Over Delivery Limit Percentage was not correctly read");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationBehaviourReader_Json_ShouldReadClaimReconciliationBehaviourUnderDeliveryRecoveryAmountRowCorrectly()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Claim Reconciliation Behaviour");
            ClaimReconciliationBehaviourReader claimReconciliationBehaviourReader = new ClaimReconciliationBehaviourReader();

            // act
            IReadOnlyCollection<ClaimReconciliationBehaviourSheetType> claimReconciliationBehaviourCollectionItems = claimReconciliationBehaviourReader.ReadConfig(worksheetReader);

            // assert
            var excessRow = claimReconciliationBehaviourCollectionItems.SingleOrDefault(
                crbc => crbc.ClaimCollectionCode == "1920-Final"
                        && crbc.ClaimReconciliationAllocationGroupCode == "ALLBC1920");

            Assert.IsNotNull(excessRow, "The ExcessRow was not read correctly");
            Assert.AreEqual(UnderDeliveryRecoveryAmount.Excess, excessRow.UnderDeliveryRecoveryAmount, "Under Delivery Recovery Amount Excess was not correctly read");

            var fullRow = claimReconciliationBehaviourCollectionItems.SingleOrDefault(
                crbc => crbc.ClaimCollectionCode == "1617-Final"
                        && crbc.ClaimReconciliationAllocationGroupCode == "AEBC1617");

            Assert.IsNotNull(fullRow, "The FullRow was not read correctly");
            Assert.AreEqual(UnderDeliveryRecoveryAmount.Full, fullRow.UnderDeliveryRecoveryAmount, "Under Delivery Recovery Amount Full was not correctly read");

        }
    }
}
