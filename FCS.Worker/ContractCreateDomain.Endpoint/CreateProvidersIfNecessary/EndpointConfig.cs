
namespace ContractCreateDomain.Endpoint.CreateProvidersIfNecessary
{
    using System.Collections.Generic;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "ContractCreateDomain.Endpoint.dll";

        public string EndpointName => "ContractCreateDomain.CreateProvidersIfNecessary";

        public IReadOnlyCollection<Subscription> Subscriptions =>
            new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes =>
            new List<CommandRoute>();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            // ✅ Conventions
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    t?.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t =>
                    t?.Namespace != null && t.Namespace.EndsWith("Events"));

            // ✅ Serialization
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ Common Saga DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddContractSagaServices();
            });

            return configuration;
        }
    }
}
