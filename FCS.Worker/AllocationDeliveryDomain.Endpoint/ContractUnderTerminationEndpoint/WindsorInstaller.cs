namespace AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint
{
    using System;
    using System.Configuration;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Infrastructure;
    using Repositories;
    using Services;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;
    using SFA.FCT.Framework.Logging.Interfaces;

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
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("AllocationDeliveryDomain")),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton(),
                Component.For<IAllocationUnderTerminationRepository>().ImplementedBy<AllocationUnderTerminationRepository>().LifestyleScoped(),
                Component.For<IZeroiseActualsService>().ImplementedBy<ZeroiseActualsService>().LifestyleScoped(),
                Component.For<IFundingStreamPeriodRepository>().ImplementedBy<FundingStreamPeriodRepository>().LifestyleScoped(),
                Component.For<IAllocationDeliverablePeriodActualAuditRepository>().ImplementedBy<Repositories.AllocationDeliverablePeriodActualAuditRepository>().LifestyleScoped(),
                Component.For<IOverrideDateDBContext>().ImplementedBy<OverrideDateDBContext>().LifestyleScoped(),
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
