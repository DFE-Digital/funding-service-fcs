// Target: NServiceBus v8+ (DI via Microsoft.Extensions.DependencyInjection)

namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.InitiatePaymentBatchEndpoint
{
    using Common.Commands;
    using Microsoft.Extensions.DependencyInjection; // <-- new
    using Microsoft.Extensions.Logging;
    using NServiceBus;
    using PaymentGenerationDomain.BusinessLogic;
    using PaymentGenerationDomain.Integration.DataStore;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;
    using DataStore.Repositories;
    using Infrastructure;
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.dll";

        public string EndpointName => "PaymentGenerationDomain.InitiatePaymentBatch";

        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute("PaymentGenerationDomain.InitiatePaymentRun", typeof(InitiatePaymentRunCommand))
        };

        public IReadOnlyCollection<Subscription> Subscriptions => Enumerable.Empty<Subscription>().ToArray();


        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            if (loggerFactory is null) throw new ArgumentNullException(nameof(loggerFactory));

            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Correct logger usage
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            var connectionString = Environment.GetEnvironmentVariable("AzureServiceBusConnection");

            if (string.IsNullOrWhiteSpace(connectionString))
            {
                throw new InvalidOperationException(
                    "AzureServiceBusConnection environment variable is not set.");
            }

            // ✅ Clean conventions
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    (t?.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    typeof(ICommand).IsAssignableFrom(t))
                .DefiningEventsAs(t =>
                    t?.Namespace != null && t.Namespace.EndsWith("Events"));

            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ Converted WindsorInstaller → Microsoft DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);

                // -----------------------------
                // Scoped services (from installer)
                // -----------------------------
                services.AddScoped<IDataAccessManager, DataAccessManager>();
                services.AddScoped<PaymentGenerationDbContext>();
                services.AddScoped<IDate, StaticDate>();
                services.AddScoped<IOverrideDateDBContext, OverrideDateDBContext>();
                services.AddScoped<ISubnominalAggregationRepository, SubnominalAggregationRepository>();

                // -----------------------------
                // Singleton services
                // -----------------------------
                services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            });

            return configuration;
        }

    }
}
