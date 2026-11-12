namespace SFA.FCT.ContractRequestDomain.EngagementWatcher
{
    using Castle.Windsor;
    using IoC;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Extensions.Logging;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.ContractRequestDomain.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class EndpointConfig : IEndpointConfig
    {
        public string EndpointName => "ContractRequestDomain.EngagementWatcher";

        public string NameOfAssembly => "ContractRequestDomain.EngagementWatcher.dll";

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>
        {
            new Subscription("ContractCreateDomain.CreateContract", typeof(DasContractRequestProviderNotFoundEvent)),
            new Subscription("ContractCreateDomain.CreateContract", typeof(DasContractRequestRejectedEvent)),
            new Subscription("ContractCreateDomain.CreateContractInternal", typeof(DasContractRequestCreatedEvent))
        };

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("ContractRequestDomain.BulkUpload", typeof(NewDasContractRequestCommand)),
            new CommandRoute(EndpointName, typeof(InitiateEngagementPollingCommand)),
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Correct logger usage
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            var connectionString = Environment.GetEnvironmentVariable("AzureServiceBusConnection");

            if (string.IsNullOrWhiteSpace(connectionString))
            {
                throw new InvalidOperationException(
                    "AzureServiceBusConnection environment variable is not set.");
            }

            // ✅ Conventions (fixed & standardised)
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    (t.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    typeof(ICommand).IsAssignableFrom(t))
                .DefiningEventsAs(t =>
                    Subscriptions.Any(s => s.EventType.IsAssignableFrom(t)));

            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ DI registration (reuses your extension)
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);

                services.AddEngagementWatcherServices(loggerFactory);
            });

            return configuration;
        }

    }
}