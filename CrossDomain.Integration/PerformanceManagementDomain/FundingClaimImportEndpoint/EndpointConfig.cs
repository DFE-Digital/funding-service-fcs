
namespace SFA.FCT.PerformanceManagementDomain.FundingClaimImportEndpoint
{
    using Common.Commands;
    using FCS.Worker.Common;
    using Microsoft.Extensions.Logging;
    using IoC;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using System.Collections.Generic;
    using System.Linq;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "PerformanceManagementDomain.dll";

        public string EndpointName => "PerformanceManagementDomain.FundingClaimImport";

        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute(EndpointName, typeof(ClosedFundingClaimCollectionCommand)),
            new CommandRoute(EndpointName, typeof(FundingClaimPagedRequestCommand)),
            new CommandRoute(EndpointName, typeof(ProcessFundingClaimsCommand)),
        };

        public IReadOnlyCollection<Subscription> Subscriptions =>
            Enumerable.Empty<Subscription>().ToArray();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateLogger<EndpointConfig>();
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

                services.AddFundingClaimImportServices(loggerFactory);
            });

            return configuration;
        }
    }
}
