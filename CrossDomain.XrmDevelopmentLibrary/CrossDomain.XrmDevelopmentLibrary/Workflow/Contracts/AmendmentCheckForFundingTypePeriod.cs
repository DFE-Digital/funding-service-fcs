// <file="ValidAmendmentForFundingTypePeriod.cs" >
// <summary>Check Validity of Funding Type Period for creating an Amendment</summary>

using System;
using System.Activities;
using System.Linq;
using System.ServiceModel;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Client;
using Microsoft.Xrm.Sdk.Workflow;


namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Contracts
{
    public class AmendmentCheckForFundingTypePeriod : CodeActivity
    {
        [RequiredArgument]
        [Input("Funding Type")]
        [ReferenceTarget("sfa_fundingtype")]
        public InArgument<EntityReference> InputFundingType { get; set; }

        [RequiredArgument]
        [Input("Funding Period")]
        [ReferenceTarget("sfa_period")]
        public InArgument<EntityReference> InputFundingPeriod { get; set; }


        [Output("Valid For Amendment")]
        public OutArgument<string> ValidForAmendment { get; set; }


        protected override void Execute(CodeActivityContext executionContext)
        {
             // Create the tracing service
            ITracingService tracingService = executionContext.GetExtension<ITracingService>();
            
            if (tracingService == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve tracing service.");
            }

            tracingService.Trace("Entered AmendmentCheckForFundingTypePeriod.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("AmendmentCheckForFundingTypePeriod.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            IOrganizationServiceFactory serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);
           
            try
            {
                EntityReference inpFundingType = this.InputFundingType.Get(executionContext);
                EntityReference inpFundingPeriod = this.InputFundingPeriod.Get(executionContext);
                string validForAmend = "No";

                if (inpFundingType != null && inpFundingPeriod != null)
                {
                    validForAmend = CheckValidForAmend(service, inpFundingType, inpFundingPeriod);
                }

                ValidForAmendment.Set(executionContext, validForAmend);

            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.InnerException);
            }

            tracingService.Trace("AmendmentCheckForFundingTypePeriod.Execute(), Correlation Id: {0}", context.CorrelationId);
        }


        private string CheckValidForAmend(IOrganizationService service, EntityReference inFundingType, EntityReference inFundingPeriod)
        {
            var validForAmendment = "No";

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var contractAllocations = (from t in xrmContext.CreateQuery("sfa_fundingtypefundingperiod")
                                               where (t["sfa_fundingtypeid"] == inFundingType && t["sfa_fundingperiodid"] == inFundingPeriod 
                                               && (bool)t["sfa_generatecontractdocumentation"] == true  && (bool)t["sfa_skipdocumentmerge"] == false )
                                               select t).ToList();

                    if (contractAllocations.Count > 0)
                    {
                        validForAmendment = "Yes";
                    }

                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on execution: " + e.Message);
            }
            return validForAmendment;
        }

    }
}

