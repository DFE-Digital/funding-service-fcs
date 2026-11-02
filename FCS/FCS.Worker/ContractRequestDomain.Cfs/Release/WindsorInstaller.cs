namespace ContractRequestDomain.Cfs.Release
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Infrastructure;
    using Microsoft.Xrm.Sdk;
    using Repositories;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Repositories;
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
                Component.For<ILogger>().Instance(_loggerFactory.CreateDefaultLogger()),
                Component.For<IOrganizationService>().UsingFactoryMethod(k => CrmConnectionFactory.GetOrganizationService()).LifestyleScoped(),
                Component.For<IAllocationRepository>().ImplementedBy<AllocationRepository>().LifestyleScoped(),
                Component.For<IAllocationReleaseService>().ImplementedBy<AllocationReleaseService>().LifestyleScoped(),
                Component.For<IContractNumberEnricher>().ImplementedBy<ContractNumberEnricher>().LifestyleScoped(),
                Component.For<INumberRequestManager>().ImplementedBy<XrmNumberRequestManager>().LifestyleScoped(),
                Component.For<INumberPrefixRepository>().ImplementedBy<NumberPrefixRepository>().LifestyleScoped(),
                Component.For<ISequenceRepository>().ImplementedBy<SequenceRepository>().LifestyleSingleton(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton(),
                Component.For<IBatchCacheManager>().ImplementedBy<BatchCacheManager>().LifestyleSingleton(),
                Component.For<IContractCfsAllocationStorage>().ImplementedBy<ContractCfsAllocationStorage>().LifestyleSingleton());
        }
    }
}
