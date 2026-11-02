// <file="ValidateTerminationDialogData.cs" >
// <summary>Validate Termination Dialog Data</summary>

using System;
using System.Activities;
using System.Linq;
using System.ServiceModel;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Client;
using Microsoft.Xrm.Sdk.Workflow;


namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Contracts
{
    public class ValidateTerminationDialogData : CodeActivity
    {
        [RequiredArgument]
        [Input("Contract Reference")]
        [ReferenceTarget("sfa_contract")]
        public InArgument<EntityReference> InputContract { get; set; }

        [RequiredArgument]
        [Input("Validation Type")]
        public InArgument<string> ValidationType { get; set; }

        [Input("Allocation Reference")]
        [ReferenceTarget("sfa_contractallocation")]
        public InArgument<EntityReference> InputAllocation { get; set; }

        [Input("Termination Date")]
        public InArgument<DateTime> InputTerminationDate { get; set; }

        [Input("Stop New Starts Date")]
        public InArgument<DateTime> StopNewStartsDate { get; set; }

        [Output("Valid Data")]
        public OutArgument<bool> ValidData { get; set; }

        [Output("Error Detail")]
        public OutArgument<string> ErrorDetails { get; set; }

        //Contract Validation Rules
        string CVR1 = "The default Stop New Starts Date must be specified if Contract Termination Date has been specified";
        string CVR2 = "Contract Termination Date must not be later than the Contract End Date";
        string CVR3 = "The default Stop New Starts Date must not be later than the Contract Termination Date";
        string CVR4 = "The default Stop New Starts Date must not be later than the Contract End Date";
        //Contract Allocation Validation Rules
        string CAVR1 = "A contract allocation's Stop New Starts Date must be specified if its Termination Date has been specified";
        string CAVR2 = "Any contract allocation's Termination Date must not be later than the allocation's End Date";
        string CAVR3 = "Any contract allocation's Termination Date must not be later than the Contract Termination Date";
        string CAVR4 = "Any contract allocation's Stop New Starts Date must not be later than the allocation's Termination Date";
        //Final Validations
        string CAFV1 = "Stop New Starts Dates and Termination Dates must be specified for every contract allocation if Contract Termination Date has been specified";
        string CAFV2 = "At least one contract allocation must have either a Stop New Starts Date or a Termination Date";
        //Termination Pre-Complete Validations
        string CCVR1 = "a draft amendment exists";
        string CCVR2 = "Contract Termination Date is not specified";
        string CCVR3 = "Contract Termination Date must be in the past";

        string NEWLINE = "\r\n";

        string errorMessage = String.Empty;
        string updateErrorMessage = String.Empty;
        protected override void Execute(CodeActivityContext executionContext)
        {
             // Create the tracing service
            ITracingService tracingService = executionContext.GetExtension<ITracingService>();
            
            if (tracingService == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve tracing service.");
            }

            tracingService.Trace("Entered ValidateTerminationDialogData.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("ValidateTerminationDialogData.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            IOrganizationServiceFactory serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);
           
            try
            {
                EntityReference inpContract = this.InputContract.Get(executionContext);
                string validationType = this.ValidationType.Get(executionContext);
                DateTime inputTerminationDate = (DateTime)this.InputTerminationDate.Get(executionContext);
                DateTime stopNewStartsDate = (DateTime)this.StopNewStartsDate.Get(executionContext);
                bool validDataCheck = true;

                //intialise inflight data or finalise a per requirement
                if (validationType == "Contract")
                {
                    validDataCheck = ContractDataValidation(service, inpContract, inputTerminationDate, stopNewStartsDate);
                }
                else if (validationType == "Contract Allocation") {
                    EntityReference inpAllocation = this.InputAllocation.Get(executionContext);
                    validDataCheck = AllocationDataValidation(service, inpContract, inpAllocation, inputTerminationDate, stopNewStartsDate, "Initiate");
                }
                else if (validationType == "Final")
                {
                    validDataCheck = TerminationDataValidation(service, inpContract);
                }
                else if (validationType == "Contract Update")
                {
                    validDataCheck = ContractUpdateValidation(service, inpContract, inputTerminationDate);
                }
                else if (validationType == "All Contract Allocations")
                {
                    validDataCheck = AllAllocationDataValidation(service, inpContract);
                    errorMessage = updateErrorMessage;
                }
                else if (validationType == "Complete Termination")
                {
                    validDataCheck = PreCompleteValidation(service, inpContract);
                }

                ValidData.Set(executionContext, validDataCheck);
                ErrorDetails.Set(executionContext, errorMessage);

            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.InnerException);
            }

            tracingService.Trace("ValidateTerminationDialogData.Execute(), Correlation Id: {0}", context.CorrelationId);
        }

        private bool ContractDataValidation(IOrganizationService service, EntityReference inContract, DateTime inputTerminationDate, DateTime stopNewStartsDate)
        {
            var validContractData = true;
            errorMessage = String.Empty;

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var inputContract = (from c in xrmContext.CreateQuery("sfa_contract")
                                         where c["sfa_contractid"] == inContract
                                         select c).FirstOrDefault();

                    DateTime contractEndDate = inputContract.GetAttributeValue<DateTime>("sfa_enddate");

                    if (inputTerminationDate != DateTime.MinValue)
                    {
                        //the default Stop New Starts Date must be specified if Contract Termination Date has been specified
                        if (stopNewStartsDate == DateTime.MinValue)
                        {
                            errorMessage += CVR1 + NEWLINE;
                        }
                        else
                        {
                            //Contract Termination Date must not be later than the Contract End Date (exclude Levy)
                            if ((contractEndDate != DateTime.MinValue) && (DateTime.Compare(inputTerminationDate, contractEndDate) > 0))
                            {
                                errorMessage += CVR2 + NEWLINE;
                            }
                            //the default Stop New Starts Date must not be later than the Contract Termination Date
                            if (DateTime.Compare(stopNewStartsDate, inputTerminationDate) > 0)
                            {
                                errorMessage += CVR3 + NEWLINE;
                            }

                        }
                    } else
                    {
                        if (stopNewStartsDate != DateTime.MinValue) 
                        {
                            //the default Stop New Starts Date must not be later than the Contract End Date
                            if ((contractEndDate != DateTime.MinValue) && (DateTime.Compare(stopNewStartsDate, contractEndDate) > 0))
                            {
                                errorMessage += CVR4 + NEWLINE;
                            }

                        }
                    }

                    if (!String.IsNullOrEmpty(errorMessage))
                    {
                        validContractData = false;
                    }
                }
            } 
            catch (FaultException<OrganizationServiceFault> e)
            {
                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on execution: " + e.InnerException);
            }
            return validContractData;
        }

        private bool AllocationDataValidation(IOrganizationService service, EntityReference inContract, EntityReference inpAllocation, DateTime inputTerminationDate, DateTime stopNewStartsDate, string actionType)
        {
            var validAllocationData = true;
            errorMessage = String.Empty;

            try
            {
                if (inpAllocation != null)
                {
                    using (var xrmContext = new OrganizationServiceContext(service))
                    {
                        var inputContract = (from c in xrmContext.CreateQuery("sfa_contract")
                                             where c["sfa_contractid"] == inContract
                                             select c).FirstOrDefault();

                        DateTime contractInflightTerminationDate = inputContract.GetAttributeValue<DateTime>("sfa_inflightterminationdate");
                        if (actionType == "Update")
                        {
                            //UTC Adjustment for Update scenario
                            if (contractInflightTerminationDate != DateTime.MinValue)
                                contractInflightTerminationDate = contractInflightTerminationDate.AddHours(1);
                        }
                        var inputAllocation = (from ca in xrmContext.CreateQuery("sfa_contractallocation")
                                               where ca["sfa_contractallocationid"] == inpAllocation
                                               select ca).FirstOrDefault();
                        DateTime allocationEndDate = inputAllocation.GetAttributeValue<DateTime>("sfa_enddate");

                        if (inputTerminationDate != DateTime.MinValue)
                        {
                            //A contract allocation's Stop New Starts Date must be specified if its Termination Date has been specified
                            if (stopNewStartsDate == DateTime.MinValue)
                            {
                                errorMessage += CAVR1 + NEWLINE;
                            }
                            else
                            {
                                //Any contract allocation's Termination Date must not be later than the allocation's End Date
                                if ((allocationEndDate != DateTime.MinValue) && (DateTime.Compare(inputTerminationDate, allocationEndDate) > 0))
                                {
                                    errorMessage += CAVR2 + NEWLINE;
                                }
                                //Any contract allocation's Termination Date must not be later than the Contract Termination Date (excl Levy)
                                if ((contractInflightTerminationDate != DateTime.MinValue) && (DateTime.Compare(inputTerminationDate, contractInflightTerminationDate) > 0))
                                {
                                    errorMessage += CAVR3 + NEWLINE;
                                }
                                //Any contract allocation's Stop New Starts Date must not be later than the allocation's Termination Date
                                if (DateTime.Compare(stopNewStartsDate, inputTerminationDate) > 0)
                                {
                                    errorMessage += CAVR4 + NEWLINE;
                                }

                            }
                        }
                        else
                        {
                            if (stopNewStartsDate != DateTime.MinValue)
                            {
                                //blank for now                               
                            }
                        }

                        if (!String.IsNullOrEmpty(errorMessage))
                        {
                            validAllocationData = false;
                        }
                    }
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on execution: " + e.InnerException);
            }
            return validAllocationData;
        }

        private bool TerminationDataValidation(IOrganizationService service, EntityReference inContract)
        {
            var validTerminationData = true;
            errorMessage = String.Empty;

            try
            {
                    using (var xrmContext = new OrganizationServiceContext(service))
                    {
                        var inputContract = (from c in xrmContext.CreateQuery("sfa_contract")
                                             where c["sfa_contractid"] == inContract
                                             select c).FirstOrDefault();

                        DateTime contractInflightTerminationDate = inputContract.GetAttributeValue<DateTime>("sfa_inflightterminationdate");

                        if (contractInflightTerminationDate != DateTime.MinValue)
                        {
                                var contractAllocations = (from t in xrmContext.CreateQuery("sfa_contractallocation")
                                where t["sfa_contractid"] == inContract && (t["sfa_inflightstopnewstartsdate"] == null
                                || t["sfa_inflightterminationdate"] == null)
                                orderby t["sfa_contractallocationnumber"] ascending
                                select t).ToList();

                                // Stop New Starts Dates and Termination Dates must be specified for every contract allocation if Contract Termination Date has been specified
                                if (contractAllocations.Count > 0)
                                {
                                    errorMessage += CAFV1 + NEWLINE;
                                }
                        } else
                        {
                                var contractAllocations = (from t in xrmContext.CreateQuery("sfa_contractallocation")
                                where t["sfa_contractid"] == inContract && (t["sfa_inflightstopnewstartsdate"] != null
                                || t["sfa_inflightterminationdate"] != null)
                                orderby t["sfa_contractallocationnumber"] ascending
                                select t).ToList();

                                // at least one contract allocation must have either a Stop New Starts Date or a Termination Date
                                if (contractAllocations.Count == 0)
                                {
                                    errorMessage += CAFV2 + NEWLINE;
                                }
                        }

                        if (!String.IsNullOrEmpty(errorMessage))
                        {
                            validTerminationData = false;
                        }
                    }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on execution: " + e.InnerException);
            }
            return validTerminationData;
        }

        private bool ContractUpdateValidation(IOrganizationService service, EntityReference inContract, DateTime inputTerminationDate)
        {
            var validContractData = true;
            errorMessage = String.Empty;

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var inputContract = (from c in xrmContext.CreateQuery("sfa_contract")
                                         where c["sfa_contractid"] == inContract
                                         select c).FirstOrDefault();

                    DateTime contractEndDate = inputContract.GetAttributeValue<DateTime>("sfa_enddate");

                    if (inputTerminationDate != DateTime.MinValue)
                    {
                        //Contract Termination Date must not be later than the Contract End Date (exclude Levy)
                        if ((contractEndDate != DateTime.MinValue) && (DateTime.Compare(inputTerminationDate, contractEndDate) > 0))
                        {
                            errorMessage += CVR2 + NEWLINE;
                        }
                    }

                    if (!String.IsNullOrEmpty(errorMessage))
                    {
                        validContractData = false;
                    }
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on execution: " + e.InnerException);
            }
            return validContractData;
        }

        private bool AllAllocationDataValidation(IOrganizationService service, EntityReference inContract)
        {
            var validContractAllocData = true;
            errorMessage = String.Empty;
            updateErrorMessage = String.Empty;

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
                            var caTerminationDate = ca.GetAttributeValue<DateTime>("sfa_terminationdate");
                            var catStopNewStartsDate = ca.GetAttributeValue<DateTime>("sfa_stopnewstartsdate");
                            var validDataCheck = AllocationDataValidation(service, inContract, ca.ToEntityReference(), caTerminationDate, catStopNewStartsDate, "Update");
                            if (!validDataCheck)
                            {
                                updateErrorMessage += ca.GetAttributeValue<string>("sfa_contractallocationnumber") + ":" + NEWLINE;
                                updateErrorMessage += errorMessage;
                                errorMessage = String.Empty;
                            }
                        }
                    }

                    if (!String.IsNullOrEmpty(updateErrorMessage))
                    {
                        validContractAllocData = false;
                    }
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on execution: " + e.InnerException);
            }
            return validContractAllocData;
        }

        private bool PreCompleteValidation(IOrganizationService service, EntityReference inContract)
        {
            var validContractData = true;
            errorMessage = String.Empty;

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var inputContract = (from c in xrmContext.CreateQuery("sfa_contract")
                                         where c["sfa_contractid"] == inContract
                                         select c).FirstOrDefault();

                    DateTime terminationDate = inputContract.GetAttributeValue<DateTime>("sfa_terminationdate");
                    bool isLatestVersion = inputContract.GetAttributeValue<bool>("sfa_latestversion");
                    DateTime today = DateTime.Now.Date;

                    //a draft amendment exists
                    if (!isLatestVersion)
                    {
                        errorMessage += CCVR1 + NEWLINE;
                    }
                    //Contract Termination Date is not specified
                    if (terminationDate == DateTime.MinValue)
                    {
                        errorMessage += CCVR2 + NEWLINE;
                    }
                    else if (DateTime.Compare(terminationDate.AddHours(1), today) >= 0)
                    {
                        //Contract Termination Date must be in the past
                        errorMessage += CCVR3 + NEWLINE;
                    }

                    if (!String.IsNullOrEmpty(errorMessage))
                    {
                        validContractData = false;
                    }
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on execution: " + e.InnerException);
            }
            return validContractData;
        }

    }
}

