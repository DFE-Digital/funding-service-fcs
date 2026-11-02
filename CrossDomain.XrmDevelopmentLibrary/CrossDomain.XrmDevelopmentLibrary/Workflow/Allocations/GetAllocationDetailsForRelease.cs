// <summary>Detail of Allocations planned for Release -Based on Funding Type and Funding Period selected</summary>
namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Allocations
{
    using System.Activities;
    using System.Collections.Generic;
    using System.Linq;
    using System.ServiceModel;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;
    using Microsoft.Xrm.Sdk.Workflow;

    public sealed class GetAllocationDetailsForRelease : CodeActivity
    {

	    [RequiredArgument]
        [Input("Funding Type")]
        [ReferenceTarget("sfa_fundingtype")]
        public InArgument<EntityReference> InputFundingType { get; set; }
		
		[RequiredArgument]
        [Input("Funding Period")]
        [ReferenceTarget("sfa_period")]
        public InArgument<EntityReference> InputFundingPeriod { get; set; }

		[Output("Count")]
		[Default("0")]
        public OutArgument<int> OutputCount { get; set; }
		
		[Output("Value")]
		[Default("0.00")]
        public OutArgument<decimal> OutputValue { get; set; }

		private const int PreRelease = 229660000;
		private const int ReadyForRelease = 229660001;


        protected override void Execute(CodeActivityContext executionContext)
        {
            // Create the tracing service
            ITracingService tracingService = executionContext.GetExtension<ITracingService>();

            if (tracingService == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve tracing service.");
            }

            tracingService.Trace("Entered GetAllocationDetailsForRelease.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("GetAllocationDetailsForRelease.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            IOrganizationServiceFactory serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
					decimal totalValue = 0;
                    List<Entity> allocations = (from a in xrmContext.CreateQuery("sfa_allocation")
                                                where a.GetAttributeValue<EntityReference>("sfa_fundingtype") == this.InputFundingType.Get(executionContext)
                                                && a.GetAttributeValue<EntityReference>("sfa_fundingperiod") == this.InputFundingPeriod.Get(executionContext)
                                                && a.GetAttributeValue<OptionSetValue>("sfa_status") == new OptionSetValue(PreRelease)
                                                && a.GetAttributeValue<OptionSetValue>("sfa_substatus") == new OptionSetValue(ReadyForRelease)
                                                select a).ToList();

                    totalValue = allocations.Sum(x => x.Contains("sfa_value") ? x.GetAttributeValue<decimal>("sfa_value") : 0m);
					
					//set output params
					OutputCount.Set(executionContext, allocations.Count);
					OutputValue.Set(executionContext, totalValue);
                }


            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.InnerException);
            }

            tracingService.Trace("Exiting GetAllocationDetailsForRelease.Execute(), Correlation Id: {0}", context.CorrelationId);
        }
    }
}