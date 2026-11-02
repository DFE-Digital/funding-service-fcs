namespace ContractRequestDomain.Cfs.DetailWebJob
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
            Console.WriteLine("Initiating CfsDetailWebJob");

            if (ShouldSendMessagesInThisEnvironment())
            {
                const int timerIntervalMinutes = 5;

                Timer timer = new Timer(interval: TimeSpan.FromMinutes(timerIntervalMinutes).TotalMilliseconds);
                timer.Elapsed += (sender, _) =>
                {
                    const string feedEndpointName = "ContractRequestDomain.Cfs.Detail";

                    GetEndpointInstance().Send(feedEndpointName, new ProcessNewAllocationNotificationsCommand());
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
                configuration.Conventions().DefiningCommandsAs(t => t == typeof(ProcessNewAllocationNotificationsCommand));
                configuration.UseSerialization<JsonSerializer>();

                string azureServiceBusConnectionString = ConfigurationManager.ConnectionStrings["AzureServiceBus"].ConnectionString;
                configuration.UseTransport<AzureServiceBusTransport>().ConnectionString(azureServiceBusConnectionString);

                _bus = Bus.CreateSendOnly(configuration);
            }

            return _bus;
        }

        private static bool ShouldSendMessagesInThisEnvironment()
        {
            string shouldSendMessageSetting = ConfigurationManager.AppSettings["ShouldSendMessage"];

            bool.TryParse(shouldSendMessageSetting, out bool shouldSendMessages);

            return shouldSendMessages;
        }
    }
}
