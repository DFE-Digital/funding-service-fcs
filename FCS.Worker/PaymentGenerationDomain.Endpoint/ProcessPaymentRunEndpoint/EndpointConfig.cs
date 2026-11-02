namespace PaymentGenerationDomain.Endpoint.ProcessPaymentRunEndpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointConfig
    {
        public string EndpointName => "PaymentGenerationDomain.ProcessPaymentRun";

        public string NameOfAssembly => "PaymentGenerationDomain.Endpoint.dll";

        public IReadOnlyCollection<Subscription> Subscriptions => Enumerable.Empty<Subscription>().ToList();

        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute("PaymentGenerationDomain.ProcessPaymentComplete", typeof(ProcessPaymentRunCompleteCommand)),
            new CommandRoute("PaymentGenerationDomain.ProcessPaymentError", typeof(ProcessPaymentRunErrorCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            Logger logger = new Logger(new System.Diagnostics.TraceSource("WorkerRole"));

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on FCS.Worker");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}
