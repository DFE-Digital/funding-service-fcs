namespace AllocationDeliveryDomain.Endpoint.Validation
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using IoC;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ValidationEndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "AllocationDeliveryDomain.Endpoint.dll";

        public string EndpointName => "AllocationDeliveryDomain.Validation";

        public IReadOnlyCollection<CommandRoute> Routes => Enumerable.Empty<CommandRoute>().ToList();

        public IReadOnlyCollection<Subscription> Subscriptions => Enumerable.Empty<Subscription>().ToList();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on CrossDomain.Integration");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t => null != t.Namespace && t.Namespace.EndsWith("Events"));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}
