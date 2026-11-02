namespace SFA.FCT.ContractManagementDomain.Integration.IntegrationEndpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using ContractManagementService.Common.Commands;
    using CrossDomain.Integration.Events;
    using CrossDomain.Integration.Messages.Commands;
    using FCS.Worker.Common;
    using Framework.Logging.Interfaces;
    using IoC;
    using NServiceBus;

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
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on CDI");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t => EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}
