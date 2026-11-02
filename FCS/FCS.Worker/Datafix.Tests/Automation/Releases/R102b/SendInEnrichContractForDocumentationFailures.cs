namespace Datafix.Tests.Automation.Releases.R102b
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;

    public class SendInEnrichContractForDocumentationFailures : IApplyDataFix
    {
        public string Release => "R102b";
        public int StoryNumber => 34487;
        public string Name => "Send EnrichContractForDocumentationCommand messages";
        public int Order => 2;
        public void ApplyDataFix()
        {
            var commands =
                MessageDeserializer.GetMessagesFromFile<EnrichContractForDocumentationCommand>("Datafix.Tests",
                    "Resources.R102b.EnrichContractForDocumentationCommands.json");

            Assert.AreEqual(17, commands.Count, "Unexpected number of messages");

            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<EnrichContractForDocumentationCommand>();
            commands.ToList()
                .ForEach(command =>
                {
                    endpoint.Send(destination: "ContractCreateDomain.EnrichForDocumentation", command).Wait();
                });
        }
    }
}
