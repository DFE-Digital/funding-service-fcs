using System;
using System.Globalization;
using System.Linq;
using System.ServiceModel;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Client;
using Microsoft.Xrm.Sdk.Query;


namespace CrossDomain.XrmDevelopmentLibrary.Plugins
{
    public class ContractTransitionUpdateValidation : IPlugin
    {

        private const string ServiceReponse = "sfa_serviceresponse";
        private const int DOCUMENT_PUBLISHED_FOR_ELECTRONIC_SIGNOFF = 229660005;
        private const int DOCUMENT_PUBLISHED_FOR_AUTO_APPROVAL = 229660008;

        private const string PUBLISHED_TO_PROVIDER = "Published to Provider";
        private const string CONFIRM_RECEIPT_OF_SIGNED_CONTRACT = "Confirm Receipt of Signed Contract";
        private const string WITHDRAW_CONTRACT = "Withdraw Contract";
        private const string WITHDRAW_ON_BEHALF_OF_PROVIDER = "Withdraw On Behalf Of Provider";


        private const string SubStatus = "sfa_substatus";
        private const string FTFP_FUNDINGTYPE = "sfa_fundingtypeid";
        private const string FTFP_FUNDINGPERIOD = "sfa_fundingperiodid";
        private const string FTFP_APPROVALTYPE = "sfa_approvaltype";
        private const string CONT_FUNDINGTYPE = "sfa_fundingtype";
        private const string CONT_FUNDINGPERIOD = "sfa_periodid";
        private const string FTFPEntityName = "sfa_fundingtypefundingperiod";
        private const int FTFP_APPROVALTYPE_MANUAL = 229660000;
        private const string INITIATE_MANUAL_PUBLISH_TO_PROVIDER = "Initiate Manual Publish To Provider";
        private const string CLOSURE_REVERT_APPROVED_OR_MODIFIED = "Revert Back to Approved or Modified (Admin)";
        private const string CLOSURE_REVERT_APPROVED = "Revert Back to Approved (Admin)";
        private const string CLOSURE_REVERT_MODIFIED = "Revert Failed Closure Back to Modified (Admin)";
        private const string REJECT_CLOSURE = "Reject Closure";
        private const string REJECT_CLOSURE_MODIFICATION = "Reject Closure (Modification)";

        private const string Contract = "sfa_contract";
        private const string Status = "sfa_status";
        private const string SubStatusNameField = "sfa_name";
        private const string Transition = "sfa_transition";
        private const string TransitionName = "sfa_name";
        private const string NextActionName = "sfa_nextaction";
        private const string TerminationReason = "sfa_terminationreason";
        private const string StopStartsReason = "sfa_defaultnewstartssuspendedreason";

        /// <summary>
        /// A plug-in is validate conditions before contract tranistion field can be updated
        /// 
        /// </summary>
        /// <remarks>Register this plug-in on the Update message, sfa_contract entity,
        /// and pre-validation stage.
        /// </remarks>
        //<snippetAccountNumberPlugin2>
        public void Execute(IServiceProvider serviceProvider)
        {
            // Obtain the execution context from the service provider.

            //Extract the tracing service for use in debugging sandboxed plug-ins.
            ITracingService tracingService =
                (ITracingService)serviceProvider.GetService(typeof(ITracingService));


            // Obtain the execution context from the service provider.
            IPluginExecutionContext context = (IPluginExecutionContext)
                serviceProvider.GetService(typeof(IPluginExecutionContext));


            // The InputParameters collection contains all the data passed in the message request.
            if (context.InputParameters.Contains("Target") &&
                context.InputParameters["Target"] is Entity)
            {

                tracingService.Trace("ContractTransitionUpdateValidation started");
                // Obtain the target entity from the input parameters.
                Entity entity = (Entity)context.InputParameters["Target"];

                if (entity[NextActionName] != null)
                {
                    Guid nextActionId = entity.Contains("sfa_nextaction")
                        ? ((EntityReference)entity["sfa_nextaction"]).Id
                        : Guid.Empty;
                    tracingService.Trace("sfa_nextaction : " + nextActionId.ToString());

                    if (entity.LogicalName == Contract)
                    {

                        // Obtain the organization service reference.
                        IOrganizationServiceFactory serviceFactory =
                            (IOrganizationServiceFactory)
                                serviceProvider.GetService(typeof(IOrganizationServiceFactory));
                        IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);


                        var contract = service.Retrieve(Contract, context.PrimaryEntityId,
                            new ColumnSet(ServiceReponse, SubStatus, CONT_FUNDINGTYPE, CONT_FUNDINGPERIOD, TerminationReason, StopStartsReason));

                        if (nextActionId != Guid.Empty)
                        {
                            var nextAction = service.Retrieve(Transition, nextActionId, new ColumnSet(TransitionName));

                            if (contract != null)
                            {
                                #region "ServiceResponse and SubStatus Validation"
                                if (contract.Contains(ServiceReponse) && contract.Contains(SubStatus))
                                {
                                    var response =
                                        contract.GetAttributeValue<OptionSetValue>(ServiceReponse).Value;

                                    var substatusId = contract.GetAttributeValue<EntityReference>(SubStatus).Id;

                                    var substatus = service.Retrieve(Status, substatusId, new ColumnSet("sfa_name"));

                                    tracingService.Trace("ServiceResponse: " + response.ToString());
                                    tracingService.Trace("SubStatusId: " + substatusId);

                                    if (substatus != null && nextAction != null)
                                    {
                                        var nextActiontxt = nextAction.GetAttributeValue<string>(TransitionName);
                                        var substatusname = substatus.GetAttributeValue<string>(SubStatusNameField);
                                        tracingService.Trace("SubStatusName : " + substatusname);

                                        if (substatusname != string.Empty && nextActiontxt != string.Empty)
                                        {
                                            if ((response == DOCUMENT_PUBLISHED_FOR_AUTO_APPROVAL ||
                                                 response == DOCUMENT_PUBLISHED_FOR_ELECTRONIC_SIGNOFF)
                                                && substatusname == PUBLISHED_TO_PROVIDER
                                                && nextActiontxt == CONFIRM_RECEIPT_OF_SIGNED_CONTRACT)
                                            {
                                                // Throw an error, because account numbers must be system generated.
                                                // Throwing an InvalidPluginExecutionException will cause the error message
                                                // to be displayed in a dialog of the Web application.
                                                throw new InvalidPluginExecutionException(
                                                    "This contract has been restricted to set next action to CONFIRM RECEPT OF SIGN CONTRACT.");
                                            }


                                            if ((response == DOCUMENT_PUBLISHED_FOR_AUTO_APPROVAL)
                                               && substatusname == PUBLISHED_TO_PROVIDER)
                                            {
                                                if (nextActiontxt == WITHDRAW_CONTRACT)
                                                    throw new InvalidPluginExecutionException(
                                                        "This contract has been restricted to set next action to WITHDRAW CONTRACT.");
                                                else if (nextActiontxt == WITHDRAW_ON_BEHALF_OF_PROVIDER)
                                                {
                                                    throw new InvalidPluginExecutionException(
                                                   "This contract has been restricted to set next action to WITHDRAW CONTRACT ON BEHALF OF PROVIDER.");

                                                }
                                            }


                                        }
                                    }


                                }
                                #endregion

                                #region Approval Type and Next Action Validation

                                ApprovalType_NextActionValidation(nextAction, service, contract);

                                #endregion

                                #region Termination related Next Action Validation
                                Termination_NextActionValidation(nextAction, service, contract, entity);
                                #endregion
                            }

                        }
                    }

                }
            }
        }

