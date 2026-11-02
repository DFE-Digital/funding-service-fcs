namespace ContractRequestDomain.Cfs.FeedWebJob
{
    using System;
    using System.Configuration;
    using System.Timers;
    using ContractRequestDomain.Cfs.Common.Commands;
    using Microsoft.Azure.WebJobs;
    using NServiceBus;

    class Program
    {
        private static ISendOnlyBus _bus;
        static void Main(string[] args)
        {
            Console.WriteLine("Initiating CfsFeedWebJob");

            if (ShouldSendMessagesInThisEnvironment())
            {
                const int timerIntervalMinutes = 5;

                Timer timer = new Timer(interval: TimeSpan.FromSeconds(timerIntervalMinutes).TotalMilliseconds);
                timer.Elapsed += (sender, _) =>
                {
                    const string feedEndpointName = "ContractRequestDomain.Cfs.Feed";

                    GetEndpointInstance().Send(feedEndpointName, new PollNotificationFeedCommand());
                };

                timer.Start();
                JobHost host = new JobHost();
                host.RunAndBlock();
            }
        }

        private static ISendOnlyBus GetEndpointInstance()
        {
           
            if (_bus == null)
            {
                BusConfiguration configuration = new BusConfiguration();
                configuration.Conventions().DefiningCommandsAs(t => t == typeof(PollNotificationFeedCommand));
                configuration.UseSerialization<JsonSerializer>();

                string azureServiceBusConnectionString = ConfigurationManager.ConnectionStrings["AzureServiceBus"].ConnectionString;
                configuration.UseTransport<AzureServiceBusTransport>().ConnectionString(azureServiceBusConnectionString);

                _bus = Bus.CreateSendOnly(configuration);
            }

            return _bus;
        }

        private static bool ShouldSendMessagesInThisEnvironment()
        {
            string shouldSendMessage = ConfigurationManager.AppSettings["ShouldSendMessage"];

            return bool.TryParse(shouldSendMessage, out bool s);
        }
    }
}
