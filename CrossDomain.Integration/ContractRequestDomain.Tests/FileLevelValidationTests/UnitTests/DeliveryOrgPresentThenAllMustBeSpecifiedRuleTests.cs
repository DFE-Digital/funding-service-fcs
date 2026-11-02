namespace ContractRequestDomain.Tests.FileLevelValidationTests.UnitTests
{
    using System;
    using System.Linq;
    using System.Xml.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using MoreLinq;

    [TestClass]
    public class DeliveryOrgPresentThenAllMustBeSpecifiedRuleTests
    {
        private DeliveryOrgPresentThenAllMustBeSpecifiedRule _validator;
        private dataLoadResults _data;

        [TestInitialize]
        public void GetData()
        {
            _validator = new DeliveryOrgPresentThenAllMustBeSpecifiedRule();
            _data = (dataLoadResults)XmlSerialization.DeserializeXml(
                XDocument.Load("Resources\\DeliverablePeriodDeliverableDescriptionData.xml").Root, typeof(dataLoadResults));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_AValidFile_WithAllNecessaryDeliveryOganisations_PassesValidation()
        {
            Assert.IsFalse(_validator.GetFailuresForItem(_data).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_AnInvalidFile_WithContractAllocationDeliveryOrganisationButNoDeliveryPeriodDeliveryOrganisations_FailsValidation()
        {
            var file = new ContractBulkUpload(_data);
            file.ContractDeliverableSheet.row
                .First(r=>r.cell.Any(cell => cell.columnName == "UKPRN" && cell.Value == "80000010"))
                .cell.First(cell => cell.columnName == "DeliveryOrganisation")
                .Value = string.Empty;
                

            var failures = _validator.GetFailuresForItem(_data);

            Assert.IsTrue(failures.Any(), "Failures were returned");
            Assert.AreEqual(2, failures.Count(), "2 failures were not returned");
            Assert.IsTrue(failures.All(f => f.Value == ErrorMessages.DeliveryOrgPresentThenAllMustBeSpecified), "Incorrect error messages returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_AnInvalidFile_WithBadContractAllocationDeliveryOrganisationButGoodDeliveryPeriodDeliveryOrganisations_FailsValidation()
        {
            var file = new ContractBulkUpload(_data);
            file.ContractAllocationSheet.row
                .First(r => r.cell.Any(cell => cell.columnName.ToUpper() == "UKPRN" && cell.Value == "80000010"))
                .cell.First(cell => cell.columnName == "DeliveryOrganisation")
                .Value = string.Empty;


            var failures = _validator.GetFailuresForItem(_data);

            Assert.IsTrue(failures.Any(), "Failures were returned");
            Assert.AreEqual(1, failures.Count(), "1 failure was not returned");
            Assert.IsTrue(failures.All(f => f.Value == ErrorMessages.DeliveryOrgPresentThenAllMustBeSpecified), "Incorrect error messages returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliveryOrgPresentThenAllMustBeSpecifiedRule_ShouldPassWhenTheDeliveryOrganisationColNotPresentInAllocationOrDeliverable()
        {
            var file = new ContractBulkUpload(_data);
            file.ContractAllocationSheet.row.ForEach(row =>
            {
                var cellsInRow = row.cell.ToList();
                cellsInRow.RemoveAll(cell => cell.columnName == "DeliveryOrganisation");

                row.cell = cellsInRow.ToArray();
            });

            file.ContractDeliverableSheet.row.ForEach(row =>
            {
                var cellsInRow = row.cell.ToList();
                cellsInRow.RemoveAll(cell => cell.columnName == "DeliveryOrganisation");

                row.cell = cellsInRow.ToArray();
            });

            bool hasException = false;
            try
            {
                var failures = _validator.GetFailuresForItem(_data);
            }
            catch (Exception)
            {
                hasException = true;
            }
            
            Assert.IsFalse(hasException);
        }

    }
}
