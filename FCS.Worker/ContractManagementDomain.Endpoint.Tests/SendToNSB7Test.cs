namespace ContractManagementDomain.Endpoint.Tests
{
    using System;
    using System.IO;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    [TestClass]
    public class SendToNSB7Test
    {

        [TestMethod]
        [TestCategory("TechnicalExploration")]
        public void SendToNSB7_ShouldSend()
        {
            var endpointConfiguration =
                new EndpointConfiguration("ContractManagementDomain.InitiateContractApproval");

            endpointConfiguration.UseSerialization<SystemJsonSerializer>();

            var transport =
                endpointConfiguration.UseTransport<LearningTransport>();

            transport.Transactions(TransportTransactionMode.ReceiveOnly);

            endpointConfiguration.Conventions()
                .DefiningCommandsAs(
                    t => t.Namespace != null &&
                         t.Namespace.EndsWith("Commands"));

            var scanner = endpointConfiguration.AssemblyScanner();

            var baseDirectory = AppDomain.CurrentDomain.BaseDirectory;

            var assembliesToExclude = Directory
                .EnumerateFiles(baseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            var endpoint =
                Endpoint.Start(endpointConfiguration)
                    .GetAwaiter()
                    .GetResult();

            endpoint.Send(
                    "ContractManagementDomain.InitiateContractApproval",
                    new AggregateDeliverablesCommand())
                .GetAwaiter()
                .GetResult();

            endpoint.Stop()
                .GetAwaiter()
                .GetResult();
        }


    }
}
