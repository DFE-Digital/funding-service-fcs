// <copyright file="OrganisationAssignment.cs" company="">
// Copyright (c) 2015 All Rights Reserved
// </copyright>
// <author></author>
// <date>1/26/2015 3:53:39 PM</date>
// <summary>Implements the OrganisationAssignment Workflow Activity.</summary>

namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Organisations
{
    using System;
    using System.Activities;
    using System.Collections.Generic;
    using System.ServiceModel;
    using Microsoft.Crm.Sdk.Messages;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;
    using Microsoft.Xrm.Sdk.Workflow;
    using Common;
    using Microsoft.Xrm.Sdk.Messages;

    public sealed class ReassignChildContracts : CodeActivity
    {
        private const string Owner = "ownerid";
        private const string Status = "statecode";
        private const string Contract = "sfa_contract";
        private const string ProviderName = "sfa_providername";
        private const string ContractAdviser = "sfa_contractadviser";
        private const string SkipCaseload = "sfa_skipcaseloadassignment";
        private const string ContractStatus = "sfa_contractstatus";

        [RequiredArgument]
        [Input("Organisation")]
        [ReferenceTarget("account")]
        public InArgument<EntityReference> InputOrganisation { get; set; }

        [RequiredArgument]
        [Input("User")]
        [ReferenceTarget("systemuser")]
        public InArgument<EntityReference> InputSystemUser { get; set; }

        [Input("Team Filter")]
        public InArgument<string> InputTeam { get; set; }

        [Input("Status Filter")]
        public InArgument<string> InputStatusFilter { get; set; }

        [RequiredArgument]
        [Input("Update Contract Owner")]
        public InArgument<bool> InputUpdateContractOwner { get; set; }

        [RequiredArgument]
        [Input("Update Task Owner")]
        public InArgument<bool> InputUpdateTaskOwner { get; set; }

        /// <summary>
        ///     Executes the workflow activity.
        /// </summary>
        /// <param name="executionContext">The execution context.</param>
        protected override void Execute(CodeActivityContext executionContext)
        {
            // Create the tracing service
            var tracingService = executionContext.GetExtension<ITracingService>();

            if (tracingService == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve tracing service.");
            }

            tracingService.Trace(
                "Entered OrganisationAssignment.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}",
                executionContext.ActivityInstanceId,
                executionContext.WorkflowInstanceId);

            // Create the context
            var context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("OrganisationAssignment.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            var serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            var service = serviceFactory.CreateOrganizationService(context.UserId);

            try
            {
                // Retrieve the id
                var userRef = InputSystemUser.Get(executionContext);
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var xrmHelpers = new XrmWorkflowActivityHelpers(xrmContext);

                    var filterList = new Dictionary<string, object>();

                    if (InputTeam.Get(executionContext) != null)
                    {
                        var teamRef = xrmHelpers.GetTeamReference(InputTeam.Get(executionContext));
                        filterList.Add(Owner, teamRef);
                    }

                    if (!string.IsNullOrEmpty(InputStatusFilter.Get(executionContext)))
                    {
                        foreach (var f in InputStatusFilter.Get(executionContext).Split(','))
                        {
                            filterList.Add(Status, int.Parse(f));
                        }
                    }

                    List<Guid> contractsList = xrmHelpers.GetFilteredChildGuids(Contract, ProviderName, SkipCaseload, ContractStatus, InputOrganisation.Get(executionContext), filterList);

                    bool inputUpdateTaskOwner = InputUpdateTaskOwner.Get(executionContext);
                    bool inputUpdateContractOwner = InputUpdateContractOwner.Get(executionContext);
                    int count_taskowner = 0;
                    int count_contractowner = 0;

                    ExecuteMultipleRequest to_req = new ExecuteMultipleRequest();
                    ExecuteMultipleRequest co_req = new ExecuteMultipleRequest();

                    foreach (var c in contractsList)
                    {
                        if (inputUpdateTaskOwner)
                        {
                            if (count_taskowner == 0)
                            {
                                to_req.Requests = new OrganizationRequestCollection();
                                to_req.Settings = new ExecuteMultipleSettings();
                                to_req.Settings.ContinueOnError = true;
                                //to_req.Settings.ReturnResponses = true;
                            }
                            // Update Task Owner 
                            count_taskowner++;
                            var contract = new Entity(Contract) { Id = c };
                            contract[Owner] = userRef;

                            UpdateRequest updateRequest = new UpdateRequest { Target = contract };
                            to_req.Requests.Add(updateRequest);
                        }

                        if (inputUpdateContractOwner)
                        {
                            if (count_contractowner == 0)
                            {
                                co_req.Requests = new OrganizationRequestCollection();
                                co_req.Settings = new ExecuteMultipleSettings();
                                co_req.Settings.ContinueOnError = true;
                                //co_req.Settings.ReturnResponses = true;
                            }
                            // Update Contract Owner - via Update()
                            count_contractowner++;
                            var contract = new Entity(Contract) { Id = c };
                            contract[ContractAdviser] = userRef;
                            UpdateRequest updateRequest = new UpdateRequest { Target = contract };
                            co_req.Requests.Add(updateRequest);
                        }
                    }
                    if (count_taskowner > 0) { var res = service.Execute(to_req) as ExecuteMultipleResponse; }
                    if (count_contractowner > 0) { var res = service.Execute(co_req) as ExecuteMultipleResponse; }

                }
            }
            catch (SaveChangesException e)
            {
                tracingService.Trace("SaveChangesException: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException(
                    "An error occured updating the child contracts - Unable to save records - " + e.InnerException, e);
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("OrganizationServiceFaultException: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException(
                    "An error occured re-assigning the contracts: InnerException: " + e.InnerException + " Message: " + e.Message, e);
            }
            catch (ArgumentNullException e)
            {
                tracingService.Trace("ArgumentNullException: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException(
                    "An error occured updating the child contracts - Invalid Team", e);
            }

            tracingService.Trace("Exiting OrganisationAssignment.Execute(), Correlation Id: {0}", context.CorrelationId);
        }
    }
}