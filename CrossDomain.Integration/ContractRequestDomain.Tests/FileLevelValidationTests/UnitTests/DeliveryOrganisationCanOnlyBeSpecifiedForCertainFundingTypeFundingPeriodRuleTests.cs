namespace ContractRequestDomain.Tests.FileLevelValidationTests.UnitTests
{
    using System.Collections.Generic;
    using System.Linq;
    using global::UnitTests.Common;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;

    [TestClass]
    public class DeliveryOrganisationCanOnlyBeSpecifiedForCertainFundingTypeFundingPeriodRuleTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DeliveryOrganisationCanOnlyBeSpecifiedForCertainFundingTypeFundingPeriodRule_ShouldNotReturnErrorsWhenDeliveryOrganisationColumnsNotPresentAndFundingTypeFundingPeriodDoesNotAllowDeliveryOrganisations()
        {
            // arrange
            dataLoadResults dataLoadResults = GetDataLoadResults();
            DeliveryOrganisationCanOnlyBeSpecifiedForCertainFundingTypeFundingPeriodRule rule = new DeliveryOrganisationCanOnlyBeSpecifiedForCertainFundingTypeFundingPeriodRule(
                isAllowedToHaveDeliveryOrganisation: false, fundingPeriod: "FP1", fundingTypeCode: "FT1");

            // act
            var errors = rule.GetFailuresForItem(dataLoadResults);

            // assert
            Assert.AreEqual(0, errors.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliveryOrganisationCanOnlyBeSpecifiedForCertainFundingTypeFundingPeriodRule_ShouldNotReturnErrorsWhenDeliveryOrganisationColumnsNotPresentAndFundingTypeFundingPeriodAllowsDeliveryOrganisations()
        {
            // arrange
            dataLoadResults dataLoadResults = GetDataLoadResults();
            DeliveryOrganisationCanOnlyBeSpecifiedForCertainFundingTypeFundingPeriodRule rule = new DeliveryOrganisationCanOnlyBeSpecifiedForCertainFundingTypeFundingPeriodRule(
                isAllowedToHaveDeliveryOrganisation:true, fundingPeriod:"FP1", fundingTypeCode: "FT1");

            // act
            var errors = rule.GetFailuresForItem(dataLoadResults);

            // assert
            Assert.AreEqual(0, errors.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliveryOrganisationCanOnlyBeSpecifiedForCertainFundingTypeFundingPeriodRule_ShouldReturnErrorsWhenDeliveryOrganisationColumnPresentWithValuesOnAllocationSheetAndFundingTypeFundingPeriodDoesNotAllowDeliveryOrganisations()
        {
            // arrange
            dataLoadResults dataLoadResults = GetDataLoadResults();
            ContractBulkUpload file = new ContractBulkUpload(dataLoadResults);
            List<cellType> cellsForRow = file.ContractAllocationSheet.row[0].cell.ToList();
            cellsForRow.Add(new cellType
            {
                columnName = ContractBulkUpload.DeliveryOrganisation,
                Value = "DELIVERYORG"
            });
            file.ContractAllocationSheet.row[0].cell = cellsForRow.ToArray();

            DeliveryOrganisationCanOnlyBeSpecifiedForCertainFundingTypeFundingPeriodRule rule = new DeliveryOrganisationCanOnlyBeSpecifiedForCertainFundingTypeFundingPeriodRule(
                isAllowedToHaveDeliveryOrganisation: false, fundingPeriod: "FP1", fundingTypeCode: "FT1");

            // act
            var errors = rule.GetFailuresForItem(dataLoadResults);

            // assert
            Assert.AreEqual(1, errors.Count, "The number of errors is incorrect");
            Assert.AreEqual(ContractBulkUpload.ContractAllocationSheetFieldName, errors[0].sheet, "The sheet name specified is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliveryOrganisationCanOnlyBeSpecifiedForCertainFundingTypeFundingPeriodRule_ShouldNotReturnErrorsWhenDeliveryOrganisationColumnPresentWithoutValuesOnAllocationSheetAndFundingTypeFundingPeriodDoesNotAllowDeliveryOrganisations()
        {
            // arrange
            dataLoadResults dataLoadResults = GetDataLoadResults();
            ContractBulkUpload file = new ContractBulkUpload(dataLoadResults);
            List<cellType> cellsForRow = file.ContractAllocationSheet.row[0].cell.ToList();
            cellsForRow.Add(new cellType
            {
                columnName = ContractBulkUpload.DeliveryOrganisation,
            });
            file.ContractAllocationSheet.row[0].cell = cellsForRow.ToArray();

            DeliveryOrganisationCanOnlyBeSpecifiedForCertainFundingTypeFundingPeriodRule rule = new DeliveryOrganisationCanOnlyBeSpecifiedForCertainFundingTypeFundingPeriodRule(
                isAllowedToHaveDeliveryOrganisation: false, fundingPeriod: "FP1", fundingTypeCode: "FT1");

            // act
            var errors = rule.GetFailuresForItem(dataLoadResults);

            // assert
            Assert.AreEqual(0, errors.Count, "The number of errors is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliveryOrganisationCanOnlyBeSpecifiedForCertainFundingTypeFundingPeriodRule_ShouldReturnErrorsWhenDeliveryOrganisationColumnPresentWithValuesOnDeliverableSheetAndFundingTypeFundingPeriodDoesNotAllowDeliveryOrganisations()
        {
            // arrange
            dataLoadResults dataLoadResults = GetDataLoadResults();
            ContractBulkUpload file = new ContractBulkUpload(dataLoadResults);
            List<cellType> cellsForRow = file.ContractDeliverableSheet.row[0].cell.ToList();
            cellsForRow.Add(new cellType
            {
                columnName = ContractBulkUpload.DeliveryOrganisation,
                Value = "DELIVERYORG"
            });
            file.ContractDeliverableSheet.row[0].cell = cellsForRow.ToArray();

            DeliveryOrganisationCanOnlyBeSpecifiedForCertainFundingTypeFundingPeriodRule rule = new DeliveryOrganisationCanOnlyBeSpecifiedForCertainFundingTypeFundingPeriodRule(
                isAllowedToHaveDeliveryOrganisation: false, fundingPeriod: "FP1", fundingTypeCode: "FT1");

            // act
            var errors = rule.GetFailuresForItem(dataLoadResults);

            // assert
            Assert.AreEqual(1, errors.Count, "The number of errors is incorrect");
            Assert.AreEqual(ContractBulkUpload.ContractDeliverableSheetFieldName, errors[0].sheet, "The sheet name specified is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliveryOrganisationCanOnlyBeSpecifiedForCertainFundingTypeFundingPeriodRule_ShouldNotReturnErrorsWhenDeliveryOrganisationColumnPresentWithoutValuesOnDeliverableSheetAndFundingTypeFundingPeriodDoesNotAllowDeliveryOrganisations()
        {
            // arrange
            dataLoadResults dataLoadResults = GetDataLoadResults();
            ContractBulkUpload file = new ContractBulkUpload(dataLoadResults);
            List<cellType> cellsForRow = file.ContractDeliverableSheet.row[0].cell.ToList();
            cellsForRow.Add(new cellType
            {
                columnName = ContractBulkUpload.DeliveryOrganisation,
            });
            file.ContractDeliverableSheet.row[0].cell = cellsForRow.ToArray();

            DeliveryOrganisationCanOnlyBeSpecifiedForCertainFundingTypeFundingPeriodRule rule = new DeliveryOrganisationCanOnlyBeSpecifiedForCertainFundingTypeFundingPeriodRule(
                isAllowedToHaveDeliveryOrganisation: false, fundingPeriod: "FP1", fundingTypeCode: "FT1");

            // act
            var errors = rule.GetFailuresForItem(dataLoadResults);

            // assert
            Assert.AreEqual(0, errors.Count, "The number of errors is incorrect");
        }

        private static dataLoadResults GetDataLoadResults()
        {
            using (TestResource resource = new TestResource("ContractRequestDomain.Tests", @"Resources.MAIN AY 1516 04022016141822 v2_10017455.xlsx"))
            {
                return new ExcelFileParser().ReadFile(resource.Stream, "TestFile.xlsx");
            }
        }
    }
}
