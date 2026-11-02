namespace SFA.FCT.AllocationDeliveryDomain.IoC
{
    using System.Diagnostics;
    using System.Reflection;
    using System.Web.Http.Controllers;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using CrossDomain.Integration.Common.Atom;
    using Framework.Logging.Interfaces;
    using SFA.FCT.AllocationDelivery.DataStore.Model;
    using SFA.FCT.AllocationDelivery.DataStore;

    public class WindsorInstaller : IWindsorInstaller
    {
        private static readonly string TraceSourceName = Assembly.GetExecutingAssembly().GetName().Name;

        private readonly ILoggerFactory _loggerFactory;

        public WindsorInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<TraceSource>()
                    .ImplementedBy<TraceSource>()
                    .DependsOn(Dependency.OnValue<string>(TraceSourceName)),
                Classes.FromThisAssembly().BasedOn<IHttpController>().LifestyleTransient(),
                Component.For<IPager<AllocationDeliveryEntry>>().ImplementedBy<Pager>(),
                Component.For<IAtomFeedGenerator<AllocationDeliveryEntry>>().ImplementedBy<AtomFeedGenerator<AllocationDeliveryEntry>>(),
                Component.For<IAllocationDeliveryDbContext>().ImplementedBy<IAllocationDeliveryDbContext>(), 
                //Component.For<IAzureTableStore>().ImplementedBy<AzureTableStore>(),
                //Component.For<IStorageObjectSerializer>().ImplementedBy<StorageObjectSerializer>(),
                //Component.For<IEnvironmentContext>().ImplementedBy<EnvironmentContext>().LifestyleSingleton(),
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("AllocationDeliverytDomain")));
        }
    }
}
