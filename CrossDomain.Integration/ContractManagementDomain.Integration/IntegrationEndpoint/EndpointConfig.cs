
namespace SFA.FCT.ContractManagementDomain.Integration.IntegrationEndpoint
{
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using ContractManagementService.Common.Commands;
    using CrossDomain.Integration.Events;
    using CrossDomain.Integration.Messages.Commands;
    using FCS.Worker.Common;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Extensions.Logging;
    using NServiceBus;
    using CrossDomain.Integration.Common.Storage;
    using Infrastructure;
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class EndpointConfig : IEndpointConfig
    {
        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new List<string>
        {
            nameof(AllocationPaymentsChangedOnAggregationEvent),
            nameof(IAllocationPaymentsChangedOnPostingEvent),
        };

        public string NameOfAssembly => "ContractManagementDomain.Integration.dll";
        public string EndpointName => "ContractManagementDomain.Integration";

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>
        {
            new Subscription("PaymentGenerationDomain.AggregatePayment",
                typeof(AllocationPaymentsChangedOnAggregationEvent)),
            new Subscription("PaymentGenerationDomain.ProcessPaymentComplete",
                typeof(IAllocationPaymentsChangedOnPostingEvent)),
        };

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute(EndpointName, typeof(DeleteDocumentsForContractCommand)),
            new CommandRoute("ContractManagement.DeleteContract", typeof(DeleteContractCommand)),
            new CommandRoute("ContractManagementDomain.IssueNotification.Xrm", typeof(IssueCrmNotificationCommand))
        };


        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            var connectionString = Environment.GetEnvironmentVariable("AzureServiceBusConnection");

            if (string.IsNullOrWhiteSpace(connectionString))
            {
                throw new InvalidOperationException(
                    "AzureServiceBusConnection environment variable is not set.");
            }

            // ✅ Conventions (fixed)
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    typeof(ICommand).IsAssignableFrom(t))
                .DefiningEventsAs(t =>
                    EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ INLINE Windsor replacement

            configuration.RegisterComponents(services =>
            {
                // -----------------------------
                // Logging (IMPORTANT: correct logger type)
                // -----------------------------
                services.AddSingleton(loggerFactory);

                services.AddSingleton<ILogger>(
                    _ => loggerFactory.CreateLogger<EndpointConfig>());

                // -----------------------------
                // Singleton
                // -----------------------------
                services.AddSingleton<IOffice365Adapter, Office365StorageWrapper>();
                services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();

                // -----------------------------
                // Scoped (Windsor LifestyleScoped)
                // -----------------------------
                services.AddScoped<IApprovedContractAllocationRepository, ApprovedContractAllocationRepository>();
                services.AddScoped<IContractManagementDbContext, ContractManagementDbContext>();
            });

            return configuration;
        }
    }
}
