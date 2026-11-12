// Target: NServiceBus v8+ (DI via Microsoft.Extensions.DependencyInjection)

namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.AggregatePaymentEndpoint
{
    using Microsoft.Extensions.DependencyInjection; // <-- new
    using Microsoft.Extensions.Logging;
    using NServiceBus;
    using PaymentGenerationDomain.BusinessLogic;
    using PaymentGenerationDomain.Integration.DataStore;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
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

        public string EndpointName => "PaymentGenerationDomain.AggregatePayment";

        public IReadOnlyCollection<CommandRoute> Routes => Enumerable.Empty<CommandRoute>().ToArray();

        public IReadOnlyCollection<Subscription> Subscriptions => new[]
        {
            new Subscription("PaymentManagementDomain.PaymentAggregation", typeof(PaymentAggregatedEvent)),
        };

        private static readonly IReadOnlyCollection<Type> PublishedTypes = new List<Type>
        {
            typeof(AllocationPaymentsChangedOnAggregationEvent)
        };


        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            if (loggerFactory is null) throw new ArgumentNullException(nameof(loggerFactory));

            var configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            var connectionString = Environment.GetEnvironmentVariable("AzureServiceBusConnection");

            if (string.IsNullOrWhiteSpace(connectionString))
            {
                throw new InvalidOperationException(
                    "AzureServiceBusConnection environment variable is not set.");
            }

            // ✅ Conventions
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    (t?.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    typeof(ICommand).IsAssignableFrom(t))
                .DefiningEventsAs(t =>
                    Subscriptions.Any(s => s.EventType.IsAssignableFrom(t)) ||
                    PublishedTypes.Contains(t));

            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ Converted WindsorInstaller → MS DI
            configuration.RegisterComponents(services =>
            {
                // -----------------------------
                // Logging
                // -----------------------------
                services.AddSingleton(loggerFactory);

                services.AddSingleton<ILogger>(
                    _ => loggerFactory.CreateLogger<EndpointConfig>());

                // -----------------------------
                // Scoped services
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
