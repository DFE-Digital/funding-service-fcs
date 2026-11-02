namespace Datafix.Tests.Automation.Releases.R102
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Events;

    public class SendContractApprovedEventsToDocGen : IApplyDataFix
    {
        public string Release => "R102";
        public int StoryNumber => 34279;
        public string Name => "Send failed ContractApprovedEvents to DocumentsDomain.ArchiveDocument (34279)";
        public int Order => 1;
        public void ApplyDataFix()
        {
            const string queueName = "DocumentsDomain.ArchiveDocument";
            var contractApprovedEvents =
                MessageDeserializer.GetMessagesFromFile<ContractApprovedEvent>("Datafix.Tests",
                    "Resources.R102.ContractApprovedEvents.json");

            Assert.AreEqual(19, contractApprovedEvents.Count, "Unexpected number of messages");

            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<ContractApprovedEvent>();
            contractApprovedEvents.ToList()
                .ForEach(command =>
                {
                    endpoint.Send(destination: queueName, command).Wait();
                });

            var azureStorageMessages =
                MessageDeserializer
                    .GetMessagesInAzureStorageFromFile<(string messageBody, string PropertiesCollection)>(
                        "Datafix.Tests",
                        "Resources.R102.ContractApprovedEvents.json");

            Assert.AreEqual(1, azureStorageMessages.Count, "Unexpected number of azure storage messages");

            azureStorageMessages.ToList()
                .ForEach(message => AzureServiceBusSender.SendMessage(queueName, message.messageBody, message.messageProperties));
        }
    }
}
