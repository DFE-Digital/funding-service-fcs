namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.InitiatePaymentRunEndpoint
{
    using Common.Commands;
    using Microsoft.Extensions.DependencyInjection; // <-- new
    using Microsoft.Extensions.Logging;
    using NServiceBus;
    using PaymentGenerationDomain.BusinessLogic;
    using PaymentGenerationDomain.Integration.DataStore;
    using DataStore.Repositories;
    using Infrastructure;
    using SFA.FCS.Worker.Common;
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.dll";

        public string EndpointName => "PaymentGenerationDomain.InitiatePaymentRun";

        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute("PaymentGenerationDomain.ProcessPaymentRun", typeof(ProcessPaymentRunCommand))
        };

        public IReadOnlyCollection<Subscription> Subscriptions => Enumerable.Empty<Subscription>().ToArray();


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

            // ✅ Conventions (clean)
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    (t?.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    typeof(ICommand).IsAssignableFrom(t))
                .DefiningEventsAs(t =>
                    t?.Namespace != null && t.Namespace.EndsWith("Events"));

            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ Replace WindsorInstaller here
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);

                // ✅ Scoped services (from installer)
                services.AddScoped<IDataAccessManager, DataAccessManager>();
                services.AddScoped<PaymentGenerationDbContext>();
                services.AddScoped<ISubnominalAggregationRepository, SubnominalAggregationRepository>();

                // ✅ Singleton
                services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            });

            return configuration;
        }

    }
}
