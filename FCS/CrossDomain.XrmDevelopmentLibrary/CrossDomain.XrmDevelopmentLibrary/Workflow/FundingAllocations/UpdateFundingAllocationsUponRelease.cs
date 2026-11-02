// <summary>Update Funding Allocations Status(via Intent) based on Release Group change</summary>
namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.FundingAllocations
{
    using System.Activities;
    using System.Linq;
    using System.ServiceModel;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;
    using Microsoft.Xrm.Sdk.Workflow;

    public sealed class UpdateFundingAllocationsUponRelease : CodeActivity
    {

        [RequiredArgument]
        [Input("Release Group Reference")]
        [ReferenceTarget("sfa_releasegroup")]
        public InArgument<EntityReference> InputReleaseGroup { get; set; }

        [RequiredArgument]
        [Input("Intent")]
        public InArgument<string> InputIntent { get; set; }


        protected override void Execute(CodeActivityContext executionContext)
        {
            // Create the tracing service
            ITracingService tracingService = executionContext.GetExtension<ITracingService>();
            string inputIntent = this.InputIntent.Get(executionContext);

            if (tracingService == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve tracing service.");
            }

            tracingService.Trace("Entered UpdateAllocationsUponRelease.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("UpdateAllocationsUponRelease.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            IOrganizationServiceFactory serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {


                    var fundingAllocations = (from a in xrmContext.CreateQuery("sfa_fundingallocation")
                                              where a.GetAttributeValue<EntityReference>("sfa_releasegroup") == this.InputReleaseGroup.Get(executionContext)
                                              select a).ToList();

                    if (fundingAllocations.Count > 0)
                    {
                        foreach (Entity alloc in fundingAllocations)
                        {
                            var updatedFundingAlloc = new Entity("sfa_fundingallocation");
                            updatedFundingAlloc.Id = alloc.Id;
                            updatedFundingAlloc["sfa_intent"] = inputIntent;
                            service.Update(updatedFundingAlloc);

                        }

                    }
                }

            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.Message);
            }

            tracingService.Trace("Exiting UpdateAllocationsUponRelease.Execute(), Correlation Id: {0}", context.CorrelationId);
        }
    }
}