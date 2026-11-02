namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload.FundingAllocationRelease
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using CrossDomain.Integration.Events;
    using FCS.Worker.Common;
    using Framework.Logging;
    using Framework.Logging.Interfaces;
    using NServiceBus;

    public class EndpointConfig : IEndpointConfig
    {
        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new List<string>
        {
            nameof(FundingAllocationReleaseInProgressEvent),
            nameof(FundingAllocationReleaseGroupGroupReleasedEvent),
        };

        public string NameOfAssembly => "ContractRequestDomain.Integration.BulkUpload.dll";

        public string EndpointName => "ContractRequestDomain.FundingAllocationRelease";

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = new Logger(new System.Diagnostics.TraceSource("WorkerRole"));

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on CDI");

            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    (t.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    t.GetInterfaces().Contains(typeof(ICommand)))
                .DefiningEventsAs(t => EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}
