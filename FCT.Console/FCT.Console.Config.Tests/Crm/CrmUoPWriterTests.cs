namespace FCT.Console.Config.Tests.Crm
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using Synchronizers.Writers;
    using Synchronizers.Writers.CRM;

    [TestClass]
    public class CrmUoPWriterTests
    {
        private const string ProcurementTest = "test procurement";
        private const string UopCodeTest = "test code";
        private const string UopNameTest = "test name";

        [TestInitialize, TestCleanup]
        public void Cleanup()
        {
            GetUnitsOfProcurement(UopCodeTest).ForEach(uop =>
                CrmHelper.GetConnection().Delete(sfa_unitofprocurement.EntityLogicalName, uop.Id));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmUoPWriter_ShouldInsertNewRowIntoCrmWhenRowDoesNotExist()
        {
            // arrage
            IEnumerable<UnitsOfProcurementSheetType> rows = GetRows();

            // act
            new CrmUoPWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            IEnumerable<sfa_unitofprocurement> uops = GetUnitsOfProcurement(UopCodeTest);
            Assert.AreEqual(1, uops.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmUopWriter_ShouldUpdateExistingRowInCrmWhenRowExists()
        {
            // arrage
            IEnumerable<UnitsOfProcurementSheetType> rows = GetRows();
            new CrmUoPWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);
            const string updatedUopName = "updated test";
            rows.First().UoPName = updatedUopName;

            // act
            new CrmUoPWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            IEnumerable<sfa_unitofprocurement> uops = GetUnitsOfProcurement(UopCodeTest);
            Assert.AreEqual(updatedUopName, uops.First().sfa_name);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmUopWriter_ShouldDeleteRowInCrmWhenPolicyStatusIsDeleted()
        {
            // arrage
            IEnumerable<UnitsOfProcurementSheetType> rows = GetRows();
            new CrmUoPWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);
            rows.First().PolicyStatus = PolicyStatus.Removed;
            int expectedCount = rows.Count(r => r.PolicyStatus == PolicyStatus.Approved);

            // act
            new CrmUoPWriter().WriteToCrmDatabase(rows, WriterBehaviour.Delete);

            // assert
            IEnumerable<sfa_unitofprocurement> uops = GetUnitsOfProcurement(UopCodeTest);
            Assert.AreEqual(expectedCount, uops.Count());
        }

        private IReadOnlyCollection<UnitsOfProcurementSheetType> GetRows()
        {
            return new List<UnitsOfProcurementSheetType>
            {
                new UnitsOfProcurementSheetType
                {
                    Procurement = ProcurementTest,
                    UoPName = UopNameTest,
                    UoPCode = UopCodeTest
                }
            };
        }

        private IEnumerable<sfa_unitofprocurement> GetUnitsOfProcurement(string uopCode)
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                return from u in crmContext.sfa_unitofprocurementSet
                       where u.sfa_UoPCode == uopCode
                       select u;
            }
        }
    }
}