namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Exploratory
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Messages.Commands;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using System.Configuration;
    [TestClass]
    public class PreIncrementWithdrawalHandlerTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void PreIncrementWithdrawalHandler_ShouldHandleCommand()
        {
            PreIncrementWithdrawalCommand command = new PreIncrementWithdrawalCommand
            {
                VersionNumber = 1,
                ContractNumber = "APPLEVY-36058",
                MasterContractNumber = "ESFA-60325",
                Ukprn = "10026007"
            };

            CreateSendOnlyEndpoint<PreIncrementWithdrawalCommand>().Send(command).Wait();
        }

        public static IEndpointInstance CreateSendOnlyEndpoint<TCommand>()
        {
            var endpointConfiguration = new EndpointConfiguration("WebJobs");
            endpointConfiguration.SendOnly();

            // 1) Instantiate the modern ASB transport with topology
            var transport = new AzureServiceBusTransport(
                ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString,
                TopicTopology.Default
            );

            // 2) Register the transport
            endpointConfiguration.UseTransport(transport);
            endpointConfiguration.Conventions()
                .DefiningCommandsAs(t => t == typeof(TCommand));

            // Your existing scanner settings
            var assembliesToExclude = Directory.EnumerateFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            var scanner = endpointConfiguration.AssemblyScanner();
            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            endpointConfiguration.UseSerialization<NewtonsoftJsonSerializer>();

            return Endpoint.Start(endpointConfiguration).GetAwaiter().GetResult();
        }
    }
}
