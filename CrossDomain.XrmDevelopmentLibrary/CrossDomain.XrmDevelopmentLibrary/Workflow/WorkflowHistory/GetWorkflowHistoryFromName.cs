// <copyright file="GetWorkflowHistoryFromName.cs" company="">
// Copyright (c) 2015 All Rights Reserved
// </copyright>
// <author>Chris Turner</author>
// <date>12 Dec 2015</date>
// <summary>Implements the GetWorkflowHistoryFromName Workflow Activity.</summary>
namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.WorkflowHistory
{
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;
    using Microsoft.Xrm.Sdk.Workflow;
    using System;
    using System.Activities;
    using System.Linq;
    using System.ServiceModel;

    public sealed class GetWorkflowHistoryFromName : CodeActivity
    {
        [RequiredArgument]
        [Input("Contract Id")]
        [ReferenceTarget("sfa_contract")]
        [Default("00000000-0000-0000-0000-000000000000", "sfa_contract")]
        public InArgument<EntityReference> InputContract { get; set; }

        [RequiredArgument]
        [Input("Workflow History Name")]
        public InArgument<string> InputWorkflowHistory { get; set; }

        [Output("Workflow History Reference")]
        [ReferenceTarget("sfa_contracttransitionhistory")]
        public OutArgument<EntityReference> OutputWorkflowHistory { get; set; }

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

            tracingService.Trace("Entered GetWorkflowHistoryFromName.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("GetWorkflowHistoryFromName.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            IOrganizationServiceFactory serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var contract = this.InputContract.Get(executionContext);
                    var workflowHistoryName = this.InputWorkflowHistory.Get(executionContext);

                    var workflowHistoryQuery = from workflowHistory in xrmContext.CreateQuery("sfa_contracttransitionhistory")
                                               where (EntityReference)workflowHistory["sfa_contract"] == contract &&
                                                     (string)workflowHistory["sfa_name"] == workflowHistoryName
                                               select workflowHistory.Id;

                    var workflowHistories = workflowHistoryQuery.ToList();

                    if (workflowHistories == null)
                    {
                        throw new InvalidPluginExecutionException("The was an error querying Dynamics CRM");
                    }
                    else if (workflowHistories.Count().Equals(0))
                    {
                        throw new InvalidPluginExecutionException("The required workflow history record is not present in Dynamics CRM");
                    }
                    else if (workflowHistories.Count() > 1)
                    {
                        throw new InvalidPluginExecutionException(string.Format("There is more than one workflow history record in Dynamics CRM with the name {0}", workflowHistoryName));
                    }

                    this.OutputWorkflowHistory.Set(executionContext, new EntityReference("sfa_contracttransitionhistory", workflowHistories.First()));
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.InnerException);
            }

            tracingService.Trace("Exiting GetWorkflowHistoryFromName.Execute(), Correlation Id: {0}", context.CorrelationId);
        }
    }
}