namespace Datafix.Tests
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Common;

    [TestClass]
    public class PublishApprovedContractCommandDataFixes
    {
        [TestMethod, TestCategory("DataFix_R50B")]
        public void SendPublishApprovedContractCommandForContractNumber1619F_3360()
        {
            ISendOnlyBus bus = CreateBus();

            bus.Send(new PublishApprovedContractCommand
            {
                ContractNumber = "1619F-3360",
                MasterContractNumber = "ESFA-14514"
            });
        }

        private static ISendOnlyBus CreateBus()
        {
            var configuration = new BusConfiguration();

            configuration.AssembliesToScan(
                AllAssemblies.Matching("PerformanceManagementDomain.dll")
                    .And("Microsoft.WindowsAzure.Configuration.dll")
                    .And("NServiceBus.Azure.Transports.WindowsAzureServiceBus.dll")
                    .And("ContractManagementService.Common.dll"));

            configuration.UseTransport<AzureServiceBusTransport>();

            configuration.ScaleOut().UseSingleBrokerQueue();

            configuration.UseSerialization<JsonSerializer>();
            configuration.UsePersistence<InMemoryPersistence>();
            configuration.Conventions()
                .DefiningCommandsAs(t => null != t.Namespace && t.Namespace.EndsWith("Commands"));

            configuration.CustomConfigurationSource(new CustomConfigurationProvider(new Dictionary<Type, string>
            {
                {typeof (PublishApprovedContractCommand), "ContractManagementDomain.ContractApproved"}
            }));

            return Bus.CreateSendOnly(configuration);
        }
    }
}