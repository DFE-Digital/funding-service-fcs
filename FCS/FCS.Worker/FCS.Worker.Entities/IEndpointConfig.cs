namespace SFA.FCS.Worker.Common
{
    using NServiceBus;
    using System.Collections.Generic;

    public interface IEndpointConfig
    {
        string NameOfAssembly { get; }

        string EndpointName { get; }

        IReadOnlyCollection<Subscription> Subscriptions { get; }

        IReadOnlyCollection<CommandRoute> Routes { get; }

        EndpointConfiguration GetEndpointConfiguration(SFA.FCT.Framework.Logging.Interfaces.ILoggerFactory loggerFactory);
    }
}
