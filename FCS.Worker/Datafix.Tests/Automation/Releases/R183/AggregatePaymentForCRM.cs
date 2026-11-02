using SFA.FCS.Worker.Common.Crm;
using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
using System.IO;
using System.Reflection;
using Newtonsoft.Json;
using System;
using Datafix.Tests.Services;
using NServiceBus;
using SFA.FCT.CrossDomain.Integration.Events;
using System.Collections.Generic;

namespace Datafix.Tests.Automation.Releases.R183
{
    internal class AggregatePaymentForCRM: IApplyDataFix
    {
        public string Release => "R183a";

        public int StoryNumber => 49615;

        public string Name => "RePublish Aggregate payment into CRM";

        public int Order => 1;

        public void ApplyDataFix()
        {
            //var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            //organizationService.Delete(Account.EntityLogicalName, new Guid("f04ecfed-fac8-f011-bbd3-000d3a44b227"));
            //organizationService.Delete(Account.EntityLogicalName, new Guid("d14ecfed-fac8-f011-bbd3-000d3a44b227"));

            SendPaymentAggregatedEventsIntoSystem();
        }
        private static void SendPaymentAggregatedEventsIntoSystem()
        {
            var resources = new List<string>
            {
                "Resources.R183.ALLC-6174-ReceiveForPaymentAggregation.json",
                "Resources.R183.ASCA-1897-ReceiveQueueForPaymentSchedule.json",
                "Resources.R183.ASFC-1629-ReceiveForPaymentAggregation.json"
            };

            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<AllocationPaymentsChangedOnAggregationEvent>();

            resources.ForEach(r =>
            {
                var message = FromJson<AllocationPaymentsChangedOnAggregationEvent>("Datafix.Tests", r);
                endpoint.Send("Xrm.ReceiveForPaymentAggregation", message).Wait();
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

    }
}
