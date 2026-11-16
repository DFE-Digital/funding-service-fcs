namespace Datafix.Tests.Automation.Releases._R71c
{
    using System.Collections.Generic;
    using System.IO;
    using System.Reflection;
    using Newtonsoft.Json;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Events;

    public class SendPaymentAggregatedEventsIntoSystem //: IApplyDataFix
    {
        public string Release => "R71c";
        public int StoryNumber => 27585;
        public string Name => "Replay Payment Aggregated Events into CRM";
        public int Order => 1;
        public void ApplyDataFix()
        {
            List<string> resources = new List<string>
            {
                "Resources.R71c.AllocationPaymentsChangedOnAggregationEvent_16ED_1889.json",
                "Resources.R71c.AllocationPaymentsChangedOnAggregationEvent_APPS_2371.json",
            };

            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<AllocationPaymentsChangedOnAggregationEvent>();

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
