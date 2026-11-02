namespace SFA.FCT.Operations.Maintenance.Endpoint.IoC
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Common.Services;
    using FCS.Worker.Common;
    using Framework.Logging.Interfaces;
    using Repositories;
    using Services;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILogger _logger;
        private readonly IFcsConfiguration _appConfiguration;

        public WindsorInstaller(ILogger logger, IFcsConfiguration appConfiguration)
        {
            _logger = logger;
            _appConfiguration = appConfiguration;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(Component.For<ILogger>().Instance(_logger));
            container.Register(Component.For<IFcsConfiguration>().Instance(_appConfiguration));
            container.Register(Component.For<IAzureServiceBusQueueService, IQueueQueryService>().ImplementedBy<AzureServiceBusQueueService>().LifestyleSingleton());
            container.Register(Component.For<ICrmReplicaRepository>().ImplementedBy<CrmReplicaRepository>().LifestyleSingleton());
            container.Register(Component.For<ICrmReplicaRowDeleteRepository>().ImplementedBy<CrmReplicaRowDeleteRepository>().LifestyleSingleton());
            container.Register(Component.For<ISchemaQueryRepository>().ImplementedBy<SchemaQueryRepository>().LifestyleSingleton());
            container.Register(Component.For<IProcessedMessageDeleteRepository>().ImplementedBy<ProcessedMessageDeleteRepository>().LifestyleSingleton());
            container.Register(Component.For<IAuditMessageDeleteRepository>().ImplementedBy<AuditMessageDeleteRepository>().LifestyleSingleton());
        }
    }
}
