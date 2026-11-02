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

namespace Datafix.Tests.Automation.Releases.R153
{
    public class UpdateSSFData : IApplyDataFix
    {
        public string Release => "R153a";
        public int StoryNumber => 408585;
        public string Name => "SSF payment issue  in bulk";
        public int Order => 2;

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

                        #region PAAS

                        //  UPDATE DeliverableCode under PaymentSchedule.DeliverablePayment

                        foreach (var olddeliverableCode in oldDeliverableCodes)
                        {
                            var newDeliverlableCode = MapSSFDeliverabelCode(olddeliverableCode);
                            DeliverablePaymentRepository.UpdateRowsForAllocationVersion(allocation.AllocationNumber, olddeliverableCode, newDeliverlableCode);
                            //Update PAAS DB
                        }

                        foreach (var newdeliverableCode in newDeliverableCodes)
                        {
                            //Update payment for Oct month under PaymentSchedule.DeliverablePayment

                            DeliverablePaymentRepository.UpdateAmountsForAllocationVersion(allocation.AllocationNumber, newdeliverableCode);
                            //need to check, either we have to update or not
                           // DeliverablePaymentRepository.UpdateAugSepAmountsForAllocationVersion(allocation.AllocationNumber, newdeliverableCode, allocation.ContractVersion);
                        }
                        foreach (var oldSubnominalCode in oldSubnominalCodes)
                        {
                            var newSubnominalCode = MapSSFSubnominalCode(oldSubnominalCode);

                            //Update PAAS DB Delete Rows from SubnominalAggregations after oct Month
                            DeliverablePaymentRepository.DeleteAugRowsForSubnominalAggregations(allocation.AllocationNumber, oldSubnominalCode, newSubnominalCode);
                            DeliverablePaymentRepository.DeleteSepRowsForSubnominalAggregations(allocation.AllocationNumber, oldSubnominalCode, newSubnominalCode);

                            DeliverablePaymentRepository.DeleteRowsForSubnominalAggregations(allocation.AllocationNumber, oldSubnominalCode, newSubnominalCode);

                            //update aug and sep month subnominal codes                                                         
                            DeliverablePaymentRepository.UpdateSubnominalForSubnominalAggregations(allocation.AllocationNumber, oldSubnominalCode, newSubnominalCode);
                            DeliverablePaymentRepository.UpdateAugSubnominalForSubnominalAggregations(allocation.AllocationNumber, oldSubnominalCode, newSubnominalCode);
                            DeliverablePaymentRepository.UpdateSepSubnominalForSubnominalAggregations(allocation.AllocationNumber, oldSubnominalCode, newSubnominalCode);

                            var newDeliverlableCode = MapSSFDeliverbleCodeFromSubnominalCode(oldSubnominalCode);
                            //Update aggegate value for new subnominal for Oct month
                            DeliverablePaymentRepository.UpdateAggregateAmountForSubnominalAggregations(allocation.AllocationNumber, newSubnominalCode, allocation.ContractVersion, newDeliverlableCode);

                            //Update aug sep data 
                            //need to check, either we have to update or not
                            DeliverablePaymentRepository.UpdateAugSepAggregateAmountForSubnominalAggregations(allocation.AllocationNumber, newSubnominalCode, allocation.ContractVersion, newDeliverlableCode);
                        }

                        //

                        #endregion PAAS

                        #region CRM

                        var cdpData = CrmContractDeliverableRepository.GetContractDeliverablePeridByAllocationNumber(allocation.AllocationNumber);

                        //TidyUp Aug Month Data
                        UpdateAugMonth(cdpData.Where(x => x.Period.Value == 8).ToList());

                        //TidyUp Sep Month Data
                        UpdateSepMonth(cdpData.Where(x => x.Period.Value == 9).ToList());

                        ////TidyUp Oct Month Onwards Data
                        UpdateOctOnwardsData(cdpData.Where(x => octOnwardPerid.Contains(x.Period.Value)));

                        //TidyUp Oct Month Data
                        UpdateOctMonthData(cdpData.Where(x => x.Period.Value == 10 && x.PeriodName == "Oct-23"));

