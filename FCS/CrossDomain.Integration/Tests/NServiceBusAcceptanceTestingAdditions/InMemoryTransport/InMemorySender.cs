namespace NServiceBusAcceptanceTestingAdditions.InMemoryTransport
{
    using System;
    using System.Collections.Concurrent;
    using System.Diagnostics.CodeAnalysis;
    using NServiceBus;
    using NServiceBus.Logging;
    using NServiceBus.Transports;
    using NServiceBus.Unicast;

    [ExcludeFromCodeCoverage]
    public class InMemorySender : ISendMessages
    {
        public InMemoryQueues Queues { get; set; }

        public void Send(TransportMessage message, SendOptions sendOptions)
        {
            var destinationQueue = sendOptions.Destination.Queue;

            LogMessage(message, sendOptions);

            // may be send only endpoint
            if (sendOptions.ReplyToAddress != null)
            {
                message.Headers[Headers.ReplyToAddress] = sendOptions.ReplyToAddress.Queue;
            }

            BlockingCollection<TransportMessage> queue = null;
            if (Queues.Queues.TryGetValue(destinationQueue, out queue))
            {
                queue.TryAdd(message);
            }
            else
            {
                throw new Exception(string.Format("Message not sent as queue {0} does not exist", destinationQueue));
            }
        }

        private void LogMessage(TransportMessage message, SendOptions sendOptions)
        {
            if (message.Headers.ContainsKey(Headers.ControlMessageHeader) && string.Compare(message.Headers[Headers.ControlMessageHeader], "true", StringComparison.InvariantCultureIgnoreCase) == 0)
            {
                if (string.Compare(message.Headers[Headers.MessageIntent], "Subscribe", StringComparison.InvariantCultureIgnoreCase) == 0)
                {
                    Logger.InfoFormat("Sending a subscription request to {0} of type {1}", sendOptions.Destination.Queue, message.Headers[Headers.SubscriptionMessageType]);
                }
                else
                {
                    Logger.InfoFormat("Sending an unknown control message with intent {0} to {1}", message.Headers[Headers.MessageIntent], sendOptions.Destination.Queue);
                }
            }
            else
            {
                Logger.InfoFormat("Sending message to {0} of type {1}", sendOptions.Destination.Queue, message.Headers[Headers.EnclosedMessageTypes]);
            }
        }

        private static readonly ILog Logger = LogManager.GetLogger<InMemorySender>();

    }
}