// <file="ValidateTerminationDialogData.cs" >
// <summary>Validate Termination Dialog Data</summary>

using System;
using System.Activities;
using System.Linq;
using System.ServiceModel;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Client;
using Microsoft.Xrm.Sdk.Query;
using Microsoft.Xrm.Sdk.Workflow;


namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Contracts
{
    public class ValidateTerminationFormData : CodeActivity
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

        [Input("Termination Reason")]
        public InArgument<string> TerminationReason { get; set; }

        [Input("Action Date")]
        public InArgument<DateTime> ActionDate { get; set; }

        [Output("Valid Data")]
        public OutArgument<string> ValidData { get; set; }

        [Output("Error Detail")]
        public OutArgument<string> ErrorDetails { get; set; }

        string CTVR1 = "Unable to initiate contract termination - a draft amendment exists";
        string CTVRU1 = "Unable to update termination details - a draft amendment exists";
        string CTVRC1 = "Unable to cancel contract termination - a draft amendment exists";
        string CTVRCM1 = "Unable to complete contract termination - a draft amendment exists";
        string CTVR2 = "Termination Date must contain a value";
        string CTVR3 = "Termination Reason must contain a value";
        string CTVR4 = "Provisional Stop New Starts Date and Provisional Funding Cessation Date must contain values for every contract allocation";
        string CTVW1 = "The Termination Date is after the Contract End Date." + "\r\n" + "Are you sure you wish to continue? Select OK to continue or Cancel to return to the Termination Details.";
        string CPCTVR1 = "Unable to complete contract termination - contract termination date must be in the past";
        string CPCTVR2 = "There are unsaved changes in Termination Details. Check the dates are correct and choose Update Termination Details to save the changes.";
        string CPCTVR3 = "Unable to complete contract termination - one or more outstanding Funding Allocations exist in Contract Control";
        string CPCTVW1 = "The Termination Date is after the Contract End Date." + "\r\n" + "Are you sure you wish to continue as Termination Completion cannot be undone? Select OK to complete or Cancel to return to the Termination Details.";

        string CATVR1 = "The Provisional Funding Cessation Date must be equal to or earlier than the Termination Date";
        string CATVR2 = "The Provisional Stop New Starts Date must be equal to or earlier than the Provisional Funding Cessation Date, for the same allocation";

        string CMVR1 = "Unable to initiate contract modification - a draft amendment exists";
        string CMVRU1 = "Unable to update modification details - a draft amendment exists";
        string CMVRC1 = "Unable to cancel contract modification - a draft amendment exists";
        string CMVR2 = "Default Stop New Starts Date must contain a value";
        string CMVR3 = "Default New Starts Suspended Reason must contain a value";
        string CMVW1 = "The Default Stop New Starts Date is after the Contract End Date." + "\r\n" + "Are you sure you wish to continue?  Select OK to continue or Cancel to return to the Modification Details.";

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

            tracingService.Trace("Entered ValidateTerminationFormData.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("ValidateTerminationFormData.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            IOrganizationServiceFactory serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);

            try
            {
                EntityReference inpContract = this.InputContract.Get(executionContext);
                string validationType = this.ValidationType.Get(executionContext);
                DateTime inputTerminationDate = (DateTime)this.InputTerminationDate.Get(executionContext);
                DateTime stopNewStartsDate = (DateTime)this.StopNewStartsDate.Get(executionContext);
                string terminationReason = this.TerminationReason.Get(executionContext);

                string validDataCheck = "Valid";

                //validate
                if (validationType == "Initiate Termination")
                {

                    validDataCheck = InitiateTerminationDataValidate(service, inpContract, stopNewStartsDate, inputTerminationDate, terminationReason, validationType);
                }
                else if (validationType == "Update Termination Details")
                {
                    validDataCheck = InitiateTerminationDataValidate(service, inpContract, stopNewStartsDate, inputTerminationDate, terminationReason, validationType);
                }
                else if (validationType == "Cancel Termination")
                {
                    validDataCheck = CancelTerminationDataValidate(service, inpContract);
                }
                else if (validationType == "Complete Termination")
                {
                    DateTime actionDate = (DateTime)this.ActionDate.Get(executionContext);
                    validDataCheck = PreCompleteTerminationDataValidate(service, inpContract, stopNewStartsDate, inputTerminationDate, terminationReason, actionDate);
                }
                else if (validationType == "Initiate Modification")
                {
                    validDataCheck = InitiateModificationDataValidate(service, inpContract, stopNewStartsDate, terminationReason, validationType);
                }
                else if (validationType == "Update Modification Details")
                {
                    validDataCheck = InitiateModificationDataValidate(service, inpContract, stopNewStartsDate, terminationReason, validationType);
                }
                else if (validationType == "Cancel Modification")
                {
                    validDataCheck = CancelModificationDataValidate(service, inpContract);
                }

                ValidData.Set(executionContext, validDataCheck);
                ErrorDetails.Set(executionContext, errorMessage);

            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.Message);
            }

            tracingService.Trace("ValidateTerminationFormData.Execute(), Correlation Id: {0}", context.CorrelationId);
        }




        private string InitiateTerminationDataValidate(IOrganizationService service, EntityReference inContract, DateTime stopNewStartsDate, DateTime inputTerminationDate, string terminationReason, string validationType)
        {
            var validContractData = "Valid";
            errorMessage = String.Empty;

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var inputContract = (from c in xrmContext.CreateQuery("sfa_contract")
                                         where c["sfa_contractid"] == inContract
                                         select c).FirstOrDefault();

                    bool isLatestVersion = inputContract.GetAttributeValue<bool>("sfa_latestversion");
                    //OptionSetValue contractTerminationReason = inputContract.GetAttributeValue<OptionSetValue>("sfa_terminationreason");

                    //a draft amendment exists
                    if (!isLatestVersion)
                    {
                        if (validationType == "Initiate Termination")
                        {
                            errorMessage += CTVR1 + NEWLINE;
                        }
                        else if (validationType == "Update Termination Details")
                        {
                            errorMessage += CTVRU1 + NEWLINE;
                        }
                    }
                    else
                    {
                        //Contract Termination Date and Termination Reason must be both specified
                        if (inputTerminationDate == DateTime.MinValue)
                        {
                            errorMessage += CTVR2 + NEWLINE;
                        }
                        else if (terminationReason == null)
                        {
                            errorMessage += CTVR3 + NEWLINE;
                        }
                        else
                        {
                            //Default Stop New Starts Date must not be later than the Contract Termination Date
                            //if (DateTime.Compare(stopNewStartsDate, inputTerminationDate) > 0)
                            //{
                            //errorMessage += CTVR4 + NEWLINE;
                            //}
                            var allContractAllocations = (from t in xrmContext.CreateQuery("sfa_contractallocation")
                                                          where t["sfa_contractid"] == inContract && (t["sfa_inflightstopnewstartsdate"] == null
                                                          || t["sfa_inflightterminationdate"] == null)
                                                          orderby t["sfa_contractallocationnumber"] ascending
                                                          select t).ToList();

                            // Stop New Starts Dates and Funding Cessation Dates must be specified for every contract allocation
                            if (allContractAllocations.Count > 0)
                            {
                                errorMessage += CTVR4 + NEWLINE;
                            }
                            else //when all allocations have Funding Ceased and Stop New Starts do detail validation
                            {

                                var contractAllocations = (from t in xrmContext.CreateQuery("sfa_contractallocation")
                                                           where t["sfa_contractid"] == inContract
                                                           select t).ToList();

                                if (contractAllocations.Count > 0)
                                {
                                    foreach (Entity ca in contractAllocations)
                                    {
                                        var caFundingCessationDate = ca.GetAttributeValue<DateTime>("sfa_inflightterminationdate");
                                        var catStopNewStartsDate = ca.GetAttributeValue<DateTime>("sfa_inflightstopnewstartsdate");
                                        if (caFundingCessationDate != DateTime.MinValue)
                                        {
                                            //for BST local time
                                            if (caFundingCessationDate.Hour == 23) caFundingCessationDate = caFundingCessationDate.AddHours(1);
                                        }
                                        if (catStopNewStartsDate != DateTime.MinValue)
                                        {
                                            //for BST local time
                                            if (catStopNewStartsDate.Hour == 23) catStopNewStartsDate = catStopNewStartsDate.AddHours(1);
                                        }
                                        //Any contract allocation's Funding Cessation Date must not be later than the Contract Termination Date
                                        if ((inputTerminationDate != DateTime.MinValue) && (DateTime.Compare(caFundingCessationDate, inputTerminationDate) > 0))
                                        {
                                            errorMessage += ca.GetAttributeValue<string>("sfa_contractallocationnumber") + ": " + CATVR1 + NEWLINE;
                                        }
                                        //Any contract allocation's Stop New Starts Date must not be later than the allocation's Funding Cessation Date
                                        if (DateTime.Compare(catStopNewStartsDate, caFundingCessationDate) > 0)
                                        {
                                            errorMessage += ca.GetAttributeValue<string>("sfa_contractallocationnumber") + ": " + CATVR2 + NEWLINE;
                                        }
                                    }
                                }
                            }
                        }
                    }

                    if (!String.IsNullOrEmpty(errorMessage))
                    {
                        validContractData = "Error";
                    }
                    else
                    {
                        DateTime contractEndDate = inputContract.GetAttributeValue<DateTime>("sfa_enddate");
                        if ((contractEndDate != DateTime.MinValue) && (DateTime.Compare(inputTerminationDate, contractEndDate) > 0))
                        {
                            errorMessage += CTVW1 + NEWLINE;
                            validContractData = "Warning";
                        }


                    }
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on execution: " + e.Message);
            }
            return validContractData;
        }

        private string InitiateModificationDataValidate(IOrganizationService service, EntityReference inContract, DateTime stopNewStartsDate, string terminationReason, string validationType)
        {
            var validContractData = "Valid";
            errorMessage = String.Empty;

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var inputContract = (from c in xrmContext.CreateQuery("sfa_contract")
                                         where c["sfa_contractid"] == inContract
                                         select c).FirstOrDefault();

                    bool isLatestVersion = inputContract.GetAttributeValue<bool>("sfa_latestversion");

                    //a draft amendment exists
                    if (!isLatestVersion)
                    {
                        if (validationType == "Initiate Modification")
                        {
                            errorMessage += CMVR1 + NEWLINE;
                        }
                        else if (validationType == "Update Modification Details")
                        {
                            errorMessage += CMVRU1 + NEWLINE;
                        }
                    }
                    else
                    {
                        //Contract stopNewStartsDate Date and Reason must be both specified
                        if (stopNewStartsDate == DateTime.MinValue)
                        {
                            errorMessage += CMVR2 + NEWLINE;
                        }
                        else if (terminationReason == null)
                        {
                            errorMessage += CMVR3 + NEWLINE;
                        }
                        
                    }

                    if (!String.IsNullOrEmpty(errorMessage))
                    {
                        validContractData = "Error";
                    }
                    else
                    {
                        DateTime contractEndDate = inputContract.GetAttributeValue<DateTime>("sfa_enddate");
                        if ((contractEndDate != DateTime.MinValue) && (DateTime.Compare(stopNewStartsDate, contractEndDate) > 0))
                        {
                            errorMessage += CMVW1 + NEWLINE;
                            validContractData = "Warning";
                        }


                    }
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on execution: " + e.Message);
            }
            return validContractData;
        }

        private string PreCompleteTerminationDataValidate(IOrganizationService service, EntityReference inContract, DateTime stopNewStartsDate, DateTime inputTerminationDate, string terminationReason, DateTime actionDate)
        {
            var validContractData = "Valid";
            errorMessage = String.Empty;
            if (actionDate == DateTime.MinValue)
            {
                actionDate = DateTime.Now.Date;
            }

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var inputContract = (from c in xrmContext.CreateQuery("sfa_contract")
                                         where c["sfa_contractid"] == inContract
                                         select c).FirstOrDefault();

                    bool isLatestVersion = inputContract.GetAttributeValue<bool>("sfa_latestversion");
                    string contractUKPRN = inputContract.GetAttributeValue<string>("sfa_ukprn");
                    EntityReference contractFundingType = inputContract.GetAttributeValue<EntityReference>("sfa_fundingtype");
                    EntityReference contractFundingPeriod = inputContract.GetAttributeValue<EntityReference>("sfa_periodid");

                    //a draft amendment exists
                    if (!isLatestVersion)
                    {
                        errorMessage += CTVRCM1 + NEWLINE;
                    }
                    else if (!validAssociatedAllocations(contractUKPRN, contractFundingType, contractFundingPeriod, service))
                    {
                        //one or more outstanding funding allocations exist
                        errorMessage += CPCTVR3 + NEWLINE;
                    }
                    else if (DateTime.Compare(inputTerminationDate, actionDate) >= 0)
                    {
                        //Contract Termination Date must be in the past
                        errorMessage += CPCTVR1 + NEWLINE;
                    }
                    else if (!CheckDataIntegrity(service, inContract, inputTerminationDate, terminationReason))
                    {
                        //There are unsaved changes in the Termination Details form
                        errorMessage += CPCTVR2 + NEWLINE;
                    }

                    if (!String.IsNullOrEmpty(errorMessage))
                    {
                        validContractData = "Error";
                    }
                    else
                    {
                        DateTime contractEndDate = inputContract.GetAttributeValue<DateTime>("sfa_enddate");
                        if ((contractEndDate != DateTime.MinValue) && (DateTime.Compare(inputTerminationDate, contractEndDate) > 0))
                        {
                            errorMessage += CPCTVW1 + NEWLINE;
                            validContractData = "Warning";
                        }


                    }
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on execution: " + e.Message);
            }
            return validContractData;
        }

        private string CancelTerminationDataValidate(IOrganizationService service, EntityReference inContract)
        {
            var validContractData = "Valid";
            errorMessage = String.Empty;

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var inputContract = (from c in xrmContext.CreateQuery("sfa_contract")
                                         where c["sfa_contractid"] == inContract
                                         select c).FirstOrDefault();

                    bool isLatestVersion = inputContract.GetAttributeValue<bool>("sfa_latestversion");

                    //a draft amendment exists
                    if (!isLatestVersion)
                    {
                        errorMessage += CTVRC1 + NEWLINE;

                    }

                    if (!String.IsNullOrEmpty(errorMessage))
                    {
                        validContractData = "Error";
                    }

                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on execution: " + e.Message);
            }
            return validContractData;
        }


        private bool CheckDataIntegrity(IOrganizationService service, EntityReference inContract, DateTime inputTerminationDate, string terminationReason)
        {
            bool checkValid = true;
            errorMessage = String.Empty;

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var inputContract = (from c in xrmContext.CreateQuery("sfa_contract")
                                         where c["sfa_contractid"] == inContract
                                         select c).FirstOrDefault();

                    var contractTerminationDate = inputContract.GetAttributeValue<DateTime>("sfa_terminationdate");
                    var contractTerminationReason = inputContract.FormattedValues["sfa_terminationreason"].ToString();

                    if (contractTerminationDate != DateTime.MinValue)
                    {
                        if (contractTerminationDate.Hour == 23) contractTerminationDate = contractTerminationDate.AddHours(1);
                    }

                    if ((contractTerminationDate.Date != inputTerminationDate.Date) || (contractTerminationReason != terminationReason))
                    {
                        checkValid = false;
                    }

                    var contractAllocations = (from t in xrmContext.CreateQuery("sfa_contractallocation")
                                               where t["sfa_contractid"] == inContract
                                               select t).ToList();

                    if (contractAllocations.Count > 0)
                    {
                        foreach (Entity ca in contractAllocations)
                        {
                            var caProvFundingCessationDate = ca.GetAttributeValue<DateTime>("sfa_inflightterminationdate");
                            var caProvStopNewStartsDate = ca.GetAttributeValue<DateTime>("sfa_inflightstopnewstartsdate");
                            var caFundingCessationDate = ca.GetAttributeValue<DateTime>("sfa_terminationdate");
                            var catStopNewStartsDate = ca.GetAttributeValue<DateTime>("sfa_stopnewstartsdate");
                            if (caProvFundingCessationDate != DateTime.MinValue)
                            {
                                //for BST local time
                                if (caProvFundingCessationDate.Hour == 23) caProvFundingCessationDate = caProvFundingCessationDate.AddHours(1);
                            }
                            if (caProvStopNewStartsDate != DateTime.MinValue)
                            {
                                //for BST local time
                                if (caProvStopNewStartsDate.Hour == 23) caProvStopNewStartsDate = caProvStopNewStartsDate.AddHours(1);
                            }
                            //throw new InvalidPluginExecutionException(ca.GetAttributeValue<string>("sfa_contractallocationnumber")+"checkValid:" + checkValid + ":caFundingCessationDate: " + caFundingCessationDate + ": catStopNewStartsDate: " + catStopNewStartsDate + ": caProvFundingCessationDate:" + caProvFundingCessationDate + ": caProvStopNewStartsDate:" + caProvStopNewStartsDate);

                            if ((catStopNewStartsDate.Date != caProvStopNewStartsDate.Date) || (caFundingCessationDate.Date != caProvFundingCessationDate.Date))
                            {
                                checkValid = false;
                            }

                        }
                    }
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on execution: " + e.Message);
            }
            return checkValid;
        }

        private bool validAssociatedAllocations(string contractUKPRN, EntityReference contractFundingType, EntityReference contractFundingPeriod, IOrganizationService service)
        {
            int status_ContractApproved = 229660003;
            int status_Withdrawn = 229660004;

            using (var xrmContext = new OrganizationServiceContext(service))
            {
                var fundingAllocations = (from t in xrmContext.CreateQuery("sfa_fundingallocation")
                                          where t.GetAttributeValue<string>("sfa_ukprn") == contractUKPRN && t.GetAttributeValue<EntityReference>("sfa_fundingtype") == contractFundingType && t.GetAttributeValue<EntityReference>("sfa_period") == contractFundingPeriod
                                          && (t.GetAttributeValue<OptionSetValue>("sfa_status").Value != status_ContractApproved && t.GetAttributeValue<OptionSetValue>("sfa_status").Value != status_Withdrawn)
                                          select t).ToList();

                // at least one funding allocation that prevent termination
                if (fundingAllocations.Count != 0)
                {

                    return false;
                }

            }
            return true;
        }

        private string CancelModificationDataValidate(IOrganizationService service, EntityReference inContract)
        {
            var validContractData = "Valid";
            errorMessage = String.Empty;

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var inputContract = (from c in xrmContext.CreateQuery("sfa_contract")
                                         where c["sfa_contractid"] == inContract
                                         select c).FirstOrDefault();

                    bool isLatestVersion = inputContract.GetAttributeValue<bool>("sfa_latestversion");

                    //a draft amendment exists
                    if (!isLatestVersion)
                    {
                        errorMessage += CMVRC1 + NEWLINE;

                    }

                    if (!String.IsNullOrEmpty(errorMessage))
                    {
                        validContractData = "Error";
                    }

                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on execution: " + e.Message);
            }
            return validContractData;
        }

    }
}

