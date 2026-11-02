namespace ContractManagementDomain.Endpoint.DeleteContract
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Infrastructure;
    using Microsoft.Xrm.Sdk;
    using Repositories;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public WindsorInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(Component.For<IOrganizationService>().UsingFactoryMethod(k => CrmConnectionFactory.GetOrganizationService())
                .LifestyleScoped());
            container.Register(Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("ContractManagementDomain")).LifestyleSingleton());
            container.Register(Component.For<ICrmContractRepository>().ImplementedBy<CrmContractRepository>().LifestyleScoped());
            container.Register(Component.For<IDeleteDocumentsService>().ImplementedBy<DeleteDocumentsService>().LifestyleScoped());
            container.Register(Component.For<ICrmContractAttributesRepository>().ImplementedBy<CrmContractAttributesRepository>().LifestyleScoped());
            container.Register(Component.For<IOffice365Adapter>().ImplementedBy<Office365StorageWrapper>().LifestyleSingleton());
            container.Register(Component.For<ICreatedContractRepository>().ImplementedBy<CreatedContractRepository>().LifestyleSingleton());
            container.Register(Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton());
        }
    }
}