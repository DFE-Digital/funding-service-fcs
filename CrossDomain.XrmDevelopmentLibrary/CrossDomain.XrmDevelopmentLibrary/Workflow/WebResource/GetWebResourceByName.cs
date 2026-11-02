// <copyright file="GetWebResourceByName.cs" company="">
// Copyright (c) 2015 All Rights Reserved
// </copyright>
// <author></author>
// <date>5/20/2015 5:49:20 PM</date>
// <summary>Implements the GetWebResourceByName Workflow Activity.</summary>
namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.WebResource
{
    using System;
    using System.Activities;
    using System.Linq;
    using System.ServiceModel;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;
    using Microsoft.Xrm.Sdk.Workflow;

    public sealed class GetWebResourceByName : CodeActivity
    {
        [RequiredArgument]
        [Input("Web Resource Name")]
        public InArgument<string> InputWebResourceName { get; set; }

        [Output("WebResource Reference")]
        [ReferenceTarget("sfa_webserviceresource")]
        public OutArgument<EntityReference> OutputWebResource { get; set; }

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

            tracingService.Trace(
                "Entered GetWebResourceByName.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}",
                executionContext.ActivityInstanceId,
                executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException(OperationStatus.Retry, "Failed to retrieve workflow context.");
            }

            tracingService.Trace("GetWebResourceByName.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            IOrganizationServiceFactory serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var trans = from t in xrmContext.CreateQuery("sfa_webserviceresource")
                                where (string)t["sfa_name"] == this.InputWebResourceName.Get(executionContext)
                                select t.Id;
                    if (trans.ToList().Count() != 1)
                    {
                        throw new InvalidPluginExecutionException("The required Web Resource is not present in Dynamics CRM");
                    }

                    this.OutputWebResource.Set(executionContext, new EntityReference("sfa_webserviceresource", trans.First()));
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                // Handle the exception.
                throw;
            }

            tracingService.Trace("Exiting GetWebResourceByName.Execute(), Correlation Id: {0}", context.CorrelationId);
        }
    }
}