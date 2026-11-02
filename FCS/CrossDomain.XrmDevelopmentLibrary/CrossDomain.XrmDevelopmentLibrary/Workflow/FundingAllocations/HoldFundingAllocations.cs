// <summary>Hold Funding Allocations</summary>
namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.FundingAllocations
{
    using System;
    using System.Activities;
    using System.Linq;
    using System.ServiceModel;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;
    using Microsoft.Xrm.Sdk.Workflow;

    public class HoldFundingAllocations : CodeActivity
    {

	    [RequiredArgument]
        [Input("Hold Reason")]
        public InArgument<string> InputHoldReason { get; set; }

        [RequiredArgument]
        [Input("Input Comments")]
        public InArgument<string> InputComments { get; set; }

        [RequiredArgument]
        [Input("Input IDs")]
        public InArgument<string> InputIDs { get; set; }

        private const int SubStatus_AwaitingRelease = 229660000;
        private const int SubStatus_Held = 229660004;
        private const int HoldInProgress_Action = 229660005;
        private const int Status_AwaitingRelease = 229660000;

        protected override void Execute(CodeActivityContext executionContext)
        {
            // Create the tracing service
            ITracingService tracingService = executionContext.GetExtension<ITracingService>();

            if (tracingService == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve tracing service.");
            }

            tracingService.Trace("Entered HoldFundingAllocations.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("HoldFundingAllocations.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            IOrganizationServiceFactory serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
					string inputHoldReason = this.InputHoldReason.Get(executionContext);
                    string inputComments = this.InputComments.Get(executionContext);
                    string inputFundingAllocIDs = this.InputIDs.Get(executionContext);
					
					if ((inputFundingAllocIDs != null)||(inputFundingAllocIDs != ""))
					{
                        string[] fundingAllocationIds = inputFundingAllocIDs.Split(';');
                        var count = fundingAllocationIds.Count(); 
                        if (fundingAllocationIds.Count() > 0)
                        {
                            for (int i=0; i< count;i++ )
                            {
                                Guid fundingAllocationId = Guid.Parse(fundingAllocationIds[i]);

                                var inputFundingAlloc = (from a in xrmContext.CreateQuery("sfa_fundingallocation")
                                                     where (Guid)a["sfa_fundingallocationid"] == fundingAllocationId
                                                     select a).FirstOrDefault();

                                if (inputFundingAlloc != null)
                                {
                                    var inputFundingAllocSubStatus = inputFundingAlloc.GetAttributeValue<OptionSetValue>("sfa_substatus");
                                    var fundingAllocRG = inputFundingAlloc.GetAttributeValue<EntityReference>("sfa_releasegroup");
                                    int fundingAllocRGStatus=0;
                                    if (fundingAllocRG != null) {
                                        var selectedReleaseGroup = (from rg in xrmContext.CreateQuery("sfa_releasegroup")
                                                                    where rg["sfa_releasegroupid"] == fundingAllocRG
                                                                    select rg).FirstOrDefault();
                                        fundingAllocRGStatus = selectedReleaseGroup.GetAttributeValue<OptionSetValue>("sfa_releasestatus").Value;
                                    }
                                    if (((inputFundingAllocSubStatus.Value == SubStatus_AwaitingRelease) && (fundingAllocRGStatus == Status_AwaitingRelease)) || (inputFundingAllocSubStatus.Value == SubStatus_Held))
                                    {
                                        var updatedFundingAlloc = new Entity("sfa_fundingallocation");
                                        updatedFundingAlloc.Id = fundingAllocationId;
                                        if (inputHoldReason != null)
                                            updatedFundingAlloc["sfa_holdreason"] = new OptionSetValue(Int32.Parse(inputHoldReason));
                                        if (inputComments != null)
                                            updatedFundingAlloc["sfa_comments"] = inputComments;

                                        updatedFundingAlloc["sfa_processaction"] = new OptionSetValue(HoldInProgress_Action);
                                        service.Update(updatedFundingAlloc);
                                    }

                                }
                                

                            }
                        }

                    }
					
                 }

            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.Message);
            }

            tracingService.Trace("Exiting HoldFundingAllocations.Execute(), Correlation Id: {0}", context.CorrelationId);
        }
    }
}