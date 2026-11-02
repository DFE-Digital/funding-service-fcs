namespace ContractCreateDomain.Endpoint.NonFinancialAmendment
{
    using System;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Infrastructure;
    using Microsoft.Xrm.Sdk;
    using Repositories;
    using Services;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Configuration;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;
    using ContractCreateDomain.Endpoint.Services;
    using ContractCreateDomain.Endpoint.Services.Repositories;
    using SFA.FCS.Worker.Common.Crm;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public WindsorInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<ILogger>().Instance(_loggerFactory.CreateDefaultLogger()).LifestyleSingleton(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton(),
                Component.For<Infrastructure.IFundingTypeFundingPeriodQueryRepository>().ImplementedBy<Infrastructure.FundingTypeFundingPeriodQueryRepository>().LifestyleSingleton(),
                Component.For<INonFinancialAmendmentValidationService>().ImplementedBy<NonFinancialAmendmentValidationService>().LifestyleScoped(),
                Component.For<ICrmContractRepository>().ImplementedBy<CrmContractRepository>().LifestyleScoped(),
                Component.For<IOrganizationService>().UsingFactoryMethod(k => CrmConnectionFactory.GetOrganizationService()).LifestyleScoped(),
                Component.For<IOverrideDateDBContext>().ImplementedBy<OverrideDateDBContext>().LifestyleScoped(),
                Component.For<ISiblingContractCheckService>().ImplementedBy<SiblingContractCheckService>().LifestyleScoped(),
                Component.For<ICrmContractQueryRepository>().ImplementedBy<CrmContractQueryRepository>().LifestyleScoped(),
                GetRegistrationForIDate()
            );
        }

        private static IRegistration GetRegistrationForIDate()
        {
            var useRealDate = Convert.ToBoolean(ConfigurationManager.AppSettings["UseRealDate"]);

            return useRealDate ? Component.For<IDate>().ImplementedBy<SystemDate>().LifestyleSingleton() : Component.For<IDate>().ImplementedBy<StaticDate>().LifestyleScoped();
        }
    }
}