namespace ContractCreateDomain.Endpoint.Organisation
{
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation;

    public static class OrganisationServiceRegistration
    {
        public static IServiceCollection AddOrganisationServices(
            this IServiceCollection services)
        {
            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<IXrmOrganisationManager, XrmOrganisationManager>();

            // ✅ CRM factory (Windsor factory replacement)
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            return services;
        }
    }
}
