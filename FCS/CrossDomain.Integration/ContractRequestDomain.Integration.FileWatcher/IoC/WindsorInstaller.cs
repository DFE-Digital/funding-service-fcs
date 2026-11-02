namespace SFA.FCT.ContractRequestDomain.Integration.FileWatcher.IoC
{
    using System;
    using System.Configuration;
    using Framework.Logging.Interfaces;
    using Castle.MicroKernel.Registration;
    using CrossDomain.Integration.Common.Storage;
    using BusinessLogic.Services;
    using BusinessLogic.Interfaces;
    using SFA.FCT.ContractRequestDomain.DataStore.Repositories;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;
        private readonly string _endpointName;

        public WindsorInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(Castle.Windsor.IWindsorContainer container, Castle.MicroKernel.SubSystems.Configuration.IConfigurationStore store)
        {
            Type fileAccessType = typeof(Office365FileAccess);
            string fileAccessConfigurationSetting = ConfigurationManager.AppSettings["FileWatcher.FileAccessType"];
            if (!string.IsNullOrEmpty(fileAccessConfigurationSetting))
            {
                if (fileAccessConfigurationSetting.ToLower() == "azureblobstorage")
                {
                    fileAccessType = typeof(AzureBlobStorageFileAccess);
                }
            }

            container.Register(
                Component.For<IBulkUploadFileAccess>().ImplementedBy(fileAccessType).LifestyleTransient(),
                Component.For<IOffice365Adapter>().ImplementedBy<Office365StorageWrapper>().LifestyleTransient(),
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("FileWatcher")),
                Component.For<IFcsBus>().Instance(new MessageSendingBus()),
                Component.For<IFileWatcherLockResourceRepository>().ImplementedBy<FileWatcherLockResourceRepository>());
        }
    }
}
