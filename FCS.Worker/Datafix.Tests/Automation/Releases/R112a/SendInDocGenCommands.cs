namespace Datafix.Tests.Automation.Releases.R112a
{
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Threading.Tasks;
    using Newtonsoft.Json;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    public class SendInDocGenCommands : IApplyDataFix
    {
        public string Release => "R112a";
        public int StoryNumber => 36194;
        public string Name => "Send in Doc Gen Commands for missing Levy Contracts";
        public int Order => 1;

        public void ApplyDataFix()
        {
            var commands = GetDocumentGenerationCommands("Datafix.Tests", "Resources.R112a.docGenCommands.json");
            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<DocumentGenerationCommand>();
            SendOptions sendOptions = new SendOptions();
            sendOptions.RouteReplyTo("ContractCreateDomain.IncrementContractVersion");
            sendOptions.SetDestination("DocumentsDomain.GenerateDocument");
            var sendTasks = commands.Select(c => endpoint.Send(message:c, options:sendOptions));

            Task.WhenAll(sendTasks).Wait();
        }

        private static DocumentGenerationCommand[] GetDocumentGenerationCommands(string nameSpace, string resourceName)
        {
            using (var stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (var streamReader = new StreamReader(stream))
            {
                var jsonString = streamReader.ReadToEnd();
                return JsonConvert.DeserializeObject<DocumentGenerationCommand[]>(jsonString);
            }
        }
    }
}
