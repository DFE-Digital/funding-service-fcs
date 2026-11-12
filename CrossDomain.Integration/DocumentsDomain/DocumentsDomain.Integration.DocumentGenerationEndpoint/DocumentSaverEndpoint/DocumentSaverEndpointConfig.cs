
namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.DocumentSaverEndpoint
{
    using FCS.Worker.Common;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using System.Collections.Generic;
    using System.Linq;
    using IoC;

    public class DocumentSaverEndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "DocumentsDomain.Integration.DocumentGenerationEndpoint.dll";

        public string EndpointName => "DocumentsDomain.SaveDocument";

        public IReadOnlyCollection<CommandRoute> Routes => Enumerable.Empty<CommandRoute>().ToList();

        public IReadOnlyCollection<Subscription> Subscriptions => Enumerable.Empty<Subscription>().ToList();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateLogger<DocumentSaverEndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            // ✅ Conventions only
            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t => t.Namespace != null && t.Namespace.EndsWith("Events"));

            // ✅ DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);

                services.AddDocumentSaverServices(loggerFactory);
            });

            return configuration;
        }
    }
}
