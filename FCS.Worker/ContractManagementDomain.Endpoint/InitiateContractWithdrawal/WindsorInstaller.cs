namespace ContractManagementDomain.Endpoint.InitiateContractWithdrawal
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Infrastructure;
    using Microsoft.Xrm.Sdk;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
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
            container.Register(
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("ContractManagementDomain")),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton(),
                Component.For<IOrganizationService>().UsingFactoryMethod(k => CrmConnectionFactory.GetOrganizationService()).LifestyleScoped(),
                Component.For<IXrmManager>().ImplementedBy<XrmManager>().LifestyleScoped(),
                Component.For<IContractsManager>().ImplementedBy<ContractsManager>().LifestyleScoped(),
                Component.For<IDateProvider>().ImplementedBy<DateProvider>().LifestyleSingleton()
                );
        }
    }
}
