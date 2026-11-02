namespace Datafix.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Common.MessageMutators;
    using SFA.FCT.CrossDomain.Integration.Events;
    using UnitTests.Common;

    [TestClass]
    public class SendVeryLargeMessageTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void SendVeryLargeMessageToAuditQueue()
        {
            PaymentScheduleEvent message = TestResource.FromJson<PaymentScheduleEvent>(
                "Datafix.Tests.Resources", "VeryLargePaymentScheduleEvent.json");
            CreateBus().Send("audit", message);
        }

        private static ISendOnlyBus CreateBus()
        {
            var configuration = new BusConfiguration();
            configuration.AssembliesToScan(
               AllAssemblies.Matching("CrossDomain.Integration.Events.dll")
                   .And("Microsoft.WindowsAzure.Configuration.dll")
                   .And("NServiceBus.Azure.Transports.WindowsAzureServiceBus.dll")
                   .And("CrossDomain.Integration.Messages.dll"));

            configuration.UseSerialization<JsonSerializer>();
            configuration.UseTransport<AzureServiceBusTransport>();
            configuration.UsePersistence<InMemoryPersistence>();
            configuration.EndpointName("PaymentManagementDomain.PaymentSchedule");
            configuration.Conventions().DefiningCommandsAs(t => t == typeof(PaymentScheduleEvent));

            configuration.RegisterComponents(components =>
            {
                components.ConfigureComponent<TransportMessageCompressionMutator>(DependencyLifecycle.SingleInstance);
            });

            configuration.ScaleOut().UseSingleBrokerQueue();

            return Bus.CreateSendOnly(configuration);
        }
    }
}
