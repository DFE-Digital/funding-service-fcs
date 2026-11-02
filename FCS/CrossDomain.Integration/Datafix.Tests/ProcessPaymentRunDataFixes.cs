namespace Datafix.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using PaymentGenerationDomain.Common.Commands;
    using UnitTests.Common;

    [TestClass]
    public class ProcessPaymentRunDataFixes
    {
        [TestMethod, TestCategory("DataFix_R05")]
        public void ProcessPaymentRunDataFixes_ShouldProcessLevy1799_201712()
        {
            var command = GetCommandFromFile();

            Assert.IsNotNull(command);
            var bus = CreateBus();

            bus.Send("PaymentGenerationDomain.ProcessPaymentRun", command);
        }

        private ProcessPaymentRunCommand GetCommandFromFile()
        {
            return TestResource.FromJson<ProcessPaymentRunCommand>("Datafix.Tests", "Resources.ProcessPaymentRunCommand_Levy1799_201712.json");
        }

        private ISendOnlyBus CreateBus()
        {
            var configuration = new BusConfiguration();

            configuration.UseSerialization<JsonSerializer>();
            configuration.UseTransport<AzureServiceBusTransport>();
            configuration.Conventions()
                         .DefiningCommandsAs(t =>
                             t == typeof(ProcessPaymentRunCommand));

            return Bus.CreateSendOnly(configuration);
        }
    }
}
