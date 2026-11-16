namespace SFA.FCS.Worker.Common
{
    using System.Collections.Generic;
    using Microsoft.Extensions.Logging;
    using NServiceBus;

    public interface IEndpointConfig
    {
        string NameOfAssembly { get; }

        string EndpointName { get; }

        IReadOnlyCollection<Subscription> Subscriptions { get; }

        IReadOnlyCollection<CommandRoute> Routes { get; }

        // ✅ Updated to Microsoft logger
        EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory);
    }
}