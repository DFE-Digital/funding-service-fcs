
namespace ContractCreateDomain.IncrementContractVersionEndpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using IoC;

    public class EndPointConfig : IEndpointConfig
    {
        public string NameOfAssembly =>
            "ContractCreateDomain.IncrementContractVersionEndpoint.dll";

        public string EndpointName =>
            "ContractCreateDomain.IncrementContractVersion";

        public IReadOnlyCollection<Subscription> Subscriptions =>
            new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute(
                "ContractCreateDomain.XrmService",
                typeof(AmendContractCommand)),

            new CommandRoute(
                "DocumentsDomain.GenerateDocument",
                typeof(DocumentGenerationCommand))
        };

        private static readonly IReadOnlyCollection<string> RelevantCommands =
            new List<string>
            {
                nameof(IncrementContractVersionCommand),
                nameof(DocumentGenerationComplete),
                nameof(AmendContractUnsuccessful),
                nameof(ContractAmended),
                nameof(AmendContractCommand),
                nameof(DocumentGenerationCommand)
            };

        public EndpointConfiguration GetEndpointConfiguration(
            ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging
            var logger = loggerFactory.CreateLogger<EndPointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            // ✅ Conventions (FIXED: combined into ONE rule)
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    (t?.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    RelevantCommands.Any(c => t.Name.EndsWith(c)))
                .DefiningEventsAs(t =>
                    t?.Namespace != null && t.Namespace.EndsWith("Events"));

            // ✅ Serialization
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ Local DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddIncrementContractVersionServices();
            });

            return configuration;
        }
    }
}
