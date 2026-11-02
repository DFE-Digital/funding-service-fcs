// <summary>Release Allocations Based on Funding Type and Funding Period</summary>
namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Allocations
{
    using System;
    using System.Activities;
    using System.Linq;
    using System.ServiceModel;
    using Microsoft.Crm.Sdk.Messages;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;
    using Microsoft.Xrm.Sdk.Workflow;

    public sealed class ReleaseConditionBasedAllocations : CodeActivity
    {

	    [RequiredArgument]
        [Input("Funding Type")]
        [ReferenceTarget("sfa_fundingtype")]
        public InArgument<EntityReference> InputFundingType { get; set; }
		
		[RequiredArgument]
        [Input("Funding Period")]
        [ReferenceTarget("sfa_period")]
        public InArgument<EntityReference> InputFundingPeriod { get; set; }

        [RequiredArgument]
        [Input("Funding Type Period")]
        [ReferenceTarget("sfa_fundingtypefundingperiod")]
        public InArgument<EntityReference> InputFundingTypePeriod { get; set; }

		private const int PreRelease = 229660000;
		private const int ReadyForRelease = 229660001;
		private const int InitiateRelease = 229660002;
        private Guid _workflowId = new Guid("d35519fc-827f-4a37-b017-882e6005d68d");


        protected override void Execute(CodeActivityContext executionContext)
        {
            // Create the tracing service
            ITracingService tracingService = executionContext.GetExtension<ITracingService>();

            if (tracingService == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve tracing service.");
            }

            tracingService.Trace("Entered ReleaseConditonBasedAllocations.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("ReleaseConditonBasedAllocations.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            IOrganizationServiceFactory serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var allocations = (from a in xrmContext.CreateQuery("sfa_allocation")
                                      where a.GetAttributeValue<EntityReference>("sfa_fundingtype") == this.InputFundingType.Get(executionContext)
                                      &&  a.GetAttributeValue<EntityReference>("sfa_fundingperiod") == this.InputFundingPeriod.Get(executionContext)
                                      &&  a.GetAttributeValue<OptionSetValue>("sfa_status") == new OptionSetValue(PreRelease)
									  &&  a.GetAttributeValue<OptionSetValue>("sfa_substatus") == new OptionSetValue(ReadyForRelease)
                                      select a).ToList();

                    if (allocations.Count > 0)
                    {
						foreach (Entity alloc in allocations)
						{
							var updatedAlloc = new Entity("sfa_allocation");
							updatedAlloc.Id = alloc.Id;
							updatedAlloc["sfa_action"] = new OptionSetValue(InitiateRelease);
							service.Update(updatedAlloc);
						}

                        EntityReference fundingTypePeriod = this.InputFundingTypePeriod.Get(executionContext);
                        // ExecuteWorkflow request for the Release process
                        ExecuteWorkflowRequest request = new ExecuteWorkflowRequest()
                        {
                            WorkflowId = _workflowId,
                            EntityId = fundingTypePeriod.Id
                        };
                        // Execute the workflow.
                        ExecuteWorkflowResponse response = (ExecuteWorkflowResponse)service.Execute(request);

                    }
                }

            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.InnerException);
            }

            tracingService.Trace("Exiting ReleaseConditonBasedAllocations.Execute(), Correlation Id: {0}", context.CorrelationId);
        }
    }
}