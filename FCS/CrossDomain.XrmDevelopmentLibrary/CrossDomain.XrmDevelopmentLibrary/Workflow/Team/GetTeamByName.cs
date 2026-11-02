
namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Team
{

    using System;
    using System.Activities;
    using System.Linq;
    using System.ServiceModel;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Workflow;
    using Microsoft.Xrm.Sdk.Client;
   
    public sealed class GetTeamByName : CodeActivity
    {
        [RequiredArgument]
        [Input("Team Name")]
        public InArgument<string> InputTransition { get; set; }

        [Output("Team Reference")]
        [ReferenceTarget("team")]
        public OutArgument<EntityReference> OutputTransition { get; set; }

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

            tracingService.Trace("Entered GetTeamByName.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("GetTeamByName.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            IOrganizationServiceFactory serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var teams = from t in xrmContext.CreateQuery("team")
                                where (string)t["name"] == this.InputTransition.Get(executionContext)
                                select t.Id;
                    if (teams.ToList().Count() != 1)
                    {
                        throw new InvalidPluginExecutionException("The required Team is not present in Dynamics CRM");
                    }

                    this.OutputTransition.Set(executionContext, new EntityReference("team", teams.First()));
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.InnerException);
            }

            tracingService.Trace("Exiting GetTeamByName.Execute(), Correlation Id: {0}", context.CorrelationId);
        }
    }
}
