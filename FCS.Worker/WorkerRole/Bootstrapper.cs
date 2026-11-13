namespace WorkerRole;

using Microsoft.Extensions.Configuration;
using SFA.FCT.Framework.Logging.Interfaces;
using NServiceBus;
using NServiceBus.Persistence.Sql;
using System.Data.SqlClient;
using SFA.FCS.Worker.Common;
using SFA.FCS.Worker.Common.Slack;

public static class Bootstrapper
{
    private static ILogger _logger;
    private static IConfiguration _configuration;

    public static async Task<IReadOnlyCollection<IEndpointInstance>> Start(
        IConfiguration configuration,
        ILogger logger)
    {
        _logger = logger;
        _configuration = configuration;

        return await StartEndpoints();
    }

    private static async Task<IReadOnlyCollection<IEndpointInstance>> StartEndpoints()
    {
        var endpointTypes = new List<Type>
        {
            typeof(AllocationDeliveryDomain.Endpoint.ActualsPull.EndpointConfig),
            typeof(AllocationDeliveryDomain.Endpoint.ActualsPullComplete.EndpointConfig),
            typeof(AllocationDeliveryDomain.Endpoint.ContractTerminationEndpoint.EndpointConfig)
        };

        var instances = new List<IEndpointInstance>();

        foreach (var type in endpointTypes)
        {
            var endpoint = (IEndpointConfig)Activator.CreateInstance(type)!;

            var config = BuildEndpoint(endpoint);

            var instance = await Endpoint.Start(config);

            instances.Add(instance);
        }

        return instances;
    }

    private static EndpointConfiguration BuildEndpoint(IEndpointConfig endpoint)
    {
        var configuration = endpoint.GetEndpointConfiguration(null);

        // Transport

        var transport = new AzureServiceBusTransport(
            _configuration.GetConnectionString("NServiceBus/Transport"),
            TopicTopology.Default);

        transport.TransportTransactionMode = TransportTransactionMode.ReceiveOnly;

        var transportExtensions = configuration.UseTransport(transport);

        // ✅ ✅ FIX: DO NOT call Routing() on routing settings again
        var routing = transportExtensions;

        foreach (var route in endpoint.Routes)
        {
            routing.RouteToEndpoint(route.CommandType, route.Destination);
        }


        foreach (var sub in endpoint.Subscriptions)
        {
            //routing.RegisterPublisher(sub.EventType, sub.PublisherName);
        }



        // Persistence
        var persistence = configuration.UsePersistence<SqlPersistence>();
        persistence.SqlDialect<SqlDialect.MsSqlServer>();
        persistence.ConnectionBuilder(() =>
            new SqlConnection(_configuration.GetConnectionString("NServiceBusPersistence")));

        // Serialization
        configuration.UseSerialization<SystemJsonSerializer>();

        configuration.EnableInstallers();

        configuration.SendFailedMessagesTo("error");

        if (_configuration.GetValue<bool>("SlackError:ShouldSend"))
        {
            //configuration.Recoverability()
            //    .OnMessageSentToErrorQueue(async context =>
            //    {
            //        ErrorMessageNotifier.SendMessage(context, _logger, "FCS.Worker");
            //    });

        }

        return configuration;
    }
}
