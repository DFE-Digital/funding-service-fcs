using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ContractManagementDomain.Endpoint.DeleteContract
{
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using Infrastructure;
    using Repositories;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    public static class DeleteContractServiceRegistration
    {
        public static IServiceCollection AddDeleteContractServices(
            this IServiceCollection services)
        {
            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            services.AddScoped<ICrmContractRepository, CrmContractRepository>();
            services.AddScoped<IDeleteDocumentsService, DeleteDocumentsService>();
            services.AddScoped<ICrmContractAttributesRepository, CrmContractAttributesRepository>();

            // ✅ Singleton (Windsor LifestyleSingleton)
            services.AddSingleton<IOffice365Adapter, Office365StorageWrapper>();
            services.AddSingleton<ICreatedContractRepository, CreatedContractRepository>();
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();

            return services;
        }
    }

}
