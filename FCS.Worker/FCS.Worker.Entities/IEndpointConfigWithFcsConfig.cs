namespace SFA.FCS.Worker.Common
{
    using System.Collections.Generic;
    using NServiceBus;

    public interface IEndpointConfigWithFcsConfig
    {
        string NameOfAssembly { get; }

        string EndpointName { get; }

        IReadOnlyCollection<Subscription> Subscriptions { get; }

        IReadOnlyCollection<CommandRoute> Routes { get; }

        EndpointConfiguration GetEndpointConfiguration(SFA.FCT.Framework.Logging.Interfaces.ILogger logger, IFcsConfiguration appConfiguration);
    }
}
