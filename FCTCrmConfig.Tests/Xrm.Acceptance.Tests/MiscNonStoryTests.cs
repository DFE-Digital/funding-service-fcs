using Microsoft.Crm.Sdk.Messages;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Xrm.Client;
using Microsoft.Xrm.Client.Services;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Query;

namespace SFA.FCT.Xrm.Acceptance.Tests
{
    [TestClass]
    public class MiscNonStoryTests
    {
        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "00")]
        public void TestAutoSaveDisabled()
        {

            CrmConnection crmConnection =
                CrmConnection.Parse(Properties.Settings.Default.CrmAcceptanceTestConnectionString);

            using (var orgService = new OrganizationService(crmConnection))
            {
                WhoAmIRequest wmiRequest = new WhoAmIRequest();

                WhoAmIResponse wmiResponse = (WhoAmIResponse) orgService.Execute(wmiRequest);

                ColumnSet orgCols = new ColumnSet("isautosaveenabled");

                Entity newOrg = orgService.Retrieve("organization", wmiResponse.OrganizationId, orgCols);

                Assert.IsTrue((bool) newOrg.Attributes["isautosaveenabled"] == false,
                    "The Dynamics CRM system has AutoSave enabled");
            }
        }

    }
}

