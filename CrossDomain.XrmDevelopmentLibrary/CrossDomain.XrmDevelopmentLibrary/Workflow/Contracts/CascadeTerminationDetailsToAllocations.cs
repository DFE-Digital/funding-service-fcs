// <file="CascadeTerminationDetailsToAllocations.cs" >
// <summary>Cascade the Termination Details entered on Contract to related child allocations</summary>

using System;
using System.Activities;
using System.Linq;
using System.ServiceModel;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Client;
using Microsoft.Xrm.Sdk.Workflow;


namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Contracts
{
    public class CascadeTerminationDetailsToAllocations : CodeActivity
    {
        [RequiredArgument]
        [Input("Contract Reference")]
        [ReferenceTarget("sfa_contract")]
        public InArgument<EntityReference> InputContract { get; set; }

        [Input("Termination Date")]
        public InArgument<DateTime> InputTerminationDate { get; set; }

        [Input("Stop New Starts Date")]
        public InArgument<DateTime> StopNewStartsDate { get; set; }

        protected override void Execute(CodeActivityContext executionContext)
        {
             // Create the tracing service
            ITracingService tracingService = executionContext.GetExtension<ITracingService>();
            
            if (tracingService == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve tracing service.");
            }

            tracingService.Trace("Entered CascadeTerminationDetailsToAllocations.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("CascadeTerminationDetailsToAllocations.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            IOrganizationServiceFactory serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);
           
            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var contractAllocations = (from t in xrmContext.CreateQuery("sfa_contractallocation")
                        where  t["sfa_contractid"] == this.InputContract.Get(executionContext)
                              select t).ToList();

                    if (contractAllocations.Count > 0 )
                    {
                        var inputTerminationDate = (DateTime)this.InputTerminationDate.Get(executionContext);
                        var stopNewStartsDate = (DateTime)this.StopNewStartsDate.Get(executionContext);
                        foreach (Entity ca in contractAllocations)
                        {
                            DateTime allocationEndDate = ca.GetAttributeValue<DateTime>("sfa_enddate");
                            var contractAllocation = new Entity("sfa_contractallocation");
                            contractAllocation.Id = ca.Id;

                            if (inputTerminationDate != DateTime.MinValue)
                            {
                                //Any contract allocation's Termination Date must not be later than the allocation's End Date
                                if ((allocationEndDate != DateTime.MinValue) && (DateTime.Compare(inputTerminationDate, allocationEndDate) > 0))
                                {
                                    contractAllocation["sfa_inflightterminationdate"] = allocationEndDate;
                                }
                                else
                                {
                                    contractAllocation["sfa_inflightterminationdate"] = inputTerminationDate;
                                }
                            }
                            if (stopNewStartsDate != DateTime.MinValue)
                            {
                                //Any contract allocation's Stop New Starts Date must not be later than the Termination Date
                                if ((allocationEndDate != DateTime.MinValue) && (DateTime.Compare(stopNewStartsDate, allocationEndDate) > 0))
                                {
                                    contractAllocation["sfa_inflightstopnewstartsdate"] = allocationEndDate;
                                }
                                else
                                {
                                    contractAllocation["sfa_inflightstopnewstartsdate"] = stopNewStartsDate;
                                }
                            }
                            service.Update(contractAllocation);
                        }
                    }

                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.InnerException);
            }

            tracingService.Trace("CascadeTerminationDetailsToAllocations.Execute(), Correlation Id: {0}", context.CorrelationId);
        }
    }
}

