namespace SFA.FCT.ContractRequestDomain.Integration.FileWatcher
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using FCS.Worker.Common;
    using Framework.Logging;
    using IoC;
    using NServiceBus;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces;
    using SFA.FCT.ContractRequestDomain.DataStore.Repositories;
    using ILoggerFactory = Framework.Logging.Interfaces.ILoggerFactory;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "ContractRequestDomain.Integration.FileWatcher.dll";

        public string EndpointName => "ContractRequestDomain.FileWatcher";

        public IReadOnlyCollection<Subscription> Subscriptions => Enumerable.Empty<Subscription>().ToList();

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = new LoggerFactory().CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on CDI");

            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    (t.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    t.GetInterfaces().Contains(typeof(ICommand)))
                .DefiningEventsAs(t => Subscriptions.Select(s => s.EventType.Name).Any(e => t.Name.EndsWith(e)));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory)));
            });

            // now start polling
            var container = Bootstrapper.CreateContainer(loggerFactory);
            var bulkUploadFileAccess = container.Resolve<IBulkUploadFileAccess>();
            var bus = container.Resolve<IFcsBus>();
            var lockResourceRepository = container.Resolve<IFileWatcherLockResourceRepository>();

            SimpleFilePoller.StartPolling(logger: logger, bulkUploadFileAccess: bulkUploadFileAccess, bus: bus, fileWatcherLockResourceRepository: lockResourceRepository);
            
            return configuration;
        }
    }
}
