namespace FCT.Console.Config.Tests.Crm
{
    using System.Collections.Generic;
    using System.Linq;
    using Config.Infrastructure;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using Synchronizers.Writers;
    using Synchronizers.Writers.CRM;

    [TestClass]
    public class CrmFspGroupWriterTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFspGroupWriter_ShouldInsertNewRowWhenRowDoesNotExist()
        {
            // arrange
            const string fspGroupCode = "test fspG name";
            DeleteRowsWithCode(fspGroupCode);
            CrmFspGroupWriter fspGroupWriter = new CrmFspGroupWriter();

            List<FspGroupSheetType> rows = new List<FspGroupSheetType>
            {
                new FspGroupSheetType
                {
                    FSPGroupCode = fspGroupCode,
                    PolicyStatus = PolicyStatus.Approved
                },
                new FspGroupSheetType
                {
                    FSPGroupCode = fspGroupCode,
                    PolicyStatus = PolicyStatus.Draft
                }
            };
            
            // act
            fspGroupWriter.WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            var matchingFspGroups = GetFspGroupsWithCode(fspGroupCode);
            Assert.AreEqual(1, matchingFspGroups.Count, "The number of matching rows in incorrect");
            Assert.AreEqual(fspGroupCode, matchingFspGroups.First().sfa_name, "The sfa_name is incorrect");
            DeleteRowsWithCode(fspGroupCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFspGroupWriter_ShouldDeleteRowWhenPolicyStatusIs()
        {
            // arrange
            const string fspGroupCode = "test fspG name";
            DeleteRowsWithCode(fspGroupCode);
            InsertRow(fspGroupCode);
            CrmFspGroupWriter fspGroupWriter = new CrmFspGroupWriter();

            List<FspGroupSheetType> rows = new List<FspGroupSheetType>
            {
                new FspGroupSheetType
                {
                    FSPGroupCode = fspGroupCode,
                    PolicyStatus = PolicyStatus.Removed
                },
                new FspGroupSheetType
                {
                    FSPGroupCode = fspGroupCode,
                    PolicyStatus = PolicyStatus.Draft
                }
            };

            // act
            fspGroupWriter.WriteToCrmDatabase(rows, WriterBehaviour.Delete);

            // assert
            var matchingFspGroups = GetFspGroupsWithCode(fspGroupCode);
            Assert.AreEqual(0, matchingFspGroups.Count, "The number of matching rows in incorrect");
            DeleteRowsWithCode(fspGroupCode);
        }

        private void DeleteRowsWithCode(string fspGroupCode)
        {
            var connection = CrmConnectionFactory.GetOrganizationService();
            using (var crmContext = new XrmServiceContext(connection))
            {
                crmContext.sfa_fspgroupSet.Where(fspG => fspG.sfa_name == fspGroupCode)
                    .Select(fspG => fspG.Id)
                    .ToList()
                    .ForEach(id => connection.Delete(sfa_fspgroup.EntityLogicalName, id));
            }
        }

        private IReadOnlyCollection<sfa_fspgroup> GetFspGroupsWithCode(string fspGroupCode)
        {
            var connection = CrmConnectionFactory.GetOrganizationService();
            using (var crmContext = new XrmServiceContext(connection))
            {
                return crmContext.sfa_fspgroupSet.Where(fspG => fspG.sfa_name == fspGroupCode)
                    .ToList();
            }
        }

        private void InsertRow(string fspGroupCode)
        {
            var connection = CrmConnectionFactory.GetOrganizationService();
            sfa_fspgroup fspgroup = new sfa_fspgroup
            {
                sfa_name = fspGroupCode
            };

            connection.Create(fspgroup);
        }
    }
}
