namespace SFA.FCT.FundingPolicyDomain.IoC
{
    using System.Diagnostics;
    using System.Reflection;
    using System.Web.Http.Controllers;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using CrossDomain.Integration.Common.Atom;
    using CrossDomain.Integration.Common.PagedStorage;
    using CrossDomain.Integration.Common.PagedStorage.Repositories;
    using CrossDomain.Integration.Common.Storage;
    using CrossDomain.Integration.Entities;
    using Framework.Logging;
    using Framework.Logging.Interfaces;
    using FundingStreamConfigDomain.BusinessLogic;

    public class WindsorInstaller : IWindsorInstaller
    {
        private static readonly string TraceSourceName = Assembly.GetExecutingAssembly().GetName().Name;

        private readonly ILoggerFactory _loggerFactory;

        public WindsorInstaller()
        {
            _loggerFactory = new LoggerFactory();
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<TraceSource>().ImplementedBy<TraceSource>().DependsOn(Dependency.OnValue<string>(TraceSourceName)),
                Component.For<IReferenceDataManager>().ImplementedBy<ReferenceDataManager>().LifestyleTransient(),
                Component.For<IAtomFeedGenerator<DeliverableSettingConfiguration>>().ImplementedBy<AtomFeedGenerator<DeliverableSettingConfiguration>>(),
                Component.For<IPagedStorageRepository<DeliverableSettingConfiguration>>().ImplementedBy<AzureDeliverableSettingConfigurationRepository>(),
                Component.For<IAzureTableStore>().ImplementedBy<AzureTableStore>(),
                Component.For<IStorageObjectSerializer>().ImplementedBy<StorageObjectSerializer>(),
                Component.For<IEnvironmentContext>().ImplementedBy<EnvironmentContext>().LifestyleSingleton(),
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("FundingStreamConfigDomain")),
                Classes.FromThisAssembly().BasedOn<IHttpController>().LifestyleTransient());
        }
    }
}