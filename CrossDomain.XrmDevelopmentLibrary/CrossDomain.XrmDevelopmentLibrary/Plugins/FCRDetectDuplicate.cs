using System;
using System.Linq;
using System.ServiceModel;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Client;
using Microsoft.Xrm.Sdk.Query;
using System.Collections.Generic;

namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Plugins
{
    public class FCRDetectDuplicate : IPlugin
    {

        /// <summary>
        /// This plugin is design to execute a pre-operation duplicate check for the FCR entity 
        /// stage - Preoperationn
        /// entity - sfa_fundingclaimreconciliation
        /// message - create
        /// </summary>
        /// <param name="serviceProvider"></param>
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

            try
            {
                // The InputParameters collection contains all the data passed in the message request.
                if (context.InputParameters.Contains("Target") &&
                context.InputParameters["Target"] is Entity)
                {

                    tracingService.Trace("FCRCreateDetectDuplicate started");
                    // Obtain the target entity from the input parameters.
                    Entity entity = (Entity)context.InputParameters["Target"];


                    if (context.MessageName != "Create" || entity.LogicalName != "sfa_fundingclaimreconciliation")
                    { return; }
                    else
                    {
                        //get fundingclaimreconcilation records to verify for duplicates
                    
                        using (var orgContext = new OrganizationServiceContext(service))
                        {
                            var claimType = entity.GetAttributeValue<EntityReference>("sfa_claimtypeid");
                            var fundingPeriod = entity.GetAttributeValue<EntityReference>("sfa_fundingperiodid");
                            var allocationGroup = entity.GetAttributeValue<EntityReference>("sfa_allocationgroupid");
                            var provider = entity.GetAttributeValue<EntityReference>("sfa_providerid");
                            Entity fcr;

                            if (claimType != null && fundingPeriod != null && allocationGroup != null && provider != null)
                            {
                                var query = from f in orgContext.CreateQuery("sfa_fundingclaimreconciliation")
                                            where f.GetAttributeValue<EntityReference>("sfa_claimtypeid").Equals(claimType.Id)
                                            && f.GetAttributeValue<EntityReference>("sfa_fundingperiodid").Equals(fundingPeriod.Id)
                                            && f.GetAttributeValue<EntityReference>("sfa_allocationgroupid").Equals(allocationGroup.Id)
                                            && f.GetAttributeValue<EntityReference>("sfa_providerid").Equals(provider.Id)
                                            select f;
                                fcr = query.FirstOrDefault();
                            }
                            else
                            {
                                throw new InvalidPluginExecutionException(OperationStatus.Canceled, "Cannot Create the Funding Claim Reconciliation since not all required fields of Claim Type, Funding Period, Allocation Group and Provider are provided.");
                            }


                            if (fcr != null)
                            {
                                    throw new InvalidPluginExecutionException(OperationStatus.Canceled, "Cannot Create the Funding Claim Reconciliation since a similar record with the same Claim Type, Funding Period, Allocation Group and Provider already exists.");
                            }

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
    }
}
