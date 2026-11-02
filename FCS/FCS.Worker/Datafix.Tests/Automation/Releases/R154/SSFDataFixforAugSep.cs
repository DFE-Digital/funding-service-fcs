using Datafix.Tests.Automation.Releases.R148;
using Datafix.Tests.Dtos;
using Datafix.Tests.Repositories;
using Microsoft.Xrm.Client.Services;
using Microsoft.Xrm.Sdk;
using Newtonsoft.Json;
using SFA.FCS.Worker.Common.Crm;
using SFA.FCT.CrossDomain.Integration.Common;
using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Datafix.Tests.Automation.Releases.R154
{
    public class SSFDataFixforAugSep : IApplyDataFix
    {
        public string Release => "R154c";
        public int StoryNumber => 40938;
        public string Name => "SSF payment issue for Aug and Sep";
        public int Order => 1;

        public void ApplyDataFix()
        {
            try
            {
                string jsonResource = "Resources.R148.AffectedUKPRN.json";
                var deliverableUkprnList = FromJsonMessageList<DeliverableUKPRN>("Datafix.Tests", jsonResource);
                
                foreach (var deliverableUkprn in deliverableUkprnList)
                {
                    var allocationsData = CrmContractDeliverableRepository.GetContractAllocationsForUKPRN(deliverableUkprn.UKPRN);
                    foreach (var allocation in allocationsData)
                    {
                        var cdpData = CrmContractDeliverableRepository.GetContractDeliverablePeridByAllocationNumber(allocation.AllocationNumber);

                        #region PAAS and CRM

                        string period = "202312";
                        foreach (var cdp in cdpData.Where(x => x.Period.Value == 12))
                        {
                            var newSubnominalCode = MapSSFSubnominalCodewithDeliverable(cdp.DeliverableCode);

                            decimal? balAmt = DeliverablePaymentRepository.SelectBalAmountsForDecAllocationVersion(allocation.AllocationNumber, cdp.DeliverableCode, period);
                            
                            if (balAmt != null)
                            {
                                DeliverablePaymentRepository.UpdateAmountsForDecAllocationVersion(allocation.AllocationNumber, cdp.DeliverableCode, period);

                                DeliverablePaymentRepository.UpdateAggregateAmountDecForSubnominalAggregations(allocation.AllocationNumber, newSubnominalCode, allocation.ContractVersion, cdp.DeliverableCode, period);

                                UpdateDecMonthData(cdp, newSubnominalCode);
                            }else 
                            {
                                decimal? balAmtLatestversion = DeliverablePaymentRepository.SelectBalAmountsForDecAllocationLatestVersion(allocation.AllocationNumber, cdp.DeliverableCode, period, cdp.ContractVersion);
                                if (balAmtLatestversion != null)
                                {
                                    DeliverablePaymentRepository.UpdateAmountsForDecAllocationLatestVersion(allocation.AllocationNumber, cdp.DeliverableCode, period, cdp.ContractVersion);

                                    DeliverablePaymentRepository.UpdateAggregateAmountDecForSubnominalAggregations(allocation.AllocationNumber, newSubnominalCode, allocation.ContractVersion, cdp.DeliverableCode, period);

                                    UpdateDecMonthData(cdp, newSubnominalCode);
                                }
                            }
                        }

                        period = "202311";
                        if (allocation.AllocationNumber == "16ED-5821")
                        {
                            foreach (var cdp in cdpData.Where(x => x.Period.Value == 11))
                            {
                                var newSubnominalCode = MapSSFSubnominalCodewithDeliverable(cdp.DeliverableCode);

                                DeliverablePaymentRepository.UpdateAmountsForDecAllocationVersion(allocation.AllocationNumber, cdp.DeliverableCode, period);

                                DeliverablePaymentRepository.UpdateAggregateAmountDecForSubnominalAggregations(allocation.AllocationNumber, newSubnominalCode, allocation.ContractVersion, cdp.DeliverableCode, period);

                                UpdateDecMonthData(cdp, newSubnominalCode);
                            }
                        }

                        if (allocation.AllocationNumber == "16ED-5888")
                        {
                            period = "202310";
                            foreach (var cdp in cdpData.Where(x => x.Period.Value == 10))
                            {
                                var newSubnominalCode = MapSSFSubnominalCodewithDeliverable(cdp.DeliverableCode);
                                var paymentsData = DeliverablePaymentRepository.GePaymentValues(allocation.AllocationNumber, cdp.DeliverableCode, period);
                                paymentsData.BalancingpaymentAmount = 0 - paymentsData.NetPaymentAmount;
                                paymentsData.NetPaymentAmount = 0 - paymentsData.NetPaymentAmount;
                                paymentsData.ProfilePaymentAmount = 0;
                                paymentsData.PlannedValue = 0;
                                DeliverablePaymentRepository.UpdateAmountsForDecAllocationVersionclawback(allocation.AllocationNumber, cdp.DeliverableCode, period, paymentsData);

                                DeliverablePaymentRepository.UpdateAggregateAmountDecForSubnominalAggregations(allocation.AllocationNumber, newSubnominalCode, allocation.ContractVersion, cdp.DeliverableCode, period);

                                UpdateCRMData(cdp, paymentsData, newSubnominalCode);

                            }
                        }

                        period = "202308";
                        //AUG Data
                        foreach (var cdpAug in cdpData.Where(x => x.Period.Value == 8))
                        {
                            var newSubnominalCode = MapSSFSubnominalCodewithDeliverable(cdpAug.DeliverableCode);
                            //PAAS

                            // Fetch payment values to update ProfilePaymentAmount ,balancing Amount and Net Payment Amount
                            var paymentsData = DeliverablePaymentRepository.GePaymentValues(allocation.AllocationNumber, cdpAug.DeliverableCode, period);
                            // Update Deliverable Payment table with values   

                            if (paymentsData != null)
                            {
                                DeliverablePaymentRepository.UpdateAugSepAmountsForAllocationVersion(allocation.AllocationNumber, cdpAug.DeliverableCode, paymentsData, period);

                                //Update Subnominal table with aggregate Values  
                                DeliverablePaymentRepository.UpdateAugSepSubnominalAggregations(allocation.AllocationNumber, newSubnominalCode, paymentsData, period);
                                //----------------------------------------------------

                                //CRM

                                // Update SFA Deliverable Payment table with values and Subnominal aggregation table with aggregate Values 
                                UpdateCRMData(cdpAug, paymentsData, newSubnominalCode);
                            }
                        }

                        //SEP Data
                        period = "202309";
                        foreach (var cdpsep in cdpData.Where(x => x.Period.Value == 9))
                        {
                            var newSubnominalCode = MapSSFSubnominalCodewithDeliverable(cdpsep.DeliverableCode);
                            //PAAS

                            // Fetch payment values to update ProfilePaymentAmount ,balancing Amount and Net Payment Amount
                            var paymentsData = DeliverablePaymentRepository.GePaymentValues(allocation.AllocationNumber, cdpsep.DeliverableCode, period);
                            if (paymentsData != null)
                            {
                                // Update Deliverable Payment table with values   
                                DeliverablePaymentRepository.UpdateAugSepAmountsForAllocationVersion(allocation.AllocationNumber, cdpsep.DeliverableCode, paymentsData, period);

                                //Update Subnominal table with aggregate Values  
                                DeliverablePaymentRepository.UpdateAugSepSubnominalAggregations(allocation.AllocationNumber, newSubnominalCode, paymentsData, period);

                                //CRM

                                // Update SFA Deliverable Payment table with values and Subnominal aggregation table with aggregate Values  

                                UpdateCRMData(cdpsep, paymentsData, newSubnominalCode);
                            }
                            if (allocation.AllocationNumber == "16ED-6172")
                            {
                                //PAAS

                                // Fetch payment values to update ProfilePaymentAmount ,balancing Amount and Net Payment Amount
                                var paymentsDataForED6172 = DeliverablePaymentRepository.GePaymentValuesFor16ED6172(allocation.AllocationNumber, cdpsep.DeliverableCode, period);
                                if (paymentsDataForED6172 != null)
                                {
                                    // Update Deliverable Payment table with values   
                                    DeliverablePaymentRepository.UpdateAugSepAmountsForAllocationVersion1619ED6172(allocation.AllocationNumber, cdpsep.DeliverableCode, paymentsDataForED6172, period);

                                    //Update Subnominal table with aggregate Values  
                                    DeliverablePaymentRepository.UpdateAugSepSubnominalAggregations(allocation.AllocationNumber, newSubnominalCode, paymentsDataForED6172, period);

                                    //CRM

                                    // Update SFA Deliverable Payment table with values and Subnominal aggregation table with aggregate Values  

                                    UpdateCRMData(cdpsep, paymentsDataForED6172, newSubnominalCode);
                                }
                            }
                            if (allocation.AllocationNumber == "16ED-6009")
                            {
                                // Fetch payment values to update ProfilePaymentAmount ,balancing Amount and Net Payment Amount
                                if (paymentsData != null)
                                {
                                    paymentsData.ProfilePaymentAmount = 0;
                                    paymentsData.NetPaymentAmount = paymentsData.BalancingpaymentAmount;

                                    // Update Deliverable Payment table with values   
                                    DeliverablePaymentRepository.UpdateAmountsForDecAllocationVersion16ED6009(allocation.AllocationNumber, cdpsep.DeliverableCode, period, paymentsData);

                                    //Update Subnominal table with aggregate Values  
                                    DeliverablePaymentRepository.UpdateAugSepSubnominalAggregations(allocation.AllocationNumber, newSubnominalCode, paymentsData, period);

                                    //CRM

                                    // Update SFA Deliverable Payment table with values and Subnominal aggregation table with aggregate Values  

                                    UpdateCRMData(cdpsep, paymentsData, newSubnominalCode);
                                }
                            }
                        }

                        #endregion PAAS and CRM


                    }
                }

                //Update posted flag to Zero where aggregate amount was 0
                DeliverablePaymentRepository.UpdatePostedFlagforZEROAggregateAmount();
            }
            catch (Exception ex)
            {

            }
        }
        private void UpdateDecMonthData(ContractDeliverablePeriod cdp, string newSubnominalCode)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            var newKey = newSubnominalCode + "_" + cdp.AllocationNumber + "_" + cdp.PeriodName;

            var newSubnominaldata = CrmContractDeliverableRepository.GetSubnominalAggreagetion(newKey);

            if (cdp.ProfilePaymentAmount != null)
            {
                if (cdp.BalancingpaymentAmount != null)
                {
                    //Update Oct Month NetPaymentAmount data into sfa_contractdeliverableperiod
                    sfa_contractdeliverableperiod deliverablePeriodToUpdate = new sfa_contractdeliverableperiod
                    {
                        Id = cdp.CDPId,
                        sfa_BalancingPaymentAmount = 0,
                        sfa_NetPaymentAmount = cdp.ProfilePaymentAmount
                    };

                    organizationService.Update(deliverablePeriodToUpdate);

                    if (cdp.ProfileSubnominalId != null)
                    {
                        sfa_subnominalaggregation subnominalaggregationToUpdate = new sfa_subnominalaggregation
                        {
                            Id = new Guid(cdp.ProfileSubnominalId),
                            sfa_AggregatedValue = cdp.ProfilePaymentAmount
                        };
                        organizationService.Update(subnominalaggregationToUpdate);
                    }
                    else
                    {
                        if (newSubnominaldata != null)
                        {
                            sfa_subnominalaggregation subnominalaggregationToUpdate = new sfa_subnominalaggregation
                            {
                                Id = newSubnominaldata.SAId,
                                sfa_AggregatedValue = cdp.ProfilePaymentAmount
                            };
                            organizationService.Update(subnominalaggregationToUpdate);
                        }
                        if (cdp.ProfileSubnominalId == null)
                        {
                            sfa_contractdeliverableperiod deliverablePeriodToUpdateProfile = new sfa_contractdeliverableperiod
                            {
                                Id = cdp.CDPId,
                                sfa_profilesubnominal = new EntityReference(sfa_subnominalaggregation.EntityLogicalName,
                                                    newSubnominaldata.SAId)
                            };
                            organizationService.Update(deliverablePeriodToUpdateProfile);
                        }
                    }
                }

            }

        }

        private void UpdateCRMData(ContractDeliverablePeriod cdpData, DeliveryPayments deliveryPayment, string newsubnominalCode)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            var newKey = newsubnominalCode + "_" + cdpData.AllocationNumber + "_" + cdpData.PeriodName;

            var newSubnominaldata = CrmContractDeliverableRepository.GetSubnominalAggreagetion(newKey);

            if (deliveryPayment.NetPaymentAmount != null)
            {
                sfa_contractdeliverableperiod deliverableNetPayment = new sfa_contractdeliverableperiod
                {
                    Id = cdpData.CDPId,
                    sfa_NetPaymentAmount = deliveryPayment.NetPaymentAmount
                };
                organizationService.Update(deliverableNetPayment);
            }
            if (deliveryPayment.ProfilePaymentAmount != null)
            {
                sfa_contractdeliverableperiod deliverableProfileAmt = new sfa_contractdeliverableperiod
                {
                    Id = cdpData.CDPId,
                    sfa_ProfilePaymentAmount = deliveryPayment.ProfilePaymentAmount
                };
                organizationService.Update(deliverableProfileAmt);
            }

            if (deliveryPayment.BalancingpaymentAmount != null)
            {
                sfa_contractdeliverableperiod deliverableBalAmt = new sfa_contractdeliverableperiod
                {
                    Id = cdpData.CDPId,
                    sfa_BalancingPaymentAmount = deliveryPayment.BalancingpaymentAmount
                };
                organizationService.Update(deliverableBalAmt);
            }

            if (newSubnominaldata != null)
            {
                if (deliveryPayment.NetPaymentAmount != null)
                {
                    sfa_subnominalaggregation AugsubnominalaggregationToUpdate = new sfa_subnominalaggregation
                    {
                        Id = newSubnominaldata.SAId,
                        sfa_AggregatedValue = deliveryPayment.NetPaymentAmount
                    };
                    organizationService.Update(AugsubnominalaggregationToUpdate);
                }
                if (cdpData.ProfileSubnominalId == null)
                {
                    sfa_contractdeliverableperiod deliverablePeriodToUpdate = new sfa_contractdeliverableperiod
                    {
                        Id = cdpData.CDPId,
                        sfa_profilesubnominal = new EntityReference(sfa_subnominalaggregation.EntityLogicalName,
                                            newSubnominaldata.SAId)
                    };
                    organizationService.Update(deliverablePeriodToUpdate);
                }
            }
        }
        private string MapSSFSubnominalCodewithDeliverable(string delCode)
        {
            switch (delCode)
            {
                case "2":
                    return "2219100";
                case "13":
                    return "2206037";
                case "47":
                    return "2202800";
                case "114":
                    return "2218011";
                case "48":
                    return "2219105";
                case "138":
                    return "2218070";
                case "146":
                    return "2219200";
                default:
                    return "oldSubnominalCode";
            }
        }
        private static List<T> FromJsonMessageList<T>(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<List<T>>(streamReader.ReadToEnd());
            }
        }
    }
    public class DeliverableUKPRN
    {
        public string UKPRN { get; set; }
        public string ProviderName { get; set; }
    }
}
