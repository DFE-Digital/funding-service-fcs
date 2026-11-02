namespace SFA.FCT.Contracts.AcceptanceTests.Pages
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.Text;
    using CrossDomain.Integration.Common.Storage;
    using Microsoft.Xrm.Sdk;
    using Xrm.TestFramework.Utils;
    using Aspose.Cells;
    using CrossDomain.Integration.Entities.Xrm;
    using DTO;
    using Microsoft.Xrm.Client;
    using FctFile = DocumentsDomain.Common.Models.FctFile;
    using Timer = System.Timers.Timer;
    using MoreLinq;
    using Extensions;
    using Infrastructure.Services;
    using OrganisationDomain.Implementation.DataAccess;
    using OrganisationDomain.Integration.DataStore;
    using Utilities;
    using Task = System.Threading.Tasks.Task;

    public sealed class ContractLoadPage :  IDisposable
    {
        private const string MasterContractHeirarchType = "229660001";
        private const string ContractHeirarchyType = "229660000";
        private const string HierarchyTypeKeyName = "sfa_hierarchytype";
        private const string ContractNumberKeyName = "sfa_number";

        public int MaxSecondsToWait { get; set; }

        public int SleepInterval { get; set; }

        public int IsSyntaxFileGeneratedAndIsSuccessInterval { get; set; }

        public int IsResultsReportFileGeneratedInterval { get; set; }

        public int WaitTillFileLevelErrorFileGeneratedInterval { get; set; }

        public int WaitTillResultsReportFileGeneratedInterval { get; set; }

        public int WaitTillPdfFileGeneratedInAzureInterval { get; set; }

        public int? NumberOfContractsToCreate { get; set; }

        public bool FileLevelErrorFileGenerated;

        private const string ReportFileExtensionName = ".Results Report.xlsx";
        private const string SummaryFileExtensionName = ".Syntax Report.txt";

        private readonly AcceptanceTestUtils _acceptanceTestUtils;
        private readonly IDictionary<string, int> _hierarchyTypeValues = new Dictionary<string, int>();
        private Timer _azureTimer;
        private string _copiedFilePath;

        private IList<Entity> _initialMatchingEntities;

        private IList<Entity> _newEntitiesList;
        private static int _waitForReplyResultCircuitBreakerCount = 0;

        private readonly IOrganizationService _crmOrganizationService;
        private readonly IOrganisationRepository _organisationRepository;

        private IList<Entity> NewEntities
        {
            get
            {
                if (_newEntitiesList == null)
                {
                    GetNewEntities();
                }
                return _newEntitiesList;
            }
            set { _newEntitiesList = value; }
        }

        private IList<object> _ukprns;

        public IList<object> Ukprns
        {
            get
            {
                if (_ukprns == null)
                {
                    _ukprns = new List<object>();
                }
                return _ukprns;
            }

            set { _ukprns = value; }
        }

        private Workbook _resultsReportWorkbook;

        private string _ukPrn;

        public List<string> ContractNumbersFromFile { get; } = new List<string>();

        public List<string> AllocationNumbersFromFile { get; } = new List<string>();

        public DateTime DateStarted { get; set; }

        public TimeSpan TestDuration { get; set; }

        public DateTime DateCompleted => DateStarted.Add(TestDuration);

        public ContractLoadPage()
        {
            _acceptanceTestUtils = new AcceptanceTestUtils("Ben"); // TODO
            DateStarted = DateTime.Now;

            MaxSecondsToWait = 600;
            SleepInterval = 5;
            IsSyntaxFileGeneratedAndIsSuccessInterval = 360;
            IsResultsReportFileGeneratedInterval = 420;
            WaitTillFileLevelErrorFileGeneratedInterval = 360;
            WaitTillResultsReportFileGeneratedInterval = 360;
            WaitTillPdfFileGeneratedInAzureInterval = 360;
            if (string.IsNullOrWhiteSpace(UseAzureStorageBulkUpload))
            {
                UseAzureStorageBulkUpload = ConfigurationManager.AppSettings["UseAzureStorageBulkUpload"];
                DropFolder = UseAzureStorageBulkUpload == "true" ? ConfigurationManager.AppSettings["BulkUploadFolder"] : ConfigurationManager.AppSettings["Office365BulkUploadFolder"];
                OutputFolder = UseAzureStorageBulkUpload == "true" ? ConfigurationManager.AppSettings["BulkUploadOutputFolder"] : ConfigurationManager.AppSettings["Office365BulkUploadOutputFolder"];
            }

            _crmOrganizationService = CrmConnectionFactory.GetConnection();
            _organisationRepository = new OrganisationRepository { OrganisationDomainDbContext = new OrganisationDomainDbContext() };
        }

        public void Dispose()
        {
            Dispose(true);
        }

        private void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (_azureTimer != null)
                {
                    _azureTimer.Dispose();
                }
            }
        }

        public string InputFilePath { get; set; }

        public bool ResultsReportFileGenerated { get; set; }

        public string DropFolder { get; set; }

        public string OutputFolder { get; set; }

        public bool IsDataInCrm { get; set; }

        public bool IsPdfFileInStorage { get; set; }

        public string UseAzureStorageBulkUpload { get; set; }

        public void Initialize()
        {
            DateStarted = DateTime.Now;
        }

        public void DeleteFilesWithPrefixInFolder(string fileNamePrefix, string folderName)
        {
            IOffice365Adapter storageAdapter = GetDataStoreInstance();
            IList<string> fileNames = storageAdapter.GetFilenamesByFileNameStartText(libraryName: folderName, fileNameStartText: fileNamePrefix);
            fileNames.ForEach(f => storageAdapter.DeleteFile(fileName: f, listName: folderName));
        }

        public bool AreCorrectNumberOfFilesWithPrefixInFolder(int expectedFileCount, string fileNamePrefix, string folderName, Func<string, bool> doesFileNameMatch)
        {
            CheckResultPoller checkResultPoller = new CheckResultPoller(
                checkResult: () =>
                {
                    IOffice365Adapter storageAdapter = GetDataStoreInstance();
                    IList<string> fileNames = storageAdapter.GetFilenamesByFileNameStartText(libraryName: folderName, fileNameStartText: fileNamePrefix);
                    return fileNames.Count(doesFileNameMatch) == expectedFileCount;
                },
                maxNumChecks: 10,
                waitIntervalSeconds: 3);

            return checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();
        }

        public void InitializeUkprnList(IList<object> ukprns)
        {
            DateStarted = DateTime.Now;
            if (ukprns != null && ukprns.Count > 0)
            {
                Ukprns = ukprns;
                _initialMatchingEntities = _acceptanceTestUtils.GetContractsInCrmForUkPrns(Ukprns, false);
            }
        }

        public void CopyFile()
        {
            var originalFileName = Path.GetFileName(InputFilePath);
            var uniqueFileName = originalFileName.Insert(originalFileName.LastIndexOf("."), DateTime.Now.Ticks.ToString());
            var fileContents = FileToByteArray(InputFilePath);

            // MMA 
            if (this.UseAzureStorageBulkUpload == "true")
            {
                AzureStorageWrapper.PutBlockBlob(new CrossDomain.Integration.Common.Storage.FctFile(DropFolder, uniqueFileName), fileContents);
            }
            else
            {
                GetDataStoreInstance().UploadFile(uniqueFileName, fileContents, DropFolder);
            }

            _copiedFilePath = uniqueFileName;
        }
        
        
        public void CopyFileWithTransformedFeatureVariables()
        {
            string originalFileName = Path.GetFileName(InputFilePath);
            string uniqueFileName = originalFileName.Insert(originalFileName.LastIndexOf(".", StringComparison.Ordinal), DateTime.Now.Ticks.ToString());

            Workbook workbook = new Workbook(InputFilePath);
            workbook.TransformFeatureVariables();
            
            MemoryStream memoryStream = new MemoryStream();
            workbook.Save(memoryStream, (SaveFormat)workbook.FileFormat);

            byte[] fileContents = memoryStream.ToArray();

            new Office365StorageWrapper().UploadFile(uniqueFileName, fileContents, DropFolder);

            _copiedFilePath = uniqueFileName;
        }

        public void CopyNonRenamedResourceFileIntoFolder(string localResourceFileName, string localResourceFolder, string destinationSharePointFolder)
        {
            IOffice365Adapter office365Adapter = GetDataStoreInstance();
            byte[] fileContents = FileToByteArray(Path.Combine(localResourceFolder, localResourceFileName));

            office365Adapter.UploadFile(localResourceFileName, fileContents, destinationSharePointFolder);
        }

        public IList<Entity> GetCreatedEntities()
        {
            if (NewEntities == null)
            {
                GetNewEntities();
            }

            return NewEntities;
        }

        public IEnumerable<Entity> GetCreatedMasterContracts()
        {
            return
                NewEntities.Where(
                    x =>
                        x.GetAttributeValue<OptionSetValue>(HierarchyTypeKeyName).Value.ToString() ==
                        MasterContractHeirarchType);
        }

        public IEnumerable<Entity> GetCreatedContracts()
        {
            return
                NewEntities.Where(
                    x =>
                        x.GetAttributeValue<OptionSetValue>(HierarchyTypeKeyName).Value.ToString() !=
                        MasterContractHeirarchType);
        }

        public void CircuitBreakerCheck()
        {
            if (_waitForReplyResultCircuitBreakerCount > 5)
            {
                throw new Exception("Circuit Breaker tripped - Issue with Filewatcher.");
            }
        }

        public bool IsSyntaxFileGeneratedAndIsSuccess()
        {
            CircuitBreakerCheck();
            // Wait up to 60 seconds
            DateTime endDateTime = DateTime.Now.Add(TimeSpan.FromSeconds(IsSyntaxFileGeneratedAndIsSuccessInterval));
            var reportFile = new CrossDomain.Integration.Common.Storage.FctFile(OutputFolder, _copiedFilePath + SummaryFileExtensionName);
            var originalFile = new CrossDomain.Integration.Common.Storage.FctFile(OutputFolder, _copiedFilePath);

            // MMA
            do
            {
                if (this.UseAzureStorageBulkUpload == "true")
                {
                    if (AzureStorageWrapper.DoesBlockBlobExist(reportFile))
                    {
                        _azureTimer = new Timer
                        {
                            Interval = SleepInterval
                        };
                        _azureTimer.Start();
                        _waitForReplyResultCircuitBreakerCount = 0;
                        return true;
                    }
                }
                else
                {
                    var offwrapper = GetDataStoreInstance();
                    if (offwrapper.DoesFileExist(OutputFolder, reportFile.Filename))
                    {
                        var data = GetDataStoreInstance().GetFileContents(reportFile.Filename, OutputFolder);

                        var output = Encoding.UTF8.GetString(data, 0, data.Length);

                        _azureTimer = new Timer
                        {
                            Interval = SleepInterval
                        };
                        _azureTimer.Start();
                        return output.Contains(originalFile.Filename + " Success");
                    }
                }

                Task.Delay(TimeSpan.FromSeconds(SleepInterval)).Wait();
            } while ((DateTime.Now < endDateTime) && IsTestToContinue());

            _waitForReplyResultCircuitBreakerCount++;
            return false;
        }

        public bool IsResultsReportFileGenerated()
        {
            DateTime endDateTime = DateTime.Now.Add(TimeSpan.FromSeconds(IsResultsReportFileGeneratedInterval));
            var reportFile = new CrossDomain.Integration.Common.Storage.FctFile(OutputFolder, _copiedFilePath + ReportFileExtensionName);

            // MMA
            do
            {
                Task.Delay(TimeSpan.FromSeconds(SleepInterval)).Wait();

                if (this.UseAzureStorageBulkUpload == "true")
                {
                    ResultsReportFileGenerated = AzureStorageWrapper.DoesBlockBlobExist(reportFile);
                }
                else
                {
                    var offwrapper = GetDataStoreInstance();
                    ResultsReportFileGenerated = offwrapper.DoesFileExist(OutputFolder, reportFile.Filename);
                }

            } while (!ResultsReportFileGenerated && (DateTime.Now < endDateTime) && IsTestToContinue());

            return ResultsReportFileGenerated;
        }

        public void WaitTillFileLevelErrorFileGenerated()
        {
            var reportFile = new CrossDomain.Integration.Common.Storage.FctFile(OutputFolder, _copiedFilePath + SummaryFileExtensionName);

            DateTime endDateTime = DateTime.Now.Add(TimeSpan.FromSeconds(WaitTillFileLevelErrorFileGeneratedInterval));

            do
            {
                if (this.UseAzureStorageBulkUpload == "true")
                {
                    FileLevelErrorFileGenerated = AzureStorageWrapper.DoesBlockBlobExist(reportFile);
                }
                else
                {
                    FileLevelErrorFileGenerated = DoesSyntaxFileWithNameStartTextExist(OutputFolder, _copiedFilePath);
                }

                if (FileLevelErrorFileGenerated == false)
                {
                    Task.Delay(TimeSpan.FromSeconds(SleepInterval)).Wait();
                }

                //TODO: looks like 2 seperate timeout mechanisms

            } while (!FileLevelErrorFileGenerated && (DateTime.Now < endDateTime) && IsTestToContinue());
        }

        private bool DoesSyntaxFileWithNameStartTextExist(string folderName, string nameStartText)
        {
            return GetDataStoreInstance().GetFilenamesByFileNameStartText(folderName, nameStartText).Any(x => x.Contains(SummaryFileExtensionName));
        }

        public void WaitTillResultsReportFileGenerated()
        {
            var reportFile = new CrossDomain.Integration.Common.Storage.FctFile(OutputFolder, _copiedFilePath + ReportFileExtensionName);

            DateTime endDateTime = DateTime.Now.Add(TimeSpan.FromSeconds(WaitTillResultsReportFileGeneratedInterval));

            do
            {
                if (this.UseAzureStorageBulkUpload == "true")
                {
                    ResultsReportFileGenerated = AzureStorageWrapper.DoesBlockBlobExist(reportFile);
                }
                else
                {
                    ResultsReportFileGenerated = GetDataStoreInstance().DoesFileExist(OutputFolder, reportFile.Filename);
                }

                if (!ResultsReportFileGenerated)
                {
                    Task.Delay(TimeSpan.FromSeconds(SleepInterval)).Wait();
                }
            } while (!ResultsReportFileGenerated && (DateTime.Now < endDateTime) && IsTestToContinue());

            if (_azureTimer != null)
                _azureTimer.Stop();
        }

        public void WaitTillFileGeneratedInSharepoint(string folderName, string fileName)
        {
            DateTime endDateTime = DateTime.Now.Add(TimeSpan.FromSeconds(WaitTillResultsReportFileGeneratedInterval));
            bool fileGenerated = false;
            do
            {
                fileGenerated = GetDataStoreInstance().DoesFileExist(folderName, fileName);
                
                if (!fileGenerated)
                {
                    Task.Delay(TimeSpan.FromSeconds(SleepInterval)).Wait();
                }
            } while (!fileGenerated && (DateTime.Now < endDateTime) && IsTestToContinue());
        }

        public Workbook GetSpreadsheetFileFromSharepoint(string folderName, string fileName)
        {
            var fileContents = GetDataStoreInstance().GetFileContents(fileName, folderName);
            Stream stream = new MemoryStream(fileContents);
            
            return new Workbook(stream);
        }

        public bool isTheReportGeneratedInTime(int time)
        {
            if (_azureTimer != null)
            {
                if (_azureTimer.Interval <= time)
                {
                    return true;
                }
            }
            return false;
        }

        public bool CheckFileLevelReport(string errormessage)
        {
            var reportFile = new CrossDomain.Integration.Common.Storage.FctFile(
                   OutputFolder,
                   _copiedFilePath + SummaryFileExtensionName);

            // MMA
            if (this.UseAzureStorageBulkUpload == "true")
            {
                if (AzureStorageWrapper.DoesBlockBlobExist(reportFile))
                {
                    var fileContents = AzureStorageWrapper.GetBlockBlobContentsAsString(reportFile);
                    return fileContents.IndexOf(errormessage, StringComparison.InvariantCultureIgnoreCase) >= 0;
                }
            }
            else
            {
                var offwrapper = GetDataStoreInstance();
                var data = offwrapper.GetFilesByFileNameStartText(OutputFolder, _copiedFilePath).Single(file => file.Key.Contains(SummaryFileExtensionName)).Value;
                var fileContents = Encoding.UTF8.GetString(data, 0, data.Length);

                return fileContents.IndexOf(errormessage, StringComparison.InvariantCultureIgnoreCase) >= 0;
            }
            return false;
        }

        public void CacheResultsReport()
        {
            // MMA
            var reportFile = new CrossDomain.Integration.Common.Storage.FctFile(
                    OutputFolder,
                    _copiedFilePath + ReportFileExtensionName);

            if (this.UseAzureStorageBulkUpload == "true")
            {
                if (AzureStorageWrapper.DoesBlockBlobExist(reportFile))
                {
                    var fileContents = AzureStorageWrapper.GetBlockBlobContents(reportFile);
                    Stream stream = new MemoryStream(fileContents);
                    _resultsReportWorkbook = new Workbook(stream);
                }
            }
            else
            {
                var offwrapper = GetDataStoreInstance();

                if (offwrapper.DoesFileExist(OutputFolder, reportFile.Filename))
                {
                    var fileContents = offwrapper.GetFileContents(reportFile.Filename, OutputFolder);
                    Stream stream = new MemoryStream(fileContents);
                    _resultsReportWorkbook = new Workbook(stream);
                }
            }
        }

        public string GetCellValueFromResultsReport(string workbookSheet, string cellAddress, bool useCachedValue = true)
        {
            if (_resultsReportWorkbook == null || useCachedValue == false)
            {
                CacheResultsReport();
            }

            if (_resultsReportWorkbook != null)
            {
                Worksheet ws = _resultsReportWorkbook.Worksheets[workbookSheet];
                Cell cell = ws.Cells[cellAddress];

                return cell.DisplayStringValue;
            }

            return null;
        }

        public string GetCellValueByColumnNameFromResultsReport(string workbookSheet, int rowNumber, string columnName)
        {
            if (_resultsReportWorkbook == null)
            {
                CacheResultsReport();
            }

            if (_resultsReportWorkbook != null)
            {
                Worksheet ws = _resultsReportWorkbook.Worksheets[workbookSheet];
                Row row = ws.Cells.Rows[rowNumber - 1];
                Cell headingCell = ws.Cells.Find(columnName, null, new FindOptions
                {
                    CaseSensitive = true,
                    LookAtType = LookAtType.EntireContent,
                    LookInType = LookInType.Values
                });
                Cell dataCell = row[headingCell.Column];

                return dataCell.DisplayStringValue;
            }

            return null;
        }

        public bool ContractHeadersMatch(List<SimpleContractHeader> simpleContractHeaders)
        {
            foreach (var contract in simpleContractHeaders)
            {
                IEnumerable<Entity> contractEntities =
                    _acceptanceTestUtils.GetContractsForContractNumber(contract.ContractNumber);
                var latestContractEntity =
                    contractEntities.OrderByDescending(x => (int)x.GetAttributeValue("sfa_version")).ThenByDescending(y => (int)y.GetAttributeValue("sfa_subversion"))
                        .FirstOrDefault(x => x.GetAttributeValue<OptionSetValue>("sfa_hierarchytype").Value == GetHierarchyTypeValue("Contract"));

                if (contract.ContractNumber != latestContractEntity.GetAttributeValue("sfa_number").ToString() ||
                    contract.ContractVersionNumber != int.Parse(latestContractEntity.GetAttributeValue("sfa_version").ToString()) ||
                    contract.ContractPeriod != int.Parse(_acceptanceTestUtils.GetPeriodInfo(latestContractEntity).Peiod) ||
                    contract.MasterContractNumber != _acceptanceTestUtils.GetMasterContractNumberFromContract(latestContractEntity) ||
                    contract.ContractType != _acceptanceTestUtils.GetContractType(latestContractEntity) ||
                    contract.ContractStartDate != DateTime.Parse(latestContractEntity.GetAttributeValue("sfa_startdate").ToString()).Date ||
                    contract.ContractEndDate != DateTime.Parse(latestContractEntity.GetAttributeValue("sfa_enddate").ToString()).Date ||
                    contract.ContractValue != ((Money)latestContractEntity.GetAttributeValue("sfa_contractvalue")).Value)
                {
                    return false;
                }

            }
            return true;
        }

        public List<Entity> GetCrmAllocationsFromLatestContract(string contractNumber)
        {
            Entity contract = null;           

            IEnumerable<Entity> contractEntities =
                _acceptanceTestUtils.GetContractsForContractNumber(contractNumber);
            contract =
                contractEntities.OrderByDescending(x => (int)x.GetAttributeValue("sfa_version")).ThenByDescending(y => (int)y.GetAttributeValue("sfa_subversion"))
                    .FirstOrDefault(
                        x =>
                            x.GetAttributeValue<OptionSetValue>("sfa_hierarchytype").Value ==
                            GetHierarchyTypeValue("Contract"));
            return _acceptanceTestUtils.GetAllocationsForContract(contract);

        }

        public bool ContractDeliverablePeriodsMatch(List<SimpleContractDeliverable> simpleContractDeliverables)
        {
            Entity allocation = null;
            List<Entity> deliverables = null;

            foreach (SimpleContractDeliverable simpleContractDeliverable in simpleContractDeliverables)
            {
                if (allocation == null || allocation.GetAttributeValue("sfa_contractallocationnumber").ToString() != simpleContractDeliverable.AllocationReference)
                {
                    allocation = GetCrmAllocationsFromLatestContract(simpleContractDeliverable.ContractNumber).First(m => m.GetAttributeValue("sfa_contractallocationnumber").ToString() == simpleContractDeliverable.AllocationReference);
                    if (allocation == null)
                        return false;

                    // Get deliverables
                    deliverables = _acceptanceTestUtils.GetDeliverablesForAllocation(allocation);
                    if (deliverables == null)
                        return false;
                }

                // Get matching deliverable periods
                List<Entity> deliverablePeriods = _acceptanceTestUtils.GetAggregatePeriodsForContractDeliverable(deliverables.FirstOrDefault(m => m.GetAttributeValue("sfa_deliverablecode").ToString() == simpleContractDeliverable.DeliverableCode));
                if (deliverablePeriods == null)
                    return false;

                foreach (SimpleContractDeliverablePeriod simpleContractDeliverablePeriod in simpleContractDeliverable.Periods)
                {
                    if (simpleContractDeliverablePeriod.PlannedValue != deliverablePeriods.FirstOrDefault(m => m.GetAttributeValue("sfa_periodname").ToString() == simpleContractDeliverablePeriod.Name).GetAttributeValue<decimal>("sfa_plannedvalue"))
                    {
                        return false;
                    }
                }
            }

            return true;
        }

        public bool ContractDeliverablePeriodsVolumesMatch(List<SimpleContractDeliverable> simpleContractDeliverables)
        {
            Entity allocation = null;
            List<Entity> deliverables = null;

            foreach (SimpleContractDeliverable simpleContractDeliverable in simpleContractDeliverables)
            {
                if (allocation == null || allocation.GetAttributeValue("sfa_contractallocationnumber").ToString() != simpleContractDeliverable.AllocationReference)
                {
                    allocation = GetCrmAllocationsFromLatestContract(simpleContractDeliverable.ContractNumber).First(m => m.GetAttributeValue("sfa_contractallocationnumber").ToString() == simpleContractDeliverable.AllocationReference);
                    if (allocation == null)
                        return false;

                    // Get deliverables
                    deliverables = _acceptanceTestUtils.GetDeliverablesForAllocation(allocation);
                    if (deliverables == null)
                        return false;
                }

                // Get matching deliverable periods
                List<Entity> deliverablePeriods = _acceptanceTestUtils.GetAggregatePeriodsForContractDeliverable(deliverables.FirstOrDefault(m => m.GetAttributeValue("sfa_deliverablecode").ToString() == simpleContractDeliverable.DeliverableCode));
                if (deliverablePeriods == null)
                    return false;

                foreach (SimpleContractDeliverablePeriod simpleContractDeliverablePeriod in simpleContractDeliverable.Periods)
                {
                    if (simpleContractDeliverablePeriod.PlannedVolume != deliverablePeriods.FirstOrDefault(m => m.GetAttributeValue("sfa_periodname").ToString() == simpleContractDeliverablePeriod.Name).GetAttributeValue<int>("sfa_plannedvolume"))
                    {
                        return false;
                    }
                }
            }

            return true;
        }

        public bool ContractDeliverableMatch(List<SimpleContractDeliverable> simpleContractDeliverables)
        {
            List<Entity> deliverables = null;

            string allocationReference = null;
            foreach (SimpleContractDeliverable simpleContractDeliverable in simpleContractDeliverables)
            {
                if (allocationReference == null || allocationReference != simpleContractDeliverable.AllocationReference)
                {

                    Entity allocation = GetCrmAllocationsFromLatestContract(simpleContractDeliverable.ContractNumber).
                        FirstOrDefault(m => m.GetAttributeValue("sfa_contractallocationnumber").ToString() == simpleContractDeliverable.AllocationReference);

                    if (allocation == null)
                        return false;

                    deliverables = _acceptanceTestUtils.GetDeliverablesForAllocation(allocation);
                }

                Entity matchingDeliverable = deliverables.First(m => m.GetAttributeStringValue("sfa_deliverablecode") == simpleContractDeliverable.DeliverableCode);

                if (simpleContractDeliverable.Description != matchingDeliverable.GetAttributeStringValue("sfa_deliverabledescription") ||
                    simpleContractDeliverable.Name != matchingDeliverable.GetAttributeStringValue("sfa_deliverablename"))
                {
                    return false;
                }

            }

            return true;
        }

        private void StartPollingAzureDocStorage(string location)
        {
            _azureTimer = new Timer
            {
                Interval = SleepInterval
            };

            _azureTimer.Elapsed += delegate { CheckIsPdfFileInStorage(location); };
            _azureTimer.Start();
        }

        private void StopPollingAzureDocStorage()
        {
            if (_azureTimer != null)
            {
                _azureTimer.Stop();
                _azureTimer = null;
            }
        }

        public void WaitTillPdfFileGeneratedInAzure(string location)
        {
            StartPollingAzureDocStorage(location);

            DateTime endDateTime = DateTime.Now.Add(TimeSpan.FromSeconds(WaitTillPdfFileGeneratedInAzureInterval));

            while (!IsPdfFileInStorage && (DateTime.Now < endDateTime) && IsTestToContinue())
            {
                Task.Delay(TimeSpan.FromSeconds(SleepInterval)).Wait();
            }

            StopPollingAzureDocStorage();
        }

        public int GetCountOfContractsInCrmForUkPrns(IList<object> ukprns)
        {
            int count = 0;
            if (ukprns.Count > 0)
            {
                List<Entity> list = _acceptanceTestUtils.GetContractsInCrmForUkPrns(ukprns, false);
                count = list.Count();
            }
            return count;
        }

        public void DeleteContracts()
        {
            if (NewEntities != null && NewEntities.Count > 0)
            {
                // first we want to delete the contracts
                var contracts = GetCreatedContracts();
                foreach (var contract in contracts)
                {
                    _acceptanceTestUtils.Delete(contract);
                }

                // then delete the masters
                var masterContracts = GetCreatedMasterContracts();
                foreach (var contract in masterContracts)
                {
                    _acceptanceTestUtils.Delete(contract);
                }
            }
        }

        public int GetLatestVersionForContract(string contractNumber)
        {
            IReadOnlyCollection<Entity> contracts = _acceptanceTestUtils.GetContractsInCrm(contractNumber);
            return contracts.Max(c => c.GetAttributeValue<int>("sfa_version"));
        }

        public void DeleteContractsWithThisUkprn(string ukrpn)
        {
            _acceptanceTestUtils.GetContractsForUKPRN(ukrpn).ForEach(_acceptanceTestUtils.Delete);
            _acceptanceTestUtils.GetMasterContractsForUKPRN(ukrpn).ForEach(_acceptanceTestUtils.Delete);
        }

        public bool DoesNewEntityListContainAllRequiredUkprns()
        {
            bool listContainsAllUkprns = false;

            if (NewEntities != null && NewEntities.Count > 0)
            {
                // first find out how many new Ukprns there are
                int numNewUkPrns = NewEntities.Select(e => e.GetAttributeValue<string>("sfa_ukprn")).Distinct().Count();

                // now check that that the number of new ones matches the number of ukprns we expect data for
                listContainsAllUkprns = numNewUkPrns == Ukprns.Count();
            }

            return listContainsAllUkprns;
        }

        public void UpdateContractStatus(string contractNumber, string contractStatus, string contractSubStatus)
        {
            var contract = XrmService.Configuration.Entity("Contract");
            var substatus = XrmService.Configuration.Entity("Status");

            var substatusId = XrmService.Connection.GetRecord(substatus, contractSubStatus);

            // Get Contract and modify the required fields
            var contractRecord = XrmService.Connection
                .GetRecord(contract, contractNumber);

            var contractId = contractRecord.Entity.Id;

            var contractToUpdate = XrmService.Connection
                .SetRecord(contract, contractNumber)
                .SetField("Contract Status", contractStatus)
                .SetLookupField(substatus, "Sub Status", substatusId);

            contractToUpdate.Entity.Id = contractId;
            contractToUpdate.Update();
        }

        public string GetUpinForCrmOrganisationWithUkprn(string ukprn)
        {
            using (var xrmContext = new XrmServiceContext(_crmOrganizationService))
            {
                return xrmContext.AccountSet.FirstOrDefault(a => a.sfa_UKPRN == ukprn)?.sfa_orgupin;
            }
        }

        public int? GetUpinForOrgServiceProviderWithUkprn(int ukprn)
        {
            return _organisationRepository.GetDetailByUkprn(ukprn)?.Upin;
        }

        private IOffice365Adapter GetDataStoreInstance()
        {
            return new Office365StorageWrapper();
        }

        private bool IsTestToContinue()
        {
            if (DateStarted.Add(TimeSpan.FromSeconds(MaxSecondsToWait)) > DateTime.Now)
            {
                return true;
            }
            throw new Exception("MaxSecondsToWait exceeded (" + MaxSecondsToWait + ")");
        }

        private void CheckIsPdfFileInStorage(string location)
        {
            if (_azureTimer != null)
            {
                _azureTimer.Stop();
            }

            if (NewEntities == null || NewEntities.Count > 0)
            {
                GetNewEntities();
            }

            var file = GetPdfFileName();

            var azureStorageWrapper = new DocumentsDomain.Integration.AzureStorageWrapper();

            if (this.UseAzureStorageBulkUpload == "true")
            {
                IsPdfFileInStorage = azureStorageWrapper.DoesBlockBlobExist(file);
            }
            else
            {
                IsPdfFileInStorage = GetDataStoreInstance().DoesFileExist(location, file.Filename);
            }

            if ((!IsPdfFileInStorage) && (_azureTimer != null))
            {
                _azureTimer.Start();
            }
        }

        private static byte[] FileToByteArray(string filepath)
        {
            using (var fs = new FileStream(filepath, FileMode.Open, FileAccess.Read))
            {
                var br = new BinaryReader(fs);
                var numBytes = new FileInfo(filepath).Length;
                return br.ReadBytes((int)numBytes);
            }
        }

        private void GetNewEntities()
        {
            if (Ukprns != null && Ukprns.Count > 0)
            {
                _newEntitiesList = _acceptanceTestUtils.GetContractsInCrmForUkPrnsNotMatchingEntities(
                    Ukprns,
                    false,
                    _initialMatchingEntities);
                if (DoesNewEntityListContainAllRequiredUkprns())
                {
                    IsDataInCrm = true;
                }
            }
        }

        private int GetHierarchyTypeValue(string label)
        {
            if (!_hierarchyTypeValues.ContainsKey(label))
            {
                // look it up
                var value = _acceptanceTestUtils.GetOptionsetValue("sfa_contracthierarchytype", label);
                if (value.HasValue)
                {
                    _hierarchyTypeValues[label] = value.Value;
                }
                else
                {
                    throw new Exception(string.Format("Hierarchy Type does not contain label {0}", label));
                }
            }

            return _hierarchyTypeValues[label];
        }

        private FctFile GetPdfFileName()
        {
            return new FctFile
            {
                FileContainer = ConfigurationManager.AppSettings["DocumentGeneration.TargetContainer"],
                Filename = GenerateFilename()
            };
        }

        private string GenerateFilename()
        {
            var fileName = string.Empty;
            var contractEntity =
                NewEntities.FirstOrDefault(
                    e =>
                        e.GetAttributeValue<OptionSetValue>(HierarchyTypeKeyName)
                            .Value.ToString()
                            .Equals(ContractHeirarchyType));
            if (contractEntity != null)
            {
                fileName = contractEntity.GetAttributeValue<string>(SheetCrmMapping.UkPrnAttributeKeyName) +
                           "_" +
                           contractEntity.GetAttributeValue<string>(ContractNumberKeyName)
                           + "_v1.pdf";

                _ukPrn = contractEntity.GetAttributeValue<string>(SheetCrmMapping.UkPrnAttributeKeyName);
            }

            return fileName;
        }

        public void DeleteContractsInCrmUsingContractNumbersOnSpreadsheet()
        {
            const string contractNumberColumn = "B";
            const string masterContractNumberColumn = "E";
            string masterContractNumberCellValue = string.Empty;
            string contractNumberCellValue = string.Empty;
            int rowIndex = 2;
            do
            {
                string masterContractNumberCellAddress = masterContractNumberColumn + rowIndex;
                string contractNumberCellAddress = contractNumberColumn + rowIndex;
                masterContractNumberCellValue = GetCellValueFromResultsReport(SheetCrmMapping.ContractSheetName, masterContractNumberCellAddress);
                contractNumberCellValue = GetCellValueFromResultsReport(SheetCrmMapping.ContractSheetName, contractNumberCellAddress);

                if (!string.IsNullOrEmpty(contractNumberCellValue))
                {
                    DeleteContractWithNumber(contractNumberCellValue);
                }
                if (!string.IsNullOrEmpty(masterContractNumberCellValue))
                {
                    DeleteContractWithNumber(masterContractNumberCellValue);
                }

                rowIndex++;
            } while (!string.IsNullOrEmpty(masterContractNumberCellValue));

        }

        public bool HaveAllContractsOnSpreadsheetBeenLoadedSuccessfully()
        {
            const string resultColumn = "J";
            string result = string.Empty;
            int numSuccessfulContracts = 0;
            int rowIndex = 2;
            do
            {
                var resultCellAddress = resultColumn + rowIndex;

                if (GetCellValueFromResultsReport(SheetCrmMapping.ContractSheetName, resultCellAddress) == "Success")
                {
                    numSuccessfulContracts++;
                }

                rowIndex++;
            } while (!string.IsNullOrEmpty(result));

            return numSuccessfulContracts == (rowIndex - 2);
        }

        private void DeleteContractWithNumber(string contractNumber)
        {
            var contractEntities = _acceptanceTestUtils.GetContractsForContractNumber(contractNumber);
            foreach (var contractEntity in contractEntities)
            {
                _acceptanceTestUtils.Delete(contractEntity);
            }
        }
        
        public void DeleteContractWithPartUKPRNNumber(string partukprn)
        {
            IEnumerable<Entity> contractEntities = _acceptanceTestUtils.GetContractsForUKPRN(partukprn).ToList();

            foreach (var contractEntity in contractEntities)
            {
                _acceptanceTestUtils.Delete(contractEntity);
            }
            contractEntities = _acceptanceTestUtils.GetMasterContractsForUKPRN(partukprn);
            foreach (var contractEntity in contractEntities)
            {
                _acceptanceTestUtils.Delete(contractEntity);
            }
        }

        public void ClearResultsReportsCache()
        {
            _resultsReportWorkbook = null;
        }
    }
}