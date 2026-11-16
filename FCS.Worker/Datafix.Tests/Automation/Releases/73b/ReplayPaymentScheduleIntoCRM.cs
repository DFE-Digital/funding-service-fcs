namespace Datafix.Tests.Automation.Releases._73b
{
    using System.IO;
    using System.Reflection;
    using Newtonsoft.Json;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Events;

    public class ReplayPaymentScheduleIntoCRM : IApplyDataFix
    {
        public string Release => "R73b";
        public int StoryNumber => 28133;
        public string Name => "Play payment schedule message into CRM for allocation AEBA-1526";
        public int Order => 1;
        public void ApplyDataFix()
        {
            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<PaymentScheduleEvent>();

            var message = FromJson<PaymentScheduleEvent>(
                "Datafix.Tests",
                "Resources.R73b.PaymentSchedule_AEBA-1526_zero_deferred.json");

            endpoint.Send("Xrm.ReceiveQueueForPaymentSchedule", message).Wait();
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
