namespace ActualsPull.NSB
{
    using NServiceBus;

    public interface IEndpointConfig
    {
        string NameOfAssembly { get; }

        string EndpointName { get; }

        EndpointConfiguration GetEndpointConfiguration(SFA.FCT.Framework.Logging.Interfaces.ILoggerFactory loggerFactory);
    }
}
