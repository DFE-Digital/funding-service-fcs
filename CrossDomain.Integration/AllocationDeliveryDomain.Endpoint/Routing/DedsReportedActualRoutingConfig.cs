namespace AllocationDeliveryDomain.Endpoint.Routing
{
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDelivery.Messages.Commands;
    using Castle.Windsor;
    using IoC;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class DedsReportedActualRoutingConfig : IEndpointConfig
    {
        public string NameOfAssembly => "AllocationDeliveryDomain.Endpoint.dll";

        public string EndpointName => "AllocationDeliveryDomain.Routing";

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("AllocationDeliveryDomain.Validation", typeof(ReportedActualsLoadedCommand)),
            new CommandRoute("AllocationDeliveryDomain.PaymentInstructionValidation", typeof(ReportedPaymentInstructionsLoadedCommand))
        };

        public IReadOnlyCollection<Subscription> Subscriptions => Enumerable.Empty<Subscription>().ToList();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on CrossDomain.Integration");

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
