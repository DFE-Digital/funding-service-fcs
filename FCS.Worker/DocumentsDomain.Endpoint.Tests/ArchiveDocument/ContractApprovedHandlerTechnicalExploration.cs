namespace DocumentsDomain.Endpoint.Tests.ArchiveDocument
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Events;

    [TestClass]
    public class ContractApprovedHandlerTechnicalExploration
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void ContractApprovedHandlerTechnicalExploration_ShouldReceiveMsg()
        {
            var endpointConfiguration = new EndpointConfiguration("ContractManagementDomain.ContractApproved");

            endpointConfiguration.UseTransport<AzureServiceBusTransport>();
            endpointConfiguration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t => t.Name == "ContractApprovedEvent");
            var scanner = endpointConfiguration.AssemblyScanner();

            var baseDirectory = AppDomain.CurrentDomain.BaseDirectory;

            // exclude all
            var assembliesToExclude = Directory.EnumerateFiles(baseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            var transport = endpointConfiguration.UseTransport<AzureServiceBusTransport>()
                .UseEndpointOrientedTopology();
            transport.Transactions(TransportTransactionMode.ReceiveOnly);

            endpointConfiguration.UseSerialization<NewtonsoftSerializer>();

            var endpoint = Endpoint.Start(endpointConfiguration).GetAwaiter().GetResult();
            var msg = new ContractApprovedEvent
            {
                CorporateContract = new contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "Some number"
                        }
                    }
                }
            };
            endpoint.Publish(msg)
                .Wait();
        }
    }
}
