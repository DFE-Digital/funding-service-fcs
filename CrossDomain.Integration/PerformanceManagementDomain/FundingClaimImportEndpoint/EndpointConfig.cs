namespace SFA.FCT.PerformanceManagementDomain.FundingClaimImportEndpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using Framework.Logging.Interfaces;
    using IoC;
    using NServiceBus;
    using Common.Commands;
    using FCS.Worker.Common;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "PerformanceManagementDomain.dll";

        public string EndpointName => "PerformanceManagementDomain.FundingClaimImport";

        public IReadOnlyCollection<CommandRoute> Routes => new []
        {
            new CommandRoute("PerformanceManagementDomain.FundingClaimImport",  typeof(ClosedFundingClaimCollectionCommand)),
            new CommandRoute("PerformanceManagementDomain.FundingClaimImport",  typeof(FundingClaimPagedRequestCommand)),
            new CommandRoute("PerformanceManagementDomain.FundingClaimImport",  typeof(ProcessFundingClaimsCommand)),
        };

        public IReadOnlyCollection<Subscription> Subscriptions => Enumerable.Empty<Subscription>().ToArray();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            ILogger logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on CrossDomain.Integration");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t => null != t.Namespace && t.Namespace.EndsWith("Events"))
                .DefiningMessagesAs(t => null != t.Namespace && t.Namespace.EndsWith("Messages"));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}