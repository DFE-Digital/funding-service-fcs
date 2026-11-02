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

        private static IEndpointInstance CreateSendOnlyEndpoint<TCommand>()
        {
            EndpointConfiguration endpointConfiguration = new EndpointConfiguration("TestSendingEndpoint");
            endpointConfiguration.UseTransport<AzureServiceBusTransport>();
            endpointConfiguration.Conventions()
                .DefiningCommandsAs(t => t == typeof(TCommand));

            // exclude all
            string[] assembliesToExclude = Directory.EnumerateFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            AssemblyScannerConfiguration scanner = endpointConfiguration.AssemblyScanner();
            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            AzureServiceBusEndpointOrientedTopologySettings transport = endpointConfiguration.UseTransport<AzureServiceBusTransport>().UseEndpointOrientedTopology();
            transport.Transactions(TransportTransactionMode.ReceiveOnly);

            endpointConfiguration.UseSerialization<NewtonsoftSerializer>();

            return Endpoint.Start(endpointConfiguration).GetAwaiter().GetResult();
        }
    }
}
