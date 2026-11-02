
using Microsoft.Xrm.Sdk;
using Xrm.Framework.Test.Integration;
using Microsoft.Xrm.Sdk.Messages;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Xrm.Sdk.Query;
using Microsoft.Xrm.Client.Services;
using Microsoft.Xrm.Client;
using System.Collections.Generic;
using System.Linq;


namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Tests.Plugins.Integration
{
    [TestClass]
    public class CallTaskRetrieveMultipleFilter_DocumentManager :PluginIntegrationTest
    {

        protected override OrganizationRequest SetupTriggerRequest()
        {
            //setup retrievemulitple requst for task entities.
            //Assign Security Role
            //Add To Team
            #region "Add memeber to certain team"

            TeamRoleHelper helper = new TeamRoleHelper(OrganizationService);

            var userId = helper.RetrieveUserId("Paul Lai");

            List<string> AddTeamList = new List<string>();
            AddTeamList.Add("Document Management Team");

            List<string> AddRoleList = new List<string>();
            AddRoleList.Add("Document Manager");


            //Add to test teams
            foreach (var tname in AddTeamList)
            {
                helper.AddMembersToTeam(tname, userId);
            }

            //assoicate with target role(s)
            foreach (var rname in AddRoleList)
            {
                helper.AssociateRolesForUser(rname, userId);
            }

            #endregion

            OrganizationService = new OrganizationService(new CrmConnection("PaulLaiXrm"));

            QueryExpression query = new QueryExpression()
            {
                EntityName = "task",
                ColumnSet = new ColumnSet(true),

                Criteria = new FilterExpression
                {
                    Conditions =
                  {
                       new ConditionExpression
                     {
                         AttributeName = "statecode",
                         Operator = ConditionOperator.Equal,
                         Values = { 0 }
                     }
                     }
                }

            };




            RetrieveMultipleRequest request = new RetrieveMultipleRequest();
            request.Query = query;
            return request;
        }

        [TestMethod, TestCategory("Sync Integration Plugin Test")]
        public void RunTaskRetrieveMultipleFilter_DocumentManager()
        {
            base.Test();
        }

        protected override void Verify()
        {
            Assert.IsNull(Error);

            RetrieveMultipleResponse response = this.TriggerResponse as RetrieveMultipleResponse;

            List<Entity> returnentities = response.EntityCollection.Entities.ToList();

            var CountOfTaskOwnedByDocumentMangementTeam = returnentities.Where(x => x.GetAttributeValue<string>("subject") == "Initiate Document Merge").Count();
            var CountOfTaskOwnedByContractManagersTeam = returnentities.Where(x => x.GetAttributeValue<string>("subject") == "Confirm Internal Approval").Count();
            var CountOfTaskOwnedByLeadManagersTeam = returnentities.Where(x => x.GetAttributeValue<string>("subject") == "Confirm Publication to Provider").Count();
            var CountOfTaskOwnedByContractAdvisersTeamTeam = returnentities.Where(x => x.GetAttributeValue<string>("subject") == "Confirm Receipt of Signed Contract"
            || x.GetAttributeValue<string>("subject") == "Confirm Receipt of Signed Contract"
            || x.GetAttributeValue<string>("subject") == "Progress Rejected Contract"
             || x.GetAttributeValue<string>("subject") == "Review Contract Details"
                   || x.GetAttributeValue<string>("subject") == "Revise Contract"
            ).Count();

            Assert.AreEqual(0, CountOfTaskOwnedByContractAdvisersTeamTeam, "Expected Number of Task is zero");
            Assert.AreEqual(0, CountOfTaskOwnedByContractManagersTeam, "Expected Number of Task is zero");
            Assert.AreEqual(0, CountOfTaskOwnedByLeadManagersTeam, "Expected Number of Task is zero");
            Assert.IsTrue(CountOfTaskOwnedByDocumentMangementTeam > 0, "Expected Number of Task is great than zero");

        }

        protected override void CleanUp()
        {

            //Remove all the team

            #region "Remove following team" for given user
            OrganizationService = new OrganizationService(new CrmConnection("Xrm"));

            TeamRoleHelper helper = new TeamRoleHelper(OrganizationService);

            var userId = helper.RetrieveUserId("Paul Lai");

            List<string> TeamList = new List<string>();
            TeamList.Add("Contract Advisers Team");
            TeamList.Add("Contract Managers Team");
            TeamList.Add("Document management Team");
            TeamList.Add("FCS Support Team");
            TeamList.Add("Lead Manager Team");
            TeamList.Add("User Access Manager Team");

            var removelist = helper.GetTeamIdByUserId(TeamList, userId);
            helper.RemoveMembersFromTeam(removelist, userId);
            helper.DisassociateRolesExceptBaseRoleFromUser(userId);

            #endregion

            base.CleanUp();

        }
    }
}
