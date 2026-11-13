
namespace ContractManagementDomain.Endpoint.InitiateContractWithdrawal
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly =>
            "ContractManagementDomain.Endpoint.dll";

        public string EndpointName =>
            "ContractManagementDomain.InitiateContractWithdrawal";

        public IReadOnlyCollection<Subscription> Subscriptions =>
            Enumerable.Empty<Subscription>().ToList();

        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute(
                EndpointName,
                typeof(InitiateContractWithdrawalCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(
            ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging FIXED
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation(
                "Started Endpoint {EndpointName} on FCS.Worker",
                EndpointName);

            // ✅ Conventions
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    t?.Namespace != null &&
                    t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t =>
                    t?.Namespace != null &&
                    t.Namespace.EndsWith("Events"));

            // ✅ Required for .NET 8
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ CLEAN DI call
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddInitiateContractWithdrawalServices();
            });

            return configuration;
        }
    }
}
