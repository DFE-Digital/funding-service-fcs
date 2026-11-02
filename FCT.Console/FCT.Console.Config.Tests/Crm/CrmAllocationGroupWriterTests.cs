namespace FCT.Console.Config.Tests.Crm
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using Synchronizers.Writers;
    using Synchronizers.Writers.CRM;

    [TestClass]
    public class CrmAllocationGroupWriterTests
    {
        private IEnumerable<ClaimReconciliationAllocationGroupSheetType> _testAllocationGroups = new List<ClaimReconciliationAllocationGroupSheetType>()
        {
            new ClaimReconciliationAllocationGroupSheetType()
            {
                ClaimReconciliationAllocationGroupCode = "CODE",
                GroupName = "TEST_ALLOCATIONGROUPNAME",
                PolicyStatus = PolicyStatus.Approved
            }
        };
        
        [TestInitialize, TestCleanup]
        public void CleanUp()
        {
            var claimTypes = GetAllocationGroups(_testAllocationGroups.First().ClaimReconciliationAllocationGroupCode);
            if (claimTypes.Any())
            {
                foreach (var claimType in claimTypes)
                {
                    CrmHelper.GetConnection().Delete(CrmEntityName.ClaimReconAllocGroup, claimType.Id);
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmAllocationGroupWriter_ShouldInsertNewRowIntoCrmWhenRowDoesNotExist()
        {
            // act
            new CrmAllocationGroupWriter().WriteToCrmDatabase(_testAllocationGroups, WriterBehaviour.AddOrUpdate);

            // assert
            IEnumerable<sfa_claimreconallocgroup> claimAllocReconGroups = GetAllocationGroups(_testAllocationGroups.First().ClaimReconciliationAllocationGroupCode);
            Assert.AreEqual(1, claimAllocReconGroups.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmAllocationGroupWriter_ShouldUpdateExistingRowInCrmWhenRowExists()
        {
            // arrange
            var updatedValue = "UpdatedValue";
            new CrmAllocationGroupWriter().WriteToCrmDatabase(_testAllocationGroups, WriterBehaviour.AddOrUpdate);

            _testAllocationGroups.First().GroupName = updatedValue;

            // act
            new CrmAllocationGroupWriter().WriteToCrmDatabase(_testAllocationGroups, WriterBehaviour.AddOrUpdate);

            // assert
            IReadOnlyCollection<sfa_claimreconallocgroup> claimReconAllocGroups = GetAllocationGroups(_testAllocationGroups.First().ClaimReconciliationAllocationGroupCode);
            Assert.AreEqual(1, claimReconAllocGroups.Count, "We have inserted a row when we wanted to do an insert");
            Assert.AreEqual(updatedValue, claimReconAllocGroups.First().sfa_name, "The claim recon alloc group name has not been updated");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmAllocationGroupWriter_ShouldDeleteExistingRowInCrmWhenRowExistsAndPolicyStatusIsDeleted()
        {
            // arrange
            new CrmAllocationGroupWriter().WriteToCrmDatabase(_testAllocationGroups, WriterBehaviour.AddOrUpdate);

            _testAllocationGroups.First().PolicyStatus = PolicyStatus.Removed;

            // act
            new CrmAllocationGroupWriter().WriteToCrmDatabase(_testAllocationGroups, WriterBehaviour.Delete);

            // assert
            IEnumerable<sfa_claimreconallocgroup> claimReconAllocGroups = GetAllocationGroups(_testAllocationGroups.First().ClaimReconciliationAllocationGroupCode);
            Assert.AreEqual(0, claimReconAllocGroups.Count(), "We have not deleted the row");
        }

        private IReadOnlyCollection<sfa_claimreconallocgroup> GetAllocationGroups(string allocationGroupCode)
        {
            using (var crmContext = new XrmServiceContext(Synchronizers.Writers.CRM.CrmHelper.GetConnection()))
            {
                return (from ct in crmContext.sfa_claimreconallocgroupSet
                                     where ct.sfa_AllocationGroupCode == allocationGroupCode
                                     select ct).ToList();
            }
        }
    }
}
