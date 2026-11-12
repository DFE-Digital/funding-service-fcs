
namespace PerformanceManagementDomain.RecalculationInitiated
{
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Extensions.Logging;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.PerformanceManagementDomain.Common.Commands;  
    using System.Collections.Generic;
    using System.Linq;

public class EndpointConfig : IEndpointConfig
{
    public string NameOfAssembly =>
        "PerformanceManagementDomain.dll";

    public string EndpointName =>
        "PerformanceManagementDomain.RecalculationInitiated";

    public IReadOnlyCollection<Subscription> Subscriptions =>
        Enumerable.Empty<Subscription>().ToList();

    public IReadOnlyCollection<CommandRoute> Routes => new[]
    {
            new CommandRoute(
                "PerformanceManagementDomain.ReconciliationCalculation",
                typeof(RecalculateFcrOnCappedClaimAdjustmentCommand))
        };

    public EndpointConfiguration GetEndpointConfiguration(
        ILoggerFactory loggerFactory)
    {
        var configuration = new EndpointConfiguration(EndpointName);

        // ✅ Logging (fixed)
        var logger = loggerFactory.CreateLogger<EndpointConfig>();
        logger.LogInformation(
            "Started Endpoint {EndpointName} on FCS.Worker",
            EndpointName);

        // ✅ Conventions (aligned)
        configuration.Conventions()
            .DefiningCommandsAs(t =>
                t?.Namespace != null &&
                t.Namespace.EndsWith("Commands"))
            .DefiningEventsAs(t =>
                t?.Namespace != null &&
                t.Namespace.EndsWith("Events"));

        // ✅ Required for .NET 8
        configuration.UseSerialization<SystemJsonSerializer>();

        // ✅ DI
        configuration.RegisterComponents(services =>
        {
            services.AddSingleton(loggerFactory);
            services.AddRecalculationInitiatedServices();
        });

        return configuration;
    }
}
}
