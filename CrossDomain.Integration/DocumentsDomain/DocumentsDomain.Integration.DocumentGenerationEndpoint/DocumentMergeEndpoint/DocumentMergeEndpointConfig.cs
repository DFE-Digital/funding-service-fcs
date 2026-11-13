
namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.DocumentMergeEndpoint
{
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using System.Collections.Generic;
    using System.Linq;
    using Common.Commands;
    using FCS.Worker.Common;
    using SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.IoC;

    public class DocumentMergeEndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "DocumentsDomain.Integration.DocumentGenerationEndpoint.dll";

        public string EndpointName => "DocumentsDomain.MergeDocument";

        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute(
                "DocumentsDomain.XrmHandler",
                typeof(UpdateDocumentMergeStatusCommand))
        };

        public IReadOnlyCollection<Subscription> Subscriptions =>
            Enumerable.Empty<Subscription>().ToList();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateLogger<DocumentMergeEndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            // ✅ Conventions only
            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace?.EndsWith("Commands") == true)
                .DefiningEventsAs(t => t.Namespace?.EndsWith("Events") == true);

            // ✅ DI only
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);

                services.AddDocumentMergeServices(loggerFactory);
            });

            return configuration;
        }
    }
}
