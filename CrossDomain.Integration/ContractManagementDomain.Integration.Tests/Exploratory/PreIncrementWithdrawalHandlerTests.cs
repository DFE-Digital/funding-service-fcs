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
