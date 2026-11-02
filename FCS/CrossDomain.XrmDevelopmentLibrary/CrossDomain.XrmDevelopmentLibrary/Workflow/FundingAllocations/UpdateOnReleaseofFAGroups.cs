// <summary>Filter and Update Release Group Status</summary>
namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.FundingAllocations
{
    using System;
    using System.Activities;
    using System.Collections.Generic;
    using System.Linq;
    using System.ServiceModel;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;
    using Microsoft.Xrm.Sdk.Workflow;

    public sealed class UpdateOnReleaseofFAGroups : CodeActivity
    {

	    [RequiredArgument]
        [Input("Input IDs")]
        public InArgument<string> InputIDs { get; set; }

        [Output("Release IDs")]
        public OutArgument<string> ReleaseIDs { get; set; }

        private const int Status_AwaitingRelease = 229660000;
        private const int Status_ReleaseInProgress = 229660002;

        protected override void Execute(CodeActivityContext executionContext)
        {
            // Create the tracing service
            ITracingService tracingService = executionContext.GetExtension<ITracingService>();

            if (tracingService == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve tracing service.");
            }

            tracingService.Trace("Entered UpdateOnReleaseofFAGroups.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("UpdateOnReleaseofFAGroups.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            IOrganizationServiceFactory serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);
            string validReleaseIDs = string.Empty;

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
					 string inputReleaseGroupIDs = this.InputIDs.Get(executionContext);
					
					if ((inputReleaseGroupIDs != null)||(inputReleaseGroupIDs != ""))
					{
                        string[] releaseGroupIds = inputReleaseGroupIDs.Split(';');
                        var count = releaseGroupIds.Count();
                        var releaseIds = new List<string>();
                        if (releaseGroupIds.Count() > 0)
                        {
                            for (int i=0; i< count;i++ )
                            {
                                Guid releaseGroupId = Guid.Parse(releaseGroupIds[i]);
                                var selectedReleaseGroup = (from rg in xrmContext.CreateQuery("sfa_releasegroup")
                                                            where (Guid)rg["sfa_releasegroupid"] == releaseGroupId
                                                            select rg).FirstOrDefault();

                                if (selectedReleaseGroup != null)
                                {
                                    var releaseStatus = selectedReleaseGroup.GetAttributeValue<OptionSetValue>("sfa_releasestatus");
                                    var releaseCount = selectedReleaseGroup.GetAttributeValue<int>("sfa_associatedcount");
                                    if ((releaseStatus.Value == Status_AwaitingRelease) &&(releaseCount > 0))
                                    {
                                        validReleaseIDs += releaseGroupIds[i] + ";";
                                        releaseIds.Add(releaseGroupIds[i]);
                                        var updatedreleaseGroup = new Entity("sfa_releasegroup");
                                        updatedreleaseGroup.Id = releaseGroupId;
                                        updatedreleaseGroup["sfa_releasestatus"] = new OptionSetValue(Status_ReleaseInProgress);
                                        updatedreleaseGroup["sfa_releasedon"] = DateTime.UtcNow;
                                        updatedreleaseGroup["sfa_releasedby"] = new EntityReference("systemuser", context.UserId);
                                        service.Update(updatedreleaseGroup);
                                    } 
                                }
                            }
                            validReleaseIDs = String.Join(";", releaseIds);
                        }
					}
                    this.ReleaseIDs.Set(executionContext, validReleaseIDs);
                }

            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.Message);
            }

            tracingService.Trace("Exiting UpdateOnReleaseofFAGroups.Execute(), Correlation Id: {0}", context.CorrelationId);
        }
    }
}