namespace FCT.Console.Config.Tests.Crm
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using Synchronizers.Writers;
    using Synchronizers.Writers.CRM;


    [TestClass]
    public class CrmAgencyWriterTests
    {
        [TestInitialize, TestCleanup]
        public void CleanUp()
        {
            var crmAgencyCollection = GetAgency(_testAgency.First().AgencyCode);
            if (crmAgencyCollection.Any())
            {
                foreach (var crmAgency in crmAgencyCollection)
                {
                    CrmHelper.GetConnection().Delete("sfa_agency", crmAgency.Id);
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmAgencyWriter_ShouldInsertNewRowIntoCrmWhenRowDoesNotExist()
        {
            // act
            new CrmAgencyWriter().WriteToCrmDatabase(_testAgency, WriterBehaviour.AddOrUpdate);

            // assert
            IEnumerable<sfa_agency> agency = GetAgency(_testAgency.First().AgencyCode);
            Assert.AreEqual(1, agency.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmAgencyWriter_ShouldUpdateExistingRowInCrmWhenRowExists()
        {
            // arrange
            var updatedValue = "UpdatedValue";
            new CrmAgencyWriter().WriteToCrmDatabase(_testAgency, WriterBehaviour.AddOrUpdate);

            _testAgency.First().AgencyShortCode = updatedValue;

            // act
            new CrmAgencyWriter().WriteToCrmDatabase(_testAgency, WriterBehaviour.AddOrUpdate);

            // assert
            IReadOnlyCollection<sfa_agency> agency = GetAgency(_testAgency.First().AgencyCode);
            Assert.AreEqual(1, agency.Count, "We have inserted a row when we wanted to do an insert");
            Assert.AreEqual(updatedValue, agency.First().sfa_agencyshortcode, "The agency short code has not been updated");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmAgencyWriter_ShouldDeleteExistingRowInCrmWhenRowExistsAndPolicyStatusIsDeleted()
        {
            // arrange
            new CrmAgencyWriter().WriteToCrmDatabase(_testAgency, WriterBehaviour.AddOrUpdate);

            _testAgency.First().PolicyStatus = PolicyStatus.Removed;

            // act
            new CrmAgencyWriter().WriteToCrmDatabase(_testAgency, WriterBehaviour.Delete);

            // assert
            IEnumerable<sfa_agency> agency = GetAgency(_testAgency.First().AgencyCode);
            Assert.AreEqual(0, agency.Count(), "We have not deleted the row");
        }


        private IReadOnlyCollection<sfa_agency> GetAgency(string agencyCode)
        {
            using (var crmContext = new XrmServiceContext(Synchronizers.Writers.CRM.CrmHelper.GetConnection()))
            {
                return (from ct in crmContext.sfa_agencySet
                        where ct.sfa_agencycode == agencyCode
                        select ct).ToList();
            }
        }

        private IEnumerable<AgencySheetType> _testAgency = new List<AgencySheetType>()
        {
            new AgencySheetType()
            {
                AgencyCode = "9",
                AgencyShortCode = "TEST",
                Description = "Test Agency",
                ContractReferencePrefix ="TEST CONTRACT",
                PolicyStatus = PolicyStatus.Approved
            }
        };

    }
}
