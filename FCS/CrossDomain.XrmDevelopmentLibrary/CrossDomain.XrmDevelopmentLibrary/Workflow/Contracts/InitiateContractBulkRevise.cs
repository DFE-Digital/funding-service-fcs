// <copyright file="InitiateContractBulkRevise.cs">
// </copyright>
// <author></author>
// <summary>Used to Trigger the Contract BulkRevise Transition which can be triggered by different Teams.</summary>
namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Contracts
{
    using System;
    using System.Activities;
    using System.Linq;
    using System.ServiceModel;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;
    using Microsoft.Xrm.Sdk.Workflow;

    public sealed class InitiateContractBulkRevise : CodeActivity
    {

        [RequiredArgument]
        [Input("Transition Name")]
        public InArgument<string> InputTransition { get; set; }


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

            tracingService.Trace(
                "Entered InitiateContractBulkRevise.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}",
                executionContext.ActivityInstanceId,
                executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("InitiateContractBulkRevise.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.UserId);

            var serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            var service = serviceFactory.CreateOrganizationService(context.UserId);
            //impersonate as admin
            Guid crmIntegrationUser = getSystemUserId("crmintegration", service);
            if (crmIntegrationUser != Guid.Empty)
                service = serviceFactory.CreateOrganizationService(crmIntegrationUser);

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var trans = from t in xrmContext.CreateQuery("sfa_transition")
                                where (string)t["sfa_name"] == this.InputTransition.Get(executionContext)
                                select t.Id;
                    if (trans.ToList().Count() != 1)
                    {
                        throw new InvalidPluginExecutionException("The required transition is not present in Dynamics CRM");
                    }

                    EntityReference inputTransition = new EntityReference("sfa_transition", trans.First());

                    if (inputTransition != null)
                    {
                        tracingService.Trace("InitiateContractBulkRevise.Execute(), Correlation Id: {0} Input Transition : {1}", context.CorrelationId, inputTransition.Id);

                        var contract = new Entity("sfa_contract");
                        contract["sfa_contractid"] = context.PrimaryEntityId;
                        contract["sfa_reasonforrejection"] = "Bulk contract revision";
                        contract["sfa_specialtaskowner"] = new EntityReference("systemuser", context.InitiatingUserId);
                        contract["sfa_nextaction"] = inputTransition;

                        service.Update(contract);
                    } 
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on execution - Message: " + e.Message + " Inner Exception: " + e.InnerException);
            }
        }


        private Guid getSystemUserId(string userName, IOrganizationService service)
        {
            Guid userId;
            using (var orgContext = new OrganizationServiceContext(service))
            {
                userId = (from user in orgContext.CreateQuery("systemuser")
                          where ((string)user["domainname"]).StartsWith(userName)
                          select user.Id).FirstOrDefault();
            }
            return userId;
        }

    }
}