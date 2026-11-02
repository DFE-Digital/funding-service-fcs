using System;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Query;
using System.Linq;
using Microsoft.Xrm.Sdk.Client;
using System.Collections.Generic;
using Microsoft.Crm.Sdk.Messages;

namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Plugins
{
    public class FCRAllocationQueryWithAddedFilter : IPlugin
    {

        /// <summary>
        /// Add additional query to View by checking Publication Close Dates
        /// </summary>
        /// 
        private const string SPECIALCONDITION = "PreviousClaimCollection";
        private const string BLOCKDEFAULTCONDITION = "CurrentClaimCollection";
        public void Execute(IServiceProvider serviceProvider)
        {

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
            // Check that all of the following conditions are true:
            //  1. plug-in is running synchronously
            //  3. plug-in is running on the 'RetrieveMultiple' event
            if (context.Mode == 0 && context.MessageName.Equals("RetrieveMultiple"))
            {

                tracingService.Trace("FCRAllocationQueryWithAddedFilter started");

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

                    if (objQueryExpression.EntityName == "sfa_fcrallocation" && objQueryExpression.Criteria != null && objQueryExpression.Criteria.Conditions != null)
                        {

                            ConditionExpression[] condns = objQueryExpression.Criteria.Conditions.ToArray();
                            foreach (var condn in condns)
                            {
                                if ((condn.AttributeName.Contains("sfa_name")) && ((string)condn.Values.FirstOrDefault() == SPECIALCONDITION) && (condn.Operator.Equals(ConditionOperator.NotEqual)))
                                {
                                    List<Entity> configData = getConfigList(service);
                                    LinkEntity fcr = new LinkEntity("sfa_fcrallocation", "sfa_fundingclaimreconciliation", "sfa_fundingclaimreconciliationid", "sfa_fundingclaimreconciliationid", JoinOperator.Inner);
                                    FilterExpression filter = new FilterExpression(LogicalOperator.Or);

                                    if (configData.Count > 0)
                                    {
                                        foreach (Entity cfgdata in configData)
                                        {
                                            EntityReference claimType = cfgdata.GetAttributeValue<EntityReference>("sfa_claimtype");
                                            EntityReference fundingPeriod = cfgdata.GetAttributeValue<EntityReference>("sfa_fundingperiod");
                                            EntityReference claimAllocGroup = cfgdata.GetAttributeValue<EntityReference>("sfa_allocationgroup");
                                            FilterExpression addnlfilter = new FilterExpression(LogicalOperator.And);
                                            addnlfilter.Conditions.Add(new ConditionExpression("sfa_claimtypeid", ConditionOperator.Equal, claimType.Id));
                                            addnlfilter.Conditions.Add(new ConditionExpression("sfa_fundingperiodid", ConditionOperator.Equal, fundingPeriod.Id));
                                            addnlfilter.Conditions.Add(new ConditionExpression("sfa_allocationgroupid", ConditionOperator.Equal, claimAllocGroup.Id));
                                            filter.AddFilter(addnlfilter);
                                        }
                                    }
                                    else
                                    {
                                        //added to filter any default records
                                        FilterExpression addnlfilter = new FilterExpression(LogicalOperator.And);
                                        addnlfilter.Conditions.Add(new ConditionExpression("sfa_name", ConditionOperator.Equal, BLOCKDEFAULTCONDITION));
                                        filter.AddFilter(addnlfilter);
                                    }
                                    //add filter
                                    fcr.LinkCriteria = filter;

                                    objQueryExpression.LinkEntities.Add(fcr);
                                }
                            }

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

        /// <summary>
        /// Query Claim Reconciliation Behaviour 
        /// </summary>
        /// <param name="service"></param>
        /// <returns></returns>
        private List<Entity> getConfigList(IOrganizationService service)
        {

            List<Entity> configdata = new List<Entity>();

            using (var xrmServiceContext = new OrganizationServiceContext(service))
            {
                //ADD days -1 to take care of BST
                configdata = (from cfg in xrmServiceContext.CreateQuery("sfa_claimreconciliationbehaviour")
                              where ((DateTime)cfg["sfa_publicationclosedate"] >= DateTime.Today.AddDays(-1))
                              select cfg).ToList();

            }

            return configdata;
        }

    }
}
