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
    public class ContractWithdrawnHandlerTechnicalExploration
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void ContractWithdrawndHandlerTechnicalExploration_ShouldReceiveMsg()
        {


            var endpointConfiguration =
                new EndpointConfiguration(
                    "ContractManagementDomain.InitiateContractWithdrawal");

            endpointConfiguration.Conventions()
                .DefiningCommandsAs(t =>
                    t.Namespace != null &&
                    t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t =>
                    t.Name == "ContractWithdrawnEvent");


            var scanner = endpointConfiguration.AssemblyScanner();

            var baseDirectory = AppDomain.CurrentDomain.BaseDirectory;

            var assembliesToExclude = Directory
                .EnumerateFiles(baseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            scanner.ExcludeAssemblies(assembliesToExclude);

            endpointConfiguration.UseTransport<LearningTransport>();


            var endpoint = Endpoint.Start(endpointConfiguration).GetAwaiter().GetResult();
            var msg = new ContractWithdrawnEvent
            {
                CorporateContract = new Contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "Some contractNumber from ContractWithdrawnEvent"
                        }
                    }
                }
            };
            endpoint.Publish(msg)
                .Wait();
        }
    }
}