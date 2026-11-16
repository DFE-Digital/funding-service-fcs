namespace SFA.FCT.ContractRequestDomain.Integration.FileWatcher.IoC
{
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Extensions.Logging;
    using System;
    using System.Configuration;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.ContractRequestDomain.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    public static class FileWatcherServiceRegistration
    {
        public static void AddFileWatcherServices(this IServiceCollection services, ILoggerFactory loggerFactory)
        {
            // -----------------------------------------------------------
            // File Access Implementation
            // -----------------------------------------------------------
            Type fileAccessType = typeof(Office365FileAccess);
            string configValue = ConfigurationManager.AppSettings["FileWatcher.FileAccessType"];

            if (!string.IsNullOrEmpty(configValue) &&
                configValue.Equals("azureblobstorage", StringComparison.OrdinalIgnoreCase))
            {
                fileAccessType = typeof(AzureBlobStorageFileAccess);
            }

            services.AddTransient(typeof(IBulkUploadFileAccess), fileAccessType);

            // -----------------------------------------------------------
            // Other Dependencies
            // -----------------------------------------------------------
            services.AddTransient<IOffice365Adapter, Office365StorageWrapper>();
            services.AddSingleton(_ => loggerFactory.CreateLogger("FileWatcher"));
            services.AddSingleton<IFcsBus>(_ => new MessageSendingBus());
            services.AddScoped<IFileWatcherLockResourceRepository, FileWatcherLockResourceRepository>();

        }
    }
}
