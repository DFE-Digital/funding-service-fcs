namespace Datafix.Tests.Automation.Releases.R140
{
    using System.Collections.Generic;
    using Datafix.Tests.Repositories;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using System.IO;
    using System.Reflection;
    using Newtonsoft.Json;
    using System;
    using Datafix.Tests.Services;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Events;

    public class RemoveCDandCDP : IApplyDataFix
    {
        public string Release => "R140";

        public int StoryNumber => 38949;

        public string Name => "Delete Duplicate from CD and CDP";

        public int Order => 3;

        public void ApplyDataFix()
        {

            string jsonResource = "Resources.R140.DuplicateCDAndCDP.json";
            var contractdeliverableList = FromJsonMessageList<Deliverable>("Datafix.Tests", jsonResource);
              
            foreach (var contractdeliverable in contractdeliverableList)
            { 
                var contractdeliverableIds = CrmContractDeliverableRepository.GetContractDeliverableIdsForLatestContractCreated
                    (contractdeliverable.ContractNo, contractdeliverable.AllocationNumber, contractdeliverable.DeliverableCode, contractdeliverable.PeriodName);

                if (contractdeliverableIds.Count >= 2)
                {
                    for (int i = 0; i < contractdeliverableIds.Count - 1; i++)
                    {    
                        var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

                        // Delete contractdeliverable from CRM
                        organizationService.Delete(sfa_contractdeliverable.EntityLogicalName, contractdeliverableIds[i].CdId);

                        // Delete duplicate contractdeliverable period from CRM in CRM
                        organizationService.Delete(sfa_contractdeliverableperiod.EntityLogicalName, contractdeliverableIds[i].CdpId);

                        // Delete duplicate contractdeliverable from CRM Replica DB
                        CrmReplicatedRepository.DeleteDuplicateDeliverablesBasedOnId(contractdeliverableIds[i].CdId);

                        // Delete duplicate contractdeliverable period from CRM Replica DB                        
                        CrmReplicatedRepository.DeleteDuplicateDeliverablesPeriodBasedOnId(contractdeliverableIds[i].CdpId);

                    }
                }
            }

            List<Guid> listOfContractdeliverableIds = RemoveGuiIdInContractdeliverable();
            foreach(var deliverableId in listOfContractdeliverableIds)
            {
                var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

                // Delete contractdeliverable from CRM
                organizationService.Delete(sfa_contractdeliverable.EntityLogicalName, deliverableId);
                // Delete duplicate contractdeliverable from CRM Replica DB
                CrmReplicatedRepository.DeleteDuplicateDeliverablesBasedOnId(deliverableId);

            }

            // rerun PaymentAggregation messages

            SendPaymentAggregatedEventsIntoSystem();

            SendPaymentScheduleEventsIntoSystem();
          
        }

        private List<Guid> RemoveGuiIdInContractdeliverable()
        {

            return new List<Guid>()
            {
              new Guid("725fd8d0-c6c8-ed11-b597-000d3abbc604"),
              new Guid("863c4579-c5c8-ed11-b597-000d3abbc58d"),
              new Guid("63f3cadf-c7c8-ed11-b597-000d3abbc604"),
              new Guid("1309202d-c7c8-ed11-b597-000d3abd809a"),
              new Guid("98c8ed7e-c7c8-ed11-b597-000d3abd8966"),
              new Guid("9feaae7a-c6c8-ed11-b597-000d3abd8ed5"),
              new Guid("6db5fe7a-c8c8-ed11-b597-000d3abbc58d"),
              new Guid("b7263b6a-c8c8-ed11-b597-000d3abbc604"),
              new Guid("9f69e485-c8c8-ed11-b597-000d3abbc604"),
              new Guid("15869a6e-c8c8-ed11-b597-000d3abd809a"),
              new Guid("2f8e0570-c8c8-ed11-b597-000d3abd8966"),
              new Guid("79ac936a-c8c8-ed11-b597-000d3abd8ed5"),
              new Guid("f8078d9c-c9c8-ed11-b597-000d3abbc58d"),
              new Guid("77f04250-c9c8-ed11-b597-000d3abbc604"),
              new Guid("1a027da9-c9c8-ed11-b597-000d3abbc604"),
              new Guid("eb40f66a-c9c8-ed11-b597-000d3abd809a"),
              new Guid("e13fe66e-c9c8-ed11-b597-000d3abd8966"),
              new Guid("1c2f6256-c9c8-ed11-b597-000d3abd8ed5")
            };
        }
        private static void SendPaymentAggregatedEventsIntoSystem()
        {
            var resources = new List<string>
            {
                "Resources.R140.ANLP-1221-ReceiveForPaymentAggregation.json",
                "Resources.R140.YNLP-1223-ReceiveForPaymentAggregation.json"
            };

            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<AllocationPaymentsChangedOnAggregationEvent>();

            resources.ForEach(r =>
            {
                var message = FromJson<AllocationPaymentsChangedOnAggregationEvent>("Datafix.Tests", r);
                endpoint.Send("Xrm.ReceiveForPaymentAggregation", message).Wait();
            });
        }

        private static void SendPaymentScheduleEventsIntoSystem()
        {
            var resources = new List<string>
            {
                "Resources.R140.ANLP-1221-ReceiveQueueForPaymentSchedule.json",
                "Resources.R140.YNLP-1223-ReceiveQueueForPaymentSchedule.json"
            };

            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<PaymentScheduleEvent>();

            resources.ForEach(r =>
            {
                var message = FromJson<PaymentScheduleEvent>("Datafix.Tests", r);
                endpoint.Send("Xrm.ReceiveQueueForPaymentSchedule", message).Wait();
            });
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

    public class Deliverable
    {
        public string AllocationNumber { get; set; }
        public string Version { get; set; }
        public string DeliverableCode { get; set; }
        public string PeriodName { get; set; }
        public string ContractNo { get; set; }
    }

    public class ContractDeliverableIds
    {
        public Guid CdId { get; set; }
        public Guid CdpId { get; set; }

    }
}