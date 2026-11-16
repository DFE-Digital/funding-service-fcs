
namespace ContractCreateDomain.Endpoint.EnrichForDocumentation
{
    using ContractCreateDomain.Endpoint.Services;
    using Microsoft.Extensions.DependencyInjection;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Services;
    using Infrastructure;
    using Services.Repositories;
    public static class EnrichForDocumentationServiceRegistration
    {
        public static IServiceCollection AddEnrichForDocumentationServices(
            this IServiceCollection services)
        {
            // ✅ Singleton (matches Windsor LifestyleSingleton exactly)
            services.AddSingleton<IOrganisationService, OrganisationService>();
            services.AddSingleton<IOrganisationServiceApiHttpClient, OrganisationServiceApiHttpClient>();
            services.AddSingleton<ISiblingApprovedContractService, SiblingApprovedContractService>();
            services.AddSingleton<IApprovedContractRepository, ApprovedContractRepository>();
            services.AddSingleton<IFundingTypeFundingPeriodRepository, FundingTypeFundingPeriodRepository>();
            services.AddSingleton<IRelatedAllocationEnricher, RelatedAllocationEnricher>();
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<IContractEnrichmentService, ContractEnrichmentService>();

            return services;
        }
    }

}
