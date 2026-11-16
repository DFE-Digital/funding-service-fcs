
namespace AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint
{
    using System;
    using Microsoft.Extensions.DependencyInjection;

    using Infrastructure;
    using Repositories;
    using Services;

    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;

    public static class ContractUnderTerminationServiceRegistration
    {
        public static IServiceCollection AddContractUnderTerminationServices(
            this IServiceCollection services)
        {
            // ✅ Singleton
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();

            // ✅ Scoped
            services.AddScoped<IAllocationUnderTerminationRepository, AllocationUnderTerminationRepository>();
            services.AddScoped<IZeroiseActualsService, ZeroiseActualsService>();
            services.AddScoped<IFundingStreamPeriodRepository, FundingStreamPeriodRepository>();

            // ✅ ✅ FIXED: Fully qualified to remove ambiguity
            services.AddScoped<IAllocationDeliverablePeriodActualAuditRepository,
                AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint.Repositories.AllocationDeliverablePeriodActualAuditRepository>();

            services.AddScoped<IOverrideDateDBContext, OverrideDateDBContext>();

            // ✅ Date provider (modern replacement for ConfigurationManager)
            var useRealDate = Convert.ToBoolean(
                Environment.GetEnvironmentVariable("UseRealDate") ?? "false");

            if (useRealDate)
                services.AddSingleton<IDate, SystemDate>();
            else
                services.AddScoped<IDate, StaticDate>();

            return services;
        }
    }
}
