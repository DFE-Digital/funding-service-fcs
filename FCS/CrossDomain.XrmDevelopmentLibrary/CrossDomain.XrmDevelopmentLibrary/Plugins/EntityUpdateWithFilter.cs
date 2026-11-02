using System;
using System.Linq;
using System.ServiceModel;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Client;
using Microsoft.Xrm.Sdk.Query;
using System.Collections.Generic;

namespace CrossDomain.XrmDevelopmentLibrary.Plugins
{
    public class EntityUpdateWithFilter : IPlugin
    {

        private List<string> filter = new List<string>();
        private string[] givenRoles = new string[] { "System Administrator" };

        /// <summary>
        /// This plugin is design to filter certain fields to prevent certain fields being updated by unauthorised user
        /// </summary>
        /// <param name="serviceProvider"></param>
        public void Execute(IServiceProvider serviceProvider)
        {

             filter.Add("sfa_reconciliationamount");
            // Obtain the execution context from the service provider.

            //Extract the tracing service for use in debugging sandboxed plug-ins.
            ITracingService tracingService =
                (ITracingService)serviceProvider.GetService(typeof(ITracingService));


            // Obtain the execution context from the service provider.
            IPluginExecutionContext context = (IPluginExecutionContext)
                serviceProvider.GetService(typeof(IPluginExecutionContext));

            // Obtain the organization service reference.
            IOrganizationServiceFactory serviceFactory =
                (IOrganizationServiceFactory)
                    serviceProvider.GetService(typeof(IOrganizationServiceFactory));
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);


            // The InputParameters collection contains all the data passed in the message request.
            if (context.InputParameters.Contains("Target") &&
                context.InputParameters["Target"] is Entity)
            {

                tracingService.Trace("ContractTransitionUpdateValidation started");
                // Obtain the target entity from the input parameters.
                Entity entity = (Entity)context.InputParameters["Target"];


                if (context.MessageName != "Update" || context.PrimaryEntityName != "sfa_fundingclaimreconciliation")
                { return; }
                else
                {
                    //Only system administrator and system customiser can bypass this filter
                    if (!IsUserInRoles(context.UserId, service, givenRoles, tracingService))
                    {
                        var fcr = service.Retrieve("sfa_fundingclaimreconciliation", context.PrimaryEntityId, new ColumnSet ( new string[] { "sfa_statuscode" }));

                        //only process record marked as 'published'

                        if (fcr.GetAttributeValue<OptionSetValue>("sfa_statuscode").Value != 229660001)
                        {
                            tracingService.Trace("context user Id : " + context.UserId);

                            //var removelist = entity.Attributes.Where(a => !filter.Contains(a.Key) && a.Key != "sfa_fundingclaimreconciliationid").ToList();

                            //foreach (var item in removelist)
                            //{
                            //    entity.Attributes.Remove(item.Key);
                            //}
                        }
                        else
                        {
                            throw new InvalidPluginExecutionException("Cannot update this Funding Claim Reconciliation since it is in 'PUBLISHED' status");
                        }
                    }

                  
                }


            }
        }

        #region Obselete - it will be repaced by field level security

        private Boolean IsUserInRoles(Guid userId, IOrganizationService service, string[] _givenRoles, ITracingService tracingService)
        {
            Boolean isUserInRole = false;

            foreach (string _givenRole in _givenRoles)
            {

                // Find a role.
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

                EntityCollection givenRoles = service.RetrieveMultiple(query);


                if (givenRoles.Entities.Count > 0)
                {
                    var givenRole = givenRoles.Entities[0];

                    tracingService.Trace(_givenRole + " - Role Id :" + givenRole.Id.ToString());


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
                            "systemuserid", ConditionOperator.Equal, userId)
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
                        LinkFromEntityName = "role",
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

                    if (isUserInRole)
                    {
                        return isUserInRole;
                    }
                }
             
            }

            return isUserInRole;

            
        }

        #endregion 
    }

}
