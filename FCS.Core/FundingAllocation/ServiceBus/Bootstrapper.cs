namespace FundingAllocation.ServiceBus
{
    using DataStore;
    //    using Microsoft.AspNetCore.Server.Kestrel;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.Extensions.Configuration;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.SharePoint.Client;
    using NServiceBus;
    using NServiceBus.MessageMutator;
    using NServiceBus.Persistence.Sql;
    using NServiceBus.Transport.AzureServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Slack;
    using Storage;
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.IO;
    using System.Linq;
    using System.Net.Http;
    using System.Reflection;
    using System.Threading.Tasks;
    using Microsoft.Extensions.DependencyInjection;

    public static class Bootstrapper
    {
        private static ILogger _logger = default!;
        private static ISlackMessageSender _slackMessageSender = default!;
        private static IHttpClientFactory _httpClientFactory = default!;

        public static IReadOnlyCollection<IEndpointInstance> Endpoints { get; private set; } = Array.Empty<IEndpointInstance>();

        private static readonly string[] Nsb5Assemblies =
        {
        "CrossDomain.Integration.Common.dll",
        "PaymentManagementDomain.PaymentSchedule.Xrm.Integration.dll"
    };

        public static async Task Start(
            ILoggerFactory loggerFactory,
            ILogger currentLogger,
            IConfigurationRoot appConfiguration,
            IHttpClientFactory httpClientFactory)
        {
            _logger = currentLogger;
            _httpClientFactory = httpClientFactory;
            _slackMessageSender = new SlackMessageSender(appConfiguration);

            Endpoints = await StartEndpoints(loggerFactory.CreateCoreLogger(), appConfiguration);
            _logger.LogInformation("All endpoints have started");
        }

        public static async Task Stop()
        {
            _logger.LogInformation("Stopping NServiceBus endpoints");

            foreach (var endpoint in Endpoints)
            {
                await endpoint.Stop().ConfigureAwait(false);
            }
        }

        private static async Task<IReadOnlyCollection<IEndpointInstance>> StartEndpoints(
            ILogger logger,
            IConfigurationRoot appConfiguration)
        {
            var endpointTypes = new List<Type>
        {
            typeof(Endpoints.PullFundingAllocation.EndpointConfig),
            typeof(Endpoints.GetFundingAllocationsPage.EndpointConfig),
            typeof(Endpoints.EnrichProviderFunding.EndpointConfig),
            typeof(Endpoints.CreateFundingAllocationInCrm.EndpointConfig),
            typeof(Endpoints.ReleaseGroup.EndpointConfig),
            typeof(Endpoints.DocumentGenerationComplete.EndpointConfig),
            typeof(Endpoints.ContractApproved.EndpointConfig),
            typeof(Endpoints.UpdateFundingAllocation.EndpointConfig),
            typeof(Endpoints.ReleaseGroupSetToReleased.EndpointConfig),
            typeof(Endpoints.CheckForReadComplete.EndpointConfig),
            typeof(Endpoints.ContractWithdrawn.EndpointConfig),
            typeof(Endpoints.DraftContractDeleted.EndpointConfig),
            typeof(Endpoints.UnParkFundingAllocation.EndpointConfig),
            typeof(Endpoints.CheckForJobComplete.EndpointConfig),
            typeof(Endpoints.CreateProvidersIfNecessaryReply.EndpointConfig),
            typeof(Endpoints.JobCompleted.EndpointConfig),
            typeof(Endpoints.CheckForMissingProvidersPostReadComplete.EndpointConfig),
            typeof(Endpoints.BulkUpload.EndpointConfig),
            typeof(Endpoints.IgnoreItemsOfNoInterest.EndpointConfig),
            typeof(Endpoints.ContractPublished.EndpointConfig),
            typeof(Endpoints.Operational.EndpointConfig),
        };

            var configurations = endpointTypes.Select(t =>
            {
                var endpoint = (IEndpointCoreConfig)Activator.CreateInstance(t)!;
                logger.LogInformation("Configuring endpoint {Endpoint}", endpoint.EndpointName);
                return ConfigureEndpoint(endpoint, logger, appConfiguration);
            });

            //return await Task.WhenAll(configurations.Select(Endpoint.Start));

            return await Task.WhenAll(
                configurations.Select(config => Endpoint.Start(config))
            );

        }

        private static EndpointConfiguration ConfigureEndpoint(
            IEndpointCoreConfig endpoint,
            ILogger logger,
            IConfigurationRoot config)
        {
            var configuration = endpoint.GetEndpointConfiguration(logger, config);

            var persistence = configuration.UsePersistence<SqlPersistence>();
            persistence.SqlDialect<SqlDialect.MsSqlServer>();
            persistence.ConnectionBuilder(() =>
                new SqlConnection(config.GetConnectionString("NServiceBus/Persistence")));



            var asbTransport = new AzureServiceBusTransport(
                config.GetConnectionString("NServiceBus/Transport"),
                TopicTopology.Default);

            asbTransport.TransportTransactionMode =
                TransportTransactionMode.ReceiveOnly;

            var routing =
                configuration.UseTransport<AzureServiceBusTransport>(asbTransport);



            foreach (var route in endpoint.Routes)
            {
                routing.RouteToEndpoint(route.CommandType, route.Destination);
            }


            configuration.UseSerialization<NewtonsoftSerializer>();
            configuration.EnableInstallers();
            configuration.SendFailedMessagesTo("error");
            configuration.AuditProcessedMessagesTo("audit", TimeSpan.FromDays(7));

            RegisterSlack(configuration, config);

            configuration.RegisterMessageMutator(
                new TransportMessageCompressionMutator(
                    _logger,
                    new LargeMessageStorageService(config)));



            configuration.RegisterComponents(services =>
            {
                services.AddScoped<FundingAllocationContext>(serviceProvider =>
                {
                    var session =
                        serviceProvider.GetRequiredService<ISqlStorageSession>();

                    var context =
                        new FundingAllocationContext(
                            new DbContextOptionsBuilder<FundingAllocationContext>()
                                .UseSqlServer(session.Connection)
                                .Options);

                    // Share the same transaction as NServiceBus SQL persistence
                    context.Database.UseTransaction(session.Transaction);

                    // Flush DbContext before NSB commits
                    session.OnSaveChanges(_ => context.SaveChangesAsync());

                    return context;
                });
            });

            return configuration;
        }

        private static void RegisterSlack(
            EndpointConfiguration configuration,
            IConfigurationRoot config)
        {
            if (config["Slack:ShouldSend"] == "true")
            {
                configuration.Recoverability()
                    .Failed(failed =>
                    {
                        failed.OnMessageSentToErrorQueue(
                            async (context, cancellationToken) =>
                            {
                                var messageSummary = $"""
                    NServiceBus message failed
                    --------------------------
                    MessageId: {context.MessageId}
                    ErrorQueue: {context.ErrorQueue}
                    Exception: {context.Exception}
                    """;

                                await _slackMessageSender.SendMessage(
                                    messageSummary,
                                    _logger,
                                    SlackChannel.General);

                                await Task.CompletedTask;
                            });
                    });

            }
        }
    }
}

