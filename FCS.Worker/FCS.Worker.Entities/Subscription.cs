namespace SFA.FCS.Worker.Common
{
    using System;

    public class Subscription
    {
        public Subscription(string subscribeToEndpoint, Type eventType)
        {
            PublisherName = subscribeToEndpoint;
            EventType = eventType;
        }

        public string PublisherName { get; }

        public Type EventType { get; }
    }
}
