// <summary>Echo Contract Task Owner for use within Workflow-CRM 2013</summary>
using System.Activities;
using System.ServiceModel;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Workflow;

namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Contracts
{

    public sealed class EchoContractTaskOwner: CodeActivity
    {
        [RequiredArgument]
        [Input("Task Owner")]
        [ReferenceTarget("systemuser")]
        public InArgument<EntityReference> InputTaskOwner { get; set; }

        [Output("Original Task Owner")]
        [ReferenceTarget("systemuser")]
        public OutArgument<EntityReference> OriginalTaskOwner { get; set; }

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

            tracingService.Trace("Entered EchoContractTaskOwner.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

           // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();
            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            try
            {
                    EntityReference contractTaskOwner = InputTaskOwner.Get<EntityReference>(executionContext);

                    if (contractTaskOwner == null)
                    {
                        throw new InvalidPluginExecutionException("The was an error getting the input Contract Task Owner");
                    }

                    OriginalTaskOwner.Set(executionContext, contractTaskOwner);
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