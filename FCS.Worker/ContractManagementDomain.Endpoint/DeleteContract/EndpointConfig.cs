
namespace ContractManagementDomain.Endpoint.DeleteContract
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly =>
            "ContractManagementDomain.Endpoint.dll";

        public string EndpointName =>
            "ContractManagement.DeleteContract";

        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new[]
        {
            nameof(DraftContractDeletedEvent)
        };

        public IReadOnlyCollection<Subscription> Subscriptions =>
            new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute(EndpointName, typeof(DeleteDocumentsForContractCommand)),
            new CommandRoute(EndpointName, typeof(DeleteContractCommand)),
            new CommandRoute(EndpointName, typeof(DeleteMasterContractsCommand)),
            new CommandRoute("ContractManagementDomain.IssueNotification.Xrm", typeof(IssueCrmNotificationCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging (aligned)
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation(
                "Started Endpoint {EndpointName} on FCS.Worker",
                EndpointName);

            // ✅ Conventions (aligned)
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
                services.AddDeleteContractServices();
            });

            return configuration;
        }
    }
}
