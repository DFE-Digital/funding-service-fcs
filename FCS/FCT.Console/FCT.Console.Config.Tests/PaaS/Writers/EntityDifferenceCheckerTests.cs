namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class EntityDifferenceCheckerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void EntityDifferenceChecker_AreThereDifferences_ShouldReturnFalseWhenThereAreNoDifferences()
        {
            // arrange
            List<PolicyDeliverable> dbRows = new List<PolicyDeliverable>
            {
                new PolicyDeliverable {DeliverableCode = 2, FundingStreamPeriod = "FSP1", IsPayable = true, ParentDeliverableCode = 1},
                new PolicyDeliverable {DeliverableCode = 3, FundingStreamPeriod = "FSP1", IsPayable = true, ParentDeliverableCode = 1}
            };

            List<FundingStreamPeriodDeliverablesSheetType> sheetRows = new List<FundingStreamPeriodDeliverablesSheetType>
            {
                new FundingStreamPeriodDeliverablesSheetType {DeliverableCode = 2, FundingStreamPeriodCode = "FSP1", IsPayable = true, ParentDeliverableCode = 1},
                new FundingStreamPeriodDeliverablesSheetType {DeliverableCode = 3, FundingStreamPeriodCode = "FSP1", IsPayable = true, ParentDeliverableCode = 1},
            };

            // act
            var assertResponse = EntityDifferenceChecker.AreThereDifferences(dbRows, sheetRows, IsRowDifferent, IsMatch);

            // assert
            Assert.IsFalse(assertResponse, "AreThereDifferences method did not return false when DB rows and sheet rows are the same");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EntityDifferenceChecker_AreThereDifferences_ShouldReturnTrueWhenThereAreDifferences()
        {
            // arrange
            List<PolicyDeliverable> dbRows = new List<PolicyDeliverable>
            {
                new PolicyDeliverable {DeliverableCode = 2, FundingStreamPeriod = "FSP1", IsPayable = false, ParentDeliverableCode = 1},
                new PolicyDeliverable {DeliverableCode = 3, FundingStreamPeriod = "FSP1", IsPayable = true, ParentDeliverableCode = 1}
            };

            List<FundingStreamPeriodDeliverablesSheetType> sheetRows = new List<FundingStreamPeriodDeliverablesSheetType>
            {
                new FundingStreamPeriodDeliverablesSheetType {DeliverableCode = 2, FundingStreamPeriodCode = "FSP1", IsPayable = true, ParentDeliverableCode = 1},
                new FundingStreamPeriodDeliverablesSheetType {DeliverableCode = 3, FundingStreamPeriodCode = "FSP1", IsPayable = true, ParentDeliverableCode = 1},
            };

            // act
            var assertResponse = EntityDifferenceChecker.AreThereDifferences(dbRows, sheetRows, IsRowDifferent, IsMatch);

            // assert
            Assert.IsTrue(assertResponse, "AreThereDifferences method did not return true when there are differences between DB rows and sheet rows");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EntityDifferenceChecker_AreThereDifferences_ShouldReturnTrueWhenOnlySheetRowsExists()
        {
            // arrange
            List<PolicyDeliverable> dbRows = new List<PolicyDeliverable>();

            List<FundingStreamPeriodDeliverablesSheetType> sheetRows = new List<FundingStreamPeriodDeliverablesSheetType>
            {
                new FundingStreamPeriodDeliverablesSheetType {DeliverableCode = 2, FundingStreamPeriodCode = "FSP1", IsPayable = true, ParentDeliverableCode = 1},
                new FundingStreamPeriodDeliverablesSheetType {DeliverableCode = 3, FundingStreamPeriodCode = "FSP1", IsPayable = true, ParentDeliverableCode = 1},
            };

            // act
            var assertResponse = EntityDifferenceChecker.AreThereDifferences(dbRows, sheetRows, IsRowDifferent, IsMatch);

            // assert
            Assert.IsTrue(assertResponse, "AreThereDifferences method did not return true when there are no DB rows");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EntityDifferenceChecker_AreThereDifferences_ShouldReturnTrueWhenOnlyDbRowsExists()
        {
            // arrange
            List<PolicyDeliverable> dbRows = new List<PolicyDeliverable>
            {
                new PolicyDeliverable {DeliverableCode = 2, FundingStreamPeriod = "FSP1", IsPayable = true, ParentDeliverableCode = 1},
                new PolicyDeliverable {DeliverableCode = 3, FundingStreamPeriod = "FSP1", IsPayable = true, ParentDeliverableCode = 1}
            };

            List<FundingStreamPeriodDeliverablesSheetType> sheetRows = new List<FundingStreamPeriodDeliverablesSheetType>();

            // act
            var assertResponse = EntityDifferenceChecker.AreThereDifferences(dbRows, sheetRows, IsRowDifferent, IsMatch);

            // assert
            Assert.IsFalse(assertResponse, "AreThereDifferences method did not return false when there are no sheet rows");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EntityDifferenceChecker_AreThereDifferences_ShouldReturnFalseWhenNoRowsExistsInBothLists()
        {
            // arrange
            List<PolicyDeliverable> dbRows = new List<PolicyDeliverable>();

            List<FundingStreamPeriodDeliverablesSheetType> sheetRows = new List<FundingStreamPeriodDeliverablesSheetType>();

            // act
            var assertResponse = EntityDifferenceChecker.AreThereDifferences(dbRows, sheetRows, IsRowDifferent, IsMatch);

            // assert
            Assert.IsFalse(assertResponse, "AreThereDifferences method did not return true when there are no DB rows or sheet rows");
        }

        private static bool IsRowDifferent(PolicyDeliverable dbRow, FundingStreamPeriodDeliverablesSheetType sheetRow)
        {
            if (dbRow == null) return true;

            bool isEqual = dbRow.IsPayable == sheetRow?.IsPayable && 
                           dbRow.ParentDeliverableCode == sheetRow.ParentDeliverableCode;
            return !isEqual;
        }

        private static bool IsMatch(PolicyDeliverable dbRow, FundingStreamPeriodDeliverablesSheetType sheetRow)
        {
            return
                dbRow.DeliverableCode == sheetRow.DeliverableCode &&
                dbRow.FundingStreamPeriod == sheetRow.FundingStreamPeriodCode;
        }
    }
}