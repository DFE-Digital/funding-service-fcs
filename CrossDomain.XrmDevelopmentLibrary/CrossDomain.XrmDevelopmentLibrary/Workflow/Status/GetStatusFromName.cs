// <copyright file="GetStatusFromName.cs" company="">
// Copyright (c) 2015 All Rights Reserved
// </copyright>
// <author></author>
// <date>2/5/2015 3:13:10 PM</date>
// <summary>Implements the GetStatusFromName Workflow Activity.</summary>
namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Status
{
    using System.Activities;
    using System.Linq;
    using System.ServiceModel;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Workflow;
    using Microsoft.Xrm.Sdk.Client;

    public sealed class GetStatusFromName : CodeActivity
    {
        [RequiredArgument]
        [Input("Status Name")]
        public InArgument<string> InputStatus { get; set; }

        [Output("Status Reference")]
        [ReferenceTarget("sfa_status")]
        public OutArgument<EntityReference> OutputStatus { get; set; }

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

            tracingService.Trace("Entered GetStatusFromName.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("GetStatusFromName.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            IOrganizationServiceFactory serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);
           
            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var status = from t in xrmContext.CreateQuery("sfa_status")
                              where (string)t["sfa_name"] == this.InputStatus.Get(executionContext)
                              select t.Id;
                    if (status.ToList().Count() != 1)
                    {
                        throw new InvalidPluginExecutionException("The required Status is not present in Dynamics CRM");
                    }

                    this.OutputStatus.Set(executionContext, new EntityReference("sfa_status", status.First()));
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.InnerException);
            }

            tracingService.Trace("Exiting GetStatusFromName.Execute(), Correlation Id: {0}", context.CorrelationId);
        }
    }
}