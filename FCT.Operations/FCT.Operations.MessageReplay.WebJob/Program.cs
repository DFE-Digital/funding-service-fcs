
namespace FCT.Operations.MessageReplay.WebJob
{
    using System;
    using System.Configuration;
    using System.Threading.Tasks;
    using NServiceBus;
    using NServiceBus.Transport.AzureServiceBus;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.Operations.Common.Commands;

    public class Program
    {
        public static async Task Main()
        {
            Console.Write("[ENTER] Message ID: ");
            string messageId = Console.ReadLine();

            Console.Write("[ENTER] Description of action taken: ");
            string description = Console.ReadLine();

            Console.WriteLine();
            Console.WriteLine($"Send MessageReplayCommand for {messageId}? [ENTER] 'y' to continue..");

            if (Console.ReadLine() == "y")
            {
                Console.WriteLine($"Initiating MessageReplayCommand for {messageId}.");

                try
                {
                    // ✅ Read from App.config
                    string connectionString =
                        ConfigurationManager.ConnectionStrings["NServiceBus/Transport"]?.ConnectionString;

                    if (string.IsNullOrWhiteSpace(connectionString))
                    {
                        throw new Exception("Connection string 'NServiceBus/Transport' not found.");
                    }

                    // ✅ Endpoint config (modern replacement of BusConfiguration)
                    var endpointConfiguration = new EndpointConfiguration("MessageReplay.Sender");

                    endpointConfiguration.SendOnly();

                    // ✅ Serialization
                    endpointConfiguration.UseSerialization<SystemJsonSerializer>();

                    // ✅ ✅ CORRECT TRANSPORT CONFIG (NO WARNINGS)
                    endpointConfiguration.UseTransport(
                        new AzureServiceBusTransport(
                            connectionString,
                            TopicTopology.Default));

                    // ✅ Start endpoint
                    var endpointInstance = await Endpoint.Start(endpointConfiguration);

                    // ✅ Send command (modern equivalent of bus.Send)
                    await endpointInstance.Send(
                        FctEndpoint.GenerateEndpointName("Operations.MessageReplay"),
                        new MessageReplayCommand
                        {
                            MessageId = messageId,
                            Description = description
                        });

                    Console.WriteLine("MessageReplayCommand sent successfully.");

                    // ✅ Stop endpoint
                    await endpointInstance.Stop();
                }
                catch (Exception ex)
                {
                    Console.WriteLine("MessageReplayCommand sending failed. Message: " + ex);
                }
            }
        }
    }
}
