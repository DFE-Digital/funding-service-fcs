
namespace ContractCreateDomain.Endpoint.NonFinancialAmendment
{
    using System;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using Infrastructure;
    using Repositories;
    using Services;
    using ContractCreateDomain.Endpoint.Services;
    using ContractCreateDomain.Endpoint.Services.Repositories;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;

    public static class NonFinancialAmendmentServiceRegistration
    {
        public static IServiceCollection AddNonFinancialAmendmentServices(
            this IServiceCollection services)
        {
            // ✅ Singleton
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<
                Infrastructure.IFundingTypeFundingPeriodQueryRepository,
                Infrastructure.FundingTypeFundingPeriodQueryRepository>();

            // ✅ Scoped
            services.AddScoped<INonFinancialAmendmentValidationService, NonFinancialAmendmentValidationService>();
            services.AddScoped<ICrmContractRepository, CrmContractRepository>();
            services.AddScoped<ICrmContractQueryRepository, CrmContractQueryRepository>();
            services.AddScoped<ISiblingContractCheckService, SiblingContractCheckService>();
            services.AddScoped<IOverrideDateDBContext, OverrideDateDBContext>();

            // ✅ CRM factory
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            // ✅ Date provider (modern replacement for ConfigurationManager)
            var useRealDate = Convert.ToBoolean(
                Environment.GetEnvironmentVariable("UseRealDate") ?? "false");

            if (useRealDate)
            {
                services.AddSingleton<IDate, SystemDate>();
            }
            else
            {
                services.AddScoped<IDate, StaticDate>();
            }

            return services;
        }
    }
}
