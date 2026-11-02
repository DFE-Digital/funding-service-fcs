// <copyright file="CallContractManagementService.cs" company="">
// Copyright (c) 2015 All Rights Reserved
// </copyright>
// <author></author>
// <date>5/19/2015 2:39:50 PM</date>
// <summary>Implements the CallContractManagementService Workflow Activity.</summary>
namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow
{
    using System;
    using System.Activities;
    using System.Linq;
    using System.Net;
    using System.Net.Http.Headers;
    using System.ServiceModel;
    using System.Web;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;
    using Microsoft.Xrm.Sdk.Workflow;

    public sealed class CallContractManagementService : CodeActivity
    {
        [RequiredArgument]
        [Input("Web Service URI")]
        public InArgument<string> InputWebServiceUri { get; set; }

        [Output("Calling Service URL")]
        public OutArgument<string> OutUrlString { get; set; }

        [Output("Response")]
        public OutArgument<string> OutResponse { get; set; }

        [Output("Error Response")]
        public OutArgument<string> OutErrorArgument { get; set; }

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

            tracingService.Trace("Entered CallContractManagementService.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("CallContractManagementService.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            //TODO: Provide a better solution to this - removing this class from the assembly will cause all CRM workflows that use custom assemblies to be re-created
            throw new NotImplementedException("This component for this service has been moved to a new assembly");
        }
    }
}