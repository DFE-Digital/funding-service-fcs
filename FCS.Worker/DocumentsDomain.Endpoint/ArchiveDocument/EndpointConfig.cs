
namespace DocumentsDomain.Endpoint.ArchiveDocument
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.DocumentsDomain.Common.Commands;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "DocumentsDomain.Endpoint.dll";

        public string EndpointName => "DocumentsDomain.ArchiveDocument";

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>
        {
            new Subscription("ContractManagementDomain.ContractApproved", typeof(ContractApprovedEvent)),
            new Subscription("ContractManagementDomain.InitiateContractWithdrawal", typeof(ContractWithdrawnEvent))
        };

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("DocumentsDomain.DeleteDocument", typeof(DocumentDeleteCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            // ✅ Conventions (PRESERVED EXACTLY)
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    t?.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t =>
                    Subscriptions
                        .Select(s => s.EventType.Name)
                        .Any(e => t.Name.EndsWith(e)));

            // ✅ Serialization
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ Local DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddArchiveDocumentServices();
            });

            return configuration;
        }
    }
}
