namespace CrossDomain.Integration.ReportRunnerEndpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "CrossDomain.Integration.ReportRunnerEndpoint.dll";

        public string EndpointName => "CrossDomain.Integration.ReportRunnerEndpoint";

        public IReadOnlyCollection<Subscription> Subscriptions => new[]
        {
            new Subscription("Operations.Cda.ReportGeneration", typeof(RunReportsAndArchiveExistingCommand)),
            new Subscription("AllocationDeliveryDomain.MonthEndCheck", typeof(MonthEndCompletedEvent))
        };

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on CDI");

            configuration.Conventions()
                .DefiningEventsAs(t => Subscriptions.Select(s => s.EventType.Name).Any(e => t.Name.EndsWith(e)));


            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new CrossDomain.Integration.ReportRunnerEndpoint.Ioc.WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}
