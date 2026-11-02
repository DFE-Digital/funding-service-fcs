namespace PerformanceManagementDomain.PullFundingClaim
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PerformanceManagementDomain.Common.Commands;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "PerformanceManagementDomain.dll";

        public string EndpointName => "PerformanceManagementDomain.PullFundingClaim";

        public IReadOnlyCollection<Subscription> Subscriptions => Enumerable.Empty<Subscription>().ToList();

        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute("PerformanceManagementDomain.FundingClaimImport", typeof(ProcessFundingClaimsCommand)) 
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            ILogger logger = loggerFactory.CreateDefaultLogger();

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
