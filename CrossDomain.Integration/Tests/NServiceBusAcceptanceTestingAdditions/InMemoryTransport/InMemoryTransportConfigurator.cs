namespace NServiceBusAcceptanceTestingAdditions.InMemoryTransport
{
    using System.Diagnostics.CodeAnalysis;
    using NServiceBus;
    using NServiceBus.Features;
    using NServiceBus.Logging;
    using NServiceBus.Transports;

    [ExcludeFromCodeCoverage]
    public class InMemoryTransportConfigurator : ConfigureTransport
    {
        static ILog Logger = LogManager.GetLogger<InMemoryTransportConfigurator>();

        internal InMemoryTransportConfigurator()
        {
        }

        protected override void Configure(FeatureConfigurationContext context, string connectionString)
        {
            InMemoryQueues queues = InMemoryTransport.Queues;

            if (!context.Settings.GetOrDefault<bool>("Endpoint.SendOnly"))
            {
                context.Container.ConfigureComponent<InMemoryDequeueStrategy>(DependencyLifecycle.InstancePerCall)
                    .ConfigureProperty(p => p.Queues, queues);
            }

            context.Container.ConfigureComponent<InMemorySender>(DependencyLifecycle.InstancePerCall)
                .ConfigureProperty(p => p.Queues, queues);

            context.Container.ConfigureComponent<InMemoryCreator>(DependencyLifecycle.InstancePerCall)
                .ConfigureProperty(p => p.Queues, queues);
        }

        protected override string ExampleConnectionStringForErrorMessage
        {
            get { return "No connection string required"; }
        }

        protected override bool RequiresConnectionString
        {
            get { return false; }
        }
    }
}
