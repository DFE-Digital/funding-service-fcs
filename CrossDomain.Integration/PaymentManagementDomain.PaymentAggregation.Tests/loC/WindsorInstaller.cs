namespace SFA.FCT.PaymentManagementDomain.PaymentAggregation.Tests.loC
{
    using System;
    using System.Configuration;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using ContractCreateDomain.Implementation;
    using ContractCreateDomain.Implementation.Persistence;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.OverrideDate;
    using CrossDomain.Integration.OverrideDate.DataStore;
    using Framework.Logging.Interfaces;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using PaymentSchedule.DataStore;
    using PolicyCache.DataStore;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public WindsorInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            var xrmConnection =
                CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);

            container.Register(
                Component.For<IOverrideDateDBContext>().ImplementedBy<OverrideDateDBContext>().LifestyleSingleton(),
                Component.For<CrmConnection>().Instance(xrmConnection),
                Component.For<IOrganizationService>().ImplementedBy<OrganizationService>().LifestyleSingleton(),
                Component.For<IXrmOrganisationManager>().ImplementedBy<XrmOrganisationManager>().LifestyleSingleton(),
                Component.For<IBatchCacheManager>().ImplementedBy<BatchCacheManager>().LifestyleSingleton(),
                Component.For<ILookupManager>().ImplementedBy<LookupManager>().LifestyleSingleton(),
                Component.For<IEnduringCacheManager>().ImplementedBy<EnduringCacheManager>().LifestyleSingleton(),
                Component.For<IPaymentManagementPolicyContext>()
                    .ImplementedBy<PaymentManagementPolicyContext>()
                    .LifeStyle.Transient,
                Component.For<IPaymentSchedulePolicyContext>()
                    .ImplementedBy<PaymentSchedulePolicyContext>()
                    .LifeStyle.Transient,
                Component.For<IContractsManager>().ImplementedBy<ContractsManager>().LifeStyle.Transient,
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("PaymentManagementDomain")),
                ParseDateRegistration());
        }

        // This registration is dependant on the environment:
        // StaticDate should be used on any environment in which automated tests have to be run
        // SystemDate should be used for production for performance improvements
        private static IRegistration ParseDateRegistration()
        {
            var useRealDate = Convert.ToBoolean(ConfigurationManager.AppSettings["UseRealDate"]);

            return useRealDate
                ? Component.For<IDate>().ImplementedBy<SystemDate>().LifestyleSingleton()
                : Component.For<IDate>().ImplementedBy<StaticDate>().LifestyleSingleton();
        }
    }
}