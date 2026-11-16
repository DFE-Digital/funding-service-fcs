namespace Operations.Web.Infrastructure
{
    using System;
    using System.IO;
    using System.Linq;
    using System.Threading.Tasks;
    using NServiceBus;
    using NServiceBus.Logging;
    public class NServiceBusSender : ITransportMessageSender
    {
        public async Task Send<T>(T command, string destination)
        {
            /***
             *  The commented out section below is an attempt to use ASB directlty it is not working at the
             *  moment
             */
            //QueueClient client = QueueClient.CreateFromConnectionString(GetConnectionString(), destination);

            //byte[] bytes = Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(command));
            //MemoryStream stream = new MemoryStream(bytes, writable: false);
            //var brokeredMessage = new BrokeredMessage(stream);

            //Type commandType = command.GetType();
            //string messageType = $"{commandType.AssemblyQualifiedName}";
            //brokeredMessage.Properties.Add("NServiceBus.EnclosedMessageTypes", messageType);
            //brokeredMessage.Properties.Add("NServiceBus.MessageIntent", "Send");
            //brokeredMessage.Properties.Add("NServiceBus.ContentType", "application/json");

            //brokeredMessage.Properties["contentType"] = "application/json";
            //brokeredMessage.Properties.Add("NServiceBus.Transport.Encoding", "wcf/byte-array");
            

            //client.Send(brokeredMessage);

            await CreateSendOnlyEndpoint<T>().Send(destination: destination, message: command);
        }

        public static IEndpointInstance CreateSendOnlyEndpoint<TCommand>()
        {
            EndpointConfiguration endpointConfiguration = new EndpointConfiguration("TestSendingEndpoint");
            endpointConfiguration.SendOnly();

            endpointConfiguration.Conventions()
                .DefiningCommandsAs(t => t == typeof(TCommand));

            string[] assembliesToExclude =
                Directory.EnumerateFiles(
                    AppDomain.CurrentDomain.BaseDirectory,
                    "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            AssemblyScannerConfiguration scanner =
                endpointConfiguration.AssemblyScanner();

            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            endpointConfiguration.UseSerialization<SystemJsonSerializer>();

            return Endpoint.Start(endpointConfiguration)
                .GetAwaiter()
                .GetResult();
        }
    }
}