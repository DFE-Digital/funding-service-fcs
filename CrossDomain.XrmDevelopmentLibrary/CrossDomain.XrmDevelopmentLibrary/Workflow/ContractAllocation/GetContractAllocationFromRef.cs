// <copyright file="GetStatusFromName.cs" company="">
// Copyright (c) 2015 All Rights Reserved
// </copyright>
// <author></author>
// <date>2/5/2015 3:13:10 PM</date>
// <summary>Implements the GetStatusFromName Workflow Activity.</summary>
namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.ContractAllocation
{
    using System;
    using System.Activities;
    using System.Linq;
    using System.ServiceModel;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;
    using Microsoft.Xrm.Sdk.Workflow;

    public sealed class GetContractAllocationFromReference : CodeActivity
    {
        private const string ContractAllocation = "sfa_contractallocation";
        private const string Contract = "sfa_contract";

        [RequiredArgument]
        [Input("Allocation Reference")]
        public InArgument<string> InputAllocation { get; set; }

        [Output("Allocation")]
        [ReferenceTarget(ContractAllocation)]
        public OutArgument<EntityReference> OutputAllocation { get; set; }

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
                    var allocation = (from a in xrmContext.CreateQuery(ContractAllocation)
                                      join c in xrmContext.CreateQuery(Contract) on a.GetAttributeValue<EntityReference>("sfa_contractid").Id equals c.GetAttributeValue<Guid>("sfa_contractid")
                                      where a.GetAttributeValue<string>("sfa_contractallocationnumber") == this.InputAllocation.Get(executionContext)
                                      where c.GetAttributeValue<bool>("sfa_latestversion")
                                      orderby a.GetAttributeValue<DateTime>("createdon") descending
                                 select a.Id).FirstOrDefault();

                    if (allocation == Guid.Empty)
                    {
                        throw new InvalidPluginExecutionException("The required Contract Allocation is not present in Dynamics CRM");
                    }

                    this.OutputAllocation.Set(executionContext, new EntityReference(ContractAllocation, allocation));
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.InnerException);
            }

            tracingService.Trace("Exiting GetContractAllocationFromReference.Execute(), Correlation Id: {0}", context.CorrelationId);
        }
    }
}