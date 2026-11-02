namespace PaymentGenerationDomain.Integration.AggregatePaymentEndpoint
{
    using NServiceBus;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging;
    using Castle.Windsor;
    using Ioc;

    public class EndpointConfig : IConfigureThisEndpoint
    {
        public const string EndpointName = "PaymentGenerationDomain.AggregatePayment";

        public void Customize(EndpointConfiguration configuration)
        {
            ILoggerFactory factory = new LoggerFactory();
            Customize(configuration, factory);
        }

        public void Customize(EndpointConfiguration configuration, ILoggerFactory loggerFactory)
        {
            configuration.UsePersistence<InMemoryPersistence>();
            configuration.DefineEndpointName(EndpointName);

            configuration.Conventions()
                .DefiningEventsAs(t => t.Namespace != null && t.Namespace.EndsWith("Events")) // does this auto-subscribe to *all* events??!
                .DefiningCommandsAs(t => null != t.Namespace && t.Namespace.EndsWith("Commands"))
                .DefiningMessagesAs(t => null != t.Namespace && t.Namespace.EndsWith("Messages"));

            configuration.UseSerialization<JsonSerializer>();

            // NHibernateStorageContext has been deprecated - does this fulfill the same purpose?
            configuration.UnitOfWork()
                .WrapHandlersInATransactionScope(
                    timeout: null, 
                    isolationLevel: System.Transactions.IsolationLevel.RepeatableRead); // unsure about isolation level

            configuration.UseContainer<WindsorBuilder>(c => c.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory))));

            var transport = configuration.UseTransport<AzureServiceBusTransport>();
            // todo: figure out how to set up subscriptions
            // commands seems to look like this:
            //transport.Routing().RouteToEndpoint(assembly, destination) ?
            // most of the stuff in CustomConfigurationSource (UnicastBus etc.) is deprecated
        }
    }
}
