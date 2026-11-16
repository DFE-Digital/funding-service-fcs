using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;
using System.Reflection;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Configuration;
using System.Threading.Tasks;
using Azure.Messaging.ServiceBus;
using Datafix.Tests.Automation.Releases.R88.Audit;
using System;

[TestClass]
public class AzureServiceBusServiceTests
{
    [TestMethod, TestCategory("TechnicalExploration")]
    public void AzureServiceBusService_ClearMessagesFromDeadLetterQueue_RemoveCorrectMessages()
    {
        Run().GetAwaiter().GetResult();
    }

    private async Task Run()
    {
        const string auditQueueName = "audit";

        var client = new ServiceBusClient(AzureServiceBusConnectionString);

        var sender = client.CreateSender(auditQueueName);
        var receiver = client.CreateReceiver(auditQueueName);

        var deadLetterReceiver = client.CreateReceiver(
            auditQueueName,
            new ServiceBusReceiverOptions
            {
                SubQueue = SubQueue.DeadLetter
            });

        await ClearQueue(receiver);
        await ClearQueue(deadLetterReceiver);

        var messages = GetMessagesFromJson(
            "Datafix.Tests",
            "Resources.R88.audit_dead_letter_messages.json");

        await AddMessagesToQueue(sender, messages);
        await AddOneRandomMessageToQueue(sender, messages.First());

        await MoveAllMessagesToDeadLetterQueue(receiver);

        var messageIds = messages.Select(m => m.MessageId).ToList();

        // Act
        await AzureServiceBusService.ClearMessagesFromDeadLetterQueue(
            auditQueueName,
            messageIds);

        // TODO: assert logic
    }

    private static async Task ClearQueue(ServiceBusReceiver receiver)
    {
        while (true)
        {
            var messages = await receiver.ReceiveMessagesAsync(50);

            if (messages == null || messages.Count == 0)
                break;

            foreach (var message in messages)
            {
                await receiver.CompleteMessageAsync(message);
            }
        }
    }

    private static async Task AddMessagesToQueue(ServiceBusSender sender, IReadOnlyCollection<ServiceBusMessage> messages)
    {
        foreach (var msg in messages)
        {
            await sender.SendMessageAsync(msg);
        }
    }

    private static async Task AddOneRandomMessageToQueue(ServiceBusSender sender, ServiceBusMessage message)
    {
        var randomMessage = new ServiceBusMessage(message.Body);

        randomMessage.MessageId = "55555555-4444-3333-2222-111111111111";

        await sender.SendMessageAsync(randomMessage);
    }

    private static async Task MoveAllMessagesToDeadLetterQueue(ServiceBusReceiver receiver)
    {
        while (true)
        {
            var messages = await receiver.ReceiveMessagesAsync(50);

            if (messages == null || messages.Count == 0)
                break;

            foreach (var message in messages)
            {
                await receiver.DeadLetterMessageAsync(message);
            }
        }
    }

    // ✅ BrokeredMessage replacement
    private static IReadOnlyCollection<ServiceBusMessage> GetMessagesFromJson(string nameSpace, string resourceName)
    {
        using var stream = Assembly.GetCallingAssembly()
            .GetManifestResourceStream($"{nameSpace}.{resourceName}");

        using var reader = new StreamReader(stream);

        var json = reader.ReadToEnd();

        var bodies = JsonConvert.DeserializeObject<List<string>>(json);

        return bodies.Select(body =>
        {
            var msg = new ServiceBusMessage(body);

            // If JSON includes MessageId, set it here manually
            msg.MessageId = Guid.NewGuid().ToString();

            return msg;
        }).ToList();
    }

    private static string AzureServiceBusConnectionString =>
        ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString;
}