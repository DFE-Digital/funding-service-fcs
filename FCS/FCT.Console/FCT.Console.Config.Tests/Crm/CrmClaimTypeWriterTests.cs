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
    public class CrmClaimTypeWriterTests
    {
        private readonly string _testClaimCode = "CODE";
        private string _testClaimTypeName = "TEST_CLAIMTYPENAME";
        
        [TestInitialize, TestCleanup]
        public void CleanUp()
        {
            var claimTypes = GetClaimTypes(_testClaimCode);
            if (claimTypes.Any())
            {
                foreach (var claimType in claimTypes)
                {
                    CrmHelper.GetConnection().Delete(CrmEntityName.ClaimType, claimType.Id);
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmClaimTypeWriter_ShouldInsertNewRowIntoCrmWhenRowDoesNotExist()
        {
            IEnumerable<ClaimTypeSheetType> rows = GetRows();
            
            // act
            new CrmClaimTypeWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            IEnumerable<sfa_claimtype> claimTypes = GetClaimTypes(_testClaimCode);
            Assert.AreEqual(1, claimTypes.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmClaimTypeWriter_ShouldUpdateExistingRowInCrmWhenRowExists()
        {
            // arrange
            var updatedValue = "UpdatedValue";
            IEnumerable<ClaimTypeSheetType> rows = GetRows();
            new CrmClaimTypeWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            IReadOnlyCollection<ClaimTypeSheetType> updateRows = GetRows();
            updateRows.ToList()[0].Name = updatedValue;

            // act
            new CrmClaimTypeWriter().WriteToCrmDatabase(updateRows, WriterBehaviour.AddOrUpdate);

            // assert
            IReadOnlyCollection<sfa_claimtype> claimTypes = GetClaimTypes(_testClaimCode);
            Assert.AreEqual(1, claimTypes.Count, "We have inserted a row when we wanted to do an update");
            Assert.AreEqual(updatedValue, claimTypes.First().sfa_name, "The Claim Type name has not been updated");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmClaimTypeWriter_ShouldDeleteExistingRowInCrmWhenRowExistsAndPolicyStatusIsDeleted()
        {
            // arrange
            IEnumerable<ClaimTypeSheetType> rows = GetRows();
            new CrmClaimTypeWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            IEnumerable<ClaimTypeSheetType> updateRows = GetRows();
            updateRows.ToList()[0].PolicyStatus = PolicyStatus.Removed;

            // act
            new CrmClaimTypeWriter().WriteToCrmDatabase(updateRows, WriterBehaviour.Delete);

            // assert
            IEnumerable<sfa_claimtype> claimTypes = GetClaimTypes(_testClaimCode);
            Assert.AreEqual(0, claimTypes.Count(), "We have not deleted the row");
        }

        private IReadOnlyCollection<sfa_claimtype> GetClaimTypes(string claimTypeCode)
        {
            using (var crmContext = new XrmServiceContext(Synchronizers.Writers.CRM.CrmHelper.GetConnection()))
            {
                var claimTypeQuery = from ct in crmContext.sfa_claimtypeSet
                                         where ct.sfa_ClaimTypeCode == claimTypeCode
                                         select ct;
                return claimTypeQuery.ToList();
            }
        }

        private IReadOnlyCollection<ClaimTypeSheetType> GetRows()
        {
            // arrange
            return new List<ClaimTypeSheetType>
            {
                new ClaimTypeSheetType
                {
                    ClaimTypeCode = _testClaimCode,
                    Name = _testClaimTypeName,
                    PolicyStatus = PolicyStatus.Approved
                }
            };
        }
    }
}
