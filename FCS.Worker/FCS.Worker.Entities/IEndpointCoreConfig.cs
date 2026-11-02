namespace SFA.FCS.Worker.Common
{
    using System.Collections.Generic;
    using Microsoft.Extensions.Configuration;
    using NServiceBus;

    public interface IEndpointCoreConfig
    {
        string NameOfAssembly { get; }

        string EndpointName { get; }

        IReadOnlyCollection<Subscription> Subscriptions { get; }

        IReadOnlyCollection<CommandRoute> Routes { get; }

        EndpointConfiguration GetEndpointConfiguration(SFA.FCT.Framework.Logging.Interfaces.ILogger logger, IConfigurationRoot appConfiguration);
    }
}
