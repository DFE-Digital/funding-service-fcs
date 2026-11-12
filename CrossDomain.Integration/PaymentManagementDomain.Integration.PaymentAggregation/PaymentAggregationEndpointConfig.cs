
namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation
{

    extern alias Entities;

    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Extensions.Logging;
    using NServiceBus;
    using NServiceBus.Newtonsoft.Json; 
    using SFA.FCS.Worker.Common;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.Services;
    using SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation.Services;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Repositories;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using Infrastructure;
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class PaymentAggregationEndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "PaymentManagementDomain.Integration.PaymentAggregation.dll";

        public string EndpointName => "PaymentManagementDomain.PaymentAggregation";

        public IReadOnlyCollection<Subscription> Subscriptions => new[]
        {
            new Subscription("PaymentManagementDomain.PaymentSchedule", typeof(PaymentScheduleEvent))
        };

        public IReadOnlyCollection<Type> TypesPublished = new List<Type>
        {
            typeof(PaymentAggregatedEvent)
        };

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>();


        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            if (loggerFactory is null) throw new ArgumentNullException(nameof(loggerFactory));

            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Correct logger
            var logger = loggerFactory.CreateLogger<PaymentAggregationEndpointConfig>();
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
                    TypesPublished.Contains(t));

            // ✅ Serialization (kept Newtonsoft as per your code)
            configuration.UseSerialization<NewtonsoftJsonSerializer>();

            // ✅ ✅ Converted Windsor → Microsoft DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);

                // -----------------------------
                // Scoped (LifestyleScoped)
                // -----------------------------
                services.AddScoped<IPaymentAggregationService, PaymentAggregationService>();
                services.AddScoped<IDeliverableToSubnominalService, DeliverableToSubnominalService>();
                services.AddScoped<IPayCalcPolicyQueryRepository, PayCalcPolicyQueryRepository>();
                services.AddScoped<IMonitoringDeliverablesDbContext, MonitoringDeliverablesDbContext>();
                services.AddScoped<IPaymentManagementPolicyContext, PaymentManagementPolicyContext>();
                services.AddScoped<IOverrideDateDBContext, OverrideDateDBContext>();

                // -----------------------------
                // Singleton
                // -----------------------------
                services.AddSingleton(typeof(IEntityCache<,>), typeof(EntityCache<,>));
                services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();

                // -----------------------------
                // Date registration (converted)
                // -----------------------------
                var useRealDate = Convert.ToBoolean(
                    Environment.GetEnvironmentVariable("UseRealDate") ?? "false");

                if (useRealDate)
                {
                    services.AddSingleton<IDate, SystemDate>();
                }
                else
                {
                    services.AddSingleton<IDate, StaticDate>();
                }
            });

            return configuration;
        }

    }
}
