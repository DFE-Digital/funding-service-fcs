namespace FCT.Console.Config.Tests.Crm
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using Synchronizers.Writers;
    using Synchronizers.Writers.CRM;

    [TestClass]
    public class CrmClaimReconciliationBehaviourWriterTests
    {
        private const string ClaimCollectionCode = "2021-Final";
        private const string AllocationGroupCode = "ALLOCG2021";

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmClaimReconciliationBehaviourWriter_ShouldInsertNewRowIntoCrmWhenRowDoesNotExist()
        {
            // arrange 
            Cleanup();
            SetUpData();
            DateTime closeDate = new DateTime(2020, 1, 1);
            
            // act
            new CrmClaimReconciliationBehaviourWriter().WriteToCrmDatabase(
                GetSheets(PolicyStatus.Approved, closeDate), WriterBehaviour.AddOrUpdate);

            // assert
            var inserted = GetCrmEntities();
            Assert.AreEqual(1, inserted.Count);
            Assert.AreEqual(closeDate, inserted.First().sfa_publicationclosedate);

            Cleanup();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmClaimReconciliationBehaviourWriter_ShouldUpdateExistingRowIntoCrmWhenRowDoesExist()
        {
            // arrange 
            Cleanup();
            SetUpData();
            DateTime closeDate = new DateTime(2020, 1, 1);

            var rows = GetSheets(PolicyStatus.Approved, closeDate);

            new CrmClaimReconciliationBehaviourWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            DateTime newCloseDate = new DateTime(2019, 2, 2);
            rows.ForEach(r => r.PublicationCloseDate = newCloseDate);

            // act
            new CrmClaimReconciliationBehaviourWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            var inserted = GetCrmEntities();
            Assert.AreEqual(1, inserted.Count);
            Assert.AreEqual(newCloseDate, inserted.First().sfa_publicationclosedate);

            Cleanup();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmClaimReconciliationBehaviourWriter_ShouldDeleteRowFromCrmWhenRowExistsAndPolicyStatusIsDeleted()
        {
            // arrange 
            Cleanup();
            SetUpData();
            DateTime closeDate = new DateTime(2020, 1, 1);

            var rows = GetSheets(PolicyStatus.Approved, closeDate);

            new CrmClaimReconciliationBehaviourWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            rows.ForEach(r => r.PolicyStatus = PolicyStatus.Removed);

            // act
            new CrmClaimReconciliationBehaviourWriter().WriteToCrmDatabase(rows, WriterBehaviour.Delete);

            // assert
            var crmRecords = GetCrmEntities();
            Assert.AreEqual(0, crmRecords.Count);

            Cleanup();
        }

        private IReadOnlyCollection<ClaimReconciliationBehaviourSheetType> GetSheets(PolicyStatus policyStatus, DateTime publicationClose)
        {
            return new List<ClaimReconciliationBehaviourSheetType>
            {
                new ClaimReconciliationBehaviourSheetType
                {
                    ClaimCollectionCode = ClaimCollectionCode,
                    ClaimReconciliationAllocationGroupCode = AllocationGroupCode,
                    ClaimTypeCode = "F",
                    PolicyStatus = policyStatus,
                    PublicationCloseDate = publicationClose,
                    FundingPeriod = "AY1516"
                }
            };
        }

        private IReadOnlyCollection<sfa_claimreconciliationbehaviour> GetCrmEntities()
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                return (from crb in crmContext.sfa_claimreconciliationbehaviourSet
                        join ag in crmContext.sfa_claimreconallocgroupSet
                            on crb.sfa_allocationgroup.Id equals ag.sfa_claimreconallocgroupId.Value
                        where ag.sfa_AllocationGroupCode == AllocationGroupCode
                        select crb).ToList();
            }
        }

        private void Cleanup()
        {
            IReadOnlyCollection<sfa_claimreconciliationbehaviour> crmEntitiesToRemove = GetCrmEntities(); // TODO

            if (crmEntitiesToRemove.Any())
            {
                string name = crmEntitiesToRemove.First().LogicalName;

                crmEntitiesToRemove.ForEach(e => CrmHelper.GetConnection().Delete(name, e.Id));
            }

            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                sfa_claimreconallocgroup allocGroupToRemove =
                    crmContext.sfa_claimreconallocgroupSet.SingleOrDefault(
                        ag => ag.sfa_AllocationGroupCode == AllocationGroupCode);

                if (allocGroupToRemove != null)
                {
                    CrmHelper.GetConnection().Delete(allocGroupToRemove.LogicalName, allocGroupToRemove.Id);
                }
            }
        }

        private void SetUpData()
        {
            sfa_claimreconallocgroup allocGroup = new sfa_claimreconallocgroup
            {
                sfa_AllocationGroupCode = AllocationGroupCode,
                sfa_name = "Test alloc group"
            };

            CrmHelper.GetConnection().Create(allocGroup);
        }
    }
}