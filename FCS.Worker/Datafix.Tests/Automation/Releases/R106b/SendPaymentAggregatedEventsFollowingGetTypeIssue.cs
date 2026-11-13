namespace Datafix.Tests.Automation.Releases.R106b
{
    using System.IO;
    using System.Reflection;
    using Newtonsoft.Json;
    using System.Collections.Generic;
    using System.Linq;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Events;

    public class SendPaymentAggregatedEventsFollowingGetTypeIssue : IApplyDataFix
    {
        public string Release => "R106b";

        public int StoryNumber => 35285;

        public string Name => "Send 2 PaymentAggregatedEvent messages following get type issue";

        public int Order => 1;

        public void ApplyDataFix()
        {
            var paymentAggregatedEvents = GetPaymentAggregatedEventsFromJson(
                "Datafix.Tests", "Resources.R106b.PaymentAggregatedEvents.json");

            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<PaymentAggregatedEvent>();

            paymentAggregatedEvents.ToList().ForEach(paymentAggregatedEvent =>
            {
                endpoint.Send("ADMonitoringDomain.Endpoint", paymentAggregatedEvent).Wait();
            });
        }

        private static IReadOnlyCollection<PaymentAggregatedEvent> GetPaymentAggregatedEventsFromJson(string nameSpace, string resourceName)
        {
            using (var stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (var streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<List<PaymentAggregatedEvent>>(streamReader.ReadToEnd());
            }
        }
    }
}