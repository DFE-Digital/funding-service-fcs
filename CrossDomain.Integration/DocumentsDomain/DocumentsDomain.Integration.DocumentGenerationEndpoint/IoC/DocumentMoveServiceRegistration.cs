
namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.IoC
{
    using System;
    using Microsoft.Extensions.DependencyInjection;
    using Common;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Common.Storage;
    using CrossDomain.Integration.OverrideDate;
    using CrossDomain.Integration.OverrideDate.DataStore;
    using DocumentGeneration;
    using DocumentGeneration.DocumentDefiner;
    using DocumentGeneration.DocumentLocationResolver;
    using Microsoft.Extensions.Logging;

    public static class DocumentMoveServiceRegistration
    {
        public static void AddDocumentMoveServices(
            this IServiceCollection services,
            ILoggerFactory loggerFactory)
        {
            // ✅ REMOVE custom ILogger registration
            // Use ILogger<T> instead everywhere

            // ✅ Scoped services
            services.AddScoped<IDocumentMover, DocumentGeneration.DocumentMover.DocumentMover>();
            services.AddScoped<IDocumentLocationResolver, DocumentLocationResolver>();
            services.AddScoped<IDocumentDefiner, DocumentDefiner>();
            services.AddScoped<IDocumentPartFinder, DocumentPartFinder>();
            services.AddScoped<IOffice365Adapter, Office365StorageWrapper>();
            services.AddScoped<IOverrideDateDBContext, OverrideDateDBContext>();

            // ✅ Date provider (modernised)
            var useRealDate = Convert.ToBoolean(
                Environment.GetEnvironmentVariable("UseRealDate") ?? "false");

            if (useRealDate)
                services.AddSingleton<IDate, SystemDate>();
            else
                services.AddScoped<IDate, StaticDate>();
        }
    }
}
