namespace ContractManagementDomain.Endpoint.LevyAmendmentEndpoint
{
    using System.Collections.Generic;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Castle.Windsor;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "ContractManagementDomain.Endpoint.dll";

        public string EndpointName => "ContractManagementDomain.LevyAmendmentEndpoint";

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("ContractCreateDomain.IncrementContractVersion", typeof(IncrementContractVersionCommand)),
            new CommandRoute("ContractManagementDomain.InitiateContractWithdrawal", typeof(PreIncrementWithdrawalCommand)),
            new CommandRoute("ContractManagementDomain.IssueNotification.Xrm", typeof(IssueCrmNotificationCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on FCS.Worker");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}