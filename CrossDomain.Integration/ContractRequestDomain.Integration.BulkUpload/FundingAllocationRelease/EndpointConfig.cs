namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload.FundingAllocationRelease
{
    using Castle.Windsor;
    using CrossDomain.Integration.Events;
    using FCS.Worker.Common;
    using Framework.Logging;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using System.Collections.Generic;
    using System.Linq;
    using Repositories;

    public class EndpointConfig : IEndpointConfig
    {
        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new List<string>
        {
            nameof(FundingAllocationReleaseInProgressEvent),
            nameof(FundingAllocationReleaseGroupGroupReleasedEvent),
        };

        public string NameOfAssembly => "ContractRequestDomain.Integration.BulkUpload.dll";

        public string EndpointName => "ContractRequestDomain.FundingAllocationRelease";

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>();


        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            var connectionString = Environment.GetEnvironmentVariable("AzureServiceBusConnection");

            if (string.IsNullOrWhiteSpace(connectionString))
            {
                throw new InvalidOperationException(
                    "AzureServiceBusConnection environment variable is not set.");
            }

            configuration.UseTransport(
                new AzureServiceBusTransport(
                    connectionString,
                    TopicTopology.Default));

            configuration.UsePersistence<LearningPersistence>();

            configuration.EnableInstallers();

            configuration.Recoverability()
                .Immediate(i => i.NumberOfRetries(3))
                .Delayed(d => d.NumberOfRetries(3));

            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    (t.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    typeof(ICommand).IsAssignableFrom(t))
                .DefiningEventsAs(t =>
                    EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ Windsor fully replaced here
            configuration.RegisterComponents(services =>
            {
                // Logger factory
                services.AddSingleton(loggerFactory);

                // ✅ Converted Windsor registrations
                services.AddSingleton<ILogger>(
                    _ => loggerFactory.CreateLogger<EndpointConfig>());

                services.AddSingleton<IFundingAllocationReleaseRepository, FundingAllocationReleaseRepository>();

                services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            });

            return configuration;
        }

    }
}
