
namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.IoC
{
    using Microsoft.Extensions.DependencyInjection;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.ContractDocumentMerger;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentLocationResolver;
    using Microsoft.Extensions.Logging;

    public static class DocumentMergeServiceRegistration
    {
        public static void AddDocumentMergeServices(
            this IServiceCollection services,
            ILoggerFactory loggerFactory)
        {
            // ✅ Scoped services (same as Windsor LifestyleScoped)
            services.AddScoped<IDocumentDefiner, DocumentDefiner>();
            services.AddScoped<IDocumentLocationResolver, DocumentLocationResolver>();
            services.AddScoped<IContractDocumentManager, ContractDocumentManager>();
            services.AddScoped<IOffice365Adapter, Office365StorageWrapper>();
            services.AddScoped<IDocumentPartFinder, DocumentPartFinder>();
            services.AddScoped<IPdfMerger, PdfMerger>();

            // ✅ REMOVE this (no longer needed)
            // services.AddSingleton<ILogger>(...)
        }
    }
}
