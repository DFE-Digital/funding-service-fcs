using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentsDomain.Endpoint.ArchiveDocument
{
    using Microsoft.Extensions.DependencyInjection;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using Infrastructure;
    using Repositories;

    public static class ArchiveDocumentServiceRegistration
    {
        public static IServiceCollection AddArchiveDocumentServices(
            this IServiceCollection services)
        {
            // ✅ Singleton (Windsor LifestyleSingleton)
            services.AddSingleton<IArchiveFileOrchestrator, ArchiveFileOrchestrator>();
            services.AddSingleton<IOffice365Adapter, Office365StorageWrapper>();
            services.AddSingleton<IArchivedDocumentRepository, ArchivedDocumentRepository>();
            services.AddSingleton<IPolicyQueryService, PolicyQueryService>();

            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<ISessionConnectionFactory, SessionConnectionFactory>();

            return services;
        }
    }

}
