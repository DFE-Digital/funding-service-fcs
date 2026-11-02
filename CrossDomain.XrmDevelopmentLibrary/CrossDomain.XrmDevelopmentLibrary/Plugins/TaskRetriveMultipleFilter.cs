using System;
using System.Linq;
using System.ServiceModel;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Client;
using Microsoft.Xrm.Sdk.Query;
using System.Collections.Generic;
using Microsoft.Crm.Sdk.Messages;

namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Plugins
{
    public class TaskRetriveMultipleFilter : IPlugin
    {

        /// <summary>
        /// This plugin is design to execute a pre-validation for task RetriveMultiple Message
        /// stage - Prevalidation
        /// entity - task
        /// message - RetrieveMultiple
        /// field - all fields 
        /// purpose : for contract advisor 
        /// Contract Advisor can only view/update tasks owned by
        /// Him/herself Yes
        /// Other contract advisor(so she/he can re-assign to himself/herself to complete) 
        /// Owned by ‘Unassigned team’ 
        /// Owned by ‘Contract Advisor Team’
        /// If contract advisor is Document Manager or in Document Manager Team, also show tasks owned by Document Managment Team
        /// </summary>
        /// <param name="serviceProvider"></param>
        /// 



        private const string FCSSUPPORTTEAM = "FCS Support Team";
        private const string SYSTEMADMIN = "System Administrator";

        public void Execute(IServiceProvider serviceProvider)
        {
            IPluginExecutionContext context =
                       (IPluginExecutionContext)serviceProvider.GetService(typeof(Microsoft.Xrm.Sdk.IPluginExecutionContext));

            // Get the OrgService
            IOrganizationServiceFactory serviceFactory =
                (IOrganizationServiceFactory)serviceProvider.GetService(typeof(IOrganizationServiceFactory));
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);

            // Get a reference to the tracing service.
            ITracingService tracingService = (ITracingService)serviceProvider.GetService(typeof(ITracingService));

            // Check that all of the following conditions are true:
            //  1. plug-in is running synchronously
            //  3. plug-in is running on the 'RetrieveMultiple' event
            if (context.Mode == 0 && context.MessageName.Equals("RetrieveMultiple"))
            {
                tracingService.Trace("Message Correct");

                // The InputParameters collection contains all the data passed in the message request.
                if (context.InputParameters.Contains("Query"))
                {
                    QueryExpression objQueryExpression = new QueryExpression();
                    FetchExpression objFetchExpression = new FetchExpression();

                    if (context.InputParameters["Query"] is FetchExpression)
                    {

                        // Get the QueryExpression from the property bag
                        objFetchExpression = (FetchExpression)context.InputParameters["Query"];

                        // Convert the FetchXML into a query expression.
                        var conversionRequest = new FetchXmlToQueryExpressionRequest()
                        {
                            FetchXml = objFetchExpression.Query
                        };
                        var conversionResponse =
                        (FetchXmlToQueryExpressionResponse)service.Execute(conversionRequest);
                        objQueryExpression = conversionResponse.Query;
                    }
                    else if (context.InputParameters["Query"] is QueryExpression)
                    {
                        objQueryExpression = (QueryExpression)context.InputParameters["Query"];
                    }

                    //only filter for users a)NOT a system admin and b) NOT in FCS support team
                    if (!UserHasRole(context.InitiatingUserId, SYSTEMADMIN, service, tracingService) && !UserIsTeamMember(FCSSUPPORTTEAM, context.InitiatingUserId, service))
                        {
                            tracingService.Trace("Usre in Role : Contract Advister");

                            FilterExpression ownerfilter = new FilterExpression();
                            ownerfilter.FilterOperator = LogicalOperator.And;


                            using (var orgContext = new OrganizationServiceContext(service))
                            {
                                var query = from fa in orgContext.CreateQuery("sfa_taskaction")
                                            select fa;

                                var taList = query.ToList();

                                if (taList.Count() > 0)
                                {
                                    tracingService.Trace($"Retrieve all the items from Task Action Matrix with total count {taList.Count().ToString()}");

                                    foreach (var ta in taList)
                                    {
                                        if (!UserHasRole(context.InitiatingUserId, ta.GetAttributeValue<EntityReference>("sfa_actionroleid").Name, service, tracingService)
                                            && !UserIsTeamMember(ta.GetAttributeValue<EntityReference>("sfa_actionteamid").Name, context.InitiatingUserId, service))
                                        {

                                            ConditionExpression ownerCondition = new ConditionExpression()
                                            {
                                                AttributeName = "subject",
                                                Operator = ConditionOperator.NotEqual,
                                                Values = { ta.GetAttributeValue<string>("sfa_taskname") }
                                            };

                                            ownerfilter.AddCondition(ownerCondition);
                                            tracingService.Trace($"Task Type being excluded for this user : { ta.GetAttributeValue<string>("sfa_taskname")}");
                                        }
                                    }
                                }


                                if (ownerfilter.Conditions.Count > 0)
                                {
                                    objQueryExpression.Criteria.Filters.Add(ownerfilter);
                                }


                            }

                            // throw new InvalidPluginExecutionException("Task Reivew Filter Test Error");
                        }

                    if (context.InputParameters["Query"] is FetchExpression)
                    {
                        // Convert the query expression to FetchXML.
                        var conversionBackRequest = new QueryExpressionToFetchXmlRequest
                        {
                            Query = objQueryExpression
                        };
                        var conversionBackResponse =
                            (QueryExpressionToFetchXmlResponse)service.Execute(conversionBackRequest);

                        // Use the converted query to set FetchXML back
                        var fetchQuery = new FetchExpression(conversionBackResponse.FetchXml);
                        objFetchExpression.Query = fetchQuery.Query;
                    }
                }

            }
        }

        private bool UserHasRole(Guid userId, string _roleName, IOrganizationService service, ITracingService tracingService)
        {

            Boolean isUserInRole = false;

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
                        Values = {_roleName}
                    }
                }
                }
            };

            // Get the role.
            EntityCollection givenRoles = service.RetrieveMultiple(query);

            if (givenRoles.Entities.Count > 0)
            {
                Entity givenRole = givenRoles.Entities[0];
                tracingService.Trace("Checking association between user and role.");
                // Establish a SystemUser link for a query.
                LinkEntity systemUserLink = new LinkEntity()
                {
                    LinkFromEntityName = "systemuserroles",
                    LinkFromAttributeName = "systemuserid",
                    LinkToEntityName = "systemuser",
                    LinkToAttributeName = "systemuserid",
                    LinkCriteria =
                {
                    Conditions =
                    {
                        new ConditionExpression(
                            "systemuserid", ConditionOperator.Equal,userId)
                    }
                }
                };

                // Build the query.
                QueryExpression linkQuery = new QueryExpression()
                {
                    EntityName = "role",
                    ColumnSet = new ColumnSet("roleid"),
                    LinkEntities =
                {
                    new LinkEntity()
                    {
                        LinkFromEntityName ="role",
                        LinkFromAttributeName = "roleid",
                        LinkToEntityName = "systemuserroles",
                        LinkToAttributeName = "roleid",
                        LinkEntities = {systemUserLink}
                    }
                },
                    Criteria =
                {
                    Conditions =
                    {
                        new ConditionExpression("roleid", ConditionOperator.Equal, givenRole.Id)
                    }
                }
                };

                // Retrieve matching roles.
                EntityCollection matchEntities = service.RetrieveMultiple(linkQuery);

                // if an entity is returned then the user is a member
                // of the role
                isUserInRole = (matchEntities.Entities.Count > 0);

            }

            return isUserInRole;
        }
        private Guid GetTeamByName(string teamName, IOrganizationService service, ITracingService tracingservice)
        {
            Guid TeamId = Guid.Empty;

            using (var orgContext = new OrganizationServiceContext(service))
            {
                var query = from myTeam in orgContext.CreateQuery("team")
                            where (string)myTeam["name"] == teamName
                            select myTeam;

                if (query.ToList().Count() > 0)
                {
                    TeamId = query.ToList().FirstOrDefault().Id;
                    tracingservice.Trace($"Find team by name { teamName }  Guid : { TeamId.ToString()}");
                }
                else
                {
                    tracingservice.Trace($"Cannot find team by name { teamName }");
                }
            }

            return TeamId;
        }
        public bool UserIsTeamMember(string teamName, Guid userId, IOrganizationService service)
        {
            QueryExpression query = new QueryExpression("team");
            query.ColumnSet = new ColumnSet("teamid");
            query.Criteria.AddCondition(new ConditionExpression("name", ConditionOperator.Equal, teamName));
            LinkEntity link = query.AddLink("teammembership", "teamid", "teamid");
            link.LinkCriteria.AddCondition(new ConditionExpression("systemuserid", ConditionOperator.Equal, userId));
            var results = service.RetrieveMultiple(query);

            if (results.Entities.Count > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

    }
}
