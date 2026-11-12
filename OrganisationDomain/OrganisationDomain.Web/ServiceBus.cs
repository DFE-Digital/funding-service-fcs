namespace OrganisationDomain.Web
{
    using Microsoft.Extensions.Configuration;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Common;
    using System;
    using System.Threading.Tasks;
    using NServiceBus.Transport.AzureServiceBus;

    public static class ServiceBus
    {
        public static IEndpointInstance Bus { get; private set; }

        public static async Task Init(IConfiguration configuration)
        {
            var endpointConfiguration =
                new EndpointConfiguration(
                    FctEndpoint.GenerateEndpointName("OrgService.Web"));

            endpointConfiguration.EnableInstallers();

            var transport = new LearningTransport();
            var routing = endpointConfiguration.UseTransport(transport);
            endpointConfiguration.UsePersistence<LearningPersistence>();

            endpointConfiguration.UseSerialization<SystemJsonSerializer>();

            endpointConfiguration.Conventions()
                .DefiningCommandsAs(t =>
                    t.Namespace != null &&
                    t.Namespace.StartsWith(
                        "OrganisationDomain.Integration.Messages.Commands"))
                .DefiningMessagesAs(t =>
                    t.Namespace != null &&
                    t.Namespace.StartsWith(
                        "OrganisationDomain.Integration.Messages.Messages"))
                .DefiningEventsAs(t =>
                    t.Namespace != null &&
                    t.Namespace.StartsWith(
                        "OrganisationDomain.Integration.Messages.Events"));

            Bus = await Endpoint.Start(endpointConfiguration)
                                .ConfigureAwait(false);
        }
    }
}