using Azure.Messaging.ServiceBus;
using Newtonsoft.Json;
using NServiceBus;
using System;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
public class EndpointBuilder
{
    private readonly ServiceBusClient client;
    private readonly string connectionString;

    private EndpointBuilder()
    {
        connectionString = ConfigurationManager
            .ConnectionStrings["NServiceBus/Transport"]
            .ConnectionString;

        client = new ServiceBusClient(connectionString);
    }

    public static EndpointBuilder CreateSendOnlyEndpoint<T>()
    {
        return new EndpointBuilder();
    }
    public async Task Publish<T>(Action<T> messageConstructor)
    where T : new()
    {
        var message = new T();
        messageConstructor(message);

        // ✅ Decide topic name (very important)
        var topicName = $"{typeof(T).Name.ToLower()}.events";

        var sender = client.CreateSender(topicName);

        var json = JsonConvert.SerializeObject(message);

        var sbMessage = new ServiceBusMessage(Encoding.UTF8.GetBytes(json));

        // ✅ Required for compatibility
        sbMessage.ApplicationProperties["NServiceBus.EnclosedMessageTypes"] =
            typeof(T).FullName;

        sbMessage.MessageId = Guid.NewGuid().ToString();

        await sender.SendMessageAsync(sbMessage);
    }

    public static EndpointBuilder CreatePublishingEndpoint<T>(string endpointToPublishFrom)
    {
        return new EndpointBuilder();
    }
 

    public Task Send(object message, SendOptions options)
    {
        return Send(options.Destination, message);
    }

    public async Task Send(string destination, object message)
    {
        var sender = client.CreateSender(destination);

        var json = JsonConvert.SerializeObject(message);

        var sbMessage = new ServiceBusMessage(Encoding.UTF8.GetBytes(json));

        sbMessage.ApplicationProperties["NServiceBus.EnclosedMessageTypes"] =
            message.GetType().FullName;

        sbMessage.MessageId = Guid.NewGuid().ToString();

        await sender.SendMessageAsync(sbMessage);
    }

    public async Task Publish(object message)
    {
        var topicName = $"{message.GetType().Name.ToLower()}.events";

        await Send(topicName, message);
    }

    public async Task SendWithDelay(string destination, object message, TimeSpan delay)
    {
        var sender = client.CreateSender(destination);

        var json = JsonConvert.SerializeObject(message);

        var sbMessage = new ServiceBusMessage(Encoding.UTF8.GetBytes(json));

        sbMessage.ApplicationProperties["NServiceBus.EnclosedMessageTypes"] =
            message.GetType().FullName;

        sbMessage.MessageId = Guid.NewGuid().ToString();

        // ✅ delay replacement
        sbMessage.ScheduledEnqueueTime = DateTimeOffset.UtcNow.Add(delay);

        await sender.SendMessageAsync(sbMessage);
    }

}

public class SendOptions
{
    public string Destination { get; set; }
}


