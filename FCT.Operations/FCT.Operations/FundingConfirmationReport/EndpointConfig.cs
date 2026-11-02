namespace FCT.Operations.FundingConfirmationReport
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using Microsoft.Extensions.Configuration;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointConfigWithFcsConfig
    {
        public static string EndpointName => "Operations.FundingConfirmationReport";

        public string NameOfAssembly => "FCT.Operations.dll";

        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new List<string>
        {
        };

        private static readonly IReadOnlyCollection<Type> CommandsUsedInThisEndpoint = new List<Type>
        {
            typeof(CreateFundingConfirmationReportCommand), typeof(CreateFundingConfirmationReportForPeriodCommand)
        };

        string IEndpointConfigWithFcsConfig.EndpointName => EndpointName;

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>();

        public EndpointConfiguration GetEndpointConfiguration(ILogger logger, IFcsConfiguration appConfiguration)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on Ops.Worker");

            configuration.Conventions()
                .DefiningCommandsAs(t => CommandsUsedInThisEndpoint.Contains(t))
                .DefiningEventsAs(t => EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(logger, appConfiguration)));
            });

            return configuration;
        }
    }
}
