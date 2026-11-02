namespace SFA.FCT.Operations.Integrity.WebJob
{
    using System;
    using NServiceBus;
    using Common.Commands;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Messages.Commands;

    public class Program
    {
        public static void Main()
        {
            Console.WriteLine("Initiating Integrity check");

            try
            {
                BusConfiguration configuration = new BusConfiguration();
                configuration.Conventions().DefiningCommandsAs(t => t == typeof(InitiateCheckersCommand));
                configuration.UseSerialization<JsonSerializer>();
                configuration.UseTransport<AzureServiceBusTransport>();
                configuration.EnableInstallers();

                using (ISendOnlyBus bus = Bus.CreateSendOnly(configuration))
                {
                    bus.Send(FctEndpoint.GenerateEndpointName("Operations.IntegrityCheckers"), InitiateCheckersCommand.CreateDefaultCommand());

                    Console.WriteLine("Initiate Integrity check completed successfully");
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("Initiating Integrity check failed. Message: " + e);
            }
        }
    }
}
