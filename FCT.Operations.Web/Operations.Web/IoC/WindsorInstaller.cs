namespace Operations.Web.IoC
{
    using System.Web.Http.Controllers;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using DataStore;
    using DataStore.Repositories;
    using Infrastructure;
    using Repositories;
    using Services;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Table;
    using System.Configuration;

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
                Classes.FromThisAssembly().BasedOn<IHttpController>().LifestyleTransient(),
                Component.For<ICheckerFactory>().ImplementedBy<CheckerFactory>().LifestylePerWebRequest(),
                Component.For<IAvailabilityCheckerService>().ImplementedBy<AvailabilityCheckerService>().LifestylePerWebRequest(),
                Component.For<ISessionRepository>().ImplementedBy<SessionRepository>().LifestylePerWebRequest(),
                Component.For<IOrganisationRepository>().ImplementedBy<OrganisationRepository>().LifestylePerWebRequest(),
                Component.For<IEngagementEventRepository>().ImplementedBy<EngagementEventRepository>().LifestyleSingleton(),
                Component.For<IDasRequestService>().ImplementedBy<DasRequestService>().LifestyleSingleton(),
                Component.For<IFundingTypeFundingPeriodRepository>().ImplementedBy<FundingTypeFundingPeriodRepository>().LifestyleSingleton(),
                Component.For<OperationsDbContext>().LifestylePerWebRequest(),
                Component.For<INotificationsService>().ImplementedBy<NotificationsService>().LifestylePerWebRequest(),
                Component.For<INotifierFactory>().ImplementedBy<NotifierFactory>().LifestylePerWebRequest(),
                Component.For<IRoatpUkprnRepository>().ImplementedBy<RoatpUkprnRepository>().LifestylePerWebRequest(),
                Component.For<IContractManagementDbContext>().ImplementedBy<ContractManagementDbContext>().LifestylePerWebRequest(),
                Component.For<ILevyContractService>().ImplementedBy<LevyContractService>().LifestylePerWebRequest(),
                Component.For<ICrmContractInformationRepository>().ImplementedBy<CrmContractInformationRepository>().LifestylePerWebRequest(),
                Component.For<IIntegrityCheckerService>().ImplementedBy<IntegrityCheckerService>().LifestyleSingleton(),
                Component.For<IContractAtomFeedQueryRepository>().ImplementedBy<ContractAtomFeedQueryRepository>().LifestyleSingleton(),
                Component.For<IClosedCollectionRepository>().ImplementedBy<ClosedCollectionRepository>().LifestyleSingleton(),
                Component.For<IMonthEndRepository>().ImplementedBy<MonthEndRepository>().LifestyleSingleton(),
                Component.For<IDownloadIntegrityCheckerRepository>().ImplementedBy<DownloadIntegrityCheckerRepository>().LifestyleSingleton(),
                Component.For<ILogger>().Instance(_loggerFactory.CreateDefaultLogger()),
                Component.For<ITransportMessageSender>().ImplementedBy<NServiceBusSender>().LifestyleSingleton(),
                Component.For<IParkedFundingAllocationRepository>().ImplementedBy<ParkedFundingAllocationRepository>().LifestyleSingleton(),
                Component.For<IConnectivityRepository>().ImplementedBy<ConnectivityRepository>().LifestyleSingleton(),
                Component.For<ICfsImportInfoRepository>().ImplementedBy<CfsImportInfoRepository>().LifestyleSingleton(),
                Component.For<IPaymentBFItemQueryRepository>().ImplementedBy<PaymentBFItemQueryRepository>().LifestyleSingleton(),
                Component.For<IAzureServiceBusQueueService>().ImplementedBy<AzureServiceBusQueueService>().LifestyleSingleton(),
                Component.For<IAppLevyRepository>().ImplementedBy<AppLevyRepository>().LifestyleSingleton(),
                Component.For<IAppLevyService>().ImplementedBy<AppLevyService>().LifestyleSingleton(),
                Component.For<IAzureTableService>().ImplementedBy<AzureTableService>().LifestyleSingleton(),
                Component.For<IContractCleanupService>().ImplementedBy<ContractCleanupService>().LifestyleSingleton(),
                Component.For<IDigiRelManagementRepository>().ImplementedBy<DigiRelManagementRepository>().LifestyleSingleton(),
                Component.For<IDigiRelManagementService>().ImplementedBy<DigiRelManagementService>().LifestyleSingleton(),
                Component.For<CloudTable>().UsingFactoryMethod(() =>
                {
                    var storageAccount = CloudStorageAccount.Parse(ConfigurationManager.ConnectionStrings["commonStorageConnectionString"].ConnectionString);
                    var tableClient = storageAccount.CreateCloudTableClient();
                    var table = tableClient.GetTableReference("CommonReleaseEntity");
                    table.CreateIfNotExistsAsync().Wait();
                    return table;
                }).LifestyleSingleton()
            );
        }
    }
}