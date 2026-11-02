namespace Datafix.Tests.Automation.Releases.R94c
{
    using System.Collections.Generic;
    using System.IO;
    using System.Reflection;
    using Newtonsoft.Json;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Events;

    public class FixOutOfSyncCRMAllocationsAfterBulkLevyAmendment : IApplyDataFix
    {
        public string Release => "R94c";

        public int StoryNumber => 31118;

        public string Name => "Fix 3 allocations out of sync in CRM after errors during Bulk Levy Amendment";

        public int Order => 1;

        public void ApplyDataFix()
        {
            SendPaymentScheduleEventsIntoSystem();

            SendPaymentAggregatedEventsIntoSystem();
        }

        private static void SendPaymentScheduleEventsIntoSystem()
        {
            var resources = new List<string>
            {
                "Resources.R94b.PaymentSchedule_APPS_2774_zero_deferred.json",
                "Resources.R94b.PaymentSchedule_APPS_2847_zero_deferred.json",
                "Resources.R94b.PaymentSchedule_APPS_2885_zero_deferred.json"
            };

            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<PaymentScheduleEvent>();

            resources.ForEach(r =>
            {
                var message = FromJson<PaymentScheduleEvent>("Datafix.Tests", r);
                endpoint.Send("Xrm.ReceiveQueueForPaymentSchedule", message).Wait();
            });
        }

        private static void SendPaymentAggregatedEventsIntoSystem()
        {
            var resources = new List<string>
            {
                "Resources.R94b.AllocationPaymentsChangedOnAggregationEvent_APPS_2774_zero_deferred.json",
                "Resources.R94b.AllocationPaymentsChangedOnAggregationEvent_APPS_2885_zero_deferred.json",
                "Resources.R94b.AllocationPaymentsChangedOnAggregationEvent_APPS_2847_zero_deferred.json",
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