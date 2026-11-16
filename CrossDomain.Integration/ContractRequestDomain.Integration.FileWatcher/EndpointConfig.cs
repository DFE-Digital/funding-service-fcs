namespace SFA.FCT.ContractRequestDomain.Integration.FileWatcher
{
    using Castle.Windsor;
    using FCS.Worker.Common;
    using Framework.Logging;
    using IoC;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Extensions.Logging;
    using NServiceBus;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.ContractRequestDomain.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Intlogger=Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "ContractRequestDomain.Integration.FileWatcher.dll";

        public string EndpointName => "ContractRequestDomain.FileWatcher";

        public IReadOnlyCollection<Subscription> Subscriptions => Enumerable.Empty<Subscription>().ToList();

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>();


        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Proper logger
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            var connectionString = Environment.GetEnvironmentVariable("AzureServiceBusConnection");

            if (string.IsNullOrWhiteSpace(connectionString))
            {
                throw new InvalidOperationException(
                    "AzureServiceBusConnection environment variable is not set.");
            }

            // ✅ Conventions (fixed)
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    (t.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    typeof(ICommand).IsAssignableFrom(t))
                .DefiningEventsAs(t =>
                    Subscriptions.Any(s => s.EventType.IsAssignableFrom(t)));

            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ Correct DI usage
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);

                services.AddFileWatcherServices(loggerFactory);

                // ✅ Register poller as singleton
                services.AddSingleton<FileWatcherPollerStarter>();
            });

            return configuration;
        }

    }


    public class FileWatcherPollerStarter
    {
        public FileWatcherPollerStarter(
            Intlogger.ILogger logger,
            IBulkUploadFileAccess bulkUploadFileAccess,
            IFcsBus bus,
            IFileWatcherLockResourceRepository lockRepository)
        {
            // ✅ Start polling when DI creates this class
            SimpleFilePoller.StartPolling(
                logger,
                bulkUploadFileAccess,
                bus,
                lockRepository);
        }
    }

}