                        #endregion CRM

                    }
                }
            }
            catch (Exception ex)
            {

            }
        }



        private void UpdateOctMonthData(IEnumerable<ContractDeliverablePeriod> cdpData)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            foreach (var cdp in cdpData.Where(x => x.Period.Value == 10 && x.PeriodName == "Oct-23"))
            {
                var oldSubnominals = MapSSFOLDDeliverabelCode(cdp.DeliverableCode);
                var Key = oldSubnominals.SubnominalCode + "_" + cdp.AllocationNumber + "_" + cdp.PeriodName;

                var Subnominaldata = CrmContractDeliverableRepository.GetSubnominalAggreagetion(Key);

                var newSubnominalCode = MapSSFSubnominalCode(oldSubnominals.SubnominalCode);

                var newKey = newSubnominalCode + "_" + cdp.AllocationNumber + "_" + cdp.PeriodName;

                var newSubnominaldata = CrmContractDeliverableRepository.GetSubnominalAggreagetion(newKey);


                if (cdp.ProfilePaymentAmount != null)
                {
                    //Update Oct Month NetPaymentAmount data into sfa_contractdeliverableperiod
                    sfa_contractdeliverableperiod deliverablePeriodToUpdate = new sfa_contractdeliverableperiod
                    {
                        Id = cdp.CDPId,
                        sfa_BalancingPaymentAmount = 0,
                        sfa_NetPaymentAmount = cdp.ProfilePaymentAmount,
                        sfa_PaymentPosted = cdp.paymentPosted
                    };
                    organizationService.Update(deliverablePeriodToUpdate);
                }
                if (newSubnominaldata != null && Subnominaldata != null)
                {
                    //should be delete
                    organizationService.Delete(sfa_subnominalaggregation.EntityLogicalName, Subnominaldata.SAId);

                }

                //Update Oct Month data aggregate value data into sfa_subnominalaggregation
                if (cdp.ProfileSubnominalId != null && cdp.ProfilePaymentAmount != null)
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
                    if (newSubnominaldata != null && cdp.ProfilePaymentAmount != null)
                    {
                        sfa_subnominalaggregation subnominalaggregationToUpdate = new sfa_subnominalaggregation
                        {
                            Id = newSubnominaldata.SAId,
                            sfa_AggregatedValue = cdp.ProfilePaymentAmount
                        };
                        organizationService.Update(subnominalaggregationToUpdate);
                    }
                }

            }
        }


        private void UpdateOctOnwardsData(IEnumerable<ContractDeliverablePeriod> cdpData)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            foreach (var cdp in cdpData.Where(x => octOnwardPerid.Contains(x.Period.Value)))
            {
                var oldSubnominals = MapSSFOLDDeliverabelCode(cdp.DeliverableCode);

                var Key = oldSubnominals.SubnominalCode + "_" + cdp.AllocationNumber + "_" + cdp.PeriodName;

                var Subnominaldata = CrmContractDeliverableRepository.GetSubnominalAggreagetion(Key);

                var newSubnominalCode = MapSSFSubnominalCode(oldSubnominals.SubnominalCode);

                var newKey = newSubnominalCode + "_" + cdp.AllocationNumber + "_" + cdp.PeriodName;

                var newSubnominaldata = CrmContractDeliverableRepository.GetSubnominalAggreagetion(newKey);
                if (Subnominaldata != null)
                {
                    if (newSubnominaldata != null)
                    {
                        //should be delete
                        organizationService.Delete(sfa_subnominalaggregation.EntityLogicalName, Subnominaldata.SAId);

                    }
                    else
                    {
                        sfa_subnominalaggregation subnominalaggregationToUpdate = new sfa_subnominalaggregation
                        {
                            Id = Subnominaldata.SAId,
                            sfa_name = newSubnominalCode,
                            sfa_SubnominalCode = newSubnominalCode,
                            sfa_SubnominalAggregateKey = newKey
                        };
                        organizationService.Update(subnominalaggregationToUpdate);
                    }
                }
                //Check what should be the value for Nov on ward is Pyament will be calculated or NOT

            }
        }
        private void UpdateSepMonth(List<ContractDeliverablePeriod> cdpDataSep)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            foreach (var cdp in cdpDataSep)
            {

                var oldSubnominals = MapSSFOLDDeliverabelCode(cdp.DeliverableCode);
                var sepKey = oldSubnominals.SubnominalCode + "_" + cdp.AllocationNumber + "_Sep-23";

                var Subnominaldata = CrmContractDeliverableRepository.GetSubnominalAggreagetion(sepKey);
                var newSubnominalCode = MapSSFSubnominalCode(oldSubnominals.SubnominalCode);
                var newKey = newSubnominalCode + "_" + cdp.AllocationNumber + "_" + cdp.PeriodName;

                var newSubnominaldata = CrmContractDeliverableRepository.GetSubnominalAggreagetion(newKey);

                if (newSubnominaldata != null && Subnominaldata != null)
                {
                    //should be delete
                    organizationService.Delete(sfa_subnominalaggregation.EntityLogicalName, Subnominaldata.SAId);
                    if (cdp.NetPaymentAmount != null)
                    {
                        sfa_subnominalaggregation SepsubnominalaggregationToUpdate = new sfa_subnominalaggregation
                        {
                            Id = newSubnominaldata.SAId,
                            sfa_AggregatedValue = cdp.NetPaymentAmount
                        };

                        organizationService.Update(SepsubnominalaggregationToUpdate);
                    }

                    sfa_contractdeliverableperiod deliverablePeriodToUpdate = new sfa_contractdeliverableperiod
                    {
                        Id = cdp.CDPId,
                        sfa_profilesubnominal = new EntityReference(sfa_subnominalaggregation.EntityLogicalName,
                                          newSubnominaldata.SAId),
                        sfa_PaymentPosted = true,
                    };
                    organizationService.Update(deliverablePeriodToUpdate);

                }
                else if (Subnominaldata != null)
                {
                    if (cdp.NetPaymentAmount != null)
                    {
                        sfa_subnominalaggregation SepsubnominalaggregationToUpdate = new sfa_subnominalaggregation
                        {
                            Id = Subnominaldata.SAId,
                            sfa_name = newSubnominalCode,
                            sfa_AggregatedValue = cdp.NetPaymentAmount,
                            sfa_SubnominalCode = newSubnominalCode,
                            sfa_SubnominalAggregateKey = Subnominaldata.AggregateKey.Replace(oldSubnominals.SubnominalCode, newSubnominalCode)
                        };

                        organizationService.Update(SepsubnominalaggregationToUpdate);
                    }
                    sfa_contractdeliverableperiod deliverablePeriodToUpdate = new sfa_contractdeliverableperiod
                    {
                        Id = cdp.CDPId,
                        sfa_profilesubnominal = new EntityReference(sfa_subnominalaggregation.EntityLogicalName,
                                           Subnominaldata.SAId),
                        sfa_PaymentPosted = true,
                    };
                    organizationService.Update(deliverablePeriodToUpdate);
                }
                else if (newSubnominaldata != null)
                {
                    if (cdp.NetPaymentAmount != null)
                    {
                        sfa_subnominalaggregation SepsubnominalaggregationToUpdate = new sfa_subnominalaggregation
                        {
                            Id = newSubnominaldata.SAId,
                            sfa_AggregatedValue = cdp.NetPaymentAmount
                        };
                        organizationService.Update(SepsubnominalaggregationToUpdate);
                    }
                    sfa_contractdeliverableperiod deliverablePeriodToUpdate = new sfa_contractdeliverableperiod
                    {
                        Id = cdp.CDPId,
                        sfa_profilesubnominal = new EntityReference(sfa_subnominalaggregation.EntityLogicalName,
                                            newSubnominaldata.SAId),
                        sfa_PaymentPosted = true,
                    };
                    organizationService.Update(deliverablePeriodToUpdate);
                }
            }
        }

        private void UpdateAugMonth(List<ContractDeliverablePeriod> cdpDataAug)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            foreach (var cdp in cdpDataAug)
            {

                var oldSubnominals = MapSSFOLDDeliverabelCode(cdp.DeliverableCode);
                var augKey = oldSubnominals.SubnominalCode + "_" + cdp.AllocationNumber + "_Aug-23";
                //  var sepKey = oldSubnominals.SubnominalCode + "_" + cdp.AllocationNumber + "_Aug23";


                var Subnominaldata = CrmContractDeliverableRepository.GetSubnominalAggreagetion(augKey);
                var newSubnominalCode = MapSSFSubnominalCode(oldSubnominals.SubnominalCode);
                var newKey = newSubnominalCode + "_" + cdp.AllocationNumber + "_" + cdp.PeriodName;

                var newSubnominaldata = CrmContractDeliverableRepository.GetSubnominalAggreagetion(newKey);

                if (newSubnominaldata != null && Subnominaldata != null)
                {
                    //should be delete
                    organizationService.Delete(sfa_subnominalaggregation.EntityLogicalName, Subnominaldata.SAId);
                    if (cdp.NetPaymentAmount != null)
                    {
                        sfa_subnominalaggregation AugsubnominalaggregationToUpdate = new sfa_subnominalaggregation
                        {
                            Id = newSubnominaldata.SAId,
                            sfa_AggregatedValue = cdp.NetPaymentAmount
                        };

                        organizationService.Update(AugsubnominalaggregationToUpdate);
                    }

                    sfa_contractdeliverableperiod deliverablePeriodToUpdate = new sfa_contractdeliverableperiod
                    {
                        Id = cdp.CDPId,
                        sfa_profilesubnominal = new EntityReference(sfa_subnominalaggregation.EntityLogicalName,
                                          newSubnominaldata.SAId),
                        sfa_PaymentPosted = true,
                    };
                    organizationService.Update(deliverablePeriodToUpdate);

                }
                else if (Subnominaldata != null)
                {
                    if (cdp.NetPaymentAmount != null)
                    {
                        sfa_subnominalaggregation AugsubnominalaggregationToUpdate = new sfa_subnominalaggregation
                        {
                            Id = Subnominaldata.SAId,
                            sfa_name = newSubnominalCode,
                            sfa_AggregatedValue = cdp.NetPaymentAmount,
                            sfa_SubnominalCode = newSubnominalCode,
                            sfa_SubnominalAggregateKey = Subnominaldata.AggregateKey.Replace(oldSubnominals.SubnominalCode, newSubnominalCode)
                        };

                        organizationService.Update(AugsubnominalaggregationToUpdate);
                    }
                    sfa_contractdeliverableperiod deliverablePeriodToUpdate = new sfa_contractdeliverableperiod
                    {
                        Id = cdp.CDPId,
                        sfa_profilesubnominal = new EntityReference(sfa_subnominalaggregation.EntityLogicalName,
                                           Subnominaldata.SAId),
                        sfa_PaymentPosted = true,
                    };
                    organizationService.Update(deliverablePeriodToUpdate);
                }
                else if (newSubnominaldata != null)
                {
                    if (cdp.NetPaymentAmount != null)
                    {
                        sfa_subnominalaggregation AugsubnominalaggregationToUpdate = new sfa_subnominalaggregation
                        {
                            Id = newSubnominaldata.SAId,
                            sfa_AggregatedValue = cdp.NetPaymentAmount
                        };
                        organizationService.Update(AugsubnominalaggregationToUpdate);
                    }
                    sfa_contractdeliverableperiod deliverablePeriodToUpdate = new sfa_contractdeliverableperiod
                    {
                        Id = cdp.CDPId,
                        sfa_profilesubnominal = new EntityReference(sfa_subnominalaggregation.EntityLogicalName,
                                            newSubnominaldata.SAId),
                        sfa_PaymentPosted = true,
                    };
                    organizationService.Update(deliverablePeriodToUpdate);
                }
            }
        }
   
        public List<int> octOnwardPerid = new List<int>
        {
            11,12,1,2,3,4,5,6,7
        };
        public List<string> oldDeliverableCodes = new List<string>
        {
            "20","19","31","112","914","136","143"
        };
        public List<string> oldSubnominalCodes = new List<string>
        {
            "2206036","2203000","2202850","2203023","2203070","2203200","2203025"
        };

        public List<string> newDeliverableCodes = new List<string>
        {
            "2","13","47","114","48","138","146"
        };
        private string MapSSFDeliverabelCode(string oldDeliverableCode)
        {
            DeliverablesSubnominal deliverablesSubnominal = new DeliverablesSubnominal();
            switch (oldDeliverableCode)
            {
                case "20":
                    return "2";
                case "19":
                    return "13";
                case "31":
                    return "47";
                case "112":
                    return "114";
                case "914":
                    return "48";
                case "136":
                    return "138";
                case "143":
                    return "146";
                default:
                    return oldDeliverableCode;
            }
        }

        private DeliverablesSubnominal MapSSFDeliverabelCode(DeliveryUKPRNOrg deliveryUkprnsOrg)
        {
            DeliverablesSubnominal deliverablesSubnominal = new DeliverablesSubnominal();
            switch (deliveryUkprnsOrg.Deliverablecode)
            {
                case "20":
                    return new DeliverablesSubnominal()
                    {
                        DeliverableCode = "2",
                        SubnominalCode = "2219100"
                    };
                case "19":
                    return new DeliverablesSubnominal()
                    {
                        DeliverableCode = "13",
                        SubnominalCode = "2206037"
                    };
                case "31":
                    return new DeliverablesSubnominal()
                    {
                        DeliverableCode = "47",
                        SubnominalCode = "2202800"
                    };
                case "112":
                    return new DeliverablesSubnominal()
                    {
                        DeliverableCode = "114",
                        SubnominalCode = "2218011"
                    };
                case "914":
                    return new DeliverablesSubnominal()
                    {
                        DeliverableCode = "48",
                        SubnominalCode = "2219105"
                    };
                case "136":
                    return new DeliverablesSubnominal()
                    {
                        DeliverableCode = "138",
                        SubnominalCode = "2218070"
                    };
                case "143":
                    return new DeliverablesSubnominal()
                    {
                        DeliverableCode = "146",
                        SubnominalCode = "2219200"
                    };
                default:
                    return new DeliverablesSubnominal()
                    {
                        DeliverableCode = deliveryUkprnsOrg.Deliverablecode
                        ,
                        SubnominalCode = deliveryUkprnsOrg.DeliverableName
                    };
            }
        }

        private DeliverablesSubnominal MapSSFOLDDeliverabelCode(string neweliverableCode)
        {
            switch (neweliverableCode)
            {
                case "2":
                    return new DeliverablesSubnominal()
                    {
                        DeliverableCode = "20",
                        SubnominalCode = "2203000"
                    };
                case "13":
                    return new DeliverablesSubnominal()
                    {
                        DeliverableCode = "19",
                        SubnominalCode = "2206036"
                    };
                case "47":
                    return new DeliverablesSubnominal()
                    {
                        DeliverableCode = "31",
                        SubnominalCode = "2202850"
                    };
                case "114":
                    return new DeliverablesSubnominal()
                    {
                        DeliverableCode = "112",
                        SubnominalCode = "2203023"
                    };
                case "48":
                    return new DeliverablesSubnominal()
                    {
                        DeliverableCode = "914",
                        SubnominalCode = "2203025"
                    };
                case "138":
                    return new DeliverablesSubnominal()
                    {
                        DeliverableCode = "136",
                        SubnominalCode = "2203070"
                    };
                case "146":
                    return new DeliverablesSubnominal()
                    {
                        DeliverableCode = "143",
                        SubnominalCode = "2203200"
                    };
                default:
                    return new DeliverablesSubnominal()
                    {
                        DeliverableCode = neweliverableCode
                        ,
                        SubnominalCode = "new"
                    };
            }
        }
        private string MapSSFSubnominalCode(string oldSubnominalCode)
        {
            switch (oldSubnominalCode)
            {
                case "2203000":
                    return "2219100";
                case "2206036":
                    return "2206037";
                case "2202850":
                    return "2202800";
                case "2203023":
                    return "2218011";
                case "2203025":
                    return "2219105";
                case "2203070":
                    return "2218070";
                case "2203200":
                    return "2219200";
                default:
                    return "oldSubnominalCode";
            }
        }

        private string MapSSFDeliverbleCodeFromSubnominalCode(string oldSubnominalCode)
        {
            switch (oldSubnominalCode)
            {
                case "2203000":
                    return "2";
                case "2206036":
                    return "13";
                case "2202850":
                    return "47";
                case "2203023":
                    return "114";
                case "2203025":
                    return "48";
                case "2203070":
                    return "138";
                case "2203200":
                    return "146";
                default:
                    return "oldSubnominalCode";
            }
        }

        private static T FromJson<T>(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<T>(streamReader.ReadToEnd());
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
    public class DeliverablesSubnominal
    {
        public string DeliverableCode { get; set; }
        public string SubnominalCode { get; set; }
    }

    public class DeliverableUKPRN
    {
        public string UKPRN { get; set; }
        public string ProviderName { get; set; }
    }

}