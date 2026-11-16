
namespace ContractCreateDomain.Endpoint.XrmService
{
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using Infrastructure;
    using Repositories;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;

    public static class XrmServiceServiceRegistration
    {
        public static IServiceCollection AddXrmServiceServices(
            this IServiceCollection services)
        {
            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<IXrmAllocationEvidenceManager, XrmAllocationEvidenceManager>();
            services.AddScoped<IContractsManager, ContractsManager>();
            services.AddScoped<ILookupManager, LookupManager>();
            services.AddScoped<IXrmOrganisationManager, XrmOrganisationManager>();
            services.AddScoped<IXrmWorkflowManager, XrmWorkflowManager>();
            services.AddScoped<IContractQueryRepository, ContractQueryRepository>();
            services.AddScoped<IContractDeDuplicationService, ContractDeDuplicationService>();
            services.AddScoped<IContractAllocationCommandRepository, ContractAllocationRepository>();

            // ✅ Singleton (Windsor LifestyleSingleton)
            services.AddSingleton<IFundingStreamDeliverablePeriodRepository, FundingStreamDeliverablePeriodRepository>();
            services.AddSingleton<IBatchCacheManager, BatchCacheManager>();
            services.AddSingleton<IEnduringCacheManager, EnduringCacheManager>();
            services.AddSingleton<IProcessedMessageRepository, ProcessedMessageRepository>();
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();

            // ✅ CRM factory
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            return services;
        }
    }
}
