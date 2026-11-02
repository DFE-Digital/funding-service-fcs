using System;
using System.Linq;
using System.ServiceModel;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Client;
using Microsoft.Xrm.Sdk.Query;
using System.Collections.Generic;

namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Plugins
{
    public class FCRAllocationUpdatePreValidation : IPlugin
    {
        private IOrganizationService service;
        private IPluginExecutionContext context;
        private const int FCR_STATUS_PUBLISHED = 229660001;
        private const int FCR_STATUS_DRAFT = 229660000;
        private const int FCR_SUBSTATUS_RECALC = 229660005;
        private const int FCR_SUBSTATUS_HELD_RECALC = 229660006;
        private const int FCRALLOC_UPDATE_FAILED = 229660022;
        private string fcrName = string.Empty;
        private string fcrUKPRN = string.Empty;
        private string fcrProviderName = string.Empty;
        private string contractAllocRef = string.Empty;


        /// <summary>
        /// This plugin is designed to execute a pre-validation for FCRAllocation entity update 
        /// stage - Prevalidation
        /// entity - sfa_fcrallocation
        /// message - update
        /// </summary>
        /// <param name="serviceProvider"></param>
        public void Execute(IServiceProvider serviceProvider)
        {

            // Extract the tracing service for use in debugging sandboxed plug-ins.
            ITracingService tracingService =
                (ITracingService)serviceProvider.GetService(typeof(ITracingService));

            // Obtain the execution context from the service provider.
            context = (IPluginExecutionContext)
                serviceProvider.GetService(typeof(IPluginExecutionContext));

            // Obtain the organization service reference.
            IOrganizationServiceFactory serviceFactory =
                (IOrganizationServiceFactory)
                    serviceProvider.GetService(typeof(IOrganizationServiceFactory));
            service = serviceFactory.CreateOrganizationService(context.UserId);

            try
            {
                // The InputParameters collection contains all the data passed in the message request.
                if (context.InputParameters.Contains("Target") &&
                context.InputParameters["Target"] is Entity)
                {

                    tracingService.Trace("FCRAllocationUpdatePreValidation started");

                    // Obtain the target entity from the input parameters.
                    Entity entity = (Entity)context.InputParameters["Target"];
                    Entity PreUpdateImage = (Entity)context.PreEntityImages["PreUpdateImage"];

                    var contractAlloc = PreUpdateImage.GetAttributeValue<EntityReference>("sfa_contractallocationid");
                    if (contractAlloc != null) contractAllocRef = contractAlloc.Name;

                    if (context.MessageName != "Update" || context.PrimaryEntityName != "sfa_fcrallocation")
                    { return; }
                    else
                    {
                        using (var orgContext = new OrganizationServiceContext(service))
                        {

                            var query = from f in orgContext.CreateQuery("sfa_fundingclaimreconciliation")
                                        join fa in orgContext.CreateQuery("sfa_fcrallocation")
                                            on f["sfa_fundingclaimreconciliationid"] equals fa["sfa_fundingclaimreconciliationid"]
                                        where (Guid)fa["sfa_fcrallocationid"] == context.PrimaryEntityId
                                        select f;

                            //get associated fundingclaimreconcilation and verify its status 
                            var fcr = query.FirstOrDefault();
                            if (fcr != null)
                            {
                                fcrName = fcr.GetAttributeValue<string>("sfa_name");
                                fcrUKPRN = fcr.GetAttributeValue<string>("sfa_ukprn");
                                var fcrProvider = fcr.GetAttributeValue<EntityReference>("sfa_providerid");
                                if (fcrProvider != null) fcrProviderName = fcrProvider.Name;

                                tracingService.Trace("FCRAllocationUpdatePreValidation: FCRStatusValidation");
                                string fcrStatusValidation = FCRStatusValidation(fcr);
                                if (fcrStatusValidation != string.Empty) throw new InvalidPluginExecutionException(fcrStatusValidation);
                            }

                            //FCR Allocation Validation -Claim Adjustment Value/Reason update
                            if ((entity.Contains("sfa_claimadjustmentvalue")) || (entity.Contains("sfa_claimadjustmentreason")))
                            {
                                tracingService.Trace("FCRAllocationUpdatePreValidation: FCRClaimAdjustmentRelatedValidation");
                                string fcrClaimAdjustmentValidation = FCRClaimAdjustmentRelatedValidation(entity, PreUpdateImage);
                                if (fcrClaimAdjustmentValidation != string.Empty) throw new InvalidPluginExecutionException(fcrClaimAdjustmentValidation);

                            }

                            tracingService.Trace("FCRAllocationUpdatePreValidation: DetectFCRUpdate");
                            //detection of the Update- used for the Calc Interface
                            string updateOutcome = DetectFCRUpdate(entity, PreUpdateImage, tracingService);

                            //update fcr with outcome for the Calc Interface 
                            EntityReference fundingClaimRecon = PreUpdateImage.GetAttributeValue<EntityReference>("sfa_fundingclaimreconciliationid");
                            Entity updateFCR = new Entity("sfa_fundingclaimreconciliation");
                            updateFCR.Id = fundingClaimRecon.Id;
                            updateFCR.Attributes["sfa_systemimport"] = updateOutcome;
                            service.Update(updateFCR);
                        }
                    }
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                tracingService.Trace("Exception: {0}", e.ToString());

                // Handle the exception.
                throw new InvalidPluginExecutionException("Error on plugin execution: " + e.InnerException);
            }
        }

        private string DetectFCRUpdate(Entity entity, Entity PreUpdateImage, ITracingService tracingService)
        {
            string outcome = "None";
            var preClaimAdjustmentValue = PreUpdateImage.GetAttributeValue<decimal>("sfa_claimadjustmentvalue");
            var preReconciliationValue = PreUpdateImage.GetAttributeValue<decimal>("sfa_reconciliationvalue");
            var preEarningsboostvalue = PreUpdateImage.GetAttributeValue<decimal>("sfa_earningsboostvalue");
            tracingService.Trace("preClaimAdjustmentValue: {0}", preClaimAdjustmentValue);
            tracingService.Trace("preReconciliationValue: {0}", preReconciliationValue);
            tracingService.Trace("preEarningsboostvalue: {0}", preEarningsboostvalue);
            tracingService.Trace("entity.Contains(\"sfa_claimadjustmentvalue\"): {0}", entity.Contains("sfa_claimadjustmentvalue"));
            tracingService.Trace("entity.Contains(\"sfa_reconciliationvalue\"): {0}", entity.Contains("sfa_reconciliationvalue"));
            tracingService.Trace("entity.Contains(\"sfa_earningsboostvalue\"): {0}", entity.Contains("sfa_earningsboostvalue"));


            var claimAdjustmentValue = entity.GetAttributeValue<decimal>("sfa_claimadjustmentvalue");
            var reconciliationValue = entity.GetAttributeValue<decimal>("sfa_reconciliationvalue");
            var earningsboostvalue = entity.GetAttributeValue<decimal>("sfa_earningsboostvalue");

            tracingService.Trace("claimAdjustmentValue: {0}", claimAdjustmentValue);
            tracingService.Trace("reconciliationValue: {0}", reconciliationValue);
            tracingService.Trace("earningsboostvalue: {0}", earningsboostvalue);


            if ((entity.Contains("sfa_claimadjustmentvalue")) && (entity.Contains("sfa_reconciliationvalue")) && (entity.Contains("sfa_earningsboostvalue")))
            {
                claimAdjustmentValue = entity.GetAttributeValue<decimal>("sfa_claimadjustmentvalue");
                reconciliationValue = entity.GetAttributeValue<decimal>("sfa_reconciliationvalue");
                earningsboostvalue = entity.GetAttributeValue<decimal>("sfa_earningsboostvalue");

                tracingService.Trace("claimAdjustmentValue: {0}", claimAdjustmentValue);
                tracingService.Trace("reconciliationValue: {0}", reconciliationValue);
                tracingService.Trace("earningsboostvalue: {0}", earningsboostvalue);

                if ((preClaimAdjustmentValue != claimAdjustmentValue) && (preReconciliationValue != reconciliationValue) && (preEarningsboostvalue != earningsboostvalue))
                {
                    outcome = "Triad";
                }
                else if ((preClaimAdjustmentValue != claimAdjustmentValue) && (preReconciliationValue != reconciliationValue))
                {
                    outcome = "DualClaimRecon";
                }
                else if ((preReconciliationValue != reconciliationValue) && (preEarningsboostvalue != earningsboostvalue))
                {
                    outcome = "DualReconEarning";
                }
                else if ((preClaimAdjustmentValue != claimAdjustmentValue) && (preEarningsboostvalue != earningsboostvalue))
                {
                    outcome = "DualClaimEarning";
                }
                else if (preClaimAdjustmentValue != claimAdjustmentValue)
                {
                    outcome = "ClaimAdjustment";
                }
                else if (preReconciliationValue != reconciliationValue)
                {
                    outcome = "ReconciliationValue";
                }
                else if (preEarningsboostvalue != earningsboostvalue)
                {
                    outcome = "EarningsBoost";
                }

            }
            else if ((entity.Contains("sfa_claimadjustmentvalue")) && (entity.Contains("sfa_reconciliationvalue")))
            {
                claimAdjustmentValue = entity.GetAttributeValue<decimal>("sfa_claimadjustmentvalue");
                reconciliationValue = entity.GetAttributeValue<decimal>("sfa_reconciliationvalue");
                tracingService.Trace("sfa_claimadjustmentvalue: {0}", claimAdjustmentValue);
                if ((preClaimAdjustmentValue != claimAdjustmentValue) && (preReconciliationValue != reconciliationValue))
                {
                    outcome = "DualClaimRecon";
                }
                else if (preClaimAdjustmentValue != claimAdjustmentValue)
                {
                    outcome = "ClaimAdjustment";
                }
                else if (preReconciliationValue != reconciliationValue)
                {
                    outcome = "ReconciliationValue";
                }

            }
            else if ((entity.Contains("sfa_claimadjustmentvalue")) && (entity.Contains("sfa_earningsboostvalue")))
            {
                claimAdjustmentValue = entity.GetAttributeValue<decimal>("sfa_claimadjustmentvalue");
                earningsboostvalue = entity.GetAttributeValue<decimal>("sfa_earningsboostvalue");
                tracingService.Trace("sfa_claimadjustmentvalue: {0}", claimAdjustmentValue);
                if ((preClaimAdjustmentValue != claimAdjustmentValue) && (preEarningsboostvalue != earningsboostvalue))
                {
                    outcome = "DualClaimEarning";
                }
                else if (preClaimAdjustmentValue != claimAdjustmentValue)
                {
                    outcome = "ClaimAdjustment";
                }
                else if (preEarningsboostvalue != earningsboostvalue)
                {
                    outcome = "EarningsBoost";
                }

            }
            else if ((entity.Contains("sfa_reconciliationvalue")) && (entity.Contains("sfa_earningsboostvalue")))
            {
                reconciliationValue = entity.GetAttributeValue<decimal>("sfa_reconciliationvalue");
                earningsboostvalue = entity.GetAttributeValue<decimal>("sfa_earningsboostvalue");
                tracingService.Trace("sfa_claimadjustmentvalue: {0}", claimAdjustmentValue);
                if ((preReconciliationValue != reconciliationValue) && (preEarningsboostvalue != earningsboostvalue))
                {
                    outcome = "DualReconEarning";
                }
                else if (preReconciliationValue != reconciliationValue)
                {
                    outcome = "ReconciliationValue";
                }
                else if (preEarningsboostvalue != earningsboostvalue)
                {
                    outcome = "EarningsBoost";
                }


            }
            else if (entity.Contains("sfa_claimadjustmentvalue"))
            {
                claimAdjustmentValue = entity.GetAttributeValue<decimal>("sfa_claimadjustmentvalue");
                if (preClaimAdjustmentValue != claimAdjustmentValue)
                {
                    outcome = "ClaimAdjustment";
                }
            }
            else if (entity.Contains("sfa_reconciliationvalue"))
            {
                reconciliationValue = entity.GetAttributeValue<decimal>("sfa_reconciliationvalue");
                if (preReconciliationValue != reconciliationValue)
                {
                    outcome = "ReconciliationValue";
                }
            }
            else if (entity.Contains("sfa_earningsboostvalue"))
            {
                earningsboostvalue = entity.GetAttributeValue<decimal>("sfa_earningsboostvalue");
                if (preEarningsboostvalue != earningsboostvalue)
                {
                    outcome = "EarningsBoost";
                }
            }
            tracingService.Trace("outcome is: {0}", outcome);
            return outcome;
        }


        private string FCRStatusValidation(Entity relatedFCR)
        {
            var fcrStatus = relatedFCR.GetAttributeValue<OptionSetValue>("sfa_statuscode").Value;
            var fcrSubStatus = relatedFCR.GetAttributeValue<OptionSetValue>("sfa_substatus").Value;

            string errorMessage = string.Empty;

            //FCR related Validation
            if (fcrStatus == FCR_STATUS_PUBLISHED)
            {
                errorMessage = "Cannot update this FCR Allocation since its associated Funding Claim Reconciliation record is in 'PUBLISHED' status";
            }
            else if ((fcrStatus == FCR_STATUS_DRAFT) && ((fcrSubStatus == FCR_SUBSTATUS_RECALC) || (fcrSubStatus == FCR_SUBSTATUS_HELD_RECALC)))
            {
                Entity notification = new Entity("sfa_notification");
                notification.Attributes["sfa_name"] = "FCR Allocation Update Failed - " + contractAllocRef + " - " + fcrName;
                notification.Attributes["sfa_notificationtype"] = new OptionSetValue(FCRALLOC_UPDATE_FAILED);
                notification.Attributes["sfa_notification"] = "The FCR Allocation for contract allocation " + contractAllocRef + " for provider " + fcrUKPRN + " (" + fcrProviderName + ") could not be updated because it is being recalculated";
                notification.Attributes["ownerid"] = new EntityReference("systemuser", context.UserId);
                service.Create(notification);
                errorMessage = "Cannot update this FCR Allocation since its associated Funding Claim Reconciliation is being recalculated";
            }
            return errorMessage;
        }

        private string FCRClaimAdjustmentRelatedValidation(Entity entity, Entity PreUpdateImage)
        {
            decimal claimAdjustmentValue = 0;
            OptionSetValue claimAdjustmentReason = null;
            string errorMessage = string.Empty;

            if (entity.Contains("sfa_claimadjustmentvalue"))
            {
                claimAdjustmentValue = entity.GetAttributeValue<decimal>("sfa_claimadjustmentvalue");
            }
            else
            {
                claimAdjustmentValue = PreUpdateImage.GetAttributeValue<decimal>("sfa_claimadjustmentvalue");
            }

            if (entity.Contains("sfa_claimadjustmentreason"))
            {
                claimAdjustmentReason = entity.GetAttributeValue<OptionSetValue>("sfa_claimadjustmentreason");
            }
            else
            {
                claimAdjustmentReason = PreUpdateImage.GetAttributeValue<OptionSetValue>("sfa_claimadjustmentreason");
            }

            if (claimAdjustmentValue != 0)
            {

                if (claimAdjustmentReason == null)
                {
                    Entity notification = new Entity("sfa_notification");
                    notification.Attributes["sfa_name"] = "FCR Allocation Update Failed - " + contractAllocRef + " - " + fcrName;
                    notification.Attributes["sfa_notificationtype"] = new OptionSetValue(FCRALLOC_UPDATE_FAILED);
                    notification.Attributes["sfa_notification"] = "The FCR Allocation for contract allocation " + contractAllocRef + " for provider " + fcrUKPRN + " (" + fcrProviderName + ") could not be updated because a Claim Adjustment Reason is required when a non-zero Claim Adjustment Value is specified";
                    notification.Attributes["ownerid"] = new EntityReference("systemuser", context.UserId);
                    service.Create(notification);
                    errorMessage = "Cannot update this FCR Allocation since a Claim Adjustment Reason is required when a non-zero Claim Adjustment Value is specified";
                }
            }
            else
            {
                if (claimAdjustmentReason != null)
                {
                    Entity notification = new Entity("sfa_notification");
                    notification.Attributes["sfa_name"] = "FCR Allocation Update Failed - " + contractAllocRef + " - " + fcrName;
                    notification.Attributes["sfa_notificationtype"] = new OptionSetValue(FCRALLOC_UPDATE_FAILED);
                    notification.Attributes["sfa_notification"] = "The FCR Allocation for contract allocation " + contractAllocRef + " for provider " + fcrUKPRN + " (" + fcrProviderName + ") could not be updated because a Claim Adjustment Reason is only allowed if a non-zero Claim Adjustment Value has been specified";
                    notification.Attributes["ownerid"] = new EntityReference("systemuser", context.UserId);
                    service.Create(notification);
                    errorMessage = "Cannot update this FCR Allocation since a Claim Adjustment Reason is only allowed if a non-zero Claim Adjustment Value has been specified";
                }

            }
            return errorMessage;
        }


    }
}
