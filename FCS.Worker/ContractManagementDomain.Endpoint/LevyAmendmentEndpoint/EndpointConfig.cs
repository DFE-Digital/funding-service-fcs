
namespace ContractManagementDomain.Endpoint.LevyAmendmentEndpoint
{
    using System.Collections.Generic;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly =>
            "ContractManagementDomain.Endpoint.dll";

        public string EndpointName =>
            "ContractManagementDomain.LevyAmendmentEndpoint";

        public IReadOnlyCollection<Subscription> Subscriptions =>
            new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes =>
            new List<CommandRoute>
            {
                new CommandRoute("ContractCreateDomain.IncrementContractVersion", typeof(IncrementContractVersionCommand)),
                new CommandRoute("ContractManagementDomain.InitiateContractWithdrawal", typeof(PreIncrementWithdrawalCommand)),
                new CommandRoute("ContractManagementDomain.IssueNotification.Xrm", typeof(IssueCrmNotificationCommand))
            };

        public EndpointConfiguration GetEndpointConfiguration(
            ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName} on FCS.Worker", EndpointName);

            // ✅ Conventions
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    t?.Namespace != null &&
                    t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t =>
                    t?.Namespace != null &&
                    t.Namespace.EndsWith("Events"));

            // ✅ Serialization
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ CLEAN DI call
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddLevyAmendmentServices();
            });

            return configuration;
        }
    }
}
