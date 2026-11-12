
// File: EndpointConfig.cs
// Target: NServiceBus v8+ (DI via Microsoft.Extensions.DependencyInjection)

#nullable enable
namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.ProcessPaymentRunCompleteEndpoint
{
    using Microsoft.Extensions.DependencyInjection; // <-- replaces Castle Windsor usage
    using Microsoft.Extensions.Logging;
    using NServiceBus;
    using PaymentGenerationDomain.BusinessLogic;
    using PaymentGenerationDomain.BusinessLogic.Mappers;
    using PaymentGenerationDomain.Integration.DataStore;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
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

        public string EndpointName => "PaymentGenerationDomain.ProcessPaymentComplete";

        public IReadOnlyCollection<CommandRoute> Routes => Enumerable.Empty<CommandRoute>().ToArray();

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

            // ✅ ✅ Converted Windsor → Microsoft DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);

                // -----------------------------
                // Scoped services (from installer)
                // -----------------------------
                services.AddScoped<IDataAccessManager, DataAccessManager>();
                services.AddScoped<IAggregatedPaymentMapper, AggregatedPaymentMapper>();
                services.AddScoped<PaymentGenerationDbContext>();
                services.AddScoped<IPaymentSchedulePolicyContext, PaymentSchedulePolicyContext>();
                services.AddScoped<ISubnominalAggregationRepository, SubnominalAggregationRepository>();
                services.AddScoped<IPaymentTimetableRepository, PaymentTimetableRepository>();
                services.AddScoped<IOutstandingPaymentsChecker, OutstandingPaymentsChecker>();
                services.AddScoped<IDate, StaticDate>();
                services.AddScoped<IOverrideDateDBContext, OverrideDateDBContext>();

                // -----------------------------
                // Singleton
                // -----------------------------
                services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            });

            return configuration;
        }

    }
}
