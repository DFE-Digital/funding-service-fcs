namespace ActualsPull.Dc
{
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDelivery.Messages.Commands;
    using AllocationDeliveryPerformance;
    using Castle.Windsor;
    using NSB;
    using NServiceBus;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class DcEndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "ActualsPull.dll";

        public string EndpointName => "ADP.ActualsPull";


        private static readonly IReadOnlyCollection<string> RelevantCommands = new List<string>
        {
            nameof(BeginDcActualsPullCommand)
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            ILogger logger = loggerFactory.CreateDefaultLogger(Config.GetAppSetting("Environment:NoSqlConnectionString"));

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on ActualsPull");

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
