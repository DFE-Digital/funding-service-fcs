namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.IoC
{
    using Microsoft.Extensions.DependencyInjection;
    using CrossDomain.Integration.Common.Storage;
    using DocumentGeneration.DocumentDeleter;
    using DocumentGeneration.DocumentLocationResolver;
    using Microsoft.Extensions.Logging;

    public static class DocumentDeleterServiceRegistration
    {
        public static void AddDocumentDeleterServices(
            this IServiceCollection services,
            ILoggerFactory loggerFactory)
        {
            // ✅ REMOVE ILogger registration

            // ✅ Singleton services
            services.AddSingleton<IDocumentDeleter, DocumentDeleter>();
            services.AddSingleton<IOffice365Adapter, Office365StorageWrapper>();
            services.AddSingleton<IDocumentLocationResolver, DocumentLocationResolver>();
        }
    }
}
