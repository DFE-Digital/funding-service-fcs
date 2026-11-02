namespace Datafix.Tests.Automation.Releases.R111c
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using Microsoft.ServiceBus.Messaging;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Linq;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;

    public class SendReleaseGroupMessagesBackIntoSystem : IApplyDataFix
    {
        public string Release => "R111c";

        public int StoryNumber => 36101;

        public string Name => "Run 46 DocumentGenerationComplete";

        public int Order => 1;

        public void ApplyDataFix()
        {
            var bodies =
                GetMessageBodiesFromJsonFile("Datafix.Tests",
                    "Resources.R111c.DocGenCompleteMessages.json");
            
            var fullMessages = bodies.Where(b => b is JObject).ToList();

            var docGenCompleteCommands = fullMessages.Select(b => b.ToObject<DocumentGenerationComplete>()).ToList();

            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<DocumentGenerationComplete>();
            docGenCompleteCommands.ForEach(command => endpoint.Send("FundingAllocation.DocumentGenerationComplete", command));
            
            var messageSender =
                GetMessagingFactory().CreateMessageSender("FundingAllocation.DocumentGenerationComplete");
            var brokeredMessages = GetBrokeredMessagesJsonFile("Datafix.Tests",
                "Resources.R111c.DocGenCompleteMessages.json");

            var message = brokeredMessages[4];
            messageSender.Send(message);
        }

        private static IReadOnlyCollection<JToken> GetMessageBodiesFromJsonFile(string nameSpace, string resourceName)
        {
            using (var stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (var streamReader = new StreamReader(stream))
            {
                var jsonString = streamReader.ReadToEnd();
                var jObjects = JsonConvert.DeserializeObject<List<JObject>>(jsonString);
              
                return jObjects.Select(m => m["body"]).ToList();
            }
        }

        private static IList<BrokeredMessage> GetBrokeredMessagesJsonFile(string nameSpace, string resourceName)
        {
            using (var stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (var streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<List<BrokeredMessage>>(streamReader.ReadToEnd());
            }
        }

        private static MessagingFactory GetMessagingFactory()
        {
            return MessagingFactory.CreateFromConnectionString(ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString);
        }
    }
}
