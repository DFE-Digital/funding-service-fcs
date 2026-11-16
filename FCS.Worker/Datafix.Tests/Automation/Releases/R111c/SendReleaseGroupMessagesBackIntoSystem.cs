using Azure.Messaging.ServiceBus;
using Datafix.Tests.Automation;
using Datafix.Tests.Services;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using NServiceBus;
using SFA.FCT.CrossDomain.Integration.Messages.Messages;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;

public class SendReleaseGroupMessagesBackIntoSystem : IApplyDataFix
{
    public string Release => "R111c";
    public int StoryNumber => 36101;
    public string Name => "Run 46 DocumentGenerationComplete";
    public int Order => 1;

    public void ApplyDataFix()
    {
        // Run async code from sync method
        Run().GetAwaiter().GetResult();
    }

    private async Task Run()
    {
        var bodies = GetMessageBodiesFromJsonFile(
            "Datafix.Tests",
            "Resources.R111c.DocGenCompleteMessages.json");

        var fullMessages = bodies.Where(b => b is JObject).ToList();

        var docGenCompleteCommands = fullMessages
            .Select(b => b.ToObject<DocumentGenerationComplete>())
            .ToList();

        // ✅ FIX 1: Async endpoint creation
        var endpoint = EndpointBuilder
            .CreateSendOnlyEndpoint<DocumentGenerationComplete>();

        foreach (var command in docGenCompleteCommands)
        {
            await endpoint.Send("FundingAllocation.DocumentGenerationComplete", command);
        }

        // ✅ FIX 2 + 3: Replace MessagingFactory & BrokeredMessage
        var client = GetServiceBusClient();
        var sender = client.CreateSender("FundingAllocation.DocumentGenerationComplete");

        var messages = GetServiceBusMessagesJsonFile(
            "Datafix.Tests",
            "Resources.R111c.DocGenCompleteMessages.json");

        var message = messages[4];

        await sender.SendMessageAsync(message);
    }

    private static IReadOnlyCollection<JToken> GetMessageBodiesFromJsonFile(string nameSpace, string resourceName)
    {
        using var stream = Assembly.GetCallingAssembly()
            .GetManifestResourceStream($"{nameSpace}.{resourceName}");

        using var reader = new StreamReader(stream);

        var jsonString = reader.ReadToEnd();

        var jObjects = JsonConvert.DeserializeObject<List<JObject>>(jsonString);

        return jObjects.Select(m => m["body"]).ToList();
    }

    // ✅ FIX: BrokeredMessage → ServiceBusMessage
    private static IList<ServiceBusMessage> GetServiceBusMessagesJsonFile(string nameSpace, string resourceName)
    {
        using var stream = Assembly.GetCallingAssembly()
            .GetManifestResourceStream($"{nameSpace}.{resourceName}");

        using var reader = new StreamReader(stream);

        var rawMessages = JsonConvert.DeserializeObject<List<string>>(reader.ReadToEnd());

        // Convert JSON strings → ServiceBusMessage
        return rawMessages?
            .Select(msg => new ServiceBusMessage(msg))
            .ToList();
    }

    // ✅ FIX: MessagingFactory → ServiceBusClient
    private static ServiceBusClient GetServiceBusClient()
    {
        var connectionString = ConfigurationManager
            .ConnectionStrings["NServiceBus/Transport"]
            .ConnectionString;

        return new ServiceBusClient(connectionString);
    }
}