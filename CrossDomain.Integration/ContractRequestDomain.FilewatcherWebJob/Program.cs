namespace SFA.FCT.ContractRequestDomain.FilewatcherWebJob
{
    using System;
    using System.Configuration;
    using System.Diagnostics;
    using System.Diagnostics.CodeAnalysis;
    using NServiceBus;
    using Common.Commands;
    using CrossDomain.Integration.Common;

    [ExcludeFromCodeCoverage]
    public class Program
    {
        private const string EndpointTaskName = "FileWatcher";

        private enum ExitCode
        {
            Success = 0,
            Error = 1,
        }

        public static int Main(string[] args)
        {
            Console.WriteLine("Initiating KickstartFilewatcher Job");

            var exitCode = ExitCode.Error;

            try
            {
                var configuration = new BusConfiguration();
                configuration.Conventions().DefiningCommandsAs(t => t == typeof(StartFileWatcherCommand));
                configuration.UseSerialization<JsonSerializer>();

                string useTransportSetting = ConfigurationManager.AppSettings["NServiceBus.UseTransport"];
                if (!string.IsNullOrEmpty(useTransportSetting) && useTransportSetting.ToLower().Equals("msmq"))
                {
                    configuration.UseTransport<MsmqTransport>();
                }
                else
                {
                    configuration.UseTransport<AzureServiceBusTransport>();
                }

                configuration.EnableInstallers();

                using (var bus = Bus.CreateSendOnly(configuration))
                {
                    string taskName = Debugger.IsAttached ? string.Format("{0}-{1}", EndpointTaskName, Environment.MachineName) : EndpointTaskName;

                    bus.Send(FctEndpoint.GenerateEndpointName("ContractRequestDomain.FileWatcher"), new StartFileWatcherCommand { TaskName = taskName });

                    Console.WriteLine("KickstartFilewatcher completed successfully");

                    exitCode = ExitCode.Success;
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("KickstartFilewatcher failed. Message: " + e);
            }

            return (int)exitCode;
        }
    }
}
