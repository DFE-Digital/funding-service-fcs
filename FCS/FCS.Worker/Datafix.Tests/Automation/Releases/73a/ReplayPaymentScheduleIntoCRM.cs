namespace Datafix.Tests.Automation.Releases._73a
{
    using System.IO;
    using System.Reflection;
    using Newtonsoft.Json;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Events;

    public class ReplayPaymentScheduleIntoCRM : IApplyDataFix
    {
        public string Release => "R73a";
        public int StoryNumber => 28133;
        public string Name => "Play payment schedule message into CRM for allocation AEBA-1526";
        public int Order => 1;
        public void ApplyDataFix()
        {
            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<PaymentScheduleEvent>();

            var message = FromJson<PaymentScheduleEvent>(
                "Datafix.Tests",
                "Resources.R73a.PaymentSchedule_AEBA-1526.json");

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
