
namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.DocumentMoveEndpoint
{
    using Common.Commands;
    using FCS.Worker.Common;
    using Microsoft.Extensions.Logging;
    using IoC;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using System.Collections.Generic;
    using System.Linq;

    public class DocumentMoveEndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "DocumentsDomain.Integration.DocumentGenerationEndpoint.dll";

        public string EndpointName => "DocumentsDomain.MoveDocument";

        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute("DocumentsDomain.XrmHandler", typeof(UpdateContractPublishedToProviderFailedCommand))
        };

        public IReadOnlyCollection<Subscription> Subscriptions =>
            Enumerable.Empty<Subscription>().ToList();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateLogger<DocumentMoveEndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            // ✅ Conventions only
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t =>
                    t.Namespace != null && t.Namespace.EndsWith("Events"));

            // ✅ DI only
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);

                services.AddDocumentMoveServices(loggerFactory);
            });

            return configuration;
        }
    }
}
