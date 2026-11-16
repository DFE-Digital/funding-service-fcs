
namespace PaymentGenerationDomain.Endpoint.PaymentPostedEndpoint
{
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using BusinessLogic;

    public static class PaymentPostedServiceRegistration
    {
        public static IServiceCollection AddPaymentPostedServices(
            this IServiceCollection services)
        {
            // ✅ Scoped (Windsor LifestyleScoped equivalent)
            services.AddScoped<IXrmAllocationManager, XrmAllocationManager>();

            services.AddScoped<IOrganizationService>(provider =>
                CrmConnectionFactory.GetOrganizationService());

            return services;
        }
    }
}
