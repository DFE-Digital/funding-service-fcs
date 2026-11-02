namespace NServiceBusAcceptanceTestingAdditions.InMemoryTransport
{
    using System.Collections.Concurrent;
    using System.Diagnostics.CodeAnalysis;
    using NServiceBus;
    using NServiceBus.Logging;
    using NServiceBus.Transports;

    [ExcludeFromCodeCoverage]
    public class InMemoryCreator : ICreateQueues
    {
        private static ILog Logger = LogManager.GetLogger<InMemoryCreator>();

        public InMemoryQueues Queues { get; set; }

        public void CreateQueueIfNecessary(Address address, string account)
        {
            Logger.InfoFormat("Creating the InMemoryQueue for {0}", address.Queue);
            Queues.Queues.TryAdd(address.Queue, new BlockingCollection<TransportMessage>());
        }
    }
}