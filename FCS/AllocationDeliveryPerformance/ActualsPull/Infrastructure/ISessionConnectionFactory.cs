namespace ActualsPull.Infrastructure
{
    using NServiceBus;

    public interface ISessionConnectionFactory
    {
        ConnectionInfo GetConnection(IMessageHandlerContext context);
    }
}
