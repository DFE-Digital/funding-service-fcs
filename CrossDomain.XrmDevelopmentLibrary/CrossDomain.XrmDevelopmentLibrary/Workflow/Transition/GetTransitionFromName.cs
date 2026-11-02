// <copyright file="GetTransitionFromName.cs" company="">
// Copyright (c) 2015 All Rights Reserved
// </copyright>
// <author></author>
// <date>2/5/2015 3:13:10 PM</date>
// <summary>Implements the GetTransitionFromName Workflow Activity.</summary>
namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Transition
{
    using System;
    using System.Activities;
    using System.Linq;
    using System.ServiceModel;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Workflow;
    using Microsoft.Xrm.Sdk.Client;
    using SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Common;

    public sealed class GetTransitionFromName : CodeActivity
    {
        [RequiredArgument]
        [Input("Transition Name")]
        public InArgument<string> InputTransition { get; set; }

        [Output("Transition Reference")]
        [ReferenceTarget("sfa_transition")]
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

            tracingService.Trace("Entered GetTransitionFromName.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("GetTransitionFromName.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            IOrganizationServiceFactory serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);
           
            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var trans = from t in xrmContext.CreateQuery("sfa_transition")
                              where (string)t["sfa_name"] == this.InputTransition.Get(executionContext)
                              select t.Id;
                    if (trans.ToList().Count() != 1)
                    {
                        throw new InvalidPluginExecutionException("The required transition is not present in Dynamics CRM");
                    }

                    this.OutputTransition.Set(executionContext, new EntityReference("sfa_transition", trans.First()));
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.InnerException);
            }

            tracingService.Trace("Exiting GetTransitionFromName.Execute(), Correlation Id: {0}", context.CorrelationId);
        }
    }
}