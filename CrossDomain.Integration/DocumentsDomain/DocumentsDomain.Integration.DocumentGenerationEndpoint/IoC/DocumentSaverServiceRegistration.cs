
namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.IoC
{
    using CrossDomain.Integration.Common.Storage;
    using DataStore;
    using DataStore.Repositories;
    using DocumentGeneration.DocumentSaver;
    using DocumentGeneration.Infrastructure;
    using Integration;
    using Microsoft.Extensions.DependencyInjection;
    using System;
    using AzureStorageWrapper = Integration.AzureStorageWrapper;
    using Microsoft.Extensions.Logging;

    public static class DocumentSaverServiceRegistration
    {
        public static void AddDocumentSaverServices(
            this IServiceCollection services,
            ILoggerFactory loggerFactory)
        {
            // ✅ REMOVE custom ILogger registration (use ILogger<T> instead)

            // ---------------------------------------------
            // DocumentSaver implementation selection
            // ---------------------------------------------
            var saverType = typeof(DocumentSaver);

            var configuredType =
                Environment.GetEnvironmentVariable("DocumentGeneration.DocumentSaverType");

            if (!string.IsNullOrWhiteSpace(configuredType) &&
                configuredType.Equals("AzureBlobStorage", StringComparison.OrdinalIgnoreCase))
            {
                saverType = typeof(DocumentSaverToAzureBlobStorage);
            }

            // ✅ Singleton
            services.AddSingleton(typeof(IDocumentSaver), saverType);

            // ✅ Singleton services
            services.AddSingleton<IDocumentRepository, DocumentRepository>();
            services.AddSingleton<IAzureStorageWrapper, AzureStorageWrapper>();
            services.AddSingleton<IOffice365Adapter, Office365StorageWrapper>();
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();

            // ✅ Scoped services
            services.AddScoped<IProcessedMessageRepository, ProcessedMessageRepository>();
            services.AddScoped<DocumentsDomainDbContext, DocumentsDomainDbContext>();
        }
    }
}
