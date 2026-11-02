using Datafix.Tests.Repositories;
using Datafix.Tests.Services;
using Microsoft.Xrm.Sdk.Messages;
using Newtonsoft.Json;
using NServiceBus;
using SFA.FCS.Worker.Common.Crm;
using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;

namespace Datafix.Tests.Automation.Releases.R148
{
    public class UpdateDeliverablesForAffectedUKPRN : IApplyDataFix
    {
        public string Release => "R148";
        public int StoryNumber => 40125;
        public string Name => "Update Deliverables codes for affected ukprn";
        public int Order => 1;

        public void ApplyDataFix()
        {
            try
            {
                string jsonResource = "Resources.R148.AffectedUKPRN.json";
                var deliverableUkprnList = FromJsonMessageList<DeliverableUKPRN>("Datafix.Tests", jsonResource);
                
                foreach (var deliverableUkprn in deliverableUkprnList)
                {
                    var deliveryUkprnsOrgs = CrmContractDeliverableRepository.GetContractDeliverableIdsForUKPRN(deliverableUkprn.UKPRN);
                    foreach (var deliveryUkprnsOrg in deliveryUkprnsOrgs)
                    { 
                       var SSFDeliverlable = MapSSFDeliverabelCode(deliveryUkprnsOrg);

                        //Update CRM and CRM replica DB

                        var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
                        // Update contractdeliverable from CRM
                        sfa_contractdeliverable deliverableToUpdate = new sfa_contractdeliverable
                        {
                            Id = deliveryUkprnsOrg.CdId,
                            sfa_DeliverableCode = SSFDeliverlable.DeliverableCode,
                            sfa_deliverablename = SSFDeliverlable.DeliverableName
                        };

                        organizationService.Update(deliverableToUpdate);

                        // Update contractdeliverable from CRM replica
                        // CrmReplicatedRepository.UpdateDeliverablesCodeBasedOnId(SSFDeliverlable.DeliverableCode, SSFDeliverlable.DeliverableName, deliveryUkprnsOrg.CdId);
                        // No need to update replica as data will be sync from adf pipeline

                        //Update PAAS DB
                      ContractDeliverableRepository.UpdateContractDelvierables(deliveryUkprnsOrg.Contractallocationnumber, deliveryUkprnsOrg.Deliverablecode, SSFDeliverlable.DeliverableCode);

                    }


                }
            }
            catch (Exception ex)
            {

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
    public class UpdatedDeliverables
    {
        public string DeliverableCode { get; set; }
        public string DeliverableName { get; set; }
    }

    public class DeliverableUKPRN
    {
        public string UKPRN { get; set; }
        public string ProviderName { get; set; }
    }


    public class DeliveryUKPRNOrg
    {
        public Guid CdId { get; set; }
        public string Contractallocationnumber { get; set; }
        public string Deliveryorganisationukprn { get; set; }
        public string Deliverablecode { get; set; }
        public string ContractNumber { get; set; }
        public string DeliverableName { get; set; }
        public int? ContractVersion { get; set; }
    }
}
