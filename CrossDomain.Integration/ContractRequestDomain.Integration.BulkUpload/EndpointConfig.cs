namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload
{
    using Common.Commands;
    using Common.Utils;
    using CrossDomain.Integration.Events;
    using CrossDomain.Integration.Messages.Commands;
    using FCS.Worker.Common;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Extensions.Logging;
    using NServiceBus;
    using BusinessLogic.Services;
    using BusinessLogic.Interfaces;
    using CrossDomain.Integration.Common.Storage;
    using CrossDomain.Integration.OverrideDate.DataStore.Services;
    using DataStore.Repositories;
    using Das.Services;
    using DataStore;
    using Repositories;
    using System.Collections.Generic;
    using System.Linq;

    public class EndpointConfig : IEndpointConfig
    {
        static EndpointConfig()
        {
            BulkImportProcessingTable = ConfigurationHelper.GetSetting(ConfigurationHelper.BulkUpdateProcessingTableConfigEntryKey);
            BulkImportLocationMappingTable = ConfigurationHelper.GetSetting(ConfigurationHelper.BulkUpdateLocationMappingTableConfigEntryKey);
        }

        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new List<string>
        {
            nameof(INewExcelUploadFileEvent),
            nameof(BulkUploadInProgressEvent),
            nameof(BulkUploadCompleteEvent)
        };

        public static string BulkImportProcessingTable { get; private set; }

        public static string BulkImportLocationMappingTable { get; private set; }

        public string NameOfAssembly => "ContractRequestDomain.Integration.BulkUpload.dll";

        public string EndpointName => "ContractRequestDomain.BulkUpload";

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>
        {
            new Subscription("ContractRequestDomain.FileWatcher", typeof(INewExcelUploadFileEvent))
        };

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("ContractCreateDomain.CreateContract", typeof(NewContractRequestCommand)),
            new CommandRoute("ContractCreateDomain.CreateContract", typeof(NewAmendmentRequestCommand)),
            new CommandRoute("ContractCreateDomain.CreateContract", typeof(RevisedNewContractRequestCommand)),
            new CommandRoute("ContractCreateDomain.UpdateContract", typeof(DraftContractUpdateRequestCommand)),
            new CommandRoute("ContractCreateDomain.AmendContract", typeof(ContractAmendmentRequestCommand)),
            new CommandRoute("ContractCreateDomain.UpdateDraftContractAmendment", typeof(UpdateDraftContractAmendmentRequestCommand)),
            new CommandRoute(EndpointName, typeof(StartBulkImportProcessingCommand))
        };


        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            var connectionString = Environment.GetEnvironmentVariable("AzureServiceBusConnection");

            if (string.IsNullOrWhiteSpace(connectionString))
            {
                throw new InvalidOperationException(
                    "AzureServiceBusConnection environment variable is not set.");
            }

           
            // ✅ Conventions (fixed)
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    (t.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    typeof(ICommand).IsAssignableFrom(t))
                .DefiningEventsAs(t =>
                    EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ INLINE REPLACEMENT OF WINDSOR
            configuration.RegisterComponents(services =>
            {
                // -----------------------------
                // Logger
                // -----------------------------
                services.AddSingleton(loggerFactory);

                services.AddSingleton<ILogger>(
                    _ => loggerFactory.CreateLogger<EndpointConfig>());

                // -----------------------------
                // Dynamic file access selection
                // -----------------------------
                Type fileAccessType = typeof(Office365FileAccess);

                var fileAccessSetting = Environment.GetEnvironmentVariable("FileWatcher.FileAccessType");

                if (!string.IsNullOrEmpty(fileAccessSetting) &&
                    fileAccessSetting.Equals("azureblobstorage", StringComparison.OrdinalIgnoreCase))
                {
                    fileAccessType = typeof(AzureBlobStorageFileAccess);
                }

                services.AddTransient(typeof(IBulkUploadFileAccess), fileAccessType);

                // -----------------------------
                // Transient सेवices (Windsor LifestyleTransient)
                // -----------------------------
                services.AddTransient<IOffice365Adapter, Office365StorageWrapper>();
                services.AddTransient<IExcelFileParser, ExcelFileParser>();
                services.AddTransient<ICheckForErrorValidation, CheckForErrorValidation>();
                services.AddTransient<IContractBulkUploadFileLevelValidation, ContractBulkUploadFileLevelValidation>();
                services.AddTransient<IFileValidationFscEnrichment, FileValidationFscEnrichment>();
                services.AddTransient<IContractSyntaxValidation, ContractSyntaxValidation>();
                services.AddTransient<ITransformToContractRequest, TransformToContractRequest>();
                services.AddTransient<ILocationMapper, LocationMapper>();
                services.AddTransient<IGenerateResultsReport, GenerateResultsReport>();
                services.AddTransient<IAzureTableStore, AzureTableStore>();

                // -----------------------------
                // Scoped services (Windsor LifestyleScoped)
                // -----------------------------
                services.AddScoped<IFundingTypeFundingPeriodRepository, FundingTypeFundingPeriodRepository>();
                services.AddScoped<IContractRequestDbContext, ContractRequestDbContext>();

                // -----------------------------
                // Singleton services
                // -----------------------------
                services.AddSingleton<IFundingAllocationReleaseRepository, FundingAllocationReleaseRepository>();
                services.AddSingleton<IContractSyntaxBusinessRuleService, ContractSyntaxBusinessRuleService>();
                services.AddSingleton<IContractRequestMutator, ContractRequestMutator>();
                services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
                services.AddSingleton<IDateProvider, DateProvider>();

                // -----------------------------
                // Default (no lifestyle specified → transient in Windsor)
                // -----------------------------
                services.AddTransient<IProcessedMessageRepository, ProcessedMessageRepository>();
            });

            return configuration;
        }

    }
}
