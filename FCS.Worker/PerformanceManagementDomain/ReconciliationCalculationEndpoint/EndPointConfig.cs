
namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.PerformanceManagementDomain.Common.Commands;
    public class EndpointConfig : IEndpointConfig   // ✅ Fixed name
    {
        public string NameOfAssembly =>
            "PerformanceManagementDomain.dll";

        public string EndpointName =>
            "PerformanceManagementDomain.ReconciliationCalculation";

        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint =
            new[]
            {
                nameof(FundingClaimDebatchedEvent),
                nameof(ProposedReconciliationCalculatedEvent),
                nameof(ContractApprovedEvent)
            };

        public IReadOnlyCollection<Subscription> Subscriptions => new[]
        {
            new Subscription(
                "PerformanceManagementDomain.FundingClaimImport",
                typeof(FundingClaimDebatchedEvent)),

            new Subscription(
                "ContractManagementDomain.ContractApproved",
                typeof(ContractApprovedEvent))
        };

        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute(
                EndpointName,
                typeof(RecalculateFundingClaimReconciliationCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(
            ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging (aligned)
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation(
                "Started Endpoint {EndpointName} on FCS.Worker",
                EndpointName);

            // ✅ Conventions (preserved)
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    t?.Namespace != null &&
                    t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t =>
                    EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            // ✅ Required for .NET 8
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddReconciliationCalculationServices();
            });

            return configuration;
        }
    }
}
