
namespace OrganisationDomain.Integration.MainEndpoint
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using NServiceBus.Persistence.Sql;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using Messages.Commands;
    using Ioc;

    public class EndpointConfig : IEndpointConfig
    {
        public string EndpointName =>
            FctEndpoint.GenerateEndpointName("OrgService.Main");

        public string NameOfAssembly =>
            "OrganisationDomain.Integration.MainEndpoint.dll";

        public static IReadOnlyCollection<Type> TypesPublished =>
            new List<Type>
            {
                typeof(OrganisationDetailsChanged)
            };

        public IReadOnlyCollection<Subscription> Subscriptions =>
            new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes =>
            new List<CommandRoute>
            {
                new CommandRoute(EndpointName, typeof(PopulateSupplementaryDataForUkprnBatchCommand)),
                new CommandRoute("OrgService.XrmEndpoint", typeof(UpdateXrmOrganisationCommand)),
                new CommandRoute("OrgService.XrmEndpoint", typeof(CreateProviderUpdatedNotificationCommand)),
                new CommandRoute("OrgService.CPDS", typeof(GetProviderSummary)),
                new CommandRoute("OrgService.CPDS", typeof(GetOrganisationDetails)),
                new CommandRoute("OrgService.DataStore", typeof(GetUpdatedOrganisations)),
                new CommandRoute("OrgService.DataStore", typeof(SaveUpdatedOrganisation)),
                new CommandRoute(EndpointName, typeof(UpdateSupplementaryBatchOfDataCommand)),
            };

        public EndpointConfiguration GetEndpointConfiguration(
            ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ? Logging (fixed)
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation(
                "Started Endpoint {EndpointName} on CDI",
                EndpointName);

            // ? Conventions (preserved + aligned)
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    t?.Namespace != null &&
                    (t.Namespace.EndsWith("Commands") ||
                     t.Namespace.StartsWith("OrganisationDomain.Integration.Messages.Commands")))
                .DefiningMessagesAs(t =>
                    t?.Namespace != null &&
                    (t.Namespace.EndsWith("Messages") ||
                     t.Namespace.StartsWith("OrganisationDomain.Integration.Messages.Messages")))
                .DefiningDataBusPropertiesAs(p =>
                    p.Name.EndsWith("Databus"))
                .DefiningEventsAs(t =>
                    Subscriptions.Select(s => s.EventType.Name).Any(e => t.Name.EndsWith(e)) ||
                    TypesPublished.Contains(t));

            // ? Serialization (required)
            configuration.UseSerialization<SystemJsonSerializer>();

            // ? Persistence (preserved)
            configuration.UsePersistence<SqlPersistence>();

            // ? Clean DI registration
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddOrganisationMainServices();
            });

            return configuration;
        }
    }
}
