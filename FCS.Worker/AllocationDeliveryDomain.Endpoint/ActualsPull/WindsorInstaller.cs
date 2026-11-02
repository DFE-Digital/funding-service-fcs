namespace AllocationDeliveryDomain.Endpoint.ActualsPull
{
    using System;
    using System.Configuration;
    using Adapters;
    using Castle.MicroKernel;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Endpoint.Repositories;
    using Infrastructure;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
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
            container.Register(
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("AllocationDeliveryDomain")),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>()
                    .LifestyleSingleton(),

                Component.For<IAzureTableStore>().ImplementedBy<AzureTableStore>().LifestyleSingleton(),
                Component.For<IEnvironmentContext>().ImplementedBy<EnvironmentContext>().LifestyleSingleton(),
                Component.For<IClosedCollectionRepository>().ImplementedBy<ClosedCollectionRepository>().LifestyleSingleton(),
                Component.For<ISummarisedActualsRepository>().ImplementedBy<SummarisedActualsRepository>().LifestyleSingleton(),
                Component.For<IMonthEndStartRepository>().ImplementedBy<MonthEndHistoryRepository>().LifestyleSingleton(),
                Component.For<IDcAdapter>().UsingFactoryMethod(GetDcAdapter).LifestyleSingleton(),
                Component.For<IOAuthAccessTokenFactory>().ImplementedBy<OAuthAccessTokenFactory>().LifestyleSingleton(),
                Component.For<IHttpService>().ImplementedBy<HttpService>().LifestyleSingleton());
        }

        private IDcAdapter GetDcAdapter(IKernel kernel)
        {
            bool useStub = ConfigurationManager.AppSettings["DCT:UseStub"] == "true";

            if (useStub)
            {
                return new DcStubAdapter(kernel.Resolve<IAzureTableStore>(), kernel.Resolve<IEnvironmentContext>());
            }

            return new DcAdapter(kernel.Resolve<IHttpService>(), kernel.Resolve<IOAuthAccessTokenFactory>());
        }
    }
}
