namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule
{

    using CrossDomain.Integration.Events;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Extensions.Logging;
    using NServiceBus;
    using NServiceBus.Newtonsoft.Json;
    using PaymentManagement.Calculation;
    using PaymentManagement.Calculation.Repositories;
    using PaymentManagement.Calculation.Services;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.FundingClaimReconciliation.Repositories;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.Services;
    using SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Services;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Repositories;
    using Infrastructure;
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class PaymentManagementEndpointConfig : IEndpointConfig // keep your interface if others depend on it
    {
        public string NameOfAssembly => "PaymentManagementDomain.Integration.PaymentSchedule.dll";

        public string EndpointName => "PaymentManagementDomain.PaymentSchedule";

        public IReadOnlyCollection<CommandRoute> Routes => Enumerable.Empty<CommandRoute>().ToArray();

        public IReadOnlyCollection<Subscription> Subscriptions => new[]
        {
            new Subscription("AllocationDelivery.MonitoringDeliverablesEnrichment", typeof(AllocationDeliveryCommencedEvent)),
            new Subscription("AllocationDeliveryDomain.Validation", typeof(AllocationActualsVerified)),
            new Subscription("AllocationDeliveryDomain.ContractUnderTermination", typeof(AllocationActualsUpdated)),
            new Subscription("PerformanceManagementDomain.ReconciliationPublication", typeof(FundingClaimReconciliationPublishedEvent)),
            new Subscription("AllocationDeliveryDomain.PaymentInstructionValidation", typeof(IAllocationPaymentInstructionReceivedEvent))
        };

        private IReadOnlyCollection<Type> PublishedTypes = new List<Type>
        {
            typeof(PaymentScheduleEvent)
        };


        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Correct logger
            var logger = loggerFactory.CreateLogger<PaymentManagementEndpointConfig>();
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

            // ✅ Serialization
            configuration.UseSerialization<NewtonsoftJsonSerializer>();

            // ✅ ✅ WindsorInstaller converted to MS DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);

                // -----------------------------
                // Singleton services
                // -----------------------------
                services.AddSingleton<IPaymentScheduleAllocationCommandRepository, PaymentScheduleAllocationCommandRepository>();
                services.AddSingleton<IAllocationRepository, AllocationRepository>();
                services.AddSingleton<PaymentManagementDomain.PaymentSchedule.DataStore.Repositories.IDeliverablePaymentRepository,
                    PaymentManagementDomain.PaymentSchedule.DataStore.Repositories.DeliverablePaymentRepository>();
                services.AddSingleton<IOrganisationIdentifierRepository, OrganisationIdentifierRepository>();
                services.AddSingleton<IPayCalcPolicyQueryRepository, PayCalcPolicyQueryRepository>();
                services.AddSingleton(typeof(IEntityCache<,>), typeof(EntityCache<,>));
                services.AddSingleton<IPaymentScheduleService, PaymentScheduleService>();
                services.AddSingleton<IProvisionIdentifierRepository, ProvisionIdentifierRepository>();
                services.AddSingleton<IPreviousPaymentScheduleCopier, PreviousPaymentScheduleCopier>();
                services.AddSingleton<IPaymentScheduleCreator, NonCalculationPaymentScheduleCreator>();
                services.AddSingleton<IPublishedPayableFcrAllocationRepository, PublishedPayableFcrAllocationRepository>();
                services.AddSingleton<IActualValueNullResetService, ActualValueNullResetService>();
                services.AddSingleton<IActualVolumeApplicator, ActualVolumeApplicator>();
                services.AddSingleton<IActualVolumeService, ActualVolumeService>();
                services.AddSingleton<IPaymentValuesCalculationService, PaymentValuesCalculationService>();
                services.AddSingleton<IPaymentValuesCalculator, PaymentValuesCalculator>();
                services.AddSingleton<IDateService, DateService>();
                services.AddSingleton<IPolicyFundingStreamPeriodRepository, PolicyFundingStreamPeriodRepository>();
                services.AddSingleton<IPaymentTimetableRepository, PaymentTimetableRepository>();
                services.AddSingleton<PaymentManagement.Calculation.Repositories.IDeliverablePaymentRepository,
                    PaymentManagement.Calculation.Repositories.DeliverablePaymentRepository>();
                services.AddSingleton<IAllocationQueryRepository, AllocationQueryRepository>();
                services.AddSingleton<IActualEnrichmentService, CalculationInputActualEnrichmentService>();
                services.AddSingleton<IBehaviourFactory, BehaviourFactory>();
                services.AddSingleton<IFundingClaimReconciliationService, FundingClaimReconciliationService>();
                services.AddSingleton<IFcrPaymentValuesCalculationService, FcrPaymentValuesCalculationService>();
                services.AddSingleton<IOrganisationDetailsRepository, OrganisationDetailsRepository>();
                services.AddSingleton<ICensusDateService, CensusDateService>();
                services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();

                // -----------------------------
                // Scoped services
                // -----------------------------
                services.AddScoped<IPaymentManagementPolicyContext, PaymentManagementPolicyContext>();
                services.AddScoped<IPaymentSchedulePolicyContext, PaymentSchedulePolicyContext>();

                // -----------------------------
                // Transient (Windsor .LifeStyle.Transient)
                // -----------------------------
                services.AddTransient<IOverrideDateDBContext, OverrideDateDBContext>();
                services.AddTransient<IContractsManager, ContractsManager>();
                services.AddTransient<IAllocationDeliveryCommencedEvent, AllocationDeliveryCommencedEvent>();

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
