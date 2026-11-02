using Microsoft.Crm.Sdk.Messages;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Client;
using Microsoft.Xrm.Sdk.Query;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Tests.Plugins.Integration
{
    public class TeamRoleHelper
    {

        public IOrganizationService OrganizationService { get; set; }
        public TeamRoleHelper(IOrganizationService service)
        {
            OrganizationService = service;
        }

        public Guid RetrieveUserId(string userfullname)
        {
            Guid result = Guid.Empty;
            using (var orgContext = new OrganizationServiceContext(OrganizationService))
            {
                var query = from fa in orgContext.CreateQuery("systemuser")
                            where fa.GetAttributeValue<string>("fullname") == userfullname
                            select fa;

                result = query.FirstOrDefault().GetAttributeValue<Guid>("systemuserid");

                return result;
            }

        }


        public void AssociateRolesForUser(string _givenRole, Guid userId)
        {
            // Find the role.
            QueryExpression query = new QueryExpression
            {
                EntityName = "role",
                ColumnSet = new ColumnSet("roleid"),
                Criteria = new FilterExpression
                {
                    Conditions =
                {

                    new ConditionExpression
                    {
                        AttributeName = "name",
                        Operator = ConditionOperator.Equal,
                        Values = {_givenRole}
                    }
                }
                }
            };

            // Get the role.
            EntityCollection roles = OrganizationService.RetrieveMultiple(query);
            if (roles.Entities.Count > 0)
            {
                Entity targetRole = OrganizationService.RetrieveMultiple(query).Entities[0];
                var _roleId = targetRole.Id;

                // Associate the user with the role.
                if (_roleId != Guid.Empty && userId != Guid.Empty)
                {
                    OrganizationService.Associate(
                                 "systemuser",
                                 userId,
                                 new Relationship("systemuserroles_association"),
                                 new EntityReferenceCollection() { new EntityReference("role", _roleId) });
                }
            }

        }

        public void DisassociateRolesExceptBaseRoleFromUser(Guid userId)
        {
            using (var orgContext = new OrganizationServiceContext(OrganizationService))
            {
                var query = from s in orgContext.CreateQuery("systemuserroles")
                            join r in orgContext.CreateQuery("role")
                            on s["roleid"] equals r["roleid"]
                            where s.GetAttributeValue<Guid>("systemuserid") == userId
                            && r.GetAttributeValue<string>("name") != "Base Role"
                            select r;

                foreach (var rl in query.ToList())
                {
                    OrganizationService.Disassociate(
                         "systemuser",
                         userId,
                         new Relationship("systemuserroles_association"),
                         new EntityReferenceCollection() { new EntityReference("role", rl.GetAttributeValue<Guid>("roleid")) });

                }
            }
        }

        public void RemoveMembersFromTeam(List<Entity> teams, Guid membersId)
        {
            foreach (var t in teams)
            {

                // Create the AddMembersTeamRequest object.
                RemoveMembersTeamRequest addRequest = new RemoveMembersTeamRequest();

                // Set the AddMembersTeamRequest TeamID property to the object ID of 
                // an existing team.
                addRequest.TeamId = t.GetAttributeValue<Guid>("teamid");

                // Set the AddMembersTeamRequest MemberIds property to an 
                // array of GUIDs that contains the object IDs of one or more system users.
                addRequest.MemberIds = new Guid[] { membersId };

                // Execute the request.
                OrganizationService.Execute(addRequest);
            }

        }

        public void AddMembersToTeam(String _givenTeam, Guid membersId)
        {
            // Find the role.
            QueryExpression query = new QueryExpression
            {
                EntityName = "team",
                ColumnSet = new ColumnSet("teamid"),
                Criteria = new FilterExpression
                {
                    Conditions =
                {

                    new ConditionExpression
                    {
                        AttributeName = "name",
                        Operator = ConditionOperator.Equal,
                        Values = {_givenTeam}
                    }
                }
                }
            };

            // Get the role.
            EntityCollection teams = OrganizationService.RetrieveMultiple(query);
            if (teams.Entities.Count > 0)
            {
                Entity targetTeam = OrganizationService.RetrieveMultiple(query).Entities[0];

                // Create the AddMembersTeamRequest object.
                AddMembersTeamRequest addRequest = new AddMembersTeamRequest();

                // Set the AddMembersTeamRequest TeamID property to the object ID of 
                // an existing team.
                addRequest.TeamId = targetTeam.GetAttributeValue<Guid>("teamid");
                // Set the AddMembersTeamRequest MemberIds property to an 
                // array of GUIDs that contains the object IDs of one or more system users.
                addRequest.MemberIds = new Guid[] { membersId };

                // Execute the request.
                OrganizationService.Execute(addRequest);
            }

        }

        public List<Entity> GetTeamIdByUserId(List<string> TeamName, Guid userId)
        {
            //get team with
            List<Entity> result = new List<Entity>();
            using (var orgContext = new OrganizationServiceContext(OrganizationService))
            {
                var query = from t in orgContext.CreateQuery("team")
                            join tm in orgContext.CreateQuery("teammembership")
                            on t["teamid"] equals tm["teamid"]
                            where (t.GetAttributeValue<string>("name") == TeamName[0]
                            || t.GetAttributeValue<string>("name") == TeamName[1]
                            || t.GetAttributeValue<string>("name") == TeamName[2]
                            || t.GetAttributeValue<string>("name") == TeamName[3]
                            || t.GetAttributeValue<string>("name") == TeamName[4]
                            || t.GetAttributeValue<string>("name") == TeamName[5])
                            && tm.GetAttributeValue<Guid>("systemuserid") == userId
                            select t;

                result = query.ToList();

                return result;
            }

        }

        public Entity GetTeamIdByTeamNames(string TeamName)
        {
            //get team with
            Entity result = new Entity();
            using (var orgContext = new OrganizationServiceContext(OrganizationService))
            {
                var query = from t in orgContext.CreateQuery("team")
                            where (t.GetAttributeValue<string>("name") == TeamName)
                            select t;

                result = query.ToList().FirstOrDefault();

                return result;
            }

        }
    }
}
