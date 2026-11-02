namespace ContractCreateDomain.Implementation.Tests.IntegrationTests
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using CrmConnectionFactory = SFA.FCS.Worker.Common.Crm.CrmConnectionFactory;

    [TestClass]
    public class XrmOrganisationManagerIntegrationTests
    {
        private const string UkprnTest = "Test Org";

        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmOrganisationManagerIntegration_ShouldSaveOrgWithUpin()
        {
            // arrange
            var org = new ContractOrganisation()
            {
                OrganisationId = "ORG1",
                Name = "Test Organisation",
                Status = "Active",
                Upin = "123",
                UKPRN = UkprnTest
            };

            DeleteOrganisation(UkprnTest);

            var xrmOrgMgr = new XrmOrganisationManager { OrgService = GetOrgService() };

            // Act
            var organisationGuid = xrmOrgMgr.CreateOrganisationIfNotExists(org);

            // assert
            var xrmContext = new XrmServiceContext(GetOrgService());
            var retrievedOrg = xrmContext.AccountSet.Single(a => a.Id == organisationGuid);

            Assert.AreEqual(org.Upin, retrievedOrg.sfa_orgupin, "The upin has not been set correctly");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmOrganisationManagerIntegration_ShouldSaveOrgWithCompanyNumberAndCharityNumber()
        {
            // arrange
            var org = new ContractOrganisation
            {
                OrganisationId = "ORG1",
                Name = "Test Organisation",
                Status = "Active",
                Upin = "123",
                UKPRN = UkprnTest,
                CompanyNumber = "9876",
                CharityNumber = "123456"
            };

            DeleteOrganisation(UkprnTest);

            var xrmOrgMgr = new XrmOrganisationManager { OrgService = GetOrgService() };

            // Act
            var organisationGuid = xrmOrgMgr.CreateOrganisationIfNotExists(org);

            // assert
            var xrmContext = new XrmServiceContext(GetOrgService());
            var retrievedOrg = xrmContext.AccountSet.Single(a => a.Id == organisationGuid);

            Assert.AreEqual(org.CompanyNumber, retrievedOrg.sfa_companynumber, "The company number has not been set correctly");
            Assert.AreEqual(org.CharityNumber, retrievedOrg.sfa_charitynumber, "The charity number has not been set correctly");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmOrganisationManager_ShouldCreateOrganisationOnlyOneOrganisation_WhenCreateIfNotExistsCalledMultipleTimes()
        {
            // arrange
            var org = new ContractOrganisation
            {
                Status = "Active",
                UKPRN = UkprnTest,
            };

            DeleteOrganisation(UkprnTest);

            var xrmOrgMgr = new XrmOrganisationManager { OrgService = GetOrgService() };

            // Act
            xrmOrgMgr.CreateOrganisationIfNotExists(org);
            xrmOrgMgr.CreateOrganisationIfNotExists(org);

            // assert
            var xrmContext = new XrmServiceContext(GetOrgService());
            var retrievedOrgs = xrmContext.AccountSet.Where(a => a.sfa_UKPRN == UkprnTest).ToList();

            Assert.AreEqual(1, retrievedOrgs.Count, "The wrong number of organisations were created");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmOrganisationManager_ShouldCreateOrganisationWithAddressAttributesSet()
        {
            // arrange
            var org = new ContractOrganisation
            {
                Status = "Active",
                UKPRN = UkprnTest,
            };

            org.Address.AddressLine1 = "AddressLine1";
            org.Address.AddressLine2 = "AddressLine2";
            org.Address.AddressLine3 = "AddressLine3";
            org.Address.AddressLine4 = "AddressLine4";
            org.Address.Town = "Town";
            org.Address.County = "County";
            org.Address.Postcode = "Postcode";

            DeleteOrganisation(UkprnTest);

            var xrmOrgMgr = new XrmOrganisationManager { OrgService = GetOrgService() };

            // Act
            xrmOrgMgr.CreateOrganisationIfNotExists(org);

            // assert
            var xrmContext = new XrmServiceContext(GetOrgService());

            var retrievedOrgs = xrmContext.AccountSet.Where(a => a.sfa_UKPRN == UkprnTest).ToList();

            Assert.AreEqual(1, retrievedOrgs.Count, "The wrong number of organisations were created");
            Assert.AreEqual(org.Address.AddressLine1, retrievedOrgs[0].Address1_Line1, "The Address1_Line1 is not set correctly");
            Assert.AreEqual(org.Address.AddressLine2, retrievedOrgs[0].Address1_Line2, "The Address1_Line2 is not set correctly");
            Assert.AreEqual(org.Address.AddressLine3, retrievedOrgs[0].Address1_Line3, "The Address1_Line3 is not set correctly");
            Assert.AreEqual(org.Address.AddressLine4, retrievedOrgs[0].Address1_Line4, "The Address1_Line4 is not set correctly");
            Assert.AreEqual(org.Address.Town, retrievedOrgs[0].Address1_Town, "The Address1_Town is not set correctly");
            Assert.AreEqual(org.Address.County, retrievedOrgs[0].Address1_County, "The Address1_County is not set correctly");
            Assert.AreEqual(org.Address.Postcode, retrievedOrgs[0].Address1_PostCode, "The Address1_PostCode is not set correctly");
        }

        private static void DeleteOrganisation(string ukprn)
        {
            var xrmContext = new XrmServiceContext(GetOrgService());
            var matchingAccounts = xrmContext.AccountSet.Where(a => a.sfa_UKPRN == ukprn);

            matchingAccounts.ForEach(xrmContext.DeleteObject);

            xrmContext.SaveChanges();
        }

        private static IOrganizationService GetOrgService()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }
    }
}
