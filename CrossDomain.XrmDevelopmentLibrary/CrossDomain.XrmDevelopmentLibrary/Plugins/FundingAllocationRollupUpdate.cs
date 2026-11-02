using System;
using Microsoft.Xrm.Sdk;
using Microsoft.Crm.Sdk.Messages;
using System.ServiceModel;

namespace CrossDomain.XrmDevelopmentLibrary.Plugins
{
    public class FundingAllocationRollupUpdate : IPlugin
    {

        private const string FundingAllocReleaseGroup = "sfa_releasegroup";
        private const string AllocationCount = "sfa_associatedcount";
        private const string AllocationValue = "sfa_associatedvalue";

        /// <summary>
        /// 
        /// </summary>
        public void Execute(IServiceProvider serviceProvider)
        {
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
            if (context.InputParameters.Contains("Target"))
            {
                try
                {

                    tracingService.Trace("FundingAllocationRollupUpdate started");

                    EntityReference releaseGroup = null;
                    EntityReference preReleaseGroup = null;

                    if (context.MessageName.ToLower() == "delete")
                    {
                        Entity PreDeleteImage = (Entity)context.PreEntityImages["PreDeleteImage"];
                        releaseGroup = PreDeleteImage.GetAttributeValue<EntityReference>(FundingAllocReleaseGroup);

                    }
                    else 
                    {
                        // Obtain the target entity from the input parameters.
                        Entity entity = (Entity)context.InputParameters["Target"];
                        if (entity.Contains(FundingAllocReleaseGroup))
                        {
                            Entity PostUpdateImage = (Entity)context.PostEntityImages["PostUpdateImage"];
                            releaseGroup = PostUpdateImage.GetAttributeValue<EntityReference>(FundingAllocReleaseGroup);
                            if (context.MessageName.ToLower() == "update")
                            {
                                Entity PreUpdateImage = (Entity)context.PreEntityImages["PreUpdateImage"];
                                preReleaseGroup = PreUpdateImage.GetAttributeValue<EntityReference>(FundingAllocReleaseGroup);
                            }
                        }
                    }

                    if (releaseGroup != null)
                    {
                        
                        var calculateVALUERequest = new CalculateRollupFieldRequest { Target = releaseGroup, FieldName = AllocationValue };
                        var calculateVALUEResult = (CalculateRollupFieldResponse)service.Execute(calculateVALUERequest);

                        var calculateSUMRequest = new CalculateRollupFieldRequest { Target = releaseGroup, FieldName = AllocationCount };
                        var calculateSUMResult = (CalculateRollupFieldResponse)service.Execute(calculateSUMRequest);

                    }
                    if (preReleaseGroup != null)
                    {

                        var calculateVALUERequest = new CalculateRollupFieldRequest { Target = preReleaseGroup, FieldName = AllocationValue };
                        var calculateVALUEResult = (CalculateRollupFieldResponse)service.Execute(calculateVALUERequest);

                        var calculateSUMRequest = new CalculateRollupFieldRequest { Target = preReleaseGroup, FieldName = AllocationCount };
                        var calculateSUMResult = (CalculateRollupFieldResponse)service.Execute(calculateSUMRequest);

                    }

                }
                catch (FaultException<OrganizationServiceFault> e)
                {
                    // Handle the exception.
                    throw new InvalidPluginExecutionException("Error on plugin execution: " + e.Message);
                }
            }
        }


    }
}