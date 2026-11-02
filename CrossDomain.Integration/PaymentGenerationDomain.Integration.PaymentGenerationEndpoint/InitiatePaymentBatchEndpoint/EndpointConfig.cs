namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.InitiatePaymentBatchEndpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using Common.Commands;
    using Ioc;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.dll";

        public string EndpointName => "PaymentGenerationDomain.InitiatePaymentBatch";

        public IReadOnlyCollection<CommandRoute> Routes => new []
        {
            new CommandRoute("PaymentGenerationDomain.InitiatePaymentRun", typeof(InitiatePaymentRunCommand))
        };

        public IReadOnlyCollection<Subscription> Subscriptions => Enumerable.Empty<Subscription>().ToArray();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            ILogger logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on CrossDomain.Integration");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t => null != t.Namespace && t.Namespace.EndsWith("Events"))
                .DefiningMessagesAs(t => null != t.Namespace && t.Namespace.EndsWith("Messages"));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new InitiatePaymentBatchWindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}
