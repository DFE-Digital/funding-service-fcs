namespace FCT.Console.Config.Tests.Crm
{
    using System;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using Synchronizers.Writers;
    using Synchronizers.Writers.CRM;

    [TestClass]
    public class CrmClaimReconciliationPublicationExceptionWriterTests
    {
        private const string TestClaimReconciliationAllocationGroupCode = "AEBC1617";
        private const string TestClaimReconciliationAllocationGroupName = "Adult Education Budget (College) 16/17";
        private ClaimReconciliationPublicationExceptionSheetType _testSheet;

        [TestInitialize]
        public void TestInitialize()
        {
            _testSheet = CreateTestSheet();
            TestCleanup();
        }

        [TestCleanup]
        public void TestCleanup()
        {
            IOrganizationService organizationService = CrmHelper.GetConnection();

            var publicationExceptionToRemove = GetPublicationException(_testSheet.ClaimReconciliationAllocationGroupCode, _testSheet.Ukprn.ToString());
            if (publicationExceptionToRemove != null)
            {
                organizationService.Delete("sfa_claimreconciliationpublicationexception", publicationExceptionToRemove.Id);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmClaimReconciliationPublicationExceptionWriter_ShouldInsertNewRowIntoCrmWhenRowDoesNotExist()
        {
            // arrange
            CrmClaimReconciliationPublicationExceptionWriter writer = new CrmClaimReconciliationPublicationExceptionWriter();

            // act
            writer.WriteToCrmDatabase(new[] { _testSheet }, WriterBehaviour.AddOrUpdate);

            // assert
            var retrievedPublicationException = GetPublicationException(_testSheet.ClaimReconciliationAllocationGroupCode, _testSheet.Ukprn.ToString());
            Assert.IsNotNull(retrievedPublicationException, "Publication exception was not found in CRM");
            Assert.AreEqual(_testSheet.Ukprn.ToString(), retrievedPublicationException.sfa_ukprn, "Publication exception did not have the expected ukprn");
            Assert.AreEqual(TestClaimReconciliationAllocationGroupName, retrievedPublicationException.sfa_claimreconciliationallocationgroup.Name, "Publication exception did not have the expected claim reconciliation allocation group code");
            Assert.AreEqual($"{_testSheet.ClaimReconciliationAllocationGroupCode}_{_testSheet.Ukprn}", retrievedPublicationException.sfa_name, "Publication exception did not have the expected sfa_name");
            Assert.IsNotNull(retrievedPublicationException.sfa_provider);
            Assert.AreEqual(_testSheet.Ukprn.ToString(), GetUkprnForAccountEntity(retrievedPublicationException.sfa_provider.Id));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmClaimReconciliationPublicationExceptionWriter_ExistingRowShouldRemainUnchangedWhenUpdateCalled()
        {
            // arrange
            CrmClaimReconciliationPublicationExceptionWriter writer = new CrmClaimReconciliationPublicationExceptionWriter();
            writer.WriteToCrmDatabase(new[] { _testSheet }, WriterBehaviour.AddOrUpdate);

            // act
            writer.WriteToCrmDatabase(new[] { _testSheet }, WriterBehaviour.AddOrUpdate);

            // assert
            var retrievedPublicationException = GetPublicationException(_testSheet.ClaimReconciliationAllocationGroupCode, _testSheet.Ukprn.ToString());
            Assert.IsNotNull(retrievedPublicationException, "Publication exception was not found in CRM");
            Assert.AreEqual(_testSheet.Ukprn.ToString(), retrievedPublicationException.sfa_ukprn, "Publication exception did not have the expected ukprn");
            Assert.AreEqual(TestClaimReconciliationAllocationGroupName, retrievedPublicationException.sfa_claimreconciliationallocationgroup.Name, "Publication exception did not have the expected claim reconciliation allocation group code");
            Assert.AreEqual($"{_testSheet.ClaimReconciliationAllocationGroupCode}_{_testSheet.Ukprn}", retrievedPublicationException.sfa_name, "Publication exception did not have the expected sfa_name");
            Assert.IsNotNull(retrievedPublicationException.sfa_provider);
            Assert.AreEqual(_testSheet.Ukprn.ToString(), GetUkprnForAccountEntity(retrievedPublicationException.sfa_provider.Id));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmClaimReconciliationPublicationExceptionWriter_ShouldDeleteExistingRowInCrmWhenRowExistsAndPolicyStatusIsDeleted()
        {
            // arrange
            CrmClaimReconciliationPublicationExceptionWriter writer = new CrmClaimReconciliationPublicationExceptionWriter();
            writer.WriteToCrmDatabase(new[] { _testSheet }, WriterBehaviour.AddOrUpdate);

            // act
            _testSheet.PolicyStatus = PolicyStatus.Removed;
            writer.WriteToCrmDatabase(new[] { _testSheet }, WriterBehaviour.Delete);

            // assert
            var retrievedPublicationException = GetPublicationException(_testSheet.ClaimReconciliationAllocationGroupCode, _testSheet.Ukprn.ToString());
            Assert.IsNull(retrievedPublicationException, "Publication exception was not deleted from CRM");
        }

        private static ClaimReconciliationPublicationExceptionSheetType CreateTestSheet()
        {
            return new ClaimReconciliationPublicationExceptionSheetType
            {
                ClaimReconciliationAllocationGroupCode = TestClaimReconciliationAllocationGroupCode,
                Ukprn = GetFirstOrganisationUkprn(),
                PolicyStatus = PolicyStatus.Approved
            };
        }

        private static sfa_claimreconciliationpublicationexception GetPublicationException(string claimReconciliationAllocationGroupCode, string ukprn)
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                return (from crpe in crmContext.sfa_claimreconciliationpublicationexceptionSet
                        join crag in crmContext.sfa_claimreconallocgroupSet on crpe.sfa_claimreconciliationallocationgroup.Id equals crag.sfa_claimreconallocgroupId
                        where crpe.sfa_ukprn == ukprn && crag.sfa_AllocationGroupCode == claimReconciliationAllocationGroupCode
                        select crpe).SingleOrDefault();
            }
        }

        private static int GetFirstOrganisationUkprn()
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                var orgs = crmContext.AccountSet.Where(a => a.sfa_UKPRN != null && a.sfa_UKPRN != string.Empty)
                                                .Select(a => new { a.sfa_UKPRN, a.AccountId })
                                                .ToList();

                var orgWithUniqueUkprn = orgs.GroupBy(ag => ag.sfa_UKPRN)
                                             .First(ag => ag.Count() == 1)
                                             .Single();

                return int.Parse(orgWithUniqueUkprn.sfa_UKPRN);
            }
        }

        private static string GetUkprnForAccountEntity(Guid guid)
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                return crmContext.AccountSet.Where(o => o.AccountId == guid)
                                            .Select(o => o.sfa_UKPRN)
                                            .Single();
            }
        }
    }
}
