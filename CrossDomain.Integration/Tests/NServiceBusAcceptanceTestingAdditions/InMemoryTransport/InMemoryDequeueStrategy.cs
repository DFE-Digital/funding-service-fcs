namespace NServiceBusAcceptanceTestingAdditions.InMemoryTransport
{
    using System;
    using System.Collections.Concurrent;
    using System.Diagnostics.CodeAnalysis;
    using System.Threading;
    using System.Threading.Tasks;
    using NServiceBus;
    using NServiceBus.Logging;
    using NServiceBus.Transports;
    using NServiceBus.Unicast.Transport;

    [ExcludeFromCodeCoverage]
    public class InMemoryDequeueStrategy : IDequeueMessages, IDisposable
    {
        private Address _address;
        private TransactionSettings _transactionSettings;
        private Func<TransportMessage, bool> _tryProcessMessage = null;
        private Action<TransportMessage, Exception> _endProcessMessage = null;
        private CancellationTokenSource _cancellationTokenSource = new CancellationTokenSource();
        ManualResetEvent stopResetEvent = new ManualResetEvent(true);

        public InMemoryQueues Queues { get; set; }

        static ILog Logger = LogManager.GetLogger<InMemoryDequeueStrategy>();

        public void Init(Address address, TransactionSettings transactionSettings, Func<TransportMessage, bool> tryProcessMessage, Action<TransportMessage, Exception> endProcessMessage)
        {
            _address = address;
            _transactionSettings = transactionSettings;
            _tryProcessMessage = tryProcessMessage;
            _endProcessMessage = endProcessMessage;

            if (address == null)
            {
                throw new ArgumentException("Input queue must be specified");
            }
        }

        public void Start(int maximumConcurrencyLevel)
        {
            Logger.InfoFormat("Starting the InMemoryDequeueStrategy for {0}", _address.Queue);

            Task dequeueTask = Task.Factory.StartNew(DequeueAndProcessMessagesForQueue, _cancellationTokenSource.Token);
        }

        public void Stop()
        {
            Logger.InfoFormat("Stopping the InMemoryDequeueStrategy for {0}", _address.Queue);
            _cancellationTokenSource.Cancel();
            stopResetEvent.WaitOne();
            Queues.Queues[_address.Queue].Dispose();
            Queues.Queues[_address.Queue] = null;
            BlockingCollection<TransportMessage> outMessage;
            Queues.Queues.TryRemove(_address.Queue, out outMessage);
        }

        public void Dispose()
        {
        }

        private void DequeueAndProcessMessagesForQueue()
        {
            BlockingCollection<TransportMessage> queue = null;

            while (!_cancellationTokenSource.IsCancellationRequested)
            {
                if (Queues.Queues.TryGetValue(_address.Queue, out queue))
                {
                    break;
                }

                Logger.InfoFormat("Spinning waiting for the {0} queue to be created", _address.Queue);
                Task.Delay(1000).Wait();
            }

            while (!_cancellationTokenSource.IsCancellationRequested)
            {
                TransportMessage newMessage;
                try
                {
                    stopResetEvent.Reset();

                    try
                    {
                        if (queue.TryTake(out newMessage, 1000, _cancellationTokenSource.Token))
                        {
                            LogIncommingMesage(newMessage);

                            _tryProcessMessage(newMessage);
                            _endProcessMessage(newMessage, null);
                        }
                    }
                    catch (OperationCanceledException)
                    {
                        // just consume it and move on, the _cancellationTokenSource will have requested cancellation and so we 
                        // are on the way out anyway.
                    }
                }
                finally
                {
                    stopResetEvent.Set();
                }
            }
        }

        private void LogIncommingMesage(TransportMessage message)
        {
            if (message.Headers.ContainsKey(Headers.EnclosedMessageTypes))
            {
                Logger.InfoFormat("We have a message to process of type {0}", message.Headers[Headers.EnclosedMessageTypes]);
            }
            else if (message.Headers.ContainsKey(Headers.SubscriptionMessageType))
            {
                Logger.InfoFormat("We have a subscription request to process of type {0}", message.Headers[Headers.SubscriptionMessageType]);
            }
        }
    }
}
