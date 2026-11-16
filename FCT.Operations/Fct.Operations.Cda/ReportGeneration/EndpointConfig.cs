
namespace FCT.Operations.Cda.ReportGeneration
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointConfigWithFcsConfig
    {
        public static string EndpointName => "Operations.Cda.ReportGeneration";

        public string NameOfAssembly => "FCT.Operations.Cda.dll";

        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint =
            new List<string>();

        private static readonly IReadOnlyCollection<Type> CommandsUsedInThisEndpoint =
            new List<Type>
            {
                typeof(CreateReportFromCrmForGroupCommand),
                typeof(RunReportsCommand),
                typeof(RunReportsAndArchiveExistingCommand),
                typeof(UploadReportToSharePointCommand)
            };

        string IEndpointConfigWithFcsConfig.EndpointName => EndpointName;

        public IReadOnlyCollection<Subscription> Subscriptions =>
            new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes =>
            new List<CommandRoute>
            {
                new CommandRoute(EndpointName, typeof(CreateReportFromCrmForGroupCommand))
            };

        public EndpointConfiguration GetEndpointConfiguration(
            ILogger logger,
            IFcsConfiguration configurationRoot)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on Ops.Worker");

            // ✅ Conventions
            configuration.Conventions()
                .DefiningCommandsAs(t => CommandsUsedInThisEndpoint.Contains(t))
                .DefiningEventsAs(t => EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            // ✅ Serialization
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ ✅ DI replacement (NO Windsor)
            configuration.RegisterComponents(services =>
            {
                services.AddCdaReportGenerationServices(logger, configurationRoot);
            });

            // ✅ IMPORTANT — keep original behaviour
            configuration.LimitMessageProcessingConcurrencyTo(1);

            return configuration;
        }
    }
}
