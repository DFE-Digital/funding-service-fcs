namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Organisations
{
    using System;
    using System.Activities;
    using System.ServiceModel;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;
    using Microsoft.Xrm.Sdk.Workflow;
    using Common;

    public sealed class ReassignChildTasksForOrganisation : CodeActivity
    {
        [RequiredArgument]
        [Input("Organisation")]
        [ReferenceTarget("account")]
        public InArgument<EntityReference> InputOrganisation { get; set; }

        [RequiredArgument]
        [Input("User")]
        [ReferenceTarget("systemuser")]
        public InArgument<EntityReference> InputSystemUser { get; set; }

        [Input("Team Filter")]
        public InArgument<string> InputTeam { get; set; }

        /// <summary>
        ///     Executes the workflow activity.
        /// </summary>
        /// <param name="executionContext">The execution context.</param>
        protected override void Execute(CodeActivityContext executionContext)
        {
            // Create the tracing service
            var tracingService = executionContext.GetExtension<ITracingService>();

            if (tracingService == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve tracing service.");
            }

            tracingService.Trace("Entered OrganisationAssignment.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            var context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("OrganisationAssignment.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            var serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            var service = serviceFactory.CreateOrganizationService(context.UserId);

            using (var xrmContext = new OrganizationServiceContext(service))
            {
                try
                {
                    var xrmHelpers = new XrmWorkflowActivityHelpers(xrmContext);

                    EntityReference teamRef = null;

                    if (InputTeam.Get(executionContext) != null)
                    {
                        teamRef = xrmHelpers.GetTeamReference(InputTeam.Get(executionContext));
                    }

                    xrmHelpers.ReAssignTasks(InputSystemUser.Get(executionContext), teamRef, InputOrganisation.Get(executionContext));
                }
                catch (FaultException<OrganizationServiceFault> e)
                {
                    tracingService.Trace("OrganizationServiceFaultException: {0}", e.ToString());

                    // Handle the exception.
                    throw new InvalidPluginExecutionException("An error occured re-assigning the tasks: InnerException: " + e.InnerException + " Message: " + e.Message, e);
                }
                catch (ArgumentNullException e)
                {
                    tracingService.Trace("ArgumentNullException: {0}", e.ToString());

                    // Handle the exception.
                    throw new InvalidPluginExecutionException("An error occured updating the tasks - Invalid Team", e);
                }

                tracingService.Trace("Exiting OrganisationAssignment.Execute(), Correlation Id: {0}", context.CorrelationId);
            }
        }
    }
}