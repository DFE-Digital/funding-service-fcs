// <copyright file="GetCaseloadOwnerFromProvider.cs" company="Ciber">
// Copyright (c) 2015 All Rights Reserved
// </copyright>
// <author>Ali Rizvi</author>
// <date>4/8/2015 4:24:51 PM</date>
// <summary>Implements the GetCaseloadOwnerFromProvider Workflow Activity.</summary>
namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Contracts
{
    using System.Activities;
    using System.Linq;
    using System.ServiceModel;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;
    using Microsoft.Xrm.Sdk.Workflow;

    public sealed class GetCaseloadOwnerFromProvider : CodeActivity
    {
        private const string Owner = "ownerid";
        private const string Caseload = "sfa_caseload";

        [RequiredArgument]
        [Input("Provider")]
        [ReferenceTarget("account")]
        public InArgument<EntityReference> InputProvider { get; set; }

        [Output("Owner reference")]
        [ReferenceTarget("systemuser")]
        public OutArgument<EntityReference> OutputOwner { get; set; }

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
                "Entered GetCaseloadOwnerFromProvider.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}",
                executionContext.ActivityInstanceId,
                executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("GetCaseloadOwnerFromProvider.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            var serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            var service = serviceFactory.CreateOrganizationService(context.UserId);
            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var inputProvider = InputProvider.Get(executionContext);

                    tracingService.Trace("Entering GetCaseloadOwnerFromProvider.Execute(), Correlation Id: {0} Input Provider : {1}", context.CorrelationId, inputProvider);

                    if (inputProvider != null)
                    {
                        tracingService.Trace("Entering GetCaseloadOwnerFromProvider.Execute(), Correlation Id: {0} Input Provider : {1}", context.CorrelationId, inputProvider);

                        var trans = xrmContext
                            .CreateQuery(Caseload)
                            .FirstOrDefault(e => ((EntityReference)e["sfa_organisationid"]).Equals(inputProvider));

                        if (trans != null)
                        {
                            tracingService.Trace(
                                "Entering Get the owner, Correlation Id: {0} Input Provider : {1} Owner : {2}",
                                context.CorrelationId,
                                inputProvider,
                                trans.GetAttributeValue<EntityReference>(Owner).LogicalName);

                            OutputOwner.Set(executionContext, trans.GetAttributeValue<EntityReference>(Owner));
                        }
                    }

                    if (inputProvider == null)
                    {
                        tracingService.Trace("Input Provider is null");
                    }
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution - Message: " + e.Message + " Inner Exception: " + e.InnerException);
            }

            tracingService.Trace("Exiting GetCaseloadOwnerFromProvider.Execute(), Correlation Id: {0}", context.CorrelationId);
        }
    }
}