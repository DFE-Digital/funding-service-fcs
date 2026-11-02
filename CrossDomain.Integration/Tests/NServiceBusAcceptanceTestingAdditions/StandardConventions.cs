namespace NServiceBusAcceptanceTestingAdditions
{
    using System;
    using System.Diagnostics.CodeAnalysis;
    using NServiceBus;

    [ExcludeFromCodeCoverage]
    public class StandardConventions
    {
        public static Action<BusConfiguration> Configure()
        {
            return configuration =>
            {
                configuration.Conventions()
                    .DefiningEventsAs(t => null != t.Namespace && t.Namespace.EndsWith("Events"))
                    .DefiningCommandsAs(t => null != t.Namespace && t.Namespace.EndsWith("Commands"))
                    .DefiningMessagesAs(t => null != t.Namespace && t.Namespace.EndsWith("Messages"));
            };
        }
    }
}