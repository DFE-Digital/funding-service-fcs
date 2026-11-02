namespace PerformanceManagementDomain.Reconciliation.WebJob
{
    using System;
    using System.Configuration;
    using System.Diagnostics.CodeAnalysis;
    using NServiceBus;

    [ExcludeFromCodeCoverage]
    public class Program
    {
        private enum ExitCode
        {
            Success = 0,
            Error = 1,
        }

        public static int Main(string[] args)
        {
            Console.WriteLine("Initiating Funding Claims Reconciliation Polling Job");

            var exitCode = ExitCode.Error;

            try
            {
                var configuration = new BusConfiguration();
                configuration.Conventions().DefiningCommandsAs(t => t == typeof(FundingClaimReconciliationCommand));
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
                    bus.Send<FundingClaimReconciliationCommand>("PerformanceManagementDomain.FundingClaimImport", cmd => { });

                    Console.WriteLine("Initiate Funding Claims Reconciliation completed successfully");

                    exitCode = ExitCode.Success;
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("Funding Claims Reconciliation Polling failed. Message: " + e);
            }

            return (int)exitCode;
        }
    }
}