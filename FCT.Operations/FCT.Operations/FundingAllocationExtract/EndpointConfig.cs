
namespace FCT.Operations.FundingAllocationExtract
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
        public static string EndpointName => "Operations.FundingAllocationExtract";

        public string NameOfAssembly => "FCT.Operations.dll";

        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint =
            new List<string>();

        private static readonly IReadOnlyCollection<Type> CommandsUsedInThisEndpoint =
            new List<Type>
            {
                typeof(CreateFundingAllocationExtractCommand)
            };

        string IEndpointConfigWithFcsConfig.EndpointName => EndpointName;

        public IReadOnlyCollection<Subscription> Subscriptions =>
            new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes =>
            new List<CommandRoute>();

        public EndpointConfiguration GetEndpointConfiguration(
            ILogger logger,
            IFcsConfiguration appConfiguration)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on Ops.Worker");

            // ✅ Conventions
            configuration.Conventions()
                .DefiningCommandsAs(t => CommandsUsedInThisEndpoint.Contains(t))
                .DefiningEventsAs(t => EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            // ✅ Serialization (keep consistent)
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ ✅ DI replacement (NO Windsor)
            configuration.RegisterComponents(services =>
            {
                services.AddFundingAllocationExtractServices(logger, appConfiguration);
            });

            return configuration;
        }
    }
}

