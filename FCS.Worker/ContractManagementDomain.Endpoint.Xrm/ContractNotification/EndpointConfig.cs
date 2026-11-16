
namespace ContractManagementDomain.Endpoint.Xrm.ContractNotification
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly =>
            "ContractManagementDomain.Endpoint.Xrm.dll";

        public string EndpointName =>
            "ContractManagementDomain.IssueNotification.Xrm";

        public IReadOnlyCollection<Subscription> Subscriptions =>
            Enumerable.Empty<Subscription>().ToArray();

        public IReadOnlyCollection<CommandRoute> Routes =>
            Enumerable.Empty<CommandRoute>().ToArray();

        public EndpointConfiguration GetEndpointConfiguration(
            ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            // ✅ Conventions (CUSTOM COMMAND RULE PRESERVED)
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    (t?.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    t.Name.EndsWith(nameof(IssueCrmNotificationCommand)))
                .DefiningEventsAs(t =>
                    t?.Namespace != null && t.Namespace.EndsWith("Events"));

            // ✅ Serialization
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ Local DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddContractNotificationServices();
            });

            return configuration;
        }
    }
}
