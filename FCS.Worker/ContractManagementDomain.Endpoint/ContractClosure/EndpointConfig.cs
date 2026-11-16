
namespace ContractManagementDomain.Endpoint.ContractClosure
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly =>
            "ContractManagementDomain.Endpoint.dll";

        public string EndpointName =>
            "ContractManagementDomain.ContractClosure";

        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint =
            new List<string>
            {
                nameof(ContractClosedEvent)
            };

        public IReadOnlyCollection<Subscription> Subscriptions =>
            Enumerable.Empty<Subscription>().ToArray();

        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute(
                "ContractManagementDomain.IssueNotification.Xrm",
                typeof(IssueCrmNotificationCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(
            ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Clean logging
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation(
                "Started Endpoint {EndpointName} on FCS.Worker",
                EndpointName);

            // ✅ Conventions (preserved)
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    t?.Namespace != null &&
                    t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t =>
                    EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            // ✅ Required for .NET 8
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ Clean DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddContractClosureServices();
            });

            return configuration;
        }
    }
}
