
namespace SFA.FCT.Operations.Integrity
{
    using NServiceBus;
    using CrossDomain.Integration.Common;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.DependencyInjection;
    using Framework.Logging.Interfaces;
    using CrossDomain.Integration.Events;
    using CrossDomain.Integration.Messages.Commands;
    using SFA.FCS.Worker.Common;

    public class EndpointConfig : IEndpointConfigWithFcsConfig
    {
        private const string EndpointNameStr = "Operations.IntegrityCheckers";
        public static string EndpointName => FctEndpoint.GenerateEndpointName(EndpointNameStr);

        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint =
            new List<string>
            {
                nameof(MonthEndCompletedEvent)
            };

        public string NameOfAssembly => "FCT.Operations.Integrity.dll";

        string IEndpointConfigWithFcsConfig.EndpointName => EndpointName;

        public IReadOnlyCollection<Subscription> Subscriptions =>
            new List<Subscription>
            {
                new Subscription("AllocationDeliveryDomain.MonthEndCheck", typeof(MonthEndCompletedEvent))
            };

        public IReadOnlyCollection<CommandRoute> Routes =>
            new List<CommandRoute>
            {
                new CommandRoute(EndpointName, typeof(InitiateCheckersCommand)),
                new CommandRoute(EndpointName, typeof(CheckForDuplicateContractsCommand)),
                new CommandRoute(EndpointName, typeof(OperationalCheckShortIntervalCommand))
            };

        public EndpointConfiguration GetEndpointConfiguration(
            ILogger logger,
            IFcsConfiguration appConfiguration)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            logger.LogInformation(1, $"Started Endpoint SFA.FCT.Operations.Integrity on Ops.Worker");

            // ✅ Conventions
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    (t.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    t.GetInterfaces().Contains(typeof(ICommand)))
                .DefiningEventsAs(t =>
                    EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            // ✅ Serialization
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ ✅ DI replacement
            configuration.RegisterComponents(services =>
            {
                services.AddIntegrityServices(logger, appConfiguration);
            });

            return configuration;
        }
    }
}
