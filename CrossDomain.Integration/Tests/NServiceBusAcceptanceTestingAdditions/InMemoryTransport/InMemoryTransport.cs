namespace NServiceBusAcceptanceTestingAdditions.InMemoryTransport
{
    using System.Diagnostics.CodeAnalysis;
    using NServiceBus;
    using NServiceBus.Configuration.AdvanceExtensibility;
    using NServiceBus.Features;
    using NServiceBus.Transports;

    [ExcludeFromCodeCoverage]
    public class InMemoryTransport : TransportDefinition
    {
        private static InMemoryQueues _queues = new InMemoryQueues();

        public static InMemoryQueues Queues { get { return _queues; } }

        public InMemoryTransport()
        {
            HasNativePubSubSupport = false;
            HasSupportForCentralizedPubSub = false;
            HasSupportForDistributedTransactions = false;
            RequireOutboxConsent = true;
        }

        protected override void Configure(BusConfiguration config)
        {
            config.GetSettings().SetDefault("EndpointInstanceDiscriminator", "");
            
            config.EnableFeature<InMemoryTransportConfigurator>();

            config.EnableFeature<MessageDrivenSubscriptions>();
            config.EnableFeature<TimeoutManagerBasedDeferral>();

            config.GetSettings().EnableFeatureByDefault<StorageDrivenPublishing>();
            config.GetSettings().EnableFeatureByDefault<TimeoutManager>();
        }

    }
}
