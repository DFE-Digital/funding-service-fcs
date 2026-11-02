namespace Datafix.Tests
{
    using AllocationDelivery.Messages.Commands;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;

    [TestClass]
    public class SendCheckForMonthEndCompletionCommandTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void SendCheckForMonthEndCompletionCommand()
        {
            ISendOnlyBus bus = CreateBus();

            bus.Send("AllocationDeliveryDomain.MonthEndCheck", new CheckForMonthEndCompletionCommand());
        }

        private static ISendOnlyBus CreateBus()
        {
            var configuration = new BusConfiguration();

            configuration.AssembliesToScan(
                AllAssemblies.Matching("AllocationDeliveryDomain.Endpoint.dll")
                    .And("Microsoft.WindowsAzure.Configuration.dll")
                    .And("NServiceBus.Azure.Transports.WindowsAzureServiceBus.dll"));

            configuration.UseTransport<AzureServiceBusTransport>();

            configuration.ScaleOut().UseSingleBrokerQueue();

            configuration.UseSerialization<JsonSerializer>();
            configuration.UsePersistence<InMemoryPersistence>();
            configuration.Conventions()
                .DefiningCommandsAs(t => null != t.Namespace && t.Namespace.EndsWith("Commands"));

            return Bus.CreateSendOnly(configuration);
        }
    }
}
