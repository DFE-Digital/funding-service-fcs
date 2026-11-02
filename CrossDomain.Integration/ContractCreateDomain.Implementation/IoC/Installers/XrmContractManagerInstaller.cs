namespace SFA.FCT.ContractCreateDomain.Implementation.IoC.Installers
{
    //using System.Diagnostics.CodeAnalysis;
    //using Castle.MicroKernel.Registration;
    //using Castle.MicroKernel.SubSystems.Configuration;
    //using Castle.Windsor;
    //using ContractManagement.DataStore;
    //using ContractManagement.DataStore.Repositories;
    //using Persistence;
    //using NServiceBus.Persistence.NHibernate;

    //[ExcludeFromCodeCoverage]
    //public class XrmContractManagerInstaller : IWindsorInstaller
    //{
    //    public void Install(IWindsorContainer container, IConfigurationStore store)
    //    {
    //        container.Register(
    //          ////  Component.For<IXrmContractManager>().ImplementedBy<XrmContractManager>(),
    //            Component.For<IContractsManager>().ImplementedBy<ContractsManager>().LifestyleTransient(),
    //            Component.For<ILookupManager>().ImplementedBy<LookupManager>().LifestyleTransient(),
    //            Component.For<IContractValidationLookupDataCreator>().ImplementedBy<ContractValidationLookupDataCreator>().LifestyleTransient(),
    //            Component.For<IXrmWorkflowManager>().ImplementedBy<XrmWorkflowManager>().LifestyleTransient(),
    //            Component.For<IBatchCacheManager>().ImplementedBy<BatchCacheManager>(),
    //            Component.For<IEnduringCacheManager>().ImplementedBy<EnduringCacheManager>(),
    //            Component.For<IPolicyConfigRepository>().ImplementedBy<PolicyConfigRepository>().LifestyleScoped(),
    //            Component.For<IContractManagementDbContext>().UsingFactoryMethod(k =>
    //                new ContractManagementDbContext(k.Resolve<NHibernateStorageContext>().Connection)).LifestyleScoped());
    //    }
    //}
}