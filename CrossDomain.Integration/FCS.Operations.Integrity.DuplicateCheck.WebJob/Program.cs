namespace FCS.Operations.Integrity.ShortInterval.WebJob
{
    using System;
    using System.Configuration;
    using System.Timers;
    using Microsoft.Azure.WebJobs;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    class Program
    {
        private static IEndpointInstance _endpoint;

        static void Main()
        {
            Console.WriteLine("Initiating ShortInterval.WebJob");

            if (ShouldSendMessagesInThisEnvironment())
            {
                const int timerIntervalMinutes = 5;

                Timer timer = new Timer(interval: TimeSpan.FromMinutes(timerIntervalMinutes).TotalMilliseconds);
                timer.Elapsed += (sender, _) =>
                {
                    const string feedEndpointName = "Operations.IntegrityCheckers";

                    Console.WriteLine("Sending");
                    try
                    {
                        GetEndpointInstance<OperationalCheckShortIntervalCommand>().Send(feedEndpointName, new OperationalCheckShortIntervalCommand()).Wait();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine($"problem sending command - {e.Message}, {e.StackTrace}");
                    }

                    Console.WriteLine("Sent");
                };

                timer.Start();
                JobHost host = new JobHost();
                host.RunAndBlock();
            }
        }

        private static IEndpointInstance GetEndpointInstance<TCommand>()
        {
            if (_endpoint == null)
            {
                _endpoint = EndpointBuilder.CreateSendOnlyEndpoint<TCommand>();
                Console.WriteLine("Created bus");
            }

            return _endpoint;
        }

        private static bool ShouldSendMessagesInThisEnvironment()
        {
            string shouldSendMessageSetting = ConfigurationManager.AppSettings["ShouldSendMessageInThisEnv"];

            bool.TryParse(shouldSendMessageSetting, out bool shouldSendMessages);

            return shouldSendMessages;
        }
    }
}
