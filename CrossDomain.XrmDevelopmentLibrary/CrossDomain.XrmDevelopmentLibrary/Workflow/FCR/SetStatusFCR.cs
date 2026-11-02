// <copyright file="GetStatusFromName.cs" company="">
// Copyright (c) 2015 All Rights Reserved
// </copyright>
// <author></author>
// <date>2/5/2015 3:13:10 PM</date>
// <summary>Implements the GetStatusFromName Workflow Activity.</summary>
namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Status
{
    using System.Activities;
    using System.Linq;
    using System.ServiceModel;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Workflow;
    using Microsoft.Xrm.Sdk.Client;
    using Microsoft.Xrm.Sdk.Query;
    using System;

    public sealed class SetStatusFCR : CodeActivity
    {

       

        [RequiredArgument]
        [Input("From Status")]
        [AttributeTarget("sfa_fundingclaimreconciliation", "sfa_statuscode")]
        public InArgument<OptionSetValue> FromStatus { get; set; }


        [RequiredArgument]
        [Input("From SubStatus")]
        [AttributeTarget("sfa_fundingclaimreconciliation", "sfa_substatus")]
        public InArgument<OptionSetValue> FromSubStatus { get; set; }

        [RequiredArgument]
        [Input("To Status")]
        [AttributeTarget("sfa_fundingclaimreconciliation", "sfa_statuscode")]
        public InArgument<OptionSetValue> ToStatus { get; set; }

        [RequiredArgument]
        [Input("To SubStatus")]
        [AttributeTarget("sfa_fundingclaimreconciliation", "sfa_substatus")]
        public InArgument<OptionSetValue> ToSubStatus { get; set; }


        private const string FCSSUPPORTTEAM = "FCS Support Team";
        private const string SYSTEMADMIN = "System Administrator";

        /// <summary>
        /// Executes the workflow activity.
        /// </summary>
        /// <param name="executionContext">The execution context.</param>
        protected override void Execute(CodeActivityContext executionContext)
        {
            // Create the tracing service
            ITracingService tracingService = executionContext.GetExtension<ITracingService>();

            if (tracingService == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve tracing service.");
            }

            tracingService.Trace("Entered GetStatusFromName.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("SetStatusFCR.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            IOrganizationServiceFactory serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);

            try
            {

              

                if (!UserHasRole(context.InitiatingUserId, SYSTEMADMIN, service, tracingService) && !UserIsTeamMember(FCSSUPPORTTEAM, context.InitiatingUserId, service,tracingService))
                {

                    tracingService.Trace("Not Admin or member of FCS Support Team");

                    // Handle the exception.
                    throw new InvalidPluginExecutionException("You don’t have the correct privilege to execute this workflow. You need to be assigned to FCS Support Team to complete this action.");

                }
                else
                {


                    using (var xrmContext = new OrganizationServiceContext(service))
                    {
                        tracingService.Trace("Get fcr status");

                        var fcr = xrmContext
                            .CreateQuery("sfa_fundingclaimreconciliation")
                            .FirstOrDefault(e => ((Guid)e["sfa_fundingclaimreconciliationid"]).Equals(context.PrimaryEntityId));

                        tracingService.Trace("Retrieve Successfully");

                        //check that the From values are similar to current state of FCR
                        if ((fcr.GetAttributeValue<OptionSetValue>("sfa_statuscode").Value != this.FromStatus.Get(executionContext).Value)|| 
                            (fcr.GetAttributeValue<OptionSetValue>("sfa_substatus").Value != this.FromSubStatus.Get(executionContext).Value))
                        {

                            tracingService.Trace("Current entity - Status:" + fcr.GetAttributeValue<OptionSetValue>("sfa_statuscode").Value+": Sub Status:"+ fcr.GetAttributeValue<OptionSetValue>("sfa_substatus").Value);
                            tracingService.Trace("Expected entity - Status:" + this.FromStatus.Get(executionContext).Value + ": Sub Status:" + this.FromSubStatus.Get(executionContext).Value);

                            throw new InvalidPluginExecutionException("You cannot execute this workflow against current status of this record.");
                        }
                        else
                        {

                            //update the status reason
                            var fcrupdate = new Entity("sfa_fundingclaimreconciliation");
                            fcrupdate["sfa_fundingclaimreconciliationid"] = context.PrimaryEntityId;

                            fcrupdate["sfa_statuscode"] = new OptionSetValue(this.ToStatus.Get(executionContext).Value);
                            fcrupdate["sfa_substatus"] = new OptionSetValue(this.ToSubStatus.Get(executionContext).Value);

                            service.Update(fcrupdate);


                        }


                    }
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.InnerException);
            }

           
        }


        private bool UserHasRole(Guid userId, string _roleName, IOrganizationService service, ITracingService tracingService)
        {
            tracingService.Trace("UserHasRole Method Started");

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
            tracingService.Trace("isUserInRole" + isUserInRole.ToString());
            return isUserInRole;
        }
   
        public bool UserIsTeamMember(string teamName, Guid userId, IOrganizationService service, ITracingService tracingService)
        {
            tracingService.Trace("UserIsTeamMember method started" );
            QueryExpression query = new QueryExpression("team");
            query.ColumnSet = new ColumnSet("teamid");
            query.Criteria.AddCondition(new ConditionExpression("name", ConditionOperator.Equal, teamName));
            LinkEntity link = query.AddLink("teammembership", "teamid", "teamid");
            link.LinkCriteria.AddCondition(new ConditionExpression("systemuserid", ConditionOperator.Equal, userId));
            var results = service.RetrieveMultiple(query);

            if (results.Entities.Count > 0)
            {
                tracingService.Trace("UserIsTeamMember :" + "True");
                return true;
            }
            else
            {
                tracingService.Trace("UserIsTeamMember :" + "False");
                return false;
            }
        }
    }
}
