namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload.IoC
{
    using System;
    using System.Configuration;
    using Castle.MicroKernel.Registration;
    using Framework.Logging.Interfaces;
    using BusinessLogic.Services;
    using BusinessLogic.Interfaces;
    using CrossDomain.Integration.Common.Storage;
    using CrossDomain.Integration.OverrideDate.DataStore.Services;
    using DataStore.Repositories;
    using Das.Services;
    using DataStore;
    using Repositories;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public WindsorInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(Castle.Windsor.IWindsorContainer container, Castle.MicroKernel.SubSystems.Configuration.IConfigurationStore store)
        {
            Type fileAccessType = typeof(Office365FileAccess);
            string fileAccessConfigurationSetting = ConfigurationManager.AppSettings["FileWatcher.FileAccessType"];
            if (!string.IsNullOrEmpty(fileAccessConfigurationSetting))
            {
                if (fileAccessConfigurationSetting.ToLower() == "azureblobstorage")
                {
                    fileAccessType = typeof(AzureBlobStorageFileAccess);
                }
            }

            container.Register(
                Component.For<IBulkUploadFileAccess>().ImplementedBy(fileAccessType).LifestyleTransient(),
                Component.For<IOffice365Adapter>().ImplementedBy<Office365StorageWrapper>().LifestyleTransient(),
                Component.For<IExcelFileParser>().ImplementedBy<ExcelFileParser>().LifestyleTransient(),
                Component.For<ICheckForErrorValidation>().ImplementedBy<CheckForErrorValidation>().LifestyleTransient(),
                Component.For<IContractBulkUploadFileLevelValidation>().ImplementedBy<ContractBulkUploadFileLevelValidation>().LifestyleTransient(),
                Component.For<IFileValidationFscEnrichment>().ImplementedBy<FileValidationFscEnrichment>().LifestyleTransient(),
                Component.For<IContractSyntaxValidation>().ImplementedBy<ContractSyntaxValidation>().LifestyleTransient(),
                Component.For<ITransformToContractRequest>().ImplementedBy<TransformToContractRequest>().LifestyleTransient(),
                Component.For<ILocationMapper>().ImplementedBy<LocationMapper>().LifestyleTransient(),
                Component.For<IGenerateResultsReport>().ImplementedBy<GenerateResultsReport>().LifestyleTransient(),
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("BulkUpload")),
                Component.For<IAzureTableStore>().ImplementedBy<AzureTableStore>().LifestyleTransient(),
                Component.For<IFundingTypeFundingPeriodRepository>().ImplementedBy<FundingTypeFundingPeriodRepository>().LifestyleScoped(),
                Component.For<IFundingAllocationReleaseRepository>().ImplementedBy<FundingAllocationReleaseRepository>().LifestyleSingleton(),
                Component.For<IContractRequestDbContext>().ImplementedBy<ContractRequestDbContext>().LifestyleScoped(), // this may not work, todo: may need to use connection info
                Component.For<IContractSyntaxBusinessRuleService>().ImplementedBy<ContractSyntaxBusinessRuleService>().LifestyleSingleton(),
                Component.For<IContractRequestMutator>().ImplementedBy<ContractRequestMutator>().LifestyleSingleton(),
                Component.For<IProcessedMessageRepository>().ImplementedBy<ProcessedMessageRepository>(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton(),
                Component.For<IDateProvider>().ImplementedBy<DateProvider>().LifestyleSingleton());
        }
    }
}
