// <file="GetTerminationDetailforAllocations.cs" >
// <summary>get the related child allocations Termination details in string format(for Dialog)</summary>

using System;
using System.Activities;
using System.Linq;
using System.ServiceModel;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Client;
using Microsoft.Xrm.Sdk.Workflow;


namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Contracts
{
    public class GetTerminationDetailforAllocations : CodeActivity
    {
        [RequiredArgument]
        [Input("Contract Reference")]
        [ReferenceTarget("sfa_contract")]
        public InArgument<EntityReference> InputContract { get; set; }

        [Output("Termination Details")]
        public OutArgument<string> OutputTerminationDetails { get; set; }


        protected override void Execute(CodeActivityContext executionContext)
        {
             // Create the tracing service
            ITracingService tracingService = executionContext.GetExtension<ITracingService>();
            
            if (tracingService == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve tracing service.");
            }

            tracingService.Trace("Entered GetTerminationDetailforAllocations.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("GetTerminationDetailforAllocations.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            IOrganizationServiceFactory serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);
           
            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    string terminationDetails = "Contract Termination Date: ";
                    string NOTSET = "Not Set";

                    var contract = (from c in xrmContext.CreateQuery("sfa_contract")
                                    where c["sfa_contractid"] == this.InputContract.Get(executionContext)
                                    select c).FirstOrDefault();

                    var contractTerminationDate = contract.GetAttributeValue<DateTime>("sfa_inflightterminationdate");
                    if ((contractTerminationDate != DateTime.MinValue) && (contractTerminationDate != null))
                    {
                        terminationDetails += contractTerminationDate.AddHours(1).ToString("dd/MM/yyyy");
                    } else
                    {
                        terminationDetails += NOTSET;
                    }
                    terminationDetails += "\r\n";
                    terminationDetails += "\r\nAllocation          Stop New Starts        Termination Date     Funding Stream Period";
                    terminationDetails += "\r\n-------------        --------------------       --------------------     -----------------------------------------";
                    NOTSET = "--";

                    var contractAllocations = (from t in xrmContext.CreateQuery("sfa_contractallocation")
                        where  t["sfa_contractid"] == this.InputContract.Get(executionContext)
                        orderby t["sfa_contractallocationnumber"] ascending
                        select t).ToList();

                    if (contractAllocations.Count > 0 )
                    {
                        foreach (Entity ca in contractAllocations)
                        {
                            int formatLength = 14;

                            var allocationRef = ca.GetAttributeValue<string>("sfa_contractallocationnumber");
                            var fspRef = ca.GetAttributeValue<EntityReference>("sfa_fundingstreamperiodid");
                            int len = ((formatLength - allocationRef.Length) * 2);
                            string formatAllocRef = allocationRef + new string(' ', Math.Max(0, len));
                            terminationDetails += "\r\n" + formatAllocRef;
                            formatLength = 27;
                            
                            var stopNewStartsDate = ca.GetAttributeValue<DateTime>("sfa_inflightstopnewstartsdate");
                            if ((stopNewStartsDate != DateTime.MinValue) && (stopNewStartsDate != null))
                            {
                                string strStopNewStartsDate = stopNewStartsDate.AddHours(1).ToString("dd/MM/yyyy");
                                terminationDetails += strStopNewStartsDate.PadRight(formatLength);
                            }
                            else
                            {
                                terminationDetails += NOTSET.PadRight(formatLength+9);
                            }
                            formatLength = 21;

                            var terminationDate = ca.GetAttributeValue<DateTime>("sfa_inflightterminationdate");
                            if ((terminationDate != DateTime.MinValue) && (terminationDate != null))
                            {
                                string strTerminationDate = terminationDate.AddHours(1).ToString("dd/MM/yyyy");
                                terminationDetails += strTerminationDate.PadRight(formatLength) ;
                            } else
                            {
                                terminationDetails += NOTSET.PadRight(formatLength+9);
                            }

                            var fspName = GetFSPName(service, fspRef);
                            if ((fspName != null)&& (fspName != String.Empty))
                            {
                                terminationDetails += fspName.PadRight(formatLength);
                            }
                            else
                            {
                                terminationDetails += NOTSET.PadRight(formatLength);
                            }
                        }
                    }
                    terminationDetails += "\r\n";
                    OutputTerminationDetails.Set(executionContext, terminationDetails);
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                //Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.InnerException);
            }

            tracingService.Trace("GetTerminationDetailforAllocations.Execute(), Correlation Id: {0}", context.CorrelationId);
        }

        private string GetFSPName(IOrganizationService service, EntityReference fundingstreamperiod)
        {
            var fspName = String.Empty;
            using (var xrmContext = new OrganizationServiceContext(service))
            {
                if (fundingstreamperiod != null)
                {
                    fspName = (from fsp in xrmContext.CreateQuery("sfa_fundingstreamperiod")
                               where fsp["sfa_fundingstreamperiodid"] == fundingstreamperiod
                               select (string)fsp["sfa_fundingstreamperiodname"]).FirstOrDefault();
                }
            }
            return fspName;
        }

    }
}

