namespace NServiceBusAcceptanceTestingAdditions.InMemoryTransport
{
    using System.Collections.Concurrent;
    using System.Diagnostics.CodeAnalysis;
    using NServiceBus;

    [ExcludeFromCodeCoverage]
    public class InMemoryQueues
    {
        private readonly ConcurrentDictionary<string, BlockingCollection<TransportMessage>> _queues = new ConcurrentDictionary<string, BlockingCollection<TransportMessage>>();

        /// <summary>
        /// Queues holds all of the in memory queues (keyed by QueueName), BlockingCollection uses ConcurrentQueue by default
        /// </summary>
        public ConcurrentDictionary<string, BlockingCollection<TransportMessage>> Queues { get { return _queues; } }
    }
}
