namespace NServiceBusAcceptanceTestingAdditions
{
    using System;
    using System.Diagnostics.CodeAnalysis;
    using System.Linq;
    using NServiceBus.Pipeline;
    using NServiceBus.Pipeline.Contexts;
    using NServiceBus.Unicast.Subscriptions;
    using NServiceBus;

    [ExcludeFromCodeCoverage]
    public class SubscriptionBehavior : IBehavior<IncomingContext>
    {
        public void Invoke(IncomingContext context, Action next)
        {
            next();
            var subscriptionMessageType = GetSubscriptionMessageTypeFrom(context.PhysicalMessage);
            if (EndpointSubscribed != null && subscriptionMessageType != null)
            {
                EndpointSubscribed(new SubscriptionEventArgs
                {
                    MessageType = subscriptionMessageType,
                    SubscriberReturnAddress = context.PhysicalMessage.ReplyToAddress
                });
            }
        }

        public static Action<SubscriptionEventArgs> EndpointSubscribed;

        public static void OnEndpointSubscribed(Action<SubscriptionEventArgs> action)
        {
            EndpointSubscribed = action;
        }

        internal class Registration : RegisterStep
        {
            public Registration()
                : base("SubscriptionBehavior", typeof(SubscriptionBehavior), "So we can get subscription events")
            {
                InsertBefore(WellKnownStep.CreateChildContainer);
            }
        }

        private static string GetSubscriptionMessageTypeFrom(TransportMessage msg)
        {
            return (from header in msg.Headers where header.Key == Headers.SubscriptionMessageType select header.Value).FirstOrDefault();
        }
    }
}