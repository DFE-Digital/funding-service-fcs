// <file="SetupTerminationDialogData.cs" >
// <summary>Setup Termination Dialog Data(for inflight or to finalise)</summary>

using System;
using System.Activities;
using System.Linq;
using System.ServiceModel;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Client;
using Microsoft.Xrm.Sdk.Workflow;


namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Contracts
{
    public class SetupTerminationDialogData : CodeActivity
    {
        [RequiredArgument]
        [Input("Contract Reference")]
        [ReferenceTarget("sfa_contract")]
        public InArgument<EntityReference> InputContract { get; set; }

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

            tracingService.Trace("Entered SetupTerminationDialogData.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("SetupTerminationDialogData.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            IOrganizationServiceFactory serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);
           
            try
            {
                EntityReference inpContract = this.InputContract.Get(executionContext);
                string requiredType = this.InputType.Get(executionContext);

                //intialise inflight data or finalise a per requirement
                if (requiredType == "Initialise")
                {
                    InitialiseData(service, inpContract);
                }
                else if (requiredType == "Finalise")
                {
                    FinaliseData(service, inpContract);
                }
                else if (requiredType == "Finalise Modify")
                {
                    FinaliseModifyData(service, inpContract);
                }
                else if (requiredType == "Clear")
                {
                    ClearTerminationData(service, inpContract);
                }

            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.Message);
            }

            tracingService.Trace("SetupTerminationDialogData.Execute(), Correlation Id: {0}", context.CorrelationId);
        }

        private void InitialiseData(IOrganizationService service, EntityReference inContract)
        {

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var inputContract = (from c in xrmContext.CreateQuery("sfa_contract")
                                    where c["sfa_contractid"] == inContract
                                    select c).FirstOrDefault();

                    var contractTerminationDate = inputContract.GetAttributeValue<DateTime>("sfa_terminationdate");
                    var contractTerminationReason = inputContract.GetAttributeValue<OptionSetValue>("sfa_terminationreason");
                    var contractInitiateAmendment = inputContract.GetAttributeValue<bool>("sfa_initiateamendment");
                    var contractTerminationComments = inputContract.GetAttributeValue<string>("sfa_terminationcomments");

                    var contract = new Entity("sfa_contract");
                    contract.Id = inContract.Id;
                    if (contractTerminationDate != DateTime.MinValue)
                    {
                        contract["sfa_inflightterminationdate"] = contractTerminationDate;
                    }
                    else
                    {
                        contract["sfa_inflightterminationdate"] = null;
                    }
                    if (contractTerminationReason != null)
                    {
                        contract["sfa_inflightterminationreason"] = new OptionSetValue(contractTerminationReason.Value);
                    }
                    else
                    {
                        contract["sfa_inflightterminationreason"] = null;
                    }
                    if (contractInitiateAmendment == true)
                    {
                        contract["sfa_inflightinitiateamendment"] = "Yes";
                    }
                    else
                    {
                        contract["sfa_inflightinitiateamendment"] = "No";
                    }
                    contract["sfa_inflightterminationcomments"] = contractTerminationComments;
                    service.Update(contract);

                    var contractAllocations = (from t in xrmContext.CreateQuery("sfa_contractallocation")
                                               where t["sfa_contractid"] == inContract
                                               select t).ToList();

                    if (contractAllocations.Count > 0)
                    {
                        foreach (Entity ca in contractAllocations)
                        {
                            var caTerminationDate = ca.GetAttributeValue<DateTime>("sfa_terminationdate");
                            var catStopNewStartsDate = ca.GetAttributeValue<DateTime>("sfa_stopnewstartsdate");

                            var contractAllocation = new Entity("sfa_contractallocation");
                            contractAllocation.Id = ca.Id;
                            if (caTerminationDate != DateTime.MinValue)
                            {
                                contractAllocation["sfa_inflightterminationdate"] = caTerminationDate;
                            }
                            else
                            {
                                contractAllocation["sfa_inflightterminationdate"] = null;
                            }
                            if (catStopNewStartsDate != DateTime.MinValue)
                            {
                                contractAllocation["sfa_inflightstopnewstartsdate"] = catStopNewStartsDate;
                            } else
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

        private void FinaliseData(IOrganizationService service, EntityReference inContract)
        {

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var inputContract = (from c in xrmContext.CreateQuery("sfa_contract")
                                         where c["sfa_contractid"] == inContract
                                         select c).FirstOrDefault();

                    var contractTerminationDate = inputContract.GetAttributeValue<DateTime>("sfa_inflightterminationdate");
                    var contractTerminationReason = inputContract.GetAttributeValue<OptionSetValue>("sfa_inflightterminationreason");
                    var contractTerminationComments = inputContract.GetAttributeValue<string>("sfa_inflightterminationcomments");
                    var contractInitiateAmendment = inputContract.GetAttributeValue<string>("sfa_inflightinitiateamendment");
                    var contractDefaultStopStartsDate = inputContract.GetAttributeValue<DateTime>("sfa_defaultstopnewstartsdate");

                    var contract = new Entity("sfa_contract");
                    contract.Id = inContract.Id;
                    if (contractTerminationDate != DateTime.MinValue)
                    {
                        //for BST local time
                        if (contractTerminationDate.Hour == 23) contractTerminationDate = contractTerminationDate.AddHours(1);
                        contract["sfa_terminationdate"] = contractTerminationDate;
                    } else
                    {
                        contract["sfa_terminationdate"] = null;
                    }
                    if (contractTerminationReason != null)
                    {
                        contract["sfa_terminationreason"] = new OptionSetValue(contractTerminationReason.Value);
                    }
                    else
                    {
                        contract["sfa_terminationreason"] = null;
                    }
                    if (contractInitiateAmendment != null)
                    {
                        if (contractInitiateAmendment == "Yes")
                        {
                            contract["sfa_initiateamendment"] = true;
                        }
                        else
                        {
                            contract["sfa_initiateamendment"] = false;
                        }
                    }
                    else
                    {
                        contract["sfa_initiateamendment"] = null;
                    }
                    contract["sfa_terminationcomments"] = contractTerminationComments;
                    contract["sfa_inflightterminationcomments"] = null; //clear out Inflight Termination Comments
                    contract["sfa_inflightstopnewstartsdate"] = null;//clear out Inflight Stop Starts Date

                    if (contractDefaultStopStartsDate != DateTime.MinValue)
                    {
                        //for BST local time
                        if (contractDefaultStopStartsDate.Hour == 23) contractDefaultStopStartsDate = contractDefaultStopStartsDate.AddHours(1);
                        contract["sfa_defaultstopnewstartsdate"] = contractDefaultStopStartsDate;
                    }
                    else
                    {
                        contract["sfa_defaultstopnewstartsdate"] = null;
                    }

                    service.Update(contract);

                    var contractAllocations = (from t in xrmContext.CreateQuery("sfa_contractallocation")
                                               where t["sfa_contractid"] == inContract
                                               select t).ToList();

                    if (contractAllocations.Count > 0)
                    {
                        foreach (Entity ca in contractAllocations)
                        {
                            var caTerminationDate = ca.GetAttributeValue<DateTime>("sfa_inflightterminationdate");
                            var catStopNewStartsDate = ca.GetAttributeValue<DateTime>("sfa_inflightstopnewstartsdate");

                            var contractAllocation = new Entity("sfa_contractallocation");
                            contractAllocation.Id = ca.Id;
                            if (caTerminationDate != DateTime.MinValue)
                            {
                                //for BST local time
                                if (caTerminationDate.Hour == 23) caTerminationDate = caTerminationDate.AddHours(1);
                                contractAllocation["sfa_terminationdate"] = caTerminationDate;
                            } else
                            {
                                contractAllocation["sfa_terminationdate"] = null;
                            }
                            if (catStopNewStartsDate != DateTime.MinValue)
                            {
                                //for BST local time
                                if (catStopNewStartsDate.Hour == 23) catStopNewStartsDate = catStopNewStartsDate.AddHours(1);
                                contractAllocation["sfa_stopnewstartsdate"] = catStopNewStartsDate;
                            } else
                            {
                                contractAllocation["sfa_stopnewstartsdate"] = null;
                            }
                            service.Update(contractAllocation);
                        }
                    }

                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                // Handle the exception
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.Message);
            }
        }

        private void FinaliseModifyData(IOrganizationService service, EntityReference inContract)
        {

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var inputContract = (from c in xrmContext.CreateQuery("sfa_contract")
                                         where c["sfa_contractid"] == inContract
                                         select c).FirstOrDefault();

                    var contractNewStartsSuspendedReason = inputContract.GetAttributeValue<OptionSetValue>("sfa_inflightnewstartssuspendedreason");
                    var contractTerminationComments = inputContract.GetAttributeValue<string>("sfa_inflightterminationcomments");
                    var contractDefaultStopStartsDate = inputContract.GetAttributeValue<DateTime>("sfa_inflightstopnewstartsdate");

                    var contract = new Entity("sfa_contract");
                    contract.Id = inContract.Id;

                    if (contractNewStartsSuspendedReason != null)
                    {
                        contract["sfa_defaultnewstartssuspendedreason"] = new OptionSetValue(contractNewStartsSuspendedReason.Value);
                    }
                    else
                    {
                        contract["sfa_defaultnewstartssuspendedreason"] = null;
                    }

                    contract["sfa_terminationcomments"] = contractTerminationComments;
                    contract["sfa_inflightterminationcomments"] = null; //clear out Inflight Termination Comments

                    if (contractDefaultStopStartsDate != DateTime.MinValue)
                    {
                        //for BST local time
                        if (contractDefaultStopStartsDate.Hour == 23) contractDefaultStopStartsDate = contractDefaultStopStartsDate.AddHours(1);
                        contract["sfa_defaultstopnewstartsdate"] = contractDefaultStopStartsDate;
                    }
                    else
                    {
                        contract["sfa_defaultstopnewstartsdate"] = null;
                    }

                    service.Update(contract);

                    var contractAllocations = (from t in xrmContext.CreateQuery("sfa_contractallocation")
                                               where t["sfa_contractid"] == inContract
                                               select t).ToList();

                    if (contractAllocations.Count > 0)
                    {
                        foreach (Entity ca in contractAllocations)
                        {

                            var contractAllocation = new Entity("sfa_contractallocation");
                            contractAllocation.Id = ca.Id;

                            if (contractDefaultStopStartsDate != DateTime.MinValue)
                            {
                                //for BST local time
                                //if (contractDefaultStopStartsDate.Hour == 23) contractDefaultStopStartsDate = contractDefaultStopStartsDate.AddHours(1);
                                contractAllocation["sfa_stopnewstartsdate"] = contractDefaultStopStartsDate;
                            }
                            else
                            {
                                contractAllocation["sfa_stopnewstartsdate"] = null;
                            }
                            if (contractNewStartsSuspendedReason != null)
                            {
                                contractAllocation["sfa_newstartssuspendedreason"] = new OptionSetValue(contractNewStartsSuspendedReason.Value);
                            }
                            else
                            {
                                contractAllocation["sfa_newstartssuspendedreason"] = null;
                            }
                            service.Update(contractAllocation);
                        }
                    }

                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                // Handle the exception
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.Message);
            }
        }

        private void ClearTerminationData(IOrganizationService service, EntityReference inContract)
        {

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {

                    var contract = new Entity("sfa_contract");
                    contract.Id = inContract.Id;
                    contract["sfa_inflightterminationdate"] = null;
                    contract["sfa_inflightstopnewstartsdate"] = null;
                    contract["sfa_inflightterminationreason"] = null;
                    contract["sfa_inflightinitiateamendment"] = null;
                    contract["sfa_inflightterminationcomments"] = null;
                    contract["sfa_defaultstopnewstartsdate"] = null;
                    contract["sfa_terminationdate"] = null;
                    contract["sfa_terminationreason"] = null;
                    contract["sfa_initiateamendment"] = null;
                    contract["sfa_terminationcomments"] = null;

                    contract["sfa_inflightnewstartssuspendedreason"] = null;
                    contract["sfa_defaultnewstartssuspendedreason"] = null;

                    //clear termination in progress flag
                    contract["sfa_terminationinprogress"] = null;
                    service.Update(contract);

                    var contractAllocations = (from t in xrmContext.CreateQuery("sfa_contractallocation")
                                               where t["sfa_contractid"] == inContract
                                               select t).ToList();

                    if (contractAllocations.Count > 0)
                    {
                        foreach (Entity ca in contractAllocations)
                        {
                            var contractAllocation = new Entity("sfa_contractallocation");
                            contractAllocation.Id = ca.Id;
                            contractAllocation["sfa_inflightterminationdate"] = null;
                            contractAllocation["sfa_inflightstopnewstartsdate"] = null;
                            contractAllocation["sfa_inflightnewstartssuspendedreason"] = null;
                            contractAllocation["sfa_terminationdate"] = null;
                            contractAllocation["sfa_stopnewstartsdate"] = null;
                            contractAllocation["sfa_newstartssuspendedreason"] = null;

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

