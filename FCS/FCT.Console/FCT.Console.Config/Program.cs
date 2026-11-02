namespace FCT.Console.Config
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.Entity.Validation;
    using System.IO;
    using System.Linq;
    using Aspose.Cells;
    using ContractManagement.DataStore;
    using DocumentFolders;
    using Excel;
    using ExcelTypes;
    using Extraction;
    using Templates;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage.Repositories;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.FundingStreamConfigDomain.BusinessLogic;
    using SFA.FCT.FundingStreamConfigDomain.BusinessLogic.FundingPolicySeed;
    using Synchronizers;
    using Synchronizers.CRM;
    using Synchronizers.PaaS;
    using Synchronizers.PaaS.Repositories;
    using Synchronizers.Readers;
    using Synchronizers.Writers.CRM;
    using UnitTests.Common;
    using FCT.Console.Config.Templates.Repositories;
    using Microsoft.ServiceBus;
    using Microsoft.ServiceBus.Messaging;
    using Services;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using System.Data.SqlClient;
    using Dapper;

    class Program
    {
        private static readonly IList<SheetSynchronizers> SynchronizerGroups = new List<SheetSynchronizers>();
        private static IWorkbookReader _reader;
        private static IReadOnlyCollection<string> _sequenceNames = null;
        private static readonly ICrmContractNumberRepository CrmContractNumberRepository = new CrmContractNumberRepository();

        public static void Main(string[] args)
        {
            if (ShouldDisplayHelp(args))
            {
                DisplayHelp();
                return;
            }

            SetupLicence();

            var hasConfigChanged = true; //ConfigFileVersionService.HasConfigChanged();

            if (ShouldDeployConfiguration(args, hasConfigChanged))
            {
                DeployConfiguration();
            }

            if (ShouldCreateDocumentFolders(args, hasConfigChanged))
            {
                CreateDocumentFolders();
            }

            if (ShouldReseedAtomFeedStorage(args, hasConfigChanged))
            {
                ReseedDeliverableAtomFeedStorage();
            }

            if (ShouldDeployTemplates(args))
            {
                UpdateTemplateDocuments();
            }

            if (ShouldExtractConfig(args))
            {
                Console.WriteLine("Extracting Configuration from CRM and PaaS");
                ConfigExtractor.ExtractConfigToCsv();
            }

            if (ShouldCheckSharepointConnection(args))
            {
                CheckSharePointConnection();
            }

            if (ShouldDeployPayCalcPolicyConfigOnly(args))
            {
                DeployPayCalcPolicyCache();
            }
        }

        private static void CheckSharePointConnection()
        {
            const string folderName = "24+LOANS-1516-Input-Appendices";

            DocumentFolderCreator folderCreator = CreateDocumentFolderCreator();

            if (folderCreator.CanConnectToSharePoint(folderName))
            {
                Console.WriteLine($"SharePoint connection successful for folder name '{folderName}'");
            }
            else
            {
                Console.WriteLine($"SharePoint connection failed for folder name '{folderName}'");
            }
        }

        private static bool ShouldDisplayHelp(string[] args)
        {
            return args.Contains("/?");
        }

        private static bool ShouldExtractConfig(string[] args)
        {
            return args.Contains("/E");
        }

        private static bool ShouldDeployConfiguration(string[] args, bool hasConfigChanged)
        {
            var normalDeployRequested = args.Length == 0 || args.Contains("/D");

            return normalDeployRequested && hasConfigChanged || args.Contains("/Force-D");
        }

        private static bool ShouldCreateDocumentFolders(string[] args, bool hasConfigChanged)
        {
            var normalCreateDocumentFoldersRequested = args.Length == 0 || args.Contains("/C");

            return normalCreateDocumentFoldersRequested && hasConfigChanged || args.Contains("/Force-C");
        }

        private static bool ShouldReseedAtomFeedStorage(string[] args, bool hasConfigChanged)
        {
            var normalReseedAtomFeedStorageRequested = args.Length == 0 || args.Contains("/R");

            return normalReseedAtomFeedStorageRequested && hasConfigChanged || args.Contains("/Force-R");
        }

        private static bool ShouldDeployTemplates(string[] args)
        {
            return args.Contains("/T");
        }

        private static bool ShouldCheckSharepointConnection(string[] args)
        {
            return (args.Length == 1 && args[0].Contains("/SharePointConnectionTest"));
        }

        private static bool ShouldDeployPayCalcPolicyConfigOnly(string[] args)
        {
            return (args.Length == 1 && args[0].ToUpper() == "/PC");
        }

        private static IWorkbookReader GetJsonWorkbookReader()
        {
            if (_reader == null)
            {
                Console.WriteLine(@"Reading/Loading Json config");

                using (TestResource resource = new TestResource("FCT.Console.Config", @"Resources.Config.json"))
                {
                    _reader = new JsonWorkbookReader(resource.Stream);
                }

                Console.WriteLine(@"Json Config Read/Loaded");
            }

            return _reader;
        }

        private static void DeployConfiguration()
        {
            try
            {
                SetupSynchronizers();

                IWorkbookReader reader = GetJsonWorkbookReader();

                UpdateEntitiesInCrmAndPaas(reader);

                ConfigFileVersionService.WriteConfigInfoIntoTable();

                new FundingAllocationStatusSubStatusConfigSynchronizer().AddOrUpdateConfig(null);

                UnParkFundingAllocations();
                UpdateStatusSubStatusValues();
            }
            catch (DbEntityValidationException ex)
            {
                // Retrieve the error messages as a list of strings.
                var errorMessages = ex.EntityValidationErrors
                    .SelectMany(x => x.ValidationErrors)
                    .Select(x => x.ErrorMessage);

                // Join the list to a single string.
                var fullErrorMessage = String.Join("; ", errorMessages);

                // Combine the original exception message with the new one.
                var exceptionMessage = String.Concat(ex.Message, " The validation errors are: ", fullErrorMessage);

                // Throw a new DbEntityValidationException with the improved exception message.
                throw new DbEntityValidationException(exceptionMessage, ex.EntityValidationErrors);
            }

            Console.WriteLine("All done processing config spreadsheet");
        }

        private static void DisplayHelp()
        {
            Console.WriteLine("Applies policy configuration into FCS system including creating document folders in office 365 and Reseeding deliverables atom feed");
            Console.WriteLine();
            Console.WriteLine("FCT.Console.Config.exe [/D] [/C] [/R] [/E]");
            Console.WriteLine();
            Console.WriteLine("    /D: DeployPolicyConfig - Will read config spreadsheet and update PaaS and CRM");
            Console.WriteLine("    /C: CreateDocFolders - Will read config spreadsheet and create document folders in Office 365");
            Console.WriteLine("    /R: ReseedFeed - Will populate Deliverable Configuration Atom Feed");
            Console.WriteLine("    /E: ExtractConfig - Will extract config from CRM and PaaS and create CSV files in bin directory");
            Console.WriteLine();
            Console.WriteLine("Switches are optional, if none are provided all will be executed (except '/E: ExtractConfig')");
        }

        private static void DeployPayCalcPolicyCache()
        {
            IWorkbookReader reader = GetJsonWorkbookReader();

            GetPayCalcPolicyCacheSynchronizers().SelectMany(sheetSyncronizer => sheetSyncronizer.Synchronizers.Select(s => new { Synchronizer = s, sheetSyncronizer.SheetName })).ToList()
                .ForEach(synchronizerWithSheetName =>
                {

                    string typeName = synchronizerWithSheetName.Synchronizer.GetType().Name;
                    Console.WriteLine($"Beginning processing type {typeName} time {DateTime.Now}");
                    ActionRetrier.RetryWhenExceptionThrown(() => synchronizerWithSheetName.Synchronizer.AddOrUpdateConfig(reader.WorksheetReader(synchronizerWithSheetName.SheetName)));
                    Console.WriteLine($"Finished processing type {typeName} time {DateTime.Now}");
                });
        }

        private static IReadOnlyCollection<SheetSynchronizers> GetPayCalcPolicyCacheSynchronizers()
        {
            return new List<SheetSynchronizers>
            {
                new SheetSynchronizers("Funding Stream Period", new List<ISynchronizeConfig>
                {
                    new PolicyCacheFundingStreamPeriodSynchronizer()
                }, allowDelete: false),
                new SheetSynchronizers("FSP Capping Groups", new List<ISynchronizeConfig>
                {
                    new PolicyCacheFundingStreamPeriodCappingGroupSynchronizer()
                }, allowDelete: false),
                new SheetSynchronizers("ESF Region Investment Priority", new List<ISynchronizeConfig>
                {
                    new PolicyCacheESFRegionInvestmentPrioritySynchronizer()
                }),
                new SheetSynchronizers("FSP Pay Calc Policy", new List<ISynchronizeConfig>
                {
                    new PolicyCacheFundingStreamPeriodPayCalcPolicySynchronizer()
                }, allowDelete: false),
                new SheetSynchronizers("FSP CP Pay Calc Policy", new List<ISynchronizeConfig>
                {
                    new PolicyCacheFundingStreamPeriodCappingPeriodPayCalcPolicySynchronizer()
                }, allowDelete: false),
                new SheetSynchronizers("Subnominal", new List<ISynchronizeConfig> {new PayGenSubnominalSynchronizer()}),
                new SheetSynchronizers("Payment Timetables", new List<ISynchronizeConfig>
                {
                    new PolicyCachePolicyFundingStreamCensusDateSynchronizer()
                }, allowDelete: false),
                new SheetSynchronizers("Subnominal Payment Types", new List<ISynchronizeConfig> { new PolicyCachePolicySubnominalSynchronizer() }),
                new SheetSynchronizers("FSP Deliverables", new List<ISynchronizeConfig>
                {
                    new PolicyCachePolicyDeliverableSynchronizer(),
                    new PolicyCachePolicyDeliverableToSubnominalsSynchronizer(),
                    new PerfMgmtFspDeliverableClaimSynchronizer()
                }, allowDelete: false),
            };
        }

        private static void UpdateEntitiesInCrmAndPaas(IWorkbookReader reader)
        {
            int numSynchronizersRan = 0;
            int numSynchronizersRanWithDelete = 0;

            var sheetNames = reader.SheetNames();
            foreach (var synchronizerGroup in SynchronizerGroups)
            {
                if (sheetNames.Contains(synchronizerGroup.SheetName))
                {
                    foreach (var synchronizer in synchronizerGroup.Synchronizers)
                    {
                        IInitializeConfigStorage configStorageInitializer = synchronizer as IInitializeConfigStorage;
                        configStorageInitializer?.InitializeConfigStorage();

                        string typeName = synchronizer.GetType().Name;
                        Console.WriteLine($"Beginning processing type {typeName} time {DateTime.Now}");
                        ActionRetrier.RetryWhenExceptionThrown(() => synchronizer.AddOrUpdateConfig(reader.WorksheetReader(synchronizerGroup.SheetName)));
                        Console.WriteLine($"Finished processing type {typeName} time {DateTime.Now}");
                        numSynchronizersRan++;
                    }
                }
                else
                {
                    throw new ArgumentException($"Sheet name {synchronizerGroup.SheetName} not found in spreadsheet");
                }
            }

            IReadOnlyCollection<SheetSynchronizers> synchronizersForDeletion =
                        SynchronizerGroups.Where(sg => sg.AllowDelete).Reverse().ToList();

            foreach (var synchronizerGroup in synchronizersForDeletion)
            {
                if (sheetNames.Contains(synchronizerGroup.SheetName))
                {
                    foreach (var synchronizer in synchronizerGroup.Synchronizers)
                    {
                        string typeName = synchronizer.GetType().Name;
                        Console.WriteLine($"Beginning delete - type {typeName} time {DateTime.Now}");
                        ActionRetrier.RetryWhenExceptionThrown(() => synchronizer.DeleteConfig(reader.WorksheetReader(synchronizerGroup.SheetName)));
                        Console.WriteLine($"Finished delete - type {typeName} time {DateTime.Now}");
                        numSynchronizersRanWithDelete++;
                    }
                }
                else
                {
                    throw new ArgumentException($"Sheet name {synchronizerGroup.SheetName} not found in spreadsheet");
                }
            }

            Console.WriteLine($"Num synchronizers ran - {numSynchronizersRan}");
            Console.WriteLine($"Num synchronizers ran (delete) - {numSynchronizersRanWithDelete}");
        }

        private static void UnParkFundingAllocations()
        {
            const string queueName = "FundingAllocation.UnParkFundingAllocation";

            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<StartUnParkFundingAllocationsCommand>();

            CreateEndpointIfNotPresent(queueName, GetAsbNamespaceManager());
            endpoint.Send(destination: queueName, message: new StartUnParkFundingAllocationsCommand()).Wait();
        }

        private static void UpdateStatusSubStatusValues()
        {
            string connectionString =
                ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"UPDATE [FundingAllocation].[FundingAllocation]
                                       SET [Status] = 'InRelease'
                                          ,[SubStatus] = 'Queued'
                                     WHERE [Status] = 'Scheduling'
                                       AND [SubStatus] = 'AwaitingRelease'";
                connection.Execute(sql);
            }
        }

        private static NamespaceManager GetAsbNamespaceManager()
        {
            return NamespaceManager.CreateFromConnectionString(ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString);
        }

        private static void CreateEndpointIfNotPresent(string queueName, NamespaceManager namespaceManager)
        {
            bool isQueuePresent = false;
            try
            {
                namespaceManager.GetQueue(queueName);
                isQueuePresent = true;
            }
            catch (MessagingEntityNotFoundException)
            {
            }

            if (!isQueuePresent)
            {
                CreateQueue(queueName, namespaceManager);
            }
        }

        private static void CreateQueue(string queueName, NamespaceManager namespaceManager)
        {
            long fiveGBInMegabytes = 5 * 1024;
            namespaceManager.CreateQueue(new QueueDescription(queueName)
            {
                LockDuration = TimeSpan.FromMinutes(5),
                MaxDeliveryCount = 2147483647,
                MaxSizeInMegabytes = fiveGBInMegabytes,
                ForwardDeadLetteredMessagesTo = "error"
            });
        }

        private static void SetupLicence()
        {
            using (Stream licenseStream = LicenseManager.GetAsposeLicense())
            {
                License license = new License();
                license.SetLicense(licenseStream);
            }
        }

        private static IReadOnlyCollection<string> GetExistingSequenceNames()
        {
            if (_sequenceNames == null)
            {
                using (var context = new ContractManagementDbContext())
                {
                    _sequenceNames = SequenceRepository.GetExistingSequenceNames(context.Database.Connection);
                }
            }

            return _sequenceNames;
        }

        private static void CreateSequence(string sequenceName, int startingValue)
        {
            using (var context = new ContractManagementDbContext())
            {
                SequenceRepository.CreateSequence(context.Database.Connection, sequenceName, startingValue);
            }
        }

        private static void SetupSynchronizers()
        {
            string agencyCode = GetAgencyCode();

            SynchronizerGroups.Add(new SheetSynchronizers("Agency", new List<ISynchronizeConfig>
            {
                new CrmAgencySynchronizer(),
                new ContractNumberForAgencySynchronizer(GetExistingSequenceNames, CreateSequence, CrmContractNumberRepository)
            }));
            SynchronizerGroups.Add(new SheetSynchronizers("Funding Type", new List<ISynchronizeConfig>
            {
                new CrmFundingTypeSynchronizer(),
                new ContractNumberForFundingTypeSynchronizer(GetExistingSequenceNames, CreateSequence, CrmContractNumberRepository),
                new FundingAllocationFundingTypeConfigSynchronizer(),
            }, allowDelete: true));
            SynchronizerGroups.Add(new SheetSynchronizers("Period Type", new List<ISynchronizeConfig> { new CrmPeriodTypeSynchronizer() }, allowDelete: true));
            SynchronizerGroups.Add(new SheetSynchronizers("Funding Period", new List<ISynchronizeConfig> { new CrmFundingPeriodSynchronizer() }, allowDelete: true));
            SynchronizerGroups.Add(new SheetSynchronizers("Funding Type Period",
                new List<ISynchronizeConfig>
                {
                    new CrmFundingTypeFundingPeriodSynchronizer(),
                    new ContractManagementFundingTypeFundingPeriodSynchronizer(),
                    new ContractRequestFundingTypeFundingPeriodSynchronizer(),
                    new DocumentsDomainFundingTypeFundingPeriodSynchronizer(),
                    new FundingAllocationFundingTypeFundingPeriodConfigSynchronizer()
                }, allowDelete: true));
            SynchronizerGroups.Add(new SheetSynchronizers("Funding Stream", new List<ISynchronizeConfig>
            {
                // the reader defaults the FinanceShortCode at the moment if not in the spreadsheet..this needs changing
                new PayGenFundingStreamSynchronizer(agencyCode),
                new CrmFundingStreamSynchronizer(agencyCode),
                new ContractNumberForFundingStreamSynchronizer(GetExistingSequenceNames, CreateSequence, CrmContractNumberRepository, agencyCode)
            }));
            SynchronizerGroups.Add(new SheetSynchronizers("FSP Groups", new List<ISynchronizeConfig> { new FspGroupSynchronizer(), new CrmFspGroupSynchronizer() }, allowDelete: true));
            SynchronizerGroups.Add(new SheetSynchronizers("Funding Stream Period", new List<ISynchronizeConfig>
            {
                new PayGenFundingStreamPeriodSynchronizer(),
                new PolicyCacheFundingStreamPeriodSynchronizer(),
                new MonitoringDeliverablesFundingStreamPeriodSynchronizer(),
                new CrmFundingStreamPeriodSynchronizer(),
                new DocumentsDomainFundingStreamPeriodSynchronizer(),
                new PerfMgmtFundingStreamPeriodSynchronizer(),
                new ContractManagementFundingStreamPeriodSynchronizer(),
                new FundingAllocationFundingStreamPeriodConfigSynchronizer(),
                new OperationsFspSynchronizer()
            }, allowDelete: true));
            SynchronizerGroups.Add(new SheetSynchronizers("FSP Capping Groups", new List<ISynchronizeConfig>
            {
                new CrmFundingStreamPeriodCappingGroupSynchronizer(),
                new PolicyCacheFundingStreamPeriodCappingGroupSynchronizer()
            }, allowDelete: true));
            SynchronizerGroups.Add(new SheetSynchronizers("FSP Pay Calc Policy", new List<ISynchronizeConfig>
            {
                new PolicyCacheFundingStreamPeriodPayCalcPolicySynchronizer()
            }, allowDelete: true));
            SynchronizerGroups.Add(new SheetSynchronizers("FSP CP Pay Calc Policy", new List<ISynchronizeConfig>
            {
                new PolicyCacheFundingStreamPeriodCappingPeriodPayCalcPolicySynchronizer()
            }, allowDelete: true));
            SynchronizerGroups.Add(new SheetSynchronizers("Deliverable", new List<ISynchronizeConfig> { new CrmDeliverableSynchronizer() }, allowDelete: true));
            SynchronizerGroups.Add(new SheetSynchronizers("Claim Types", new List<ISynchronizeConfig> { new PerfMgmtClaimTypeSynchronizer(), new CrmClaimTypeSynchronizer() }));
            SynchronizerGroups.Add(new SheetSynchronizers("Claim Collections", new List<ISynchronizeConfig> { new PerfMgmtClaimCollectionSynchronizer() }));
            SynchronizerGroups.Add(new SheetSynchronizers("Claim Recon Alloc Groups", new List<ISynchronizeConfig> { new PerfMgmtClaimReconciliationAllocationGroupSynchronizer(), new CrmAllocationGroupSynchronizer() }));
            SynchronizerGroups.Add(new SheetSynchronizers("Claim Recon Alloc Group FSPs", new List<ISynchronizeConfig> { new PerfMgmtClaimReconAllocGroupFSPsSynchronizer() }));
            SynchronizerGroups.Add(new SheetSynchronizers("Claim Reconciliation Behaviour", new List<ISynchronizeConfig>
            {
                new PerfMgmtClaimReconciliationBehaviourSynchronizer(),
                new CrmClaimReconciliationBehaviourSynchronizer()
            }));
            SynchronizerGroups.Add(new SheetSynchronizers("Claim Reconciliation Del Groups", new List<ISynchronizeConfig> { new PerfMgmtClaimReconciliationDeliverableGroupSynchronizer() }, allowDelete: true));
            SynchronizerGroups.Add(new SheetSynchronizers("Claim Rec Ref Data - Profiles", new List<ISynchronizeConfig> { new PerfMgmtClaimReconciliationReferenceDataProfileSynchronizer() }, allowDelete: true));
            SynchronizerGroups.Add(new SheetSynchronizers("Claim Rec Ref Data - Exceptions", new List<ISynchronizeConfig>
            {
                new PerfMgmtClaimReconciliationPublicationExceptionSynchronizer(),
                new CrmClaimReconciliationPublicationExceptionSynchronizer()
            }));
            SynchronizerGroups.Add(new SheetSynchronizers("Subnominal", new List<ISynchronizeConfig> { new PayGenSubnominalSynchronizer() }));
            SynchronizerGroups.Add(new SheetSynchronizers("Subnominal Payment Types", new List<ISynchronizeConfig> { new PolicyCachePolicySubnominalSynchronizer() }));
            SynchronizerGroups.Add(new SheetSynchronizers("FSP Deliverables", new List<ISynchronizeConfig>
            {
                new CrmFspDeliverableSynchronizer(),
                new MonitoringDeliverablesFundingStreamPeriodDeliverableSynchronizer(),
                new PolicyCachePolicyDeliverableSynchronizer(),
                new PolicyCachePolicyDeliverableToSubnominalsSynchronizer(),
                new PerfMgmtFspDeliverableClaimSynchronizer(),
                new FundingStreamPeriodLegalDeliverableSynchronizer(),
                new DocumentsDomainFundingStreamPeriodDeliverableSynchronizer(),
                new FundingAllocationFspDeliverableConfigSynchronizer()
            }, allowDelete: true));
            SynchronizerGroups.Add(new SheetSynchronizers("Region Types", new List<ISynchronizeConfig>
            {
                new RegionTypeSynchronizer()
            }));
            SynchronizerGroups.Add(new SheetSynchronizers("ESF Region Investment Priority", new List<ISynchronizeConfig> { new PolicyCacheESFRegionInvestmentPrioritySynchronizer() }));
            SynchronizerGroups.Add(new SheetSynchronizers("Payment Timetables", new List<ISynchronizeConfig>
            {
               new PolicyCachePolicyFundingStreamCensusDateSynchronizer(),
               new PayGenPaymentTimetableSynchroniser(), // has a dependency on PayGenFundingStreamPeriodSynchronizer to populate PaaS first
               new CrmPaymentTimeTableSynchronizer()
            }, allowDelete: true));

            SynchronizerGroups.Add(new SheetSynchronizers("Funding Type Stream Relationshi", new List<ISynchronizeConfig> { new CrmFundingTypeFundingStreamSynchronizer() }, allowDelete: true));
            SynchronizerGroups.Add(new SheetSynchronizers("Units of Procurement", new List<ISynchronizeConfig> { new CrmUoPSynchronizer() }));
            SynchronizerGroups.Add(new SheetSynchronizers("Contract Type", new List<ISynchronizeConfig>
            {
                new CrmContractTypeSynchronizer(),
                new ContractTypeSynchronizer()
            }, allowDelete: true));

            SynchronizerGroups.Add(new SheetSynchronizers("FTP-FSP", new List<ISynchronizeConfig> { new FundingTypePeriodFundingStreamPeriodSynchronizer() }, allowDelete: true));
            SynchronizerGroups.Add(new SheetSynchronizers("CDA Extracts", new List<ISynchronizeConfig> { new CdaExtractSynchronizer() }));
            SynchronizerGroups.Add(new SheetSynchronizers("CDA Extract FSPs", new List<ISynchronizeConfig> { new CdaExtractFspSynchronizer() }));

            SynchronizerGroups.Add(new SheetSynchronizers("Actuals Collection Returns", new List<ISynchronizeConfig>
            {
                new MonitoringDeliverablesHeldFspCollectionConfigSynchronizer(),
            }));

            SynchronizerGroups.Add(new SheetSynchronizers("FSP Group Document Templates", new List<ISynchronizeConfig> { new DocumentsDomainFspGroupDocumentTemplateSynchronizer() }));
            SynchronizerGroups.Add(new SheetSynchronizers("Contract Document Templates", new List<ISynchronizeConfig> { new DocumentsDomainContractDocumentTemplateSynchronizer() }));
            SynchronizerGroups.Add(new SheetSynchronizers("FTP-CoT", new List<ISynchronizeConfig> { new ContractManagementFundingTypeFundingPeriodContractTypeSynchronizer() }));

            SynchronizerGroups.Add(new SheetSynchronizers("NLAP Contract Ref Data", new List<ISynchronizeConfig> { new DocumentsDomainNlapFundingConfigSynchronizer() }, allowDelete: true));
            SynchronizerGroups.Add(new SheetSynchronizers("Contract Ref Data", new List<ISynchronizeConfig> { new DocumentsDomainContractReferenceConfigSynchronizer() }, allowDelete: true));
            SynchronizerGroups.Add(new SheetSynchronizers("Allocation Lines", new List<ISynchronizeConfig> { new FundingAllocationAllocationLineSynchronizer() }, allowDelete: true));
            SynchronizerGroups.Add(new SheetSynchronizers("Allocation Provider Types", new List<ISynchronizeConfig> { new FundingAllocationAllocationProviderTypesSynchronizer() }, allowDelete: false));
            SynchronizerGroups.Add(new SheetSynchronizers("Allocation Funding Streams", new List<ISynchronizeConfig> { new FundingAllocationAllocationFundingStreamSynchronizer() }, allowDelete: true));
            SynchronizerGroups.Add(new SheetSynchronizers("PC-CT", new List<ISynchronizeConfig> { new FundingAllocationCfsCodesToContractTypeSynchronizer() }, allowDelete: true));
            SynchronizerGroups.Add(new SheetSynchronizers("Provider Category Exceptions", new List<ISynchronizeConfig> { new ProviderCategoryExceptionSynchronizer() }, allowDelete: true));
            SynchronizerGroups.Add(new SheetSynchronizers("Claim Rec Ref Data - Recon Prof", new List<ISynchronizeConfig> { new ClaimReconciliationReferenceDataReconProfilingSynchronizer() }, allowDelete: false));
        }

        private static void ReseedDeliverableAtomFeedStorage()
        {
            Console.WriteLine("Reseeding Funding Policy Atom Feed Storage ");

            var logger = new SimpleConsoleLogger();
            var azureRepository = new AzureDeliverableSettingConfigurationRepository(
                new EnvironmentContext(), new AzureTableStore(), new StorageObjectSerializer(), logger);
            var pagedStorageSeedRunner = new PagedStorageSeedRunner<DeliverableSettingConfiguration>(logger, azureRepository);
            var pagedStorageSeed = new DeliverableSettingConfigurationSeed(CrmHelper.GetConnection());

            Console.WriteLine("Clearing storage");
            azureRepository.Clear();

            pagedStorageSeedRunner.ExecuteBulkReseed(pagedStorageSeed);
        }

        private static void UpdateTemplateDocuments()
        {
            Console.WriteLine($"Uploading Templates - time {DateTime.Now}");

            new TemplatesUpdater(new UploadedDocumentTemplateRepository(), new TemplateStorageRepository(), new AssemblyRepository()).Update();

            Console.WriteLine($"Uploading Templates Complete - time {DateTime.Now}");
        }

        private static DocumentFolderCreator CreateDocumentFolderCreator()
        {
            ILogger logger = new SimpleConsoleLogger();

            return new DocumentFolderCreator(new Office365StorageWrapper { Logger = logger }, logger);
        }

        private static void CreateDocumentFolders()
        {
            bool shouldCreateFoldersPastActivityCloseDate =
                Convert.ToBoolean(ConfigurationManager.AppSettings["ShouldCreateFoldersPastActivityCloseDate"]);

            IReadOnlyCollection<string> folderNames = DocumentFolderNameUtility.GetFolderNames(shouldCreateFoldersPastActivityCloseDate);

            DocumentFolderCreator folderCreator = CreateDocumentFolderCreator();

            foreach (var folder in folderNames)
            {
                ActionRetrier.RetryWhenExceptionThrown(() => folderCreator.CreateFolderIfNotExists(folder));
            }
        }

        private static string GetAgencyCode()
        {
            _reader = GetJsonWorkbookReader();

            IWorksheetReader worksheetReader = _reader.WorksheetReader("Agency");
            AgencyReader agencySheetReader = new AgencyReader();

            IReadOnlyCollection<AgencySheetType> agencySheetRecords = agencySheetReader.ReadConfig(worksheetReader);

            return agencySheetRecords.First().AgencyShortCode;
        }

        private class SheetSynchronizers
        {
            public SheetSynchronizers(string sheetName, IEnumerable<ISynchronizeConfig> synchronizers)
            {
                Synchronizers = synchronizers;
                SheetName = sheetName;
            }

            public SheetSynchronizers(string sheetName, IEnumerable<ISynchronizeConfig> synchronizers, bool allowDelete)
                : this(sheetName, synchronizers)
            {
                AllowDelete = allowDelete;
            }

            public string SheetName { get; }

            public IEnumerable<ISynchronizeConfig> Synchronizers { get; }

            public bool AllowDelete { get; }
        }
    }
}