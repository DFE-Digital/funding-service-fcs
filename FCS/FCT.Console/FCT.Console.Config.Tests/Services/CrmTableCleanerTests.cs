namespace FCT.Console.Config.Tests.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using Config.Services;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using Synchronizers.Writers;
    using Synchronizers.Writers.CRM;

    [TestClass]
    public class CrmTableCleanerTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmTableCleaner_DeleteAllRows_ShouldRemoveAllRowsFromsfa_claimreconciliationpublicationexception()
        {
            // arrange 
            var rows = GetClaimReconciliationPublicationExceptionSheetTypeRows();
            new CrmClaimReconciliationPublicationExceptionWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);
            var crmExceptionRecordsBefore = GetCrmClaimReconciliationPublicationExceptions();
            Assert.IsTrue(crmExceptionRecordsBefore.Count > 0, "Arrange did not correctly add a sfa_claimreconciliationpublicationexception record to CRM");

            IOrganizationService organizationService = CrmHelper.GetConnection();

            // act 
            CrmTableCleaner.DeleteAllRows(sfa_claimreconciliationpublicationexception.EntityLogicalName, organizationService);

            // asset
            var crmExceptionRecordsAfter = GetCrmClaimReconciliationPublicationExceptions();
            Assert.IsTrue(crmExceptionRecordsAfter.Count == 0, "CrmTableCleaner.DeleteAllRows did not correctly clear all records from sfa_claimreconciliationpublicationexception table");
        }

        private static IReadOnlyCollection<ClaimReconciliationPublicationExceptionSheetType> GetClaimReconciliationPublicationExceptionSheetTypeRows()
        {
            return new List<ClaimReconciliationPublicationExceptionSheetType>
            {
                new ClaimReconciliationPublicationExceptionSheetType
                {
                    PolicyStatus = PolicyStatus.Approved,
                    ClaimReconciliationAllocationGroupCode = "AEBC1718",
                    Ukprn = 11
                }
            };
        }

        private static IReadOnlyCollection<sfa_claimreconciliationpublicationexception> GetCrmClaimReconciliationPublicationExceptions()
        {
            using (var crmContext = new XrmServiceContext(Synchronizers.Writers.CRM.CrmHelper.GetConnection()))
            {
                var claimReconciliationPublicationExceptionQuery = from crpe in crmContext.sfa_claimreconciliationpublicationexceptionSet
                    select crpe;
                return claimReconciliationPublicationExceptionQuery.ToList();
            }
        }
    }
}