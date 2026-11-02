namespace SFA.FCT.ContractManagementDomain.Integration.IntegrationEndpoint.IoC
{
    using System.Configuration;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Common.Storage;
    using Framework.Logging.Interfaces;
    using Infrastructure;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public string CrmConnectionString { get; set; }

        public WindsorInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
            CrmConnectionString = ConfigurationManager.ConnectionStrings["CrmConnectionString"]?.ConnectionString;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("ContractManagementDomain")).LifestyleSingleton());
            container.Register(Component.For<IOffice365Adapter>().ImplementedBy<Office365StorageWrapper>().LifestyleSingleton());
            container.Register(Component.For<IApprovedContractAllocationRepository>().ImplementedBy<ApprovedContractAllocationRepository>().LifestyleScoped());
            container.Register(Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton());
            container.Register(Component.For<IContractManagementDbContext>()
                .ImplementedBy<ContractManagementDbContext>().LifestyleScoped()); // todo: this may not work
        }
    }
}
