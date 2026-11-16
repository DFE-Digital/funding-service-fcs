namespace CrossDomain.Integration.ReportRunnerEndpoint.Ioc
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System;
    using System.Configuration;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Common.Reporting;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    //using SFA.FCT.CrossDomain.Integration.Common.ReportExecution2005;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;

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
                Component.For<IReportRunner>().ImplementedBy<ReportRunner>().LifestyleTransient(),
                //Component.For<IReportingServicesClient>().ImplementedBy<ReportingServicesClient>().LifestyleTransient(),
                //Component.For<IReportExecutionService>().ImplementedBy<ReportExecutionService>().LifestyleTransient(),
                Component.For<IOffice365Adapter>().ImplementedBy<Office365StorageWrapper>().LifestyleTransient(),
                Component.For<IArchiveReportService>().ImplementedBy<ArchiveReportService>().LifestyleSingleton(),
                Component.For<IContractManagementDbContext>().ImplementedBy<ContractManagementDbContext>().LifestyleScoped(),
                Component.For<ICdaReportFundingStreamPeriodQueryRepository>()
                         .ImplementedBy<CdaReportFundingStreamPeriodQueryRepository>()
                         .LifestyleScoped(),
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("CrossDomain.Integration.Common")),
                Component.For<IOverrideDateDBContext>().ImplementedBy<OverrideDateDBContext>().LifestyleScoped(),
                ParseDateRegistration());
        }

        private static IRegistration ParseDateRegistration()
        {
            var useRealDate = Convert.ToBoolean(ConfigurationManager.AppSettings["UseRealDate"]);

            return useRealDate ? Component.For<IDate>().ImplementedBy<SystemDate>().LifestyleScoped() : Component.For<IDate>().ImplementedBy<StaticDate>().LifestyleScoped();
        }
    }
}
