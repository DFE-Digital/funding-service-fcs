namespace ContractRequestDomain.Tests.FileLevelValidationTests.UnitTests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Xml.Linq;
    using Castle.Core.Internal;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;

    [TestClass]
    // DBR-008
    public class DeliverableCRMIntentValidationRuleTests
    {
        private DeliverablePeriodCrmIntentMustMatch _rule;
        private dataLoadResults _data;

        [TestInitialize]
        public void GetData()
        {
            _rule = new DeliverablePeriodCrmIntentMustMatch();
            _data = (dataLoadResults)XmlSerialization.DeserializeXml(XDocument.Load("Resources\\DeliverablePeriodCrmIntentData.xml").Root, typeof(dataLoadResults));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_AValidFile_PassesValidation()
        {
            Assert.IsFalse(_rule.GetFailuresForItem(_data).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_AnInvalidFile_FailsValidation()
        {
            ContractBulkUpload file = new ContractBulkUpload(_data);

            file.ContractDeliverableSheet.row.First()
                .cell.First(c => c.columnName == ContractBulkUpload.CrmIntent)
                .Value = "Invalid";

            Assert.IsTrue(_rule.GetFailuresForItem(_data).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePeriodCrmIntentMustMatch_ShouldNotReturnErrorsWhenIntentIsTheSameForDeliverablesOnTheSameAllocation()
        {
            ContractBulkUpload file = new ContractBulkUpload(_data);

            const string ukprn = "1";
            file.ContractDeliverableSheet.row.ToList().ForEach(
             r =>
                 r.cell.First(c => c.columnName == ContractBulkUpload.DeliveryOrganisation).Value =
                     ukprn);

            // change the first row to have a different intent and different delivery org
            var firstRow = file.ContractDeliverableSheet.row.First();

            firstRow.cell.First(c => c.columnName == ContractBulkUpload.CrmIntent)
             .Value = "Update Draft";

            const string otherUkprn = "2";
            firstRow.cell.First(c => c.columnName == ContractBulkUpload.DeliveryOrganisation)
             .Value = otherUkprn;

            List<errorInfo> failures = _rule.GetFailuresForItem(_data);

            Assert.IsTrue(!failures.Any(), "We have failures - " + string.Join(Environment.NewLine, failures.Select(e => e.Value).Distinct()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePeriodCrmIntentMustMatch_ShouldReturnErrorsWhenIntentIsNotTheSameForDeliverablesOnTheSameAllocation()
        {
            ContractBulkUpload file = new ContractBulkUpload(_data);

            file.ContractDeliverableSheet.row.First()
             .cell.First(c => c.columnName == ContractBulkUpload.CrmIntent)
             .Value = "Update Draft";

            const string ukprn = "1";

            file.ContractDeliverableSheet.row.ToList().ForEach(
                r =>
                    r.cell.First(c => c.columnName == ContractBulkUpload.DeliveryOrganisation).Value =
                        ukprn);     

            var failures = _rule.GetFailuresForItem(_data);

            Assert.IsTrue(failures.Any(), "We do not have any failures");
        }
    }
}
