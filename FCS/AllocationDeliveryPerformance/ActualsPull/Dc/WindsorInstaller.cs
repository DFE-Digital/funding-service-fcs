namespace ActualsPull.Dc
{
    using System;
    using Adapters;
    using AllocationDeliveryPerformance;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Infrastructure;
    using Repositories;
    using SFA.FCT.Framework.Logging.Interfaces;
    using StubInfrastructure;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public WindsorInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            string noSqlStorageStr = Config.GetAppSetting("Environment:NoSqlConnectionString");
            string environmentName = Config.GetAppSetting("Environment:Name");
            string useStubForDc = Config.GetAppSetting("Environment:UseStubForDC");

            var logger = _loggerFactory.CreateDefaultLogger(noSqlStorageStr);

            var dcAdpater = GetDcAdapter(environmentName, useStubForDc == "true", noSqlStorageStr);
            var closedCollectionRepository = new ClosedCollectionRepository();

            container.Register(
                Component.For<ILogger>().Instance(logger),
                Component.For<IDcAdapter>().Instance(dcAdpater),
                Component.For<IClosedCollectionRepository>().ImplementedBy<ClosedCollectionRepository>().LifestyleSingleton(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton()

                );
        }

        private IDcAdapter GetDcAdapter(string environmentName, bool useStub, string noSqlStorageStr)
        {
            if (useStub)
            {
                var azureTableStore = new AzureTableStorage(noSqlStorageStr);
                string tableName = $"ReportedActual{environmentName}";

                return new DcStubAdapter(azureTableStore: azureTableStore, tableName);
            }

            throw new NotImplementedException("We dont have the real implementation of the stub yet");
        }
    }
}
