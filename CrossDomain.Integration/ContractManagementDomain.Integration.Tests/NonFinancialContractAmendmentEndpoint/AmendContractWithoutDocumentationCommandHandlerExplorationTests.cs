namespace SFA.FCT.ContractManagementDomain.Integration.Tests.NonFinancialContractAmendmentEndpoint
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using ContractManagementService.Common.Commands;
    using ContractManagementService.Common;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using CrossDomain.Integration.Common;
    using System.Configuration;

    [TestClass]
    public class AmendContractNonFinancialAmendmentHandlerExplorationTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void AmendContractNonFinancialAmendmentHandler_ShouldHandleCommand()
        {
            AmendContractNonFinancialAmendmentCommand command = new AmendContractNonFinancialAmendmentCommand
            {
                ContractNumber = "AEBP-1142",
                VersionNumber = 1,
                SubVersionNumber = 0,
                AmendmentType = AmendmentType.Variation,
                IsNonFinancialAmendment = true
            };

            CreateSendOnlyEndpoint<AmendContractNonFinancialAmendmentCommand>().Send(command).Wait();
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