        private void ApprovalType_NextActionValidation(Entity nextAction, IOrganizationService service, Entity contract)
        {
            var nextActiontxt = nextAction.GetAttributeValue<string>(TransitionName);

            if (nextActiontxt == INITIATE_MANUAL_PUBLISH_TO_PROVIDER)
            {
                if (contract.Contains(CONT_FUNDINGPERIOD) && contract.Contains(CONT_FUNDINGTYPE))
                {
                    var fundingType = contract.GetAttributeValue<EntityReference>(CONT_FUNDINGTYPE).Id;
                    var fundingPeriod = contract.GetAttributeValue<EntityReference>(CONT_FUNDINGPERIOD).Id;

                    QueryExpression query = new QueryExpression
                    {
                        EntityName = FTFPEntityName,
                        ColumnSet = new ColumnSet(new string[] { FTFP_APPROVALTYPE }),
                        Criteria = new FilterExpression()
                    };

                    query.Criteria.AddCondition(FTFP_FUNDINGPERIOD, ConditionOperator.Equal, fundingPeriod);
                    query.Criteria.AddCondition(FTFP_FUNDINGTYPE, ConditionOperator.Equal, fundingType);

                    var result = (EntityCollection)service.RetrieveMultiple(query);

                    if (result.Entities.Count > 0)
                    {
                        if (result[0].Contains(FTFP_APPROVALTYPE))
                        {
                            if (result[0].GetAttributeValue<OptionSetValue>(FTFP_APPROVALTYPE).Value == FTFP_APPROVALTYPE_MANUAL)
                            {
                                throw new InvalidPluginExecutionException(
                                              "INITIATE MANUAL PUBLICATION TO PROVIDER is is not permitted for this type of contract");

                            }
                        }

                    }
                }


            }
        }

        private void Termination_NextActionValidation(Entity nextAction, IOrganizationService service, Entity contract, Entity target)
        {
            var nextActiontxt = nextAction.GetAttributeValue<string>(TransitionName);
            var contractStopStartsReason = contract.GetAttributeValue<OptionSetValue>("sfa_defaultnewstartssuspendedreason");
            //handle special cases for branching Termination Closure where substatus needs to change differently
            if (nextActiontxt == CLOSURE_REVERT_APPROVED_OR_MODIFIED)
            {
                if (contractStopStartsReason == null)
                {
                    EntityReference revertApprovalTransition = GetTransitionFromName(service, CLOSURE_REVERT_APPROVED);
                    if (revertApprovalTransition != null) target[NextActionName] = revertApprovalTransition;
                }
                else
                {
                    EntityReference revertTerminationTransition = GetTransitionFromName(service, CLOSURE_REVERT_MODIFIED);
                    if (revertTerminationTransition != null) target[NextActionName] = revertTerminationTransition;
                }

            }
            if (nextActiontxt == REJECT_CLOSURE)
            {
                if (contractStopStartsReason != null)
                {
                    EntityReference rejectClosureTerminationTransition = GetTransitionFromName(service, REJECT_CLOSURE_MODIFICATION);
                    if (rejectClosureTerminationTransition != null) target[NextActionName] = rejectClosureTerminationTransition;
                }
            }
        }

        private EntityReference GetTransitionFromName(IOrganizationService service, string TransitionName)
        {
            EntityReference outTransition;
            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    //currently using 'From Action' as null 
                    var trans = from t in xrmContext.CreateQuery("sfa_transition")
                                where (string)t["sfa_name"] == TransitionName && t["sfa_fromaction"] == null
                                select t.Id;
                    if (trans.ToList().Count() != 1)
                    {
                        throw new InvalidPluginExecutionException("The required transition is not present in Dynamics CRM");
                    }

                    outTransition = new EntityReference("sfa_transition", trans.First());
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {

                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.InnerException);
            }
            return outTransition;
        }

    }
}