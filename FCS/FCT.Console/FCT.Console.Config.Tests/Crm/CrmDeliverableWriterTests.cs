namespace FCT.Console.Config.Tests.Crm
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using Synchronizers.Writers;
    using Synchronizers.Writers.CRM;

    [TestClass]
    public class CrmDeliverableWriterTests
    {
        private readonly string _testFundingStreamCode = "AGE";
        private int _testDeliverableCode = 33;
        private string _testDeliverableName = "testDeliverableName";

        [TestInitialize, TestCleanup]
        public void CleanUp()
        {
            var fsDeliverables = GetDeliverables(_testFundingStreamCode, _testDeliverableCode);
            if (fsDeliverables.Any())
            {
                foreach (var fspDel in fsDeliverables)
                {
                    CrmHelper.GetConnection().Delete(CrmEntityName.Deliverable, fspDel.Id);
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmDeliverableWriter_ShouldInsertNewRowIntoCrmWhenRowDoesNotExist()
        {
            IEnumerable<DeliverablesSheetType> rows = GetRows();
            
            // act
            new CrmDeliverableWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            IEnumerable<sfa_deliverable> fspDeliverables = GetDeliverables(_testFundingStreamCode, _testDeliverableCode);
            Assert.AreEqual(1, fspDeliverables.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmDeliverableWriter_ShouldUpdateExistingRowInCrmWhenRowExists()
        {
            // arrange
            var updatedValue = "UpdatedValue";
            IEnumerable<DeliverablesSheetType> rows = GetRows();
            new CrmDeliverableWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            IReadOnlyCollection<DeliverablesSheetType> updateRows = GetRows();
            updateRows.ToList()[0].DeliverableName = updatedValue;

            // act
            new CrmDeliverableWriter().WriteToCrmDatabase(updateRows, WriterBehaviour.AddOrUpdate);

            // assert
            IReadOnlyCollection<sfa_deliverable> deliverables = GetDeliverables(_testFundingStreamCode, _testDeliverableCode);
            Assert.AreEqual(1, deliverables.Count, "We have inserted a row when we wanted to do an insert");
            Assert.AreEqual(updatedValue, deliverables.First().sfa_DeliverableName, "The Deliverable name has not been updated");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmDeliverableWriter_ShouldDeleteExistingRowInCrmWhenRowExistsAndPolicyStatusIsDeleted()
        {
            // arrange
            IEnumerable<DeliverablesSheetType> rows = GetRows();
            new CrmDeliverableWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            IEnumerable<DeliverablesSheetType> updateRows = GetRows();
            updateRows.ToList()[0].PolicyStatus = PolicyStatus.Removed;

            // act
            new CrmDeliverableWriter().WriteToCrmDatabase(updateRows, WriterBehaviour.Delete);

            // assert
            IEnumerable<sfa_deliverable> deliverables = GetDeliverables(_testFundingStreamCode, _testDeliverableCode);
            Assert.AreEqual(0, deliverables.Count(), "We have not deleted the row");
        }

        private sfa_fundingstream GetFundingStream(string fundingStreamCode)
        {
            using (var crmContext = new XrmServiceContext(Synchronizers.Writers.CRM.CrmHelper.GetConnection()))
            {
                var fundingStreamQuery = from fsp in crmContext.sfa_fundingstreamSet
                    where fsp.sfa_fundingstreamcode == fundingStreamCode
                    select fsp;

                return fundingStreamQuery.Single();
            }
        }

        private IReadOnlyCollection<sfa_deliverable> GetDeliverables(string fundingStreamCode, int deliverableCode)
        {
            using (var crmContext = new XrmServiceContext(Synchronizers.Writers.CRM.CrmHelper.GetConnection()))
            {
                var fsp = GetFundingStream(fundingStreamCode);

                var deliverableQuery = from d in crmContext.sfa_deliverableSet
                                         where d.sfa_FundingStreamId.Equals(fsp.ToEntityReference())
                                         && d.sfa_DeliverableCode == deliverableCode
                                         select d;

                return deliverableQuery.ToList();
            }
        }

        private IReadOnlyCollection<DeliverablesSheetType> GetRows()
        {
            // arrange
            return new List<DeliverablesSheetType>
            {
                new DeliverablesSheetType
                {
                    PolicyStatus = PolicyStatus.Approved,
                    DeliverableCode = _testDeliverableCode,
                    FundingStreamCode = _testFundingStreamCode,
                    DeliverableName = _testDeliverableName,
                    BusinessCode = string.Empty,
                    Status = "Active",
                    EffectiveDate = DateTime.Now
                }
            };
        }
    }
}
