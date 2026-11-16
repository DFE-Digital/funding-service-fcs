using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentsDomain.Endpoint.Xrm
{
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using Services;
    using SFA.FCS.Worker.Common.Crm;

    public static class DocumentsXrmServiceRegistration
    {
        public static IServiceCollection AddDocumentsXrmServices(
            this IServiceCollection services)
        {
            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            services.AddScoped<IXrmDocumentManager, XrmDocumentManager>();

            return services;
        }
    }

}
