namespace ContractRequest.Cfs.AllocationCreated
{
    using SFA.FCS.Worker.Common;
    using System.Collections.Generic;
    using Castle.Windsor;
    using NServiceBus;
    using SFA.FCT.Framework.Logging.Interfaces;
    using ContractRequestDomain.Cfs.Common.Events;
    using System.Linq;

    public class EndpointConfig : IEndpointConfig
    {
        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new List<string>
        {
            nameof(AllocationCreatedEvent)
        };

        public string NameOfAssembly => "ContractRequest.Cfs.AllocationCreated.dll";
        public string EndpointName => "ContractRequest.Cfs.AllocationCreated";

        public IReadOnlyCollection<Subscription> Subscriptions => new[]
        {
            new Subscription("ContractRequestDomain.Cfs.Xrm", typeof(AllocationCreatedEvent)),
        };
        public IReadOnlyCollection<CommandRoute> Routes { get; } = new List<CommandRoute>();
        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on FCS.Worker");

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