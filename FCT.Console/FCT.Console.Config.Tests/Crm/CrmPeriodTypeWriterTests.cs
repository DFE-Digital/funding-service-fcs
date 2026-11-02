namespace FCT.Console.Config.Tests.Crm
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;   
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using Synchronizers.Writers.CRM;
    using MoreLinq;
    using Synchronizers.Writers;

    [TestClass]
    public class CrmPeriodTypeWriterTests
    {
        private const string PeriodTypeCodeTest = "test code";
        private const string PeriodTypeNameTest = "test name";
        
        [TestInitialize, TestCleanup]
        public void CleanUp()
        {
            GetPeriodTypes(PeriodTypeCodeTest).ForEach(periodType =>
                CrmHelper.GetConnection().Delete(sfa_periodtype.EntityLogicalName, periodType.Id));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmPeriodTypeWriter_ShouldInsertNewRowIntoCrmWhenRowDoesNotExist()
        {
            // arrange
            IEnumerable<PeriodTypeSheetType> rows = GetRows();

            // act
            new CrmPeriodTypeWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            IEnumerable<sfa_periodtype> periodtypes = GetPeriodTypes(PeriodTypeCodeTest);
            Assert.AreEqual(1, periodtypes.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmPeriodTypeWriter_ShouldUpdateExistingRowIntoCrmWhenRowDoesNotExist()
        {
            // arrange
            IEnumerable<PeriodTypeSheetType> rows = GetRows();
            new CrmPeriodTypeWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);
            const string updatedPeriodTypeName = "updated test";
            rows.First().PeriodTypeName = updatedPeriodTypeName;

            // act
            new CrmPeriodTypeWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            IEnumerable<sfa_periodtype> periodtypes = GetPeriodTypes(PeriodTypeCodeTest);
            Assert.AreEqual(updatedPeriodTypeName, periodtypes.First().sfa_PeriodTypeName);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmPeriodTypeWriter_ShouldDeleteRowIntoCrmWhenPolicyStatusDeleted()
        {
            // arrange
            IEnumerable<PeriodTypeSheetType> rows = GetRows();
            new CrmPeriodTypeWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);
            rows.First().PolicyStatus = PolicyStatus.Removed;
            int expectedPeriodCount = rows.Count(r => r.PolicyStatus == PolicyStatus.Approved);

            // act
            new CrmPeriodTypeWriter().WriteToCrmDatabase(rows, WriterBehaviour.Delete);

            // assert
            var actualCount = GetPeriodTypes(PeriodTypeCodeTest).Count();
            Assert.AreEqual(expectedPeriodCount, actualCount);
        }

        private IReadOnlyCollection<PeriodTypeSheetType> GetRows()
        {
            return new List<PeriodTypeSheetType>
            {
                new PeriodTypeSheetType
                {
                    PeriodTypeCode = PeriodTypeCodeTest,
                    PeriodTypeName = PeriodTypeNameTest
                }
            };
        }

        private IEnumerable<sfa_periodtype> GetPeriodTypes(string periodTypeCode)
        {
            using (var crmContext = new XrmServiceContext(Synchronizers.Writers.CRM.CrmHelper.GetConnection()))
            {
                return from pt in crmContext.sfa_periodtypeSet
                       where pt.sfa_periodtypecode == periodTypeCode
                       select pt;
            }
        }
    }
}
