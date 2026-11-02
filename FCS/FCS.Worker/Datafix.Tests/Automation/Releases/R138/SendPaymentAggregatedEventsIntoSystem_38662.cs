using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using Datafix.Tests.Services;
using Newtonsoft.Json;
using NServiceBus;
using SFA.FCT.CrossDomain.Integration.Events;

namespace Datafix.Tests.Automation.Releases.R138
{
    public class SendPaymentAggregatedEventsIntoSystem_38662 : IApplyDataFix
    {
        public string Release => "R138";

        public int StoryNumber => 38662;

        public string Name => "Payment Issue-The PaymentAggregatedEvent - did not update the SA table";

        public int Order => 1;

        public void ApplyDataFix()
        {

            string jsonResource = "Resources.R138.SendPaymentAggregatedEvents_38662.json";
            var messageList = FromJsonMessageList<PaymentScheduleEvent>("Datafix.Tests", jsonResource);
            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<PaymentScheduleEvent>();


            foreach (var message in messageList)
            {
                endpoint.Send("PaymentManagementDomain.PaymentAggregation", message).Wait();
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
}
