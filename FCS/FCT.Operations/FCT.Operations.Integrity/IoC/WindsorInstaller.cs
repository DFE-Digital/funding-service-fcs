namespace SFA.FCT.Operations.Integrity.IoC
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using FCS.Worker.Common;
    using Framework.Logging.Interfaces;
    using Microsoft.ApplicationInsights;
    using Services;
    using Repositories;
    using Storage;

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
            container.Register(Component.For<IIntegrityCheckRunnerService>().ImplementedBy<IntegrityCheckRunnerService>().LifestyleTransient());
            container.Register(Component.For<ICheckerDocumentStoreWriter>().ImplementedBy<AzureDocumentStoreWriter>().LifestyleSingleton());
            container.Register(Component.For<ICrmDuplicateContractService>().ImplementedBy<CrmDuplicateContractService>().LifestyleScoped());
            container.Register(Component.For<ICrmDuplicateContractRepository>().ImplementedBy<CrmDuplicateContractRepository>().LifestyleScoped());
            container.Register(Component.For<IDuplicateContractRepository>().ImplementedBy<DuplicateContractRepository>().LifestyleScoped());
            container.Register(Component.For<TelemetryClient>().Instance(new TelemetryClient()));
        }
    }
}
