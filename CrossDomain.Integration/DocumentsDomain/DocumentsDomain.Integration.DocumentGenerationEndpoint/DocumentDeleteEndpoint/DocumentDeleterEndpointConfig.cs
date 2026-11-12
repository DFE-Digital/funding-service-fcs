
namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.DocumentDeleteEndpoint
{
    using Common.Commands;
    using FCS.Worker.Common;
    using Microsoft.Extensions.Logging;
    using IoC;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using System.Collections.Generic;
    using System.Linq;

    public class DocumentDeleterEndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "DocumentsDomain.Integration.DocumentGenerationEndpoint.dll";

        public string EndpointName => "DocumentsDomain.DeleteDocument";

        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute(EndpointName, typeof(DocumentDeleteCommand))
        };

        public IReadOnlyCollection<Subscription> Subscriptions =>
            Enumerable.Empty<Subscription>().ToList();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateLogger<DocumentDeleterEndpointConfig>();
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

                services.AddDocumentDeleterServices(loggerFactory);
            });

            return configuration;
        }
    }
}
