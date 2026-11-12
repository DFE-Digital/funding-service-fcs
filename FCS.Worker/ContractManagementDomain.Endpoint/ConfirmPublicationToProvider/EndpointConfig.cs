
namespace ContractManagementDomain.Endpoint.ConfirmPublicationToProvider
{
    using System;
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
            "ContractManagementDomain.Endpoint.dll";

        public string EndpointName =>
            "ContractManagementDomain.ConfirmPublicationToProvider";

        public IReadOnlyCollection<Subscription> Subscriptions =>
            Enumerable.Empty<Subscription>().ToList();

        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute(
                "DocumentsDomain.MoveDocument",
                typeof(DocumentMoveCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(
            ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging (aligned)
            var logger = loggerFactory.CreateLogger<EndpointConfig>();

            // ✅ Recoverability (preserved exactly)
            var recoverability = configuration.Recoverability();

            recoverability.Immediate(immediate =>
            {
                immediate.NumberOfRetries(3);
            });

            recoverability.Delayed(delayed =>
            {
                delayed.NumberOfRetries(2);
                delayed.TimeIncrease(TimeSpan.FromMinutes(5));
            });

            logger.LogInformation(
                "Started Endpoint {EndpointName} on FCS.Worker",
                EndpointName);

            // ✅ Conventions (aligned)
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    t?.Namespace != null &&
                    t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t =>
                    t?.Namespace != null &&
                    t.Namespace.EndsWith("Events"))
                .DefiningMessagesAs(t =>
                    t?.Namespace != null &&
                    t.Namespace.EndsWith("Messages"));

            // ✅ Required for .NET 8
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ Clean DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddConfirmPublicationToProviderServices();
            });

            return configuration;
        }
    }
}
