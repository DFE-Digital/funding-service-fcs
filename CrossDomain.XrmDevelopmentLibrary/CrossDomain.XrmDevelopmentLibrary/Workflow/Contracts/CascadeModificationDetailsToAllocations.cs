// <file="CascadeModificationDetailsToAllocations.cs" >
// <summary>Cascade the Modification Details entered on Contract to related child allocations</summary>

using System;
using System.Activities;
using System.Linq;
using System.ServiceModel;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Client;
using Microsoft.Xrm.Sdk.Workflow;


namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Contracts
{
    public class CascadeModificationDetailsToAllocations : CodeActivity
    {
        [RequiredArgument]
        [Input("Contract Reference")]
        [ReferenceTarget("sfa_contract")]
        public InArgument<EntityReference> InputContract { get; set; }

        [Input("Cascade Date")]
        public InArgument<DateTime> InDate { get; set; }

        [Input("Cascade Reason")]
        public InArgument<int> InReason { get; set; }

        [RequiredArgument]
        [Input("Type")]
        public InArgument<string> InputType { get; set; }


        protected override void Execute(CodeActivityContext executionContext)
        {
            // Create the tracing service
            ITracingService tracingService = executionContext.GetExtension<ITracingService>();

            if (tracingService == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve tracing service.");
            }

            tracingService.Trace("Entered CascadeModificationDetailsToAllocations.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("CascadeModificationDetailsToAllocations.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            IOrganizationServiceFactory serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);

            try
            {
                EntityReference inpContract = this.InputContract.Get(executionContext);
                DateTime cascadeDate = (DateTime)this.InDate.Get(executionContext);
                if (cascadeDate != DateTime.MinValue)
                {
                    if (cascadeDate.Hour == 23) cascadeDate = cascadeDate.AddHours(1);
                }
                int cascadeReason = this.InReason.Get(executionContext);
                string requiredType = this.InputType.Get(executionContext);

                //intialise inflight data or finalise a per requirement
                if (requiredType == "Stop Starts Date")
                {
                    CascadeStopStartsDate(service, inpContract, cascadeDate);
                }
                else if (requiredType == "New Starts Suspended Reason")
                {
                    CascadeNewStartsSuspendedReason(service, inpContract, cascadeReason);
                }
                else if (requiredType == "Termination Date")
                {
                    CascadeTerminationDate(service, inpContract, cascadeDate);
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.Message);
            }

            tracingService.Trace("CascadeModificationDetailsToAllocations.Execute(), Correlation Id: {0}", context.CorrelationId);
        }


        private void CascadeStopStartsDate(IOrganizationService service, EntityReference inContract, DateTime stopNewStartsDate)
        {

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {

                    var contractAllocations = (from t in xrmContext.CreateQuery("sfa_contractallocation")
                                               where t["sfa_contractid"] == inContract
                                               select t).ToList();

                    if (contractAllocations.Count > 0)
                    {
                        foreach (Entity ca in contractAllocations)
                        {

                            var contractAllocation = new Entity("sfa_contractallocation");
                            contractAllocation.Id = ca.Id;

                            if (stopNewStartsDate != DateTime.MinValue)
                            {
                                contractAllocation["sfa_inflightstopnewstartsdate"] = stopNewStartsDate;
                            }
                            else
                            {
                                contractAllocation["sfa_inflightstopnewstartsdate"] = null;
                            }

                            service.Update(contractAllocation);
                        }
                    }

                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.Message);
            }
        }

        private void CascadeTerminationDate(IOrganizationService service, EntityReference inContract, DateTime terminationDate)
        {

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {

                    var contractAllocations = (from t in xrmContext.CreateQuery("sfa_contractallocation")
                                               where t["sfa_contractid"] == inContract
                                               select t).ToList();

                    if (contractAllocations.Count > 0)
                    {
                        foreach (Entity ca in contractAllocations)
                        {

                            var contractAllocation = new Entity("sfa_contractallocation");
                            contractAllocation.Id = ca.Id;

                            if (terminationDate != DateTime.MinValue)
                            {
                                contractAllocation["sfa_inflightterminationdate"] = terminationDate;
                            }
                            else
                            {
                                contractAllocation["sfa_inflightterminationdate"] = null;
                            }

                            service.Update(contractAllocation);
                        }
                    }

                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.Message);
            }
        }

        private void CascadeNewStartsSuspendedReason(IOrganizationService service, EntityReference inContract, int newStartsSuspendedReason)
        {

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {

                    var contractAllocations = (from t in xrmContext.CreateQuery("sfa_contractallocation")
                                               where t["sfa_contractid"] == inContract
                                               select t).ToList();

                    if (contractAllocations.Count > 0)
                    {
                        foreach (Entity ca in contractAllocations)
                        {

                            var contractAllocation = new Entity("sfa_contractallocation");
                            contractAllocation.Id = ca.Id;

                            if (newStartsSuspendedReason > 0)
                            {
                                contractAllocation["sfa_inflightnewstartssuspendedreason"] = new OptionSetValue(newStartsSuspendedReason);
                            }
                            else
                            {
                                contractAllocation["sfa_inflightnewstartssuspendedreason"] = null;
                            }
                            service.Update(contractAllocation);
                        }
                    }

                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.Message);
            }
        }


    }
}

