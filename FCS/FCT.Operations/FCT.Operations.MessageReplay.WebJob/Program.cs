namespace FCT.Operations.MessageReplay.WebJob
{
    using System;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.Operations.Common.Commands;

    public class Program
    {
        public static void Main()
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
                    BusConfiguration configuration = new BusConfiguration();
                    configuration.Conventions().DefiningCommandsAs(t => t == typeof (MessageReplayCommand));
                    configuration.UseSerialization<JsonSerializer>();
                    configuration.UseTransport<AzureServiceBusTransport>();

                    using (ISendOnlyBus bus = Bus.CreateSendOnly(configuration))
                    {
                        bus.Send<MessageReplayCommand>(FctEndpoint.GenerateEndpointName("Operations.MessageReplay"), cmd =>
                        {
                            cmd.MessageId = messageId;
                            cmd.Description = description;
                        });

                        Console.WriteLine("MessageReplayCommand sent successfully.");
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("MessageReplayCommand sending failed. Message: " + ex);
                }
            }
        }
    }
}
