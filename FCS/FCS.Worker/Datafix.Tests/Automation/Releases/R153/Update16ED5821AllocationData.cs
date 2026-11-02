using Datafix.Tests.Automation.Releases.R148;
using Datafix.Tests.Repositories;
using Microsoft.Xrm.Client.Services;
using Microsoft.Xrm.Sdk;
using SFA.FCS.Worker.Common.Crm;
using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Datafix.Tests.Automation.Releases.R153
{
    public class Update16ED5821AllocationData : IApplyDataFix
    {
        public string Release => "R153a";
        public int StoryNumber => 408584;
        public string Name => "SSF payment issue";
        public int Order => 1;
        public void ApplyDataFix()
        {
            //Update data for 10024292
            UpdateDeliverableCodeforOneAllocation();
        }

        private void UpdateDeliverableCodeforOneAllocation()
        {            
            var deliveryUkprnsOrgs = CrmContractDeliverableRepository.GetContractDeliverableIdsForUKPRN("10024292");

            foreach (var deliveryUkprnsOrg in deliveryUkprnsOrgs)
            {
               
                // Update contractdeliverable from CRM

                CRMContractDelivery(deliveryUkprnsOrg);

                //PAAS

                //Update PAAS DB
                if (deliveryUkprnsOrg.Deliverablecode == "19" || deliveryUkprnsOrg.Deliverablecode == "20" || deliveryUkprnsOrg.Deliverablecode == "136")
                {
                    //var SSFDeliverlable = MapSSFDeliverabelCode(deliveryUkprnsOrg);

                    ContractDeliverableRepository.DeleteContractDelvierables(deliveryUkprnsOrg.Contractallocationnumber, deliveryUkprnsOrg.Deliverablecode);
                    var oldsubnominalCode = MapSSFSubnominalCode(deliveryUkprnsOrg.Deliverablecode);
                    ContractDeliverableRepository.DeleteDeliverablePayment(deliveryUkprnsOrg.Contractallocationnumber, deliveryUkprnsOrg.Deliverablecode);
                    ContractDeliverableRepository.DeleteSubnominalAggregation(deliveryUkprnsOrg.Contractallocationnumber, oldsubnominalCode);

                    //ContractDeliverableRepository.UpdateContractDelvierables(deliveryUkprnsOrg.Contractallocationnumber, deliveryUkprnsOrg.Deliverablecode, SSFDeliverlable.DeliverableCode);

                }
            }
        }

        private void CRMContractDelivery(DeliveryUKPRNOrg deliveryUkprnsOrg)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            if (deliveryUkprnsOrg.Deliverablecode == "19" || deliveryUkprnsOrg.Deliverablecode == "20" || deliveryUkprnsOrg.Deliverablecode == "136")
            {
                var ids = CrmContractDeliverableRepository.GetCdpIdsLatestAllocation(deliveryUkprnsOrg.CdId);

                foreach (var id in ids)
                {
                    organizationService.Delete(sfa_contractdeliverableperiod.EntityLogicalName, id);
                }

                organizationService.Delete(sfa_contractdeliverable.EntityLogicalName, deliveryUkprnsOrg.CdId);

                var oldsubnominalCode = MapSSFSubnominalCode(deliveryUkprnsOrg.Deliverablecode);

                foreach (var periodname in periodNameList)
                {
                    var Key = oldsubnominalCode + "_" + deliveryUkprnsOrg.Contractallocationnumber + "_" + periodname;

                    var subnominalId = CrmContractDeliverableRepository.GetSubnominolAggregationId(Key);

                    organizationService.Delete(sfa_subnominalaggregation.EntityLogicalName, subnominalId);
                }
            }
        }

        public List<string> periodNameList = new List<string>
        {
            "Oct-23","Nov-23","Dec-23","Jan-24","Feb-24","Mar-24","Apr-24","May-24","Jun-24","Jul-24"
        };

        private string MapSSFSubnominalCode(string oldDeliverableCode)
        {
            DeliverablesSubnominal deliverablesSubnominal = new DeliverablesSubnominal();
            switch (oldDeliverableCode)
            {
                case "20":
                    return "2203000";
                case "19":
                    return "2206036";
                case "136":
                    return "2203070";
                default:
                    return "";
            }
        }

        private UpdatedDeliverables MapSSFDeliverabelCodeFor10024292(DeliveryUKPRNOrg deliveryUkprnsOrg)
        {
            UpdatedDeliverables updatedDeliverables = new UpdatedDeliverables(); ;
            switch (deliveryUkprnsOrg.Deliverablecode)
            {
                case "20":

                    return new UpdatedDeliverables()
                    {
                        DeliverableCode = "2",
                        DeliverableName = "SSF Programme Funding"
                    };
                case "19":
                    return new UpdatedDeliverables()
                    {
                        DeliverableCode = "13",
                        DeliverableName = "SSF Bursary Funds"
                    };
                case "31":
                    return new UpdatedDeliverables()
                    {
                        DeliverableCode = "47",
                        DeliverableName = "SSF Free Meals"
                    };
                case "112":
                    return new UpdatedDeliverables()
                    {
                        DeliverableCode = "114",
                        DeliverableName = "SSF Capacity and Delivery"
                    };
                case "914":
                    return new UpdatedDeliverables()
                    {
                        DeliverableCode = "48",
                        DeliverableName = "SSF Advanced Maths Premium"
                    };
                case "136":
                    return new UpdatedDeliverables()
                    {
                        DeliverableCode = "138",
                        DeliverableName = "SSF High Value Courses Premium"
                    };
                case "143":
                    return new UpdatedDeliverables()
                    {
                        DeliverableCode = "146",
                        DeliverableName = "SSF Tuition Fund"
                    };
                default:
                    return new UpdatedDeliverables()
                    {
                        DeliverableCode = deliveryUkprnsOrg.Deliverablecode
                        ,
                        DeliverableName = deliveryUkprnsOrg.DeliverableName
                    };
            }
        }


        private UpdatedDeliverables MapSSFDeliverabelCode(DeliveryUKPRNOrg deliveryUkprnsOrg)
        {
            UpdatedDeliverables updatedDeliverables = new UpdatedDeliverables(); ;
            switch (deliveryUkprnsOrg.Deliverablecode)
            {
                case "20":

                    return new UpdatedDeliverables()
                    {
                        DeliverableCode = "2",
                        DeliverableName = "SSF Programme Funding"
                    };
                case "19":
                    return new UpdatedDeliverables()
                    {
                        DeliverableCode = "13",
                        DeliverableName = "SSF Bursary Funds"
                    };
                case "31":
                    return new UpdatedDeliverables()
                    {
                        DeliverableCode = "47",
                        DeliverableName = "SSF Free Meals"
                    };
                case "112":
                    return new UpdatedDeliverables()
                    {
                        DeliverableCode = "114",
                        DeliverableName = "SSF Capacity and Delivery"
                    };
                case "914":
                    return new UpdatedDeliverables()
                    {
                        DeliverableCode = "48",
                        DeliverableName = "SSF Advanced Maths Premium"
                    };
                case "136":
                    return new UpdatedDeliverables()
                    {
                        DeliverableCode = "138",
                        DeliverableName = "SSF High Value Courses Premium"
                    };
                case "143":
                    return new UpdatedDeliverables()
                    {
                        DeliverableCode = "146",
                        DeliverableName = "SSF Tuition Fund"
                    };
                default:
                    return new UpdatedDeliverables()
                    {
                        DeliverableCode = deliveryUkprnsOrg.Deliverablecode
                        ,
                        DeliverableName = deliveryUkprnsOrg.DeliverableName
                    };
            }
        }

        //var deliveryUkprnsNotLatestOrgs = CrmContractDeliverableRepository.GetContractNotLatestDeliverableIdsForUKPRN("10024292");
        //foreach (var deliveryUkprnsNotLatestOrg in deliveryUkprnsNotLatestOrgs)
        //{                
        //    if (deliveryUkprnsNotLatestOrg.ContractVersion == 3)
        //    {
        //        var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

        //        if (deliveryUkprnsNotLatestOrg.Deliverablecode == "19" || deliveryUkprnsNotLatestOrg.Deliverablecode == "20" || deliveryUkprnsNotLatestOrg.Deliverablecode == "136")
        //        {
        //            var ids = CrmContractDeliverableRepository.GetCdpIdsLatestAllocation(deliveryUkprnsNotLatestOrg.CdId);

        //            foreach (var id in ids)
        //            {
        //                organizationService.Delete(sfa_contractdeliverableperiod.EntityLogicalName, id);
        //            }

        //            organizationService.Delete(sfa_contractdeliverable.EntityLogicalName, deliveryUkprnsNotLatestOrg.CdId);
        //        }
        //    }
        //    else if(deliveryUkprnsNotLatestOrg.ContractVersion == 2)
        //    {
        //        var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

        //        var SSFDeliverlable = MapSSFDeliverabelCode(deliveryUkprnsNotLatestOrg);

        //        //Update CRM and CRM replica DB

        //        // Update contractdeliverable from CRM
        //        sfa_contractdeliverable deliverableToUpdate = new sfa_contractdeliverable
        //        {
        //            Id = deliveryUkprnsNotLatestOrg.CdId,
        //            sfa_DeliverableCode = SSFDeliverlable.DeliverableCode,
        //            sfa_deliverablename = SSFDeliverlable.DeliverableName
        //        };

        //        organizationService.Update(deliverableToUpdate);
        //    }
        //}


    }
}
