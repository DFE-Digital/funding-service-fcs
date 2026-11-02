// <copyright file="GetLastApprovedVersionContract.cs" company="Ciber">
// Copyright (c) 2016 All Rights Reserved
// </copyright>
// <author>Dennis yao</author>
// <date>19/02/2016</date>
// <summary>Implements the GetLastApprovedVersionContract Workflow Activity.</summary>

using System;
using System.Activities;
using System;
using System.Activities;
using System.Linq;
using System.ServiceModel;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Client;
using Microsoft.Xrm.Sdk.Workflow;


namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Contracts
{
    public class GetLastApprovedVersionContract : CodeActivity
    {

        [RequiredArgument]
        [Input("Contract Number")]
        public InArgument<string> InputContractNumber { get; set; }


        [Output("Contract Reference")]
        [ReferenceTarget("sfa_contract")]
        public OutArgument<EntityReference> OutputContract { get; set; }

        protected override void Execute(CodeActivityContext executionContext)
        {
             // Create the tracing service
            ITracingService tracingService = executionContext.GetExtension<ITracingService>();
            
            if (tracingService == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve tracing service.");
            }

            tracingService.Trace("Entered GetLastApprovedVersionContract.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("GetGetLastApprovedVersionContract.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            IOrganizationServiceFactory serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);
           
            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    var conts = from t in xrmContext.CreateQuery("sfa_contract")
                        where (string) t["sfa_number"] == this.InputContractNumber.Get(executionContext) &&
                              (bool) t["sfa_lastapprovedversion"] == true 
                              select t.Id;

                    if (conts.ToList().Count() == 0)
                    {
                        this.OutputContract.Set(executionContext, null);
                    }
                    else
                    {
                        this.OutputContract.Set(executionContext, new EntityReference("sfa_contract", conts.First()));
                    }
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.InnerException);
            }

            tracingService.Trace("GetGetLastApprovedVersionContract.Execute(), Correlation Id: {0}", context.CorrelationId);
        }


        }
    }

