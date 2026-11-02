namespace SFA.FCT.Contracts.AcceptanceTests.Pages
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Threading.Tasks;
    using AllocationDeliveryDomain.Common.Commands;
    using AllocationDeliveryDomain.Common.DataStore.Model;
    using Castle.Core.Internal;
    using CrossDomain.Integration.Common.Storage;
    using DTO;
    using Infrastructure.Repositories;
    using Infrastructure.Services;
    using Utilities;

    public class RetrieveSummarisedActualsPageObject
    {
        private const string StorageTableNamePrefix = "ReportedActualStub";

        private const string CollectionGroupStorageTableNamePrefix = "ReportedActualGroupStub";

        private const string StorageTableNamePrefixClient = "ReportedActual";
        private const string ClosedCollectionHistoryTableName = "ClosedCollectionHistory";
        private const string ClosedCollectionHistoryPartitionKey = "PK";
        private const string ActualAllocationGroupEntityTableName = "ActualAllocationGroupEntity";
        private const string ActualsCollectionTypeSummaryTableName = "ActualsCollectionTypeSummary";

        private const int WaitTillTableStorePopulatedInAzureIntervalSeconds = 60;
        private const int SleepIntervalSeconds = 2;
        private readonly string _storageTableName;
        private readonly string _collectionGroupStorageTableName;
        private readonly string _storageTableNameClient;
        private readonly string _closedCollectionHistoryTableName;
        private readonly string _actualAllocationGroupEntityTableName;
        private readonly string _actualsCollectionTypeSummaryTableName;
        private readonly AzureTableStore _azureTableStore = new AzureTableStore();
        private List<string> _clientRepositoryPartitionKeys = new List<string>();
        private IList<string> _stubCollectionGroups = new List<string>();
        private IList<string> _stubCollectionTypes = new List<string>();
        private IList<string> _stubCollectionGroupsWithUnderscore = new List<string>();
        private IEnumerable<ReportedActual> _reportedActualsAdded = new List<ReportedActual>();

        private int ExpectedStubRowCount { get; set; }

        public List<SummarisedActual> SummarisedActuals { get; set; }

        public RetrieveSummarisedActualsPageObject()
        {
            _storageTableName = StorageTableNamePrefix + ConfigurationManager.AppSettings["StorageTableSuffix"];
            _collectionGroupStorageTableName = CollectionGroupStorageTableNamePrefix + ConfigurationManager.AppSettings["StorageTableSuffix"];
            _storageTableNameClient = StorageTableNamePrefixClient + ConfigurationManager.AppSettings["StorageTableSuffix"]; //change to client table name once handler works
            _closedCollectionHistoryTableName = ClosedCollectionHistoryTableName + ConfigurationManager.AppSettings["StorageTableSuffix"];
            _actualAllocationGroupEntityTableName = ActualAllocationGroupEntityTableName + ConfigurationManager.AppSettings["StorageTableSuffix"];
            _actualsCollectionTypeSummaryTableName = ActualsCollectionTypeSummaryTableName + ConfigurationManager.AppSettings["StorageTableSuffix"];
            CreateStorageIfNotExists();
            SummarisedActuals = new List<SummarisedActual>();
        }

        public void StoreClosedCollectionActuals(IEnumerable<ReportedActual> reportedActuals)
        {
            ExpectedStubRowCount = reportedActuals.Count();
            AddPartitionKeys(reportedActuals);
            ClearStorage();
            InsertRowsIntoStubStorage(reportedActuals);
            _reportedActualsAdded = reportedActuals;
        }

        public void AddEmptyClosedCollectionToStubStorage(string collectionType, string collectionReturnCode)
        {
            ReportedActualGroup reportedActualGroup = new ReportedActualGroup
            {
                PartitionKey = collectionType,
                RowKey = collectionReturnCode,
                RowCount = 0
            };

            _azureTableStore.CreateRow(_collectionGroupStorageTableName, reportedActualGroup);
        }

        public void WaitTillReportedActualTablePopulated()
        {
            DateTime endTime = DateTime.UtcNow.AddSeconds(WaitTillTableStorePopulatedInAzureIntervalSeconds);

            do
            {
                SummarisedActuals = SummarisedActualRepository.GetAll().ToList();
                Task.Delay(TimeSpan.FromSeconds(SleepIntervalSeconds)).Wait();
            }
            while (SummarisedActuals.Count != ExpectedStubRowCount && (DateTime.UtcNow < endTime));
        }

        public void ClearStorage()
        {
            ClearStorage(true, true, true, true, true, true);
        }

        public void ClearStorage(
            bool clearReportedActualStub,
            bool clearReportedActualGroupStub,
            bool clearActualsCollectionTypeSummary,
            bool clearActualAllocationGroupEntity,
            bool clearClosedCollectionHistory,
            bool clearReportedActual)
        {
            _azureTableStore.CreateTableIfNotExists(_storageTableName);
            _azureTableStore.CreateTableIfNotExists(_collectionGroupStorageTableName);
            _azureTableStore.CreateTableIfNotExists(_actualAllocationGroupEntityTableName);

            AzureStorageRetryUtils azureStorageRetryUtils = new AzureStorageRetryUtils(_azureTableStore);

            if (clearReportedActualStub)
            {
                RemoveAllRowsFromDcfsStubTable();
                //_stubCollectionGroups.ForEach(cg => azureStorageRetryUtils.DeleteRowFromAzureTableWithRetries(_storageTableName, cg));
                _stubCollectionTypes.ToList().ForEach(ct =>
                {
                    //if (clearReportedActualGroupStub)
                    //{
                    //    azureStorageRetryUtils.DeleteRowFromAzureTableWithRetries(_collectionGroupStorageTableName, ct);
                    //}

                    if (clearActualsCollectionTypeSummary)
                    {
                        azureStorageRetryUtils.DeleteRowFromAzureTableWithRetries(_actualsCollectionTypeSummaryTableName, ct);
                    }
                });
                if (clearActualAllocationGroupEntity)
                {
                    _stubCollectionGroupsWithUnderscore.ToList().ForEach(ct => azureStorageRetryUtils.DeleteRowFromAzureTableWithRetries(_actualAllocationGroupEntityTableName, ct));
                }
            }

            _azureTableStore.CreateTableIfNotExists(_storageTableNameClient);
            if (clearReportedActual)
            {
                _clientRepositoryPartitionKeys.ForEach(pk => azureStorageRetryUtils.DeleteRowFromAzureTableWithRetries(_storageTableNameClient, pk));
            }

            _azureTableStore.CreateTableIfNotExists(_closedCollectionHistoryTableName);
            if (clearClosedCollectionHistory)
            {
                azureStorageRetryUtils.DeleteRowFromAzureTableWithRetries(_closedCollectionHistoryTableName, ClosedCollectionHistoryPartitionKey);
            }
        }

        public void RemoveAllRowsFromDcfsStubTable()
        {
            _azureTableStore.DeleteAllRows<ReportedActualGroup>(_collectionGroupStorageTableName);
            _azureTableStore.DeleteAllRows<ReportedActual>(_storageTableName);
        }

        public void StoreClosedCollectionActualsFromFile(string path)
        {
            var lines = System.IO.File.ReadAllLines(path);

            List<ReportedActual> actualsFromFile = new List<ReportedActual>();

            for (var i = 1; i < lines.Length; i++)
            {
                actualsFromFile.Add(ParseActual(lines[i]));
            }

            StoreClosedCollectionActuals(actualsFromFile);
        }

        private ReportedActual ParseActual(string line)
        {
            var splitLine = line.Split(',');

            return new ReportedActual
            {
                CollectionType = splitLine[0],
                CollectionReturnCode = splitLine[1],
                OrganisationId = splitLine[2],
                PeriodTypeCode = splitLine[3],
                Period = splitLine[4],
                FundingStreamPeriodCode = splitLine[5],
                ContractAllocationNumber = splitLine[6],
                UoPCode = splitLine[7],
                DeliverableCode = splitLine[8],
                ActualVolume = long.Parse(splitLine[9]),
                ActualValue = double.Parse(splitLine[10])
            };
        }

        private void AddPartitionKeys(IEnumerable<ReportedActual> reportedActuals)
        {
            AddClientStoragePartitionKeys(reportedActuals);

            _stubCollectionGroups = reportedActuals
                .Select(ra => ra.CollectionType + ra.CollectionReturnCode)
                .Distinct()
                .ToList();

            _stubCollectionTypes = reportedActuals
                .Select(ra => ra.CollectionType)
                .Distinct()
                .ToList();

            _stubCollectionGroupsWithUnderscore = reportedActuals
                .Select(ra => ra.CollectionType + "_" + ra.CollectionReturnCode)
                .Distinct()
                .ToList();
        }

        private void AddClientStoragePartitionKeys(IEnumerable<ReportedActual> reportedActuals)
        {
            if (_clientRepositoryPartitionKeys == null)
            {
                _clientRepositoryPartitionKeys = new List<string>();
            }

            _clientRepositoryPartitionKeys.Clear();

            _clientRepositoryPartitionKeys.AddRange(reportedActuals
                    .Select(ra => ra.EntityPartitionKey)
                    .Distinct()
                    .ToList());
        }

        private void CreateStorageIfNotExists()
        {
            _azureTableStore.CreateTableIfNotExists(_storageTableName);
            _azureTableStore.CreateTableIfNotExists(_actualsCollectionTypeSummaryTableName);
        }

        private void InsertRowsIntoStubStorage(IEnumerable<ReportedActual> reportedActuals)
        {

            var reportedActualsGrouped =
                reportedActuals
                    .GroupBy(ra => ra.CollectionType + ra.CollectionReturnCode);

            foreach (var reportedActualGroup in reportedActualsGrouped)
            {
                int rowKey = 0;
                string collectionType = string.Empty;
                string collectionReturnCode = string.Empty;

                _azureTableStore.CreateRows(_storageTableName, reportedActualGroup.Select(ra =>
                {
                    ra.PartitionKey = reportedActualGroup.Key;
                    ra.RowKey = (++rowKey).ToString("D8");

                    collectionType = ra.CollectionType;
                    collectionReturnCode = ra.CollectionReturnCode;

                    return ra;
                }));

                _azureTableStore.CreateRow(_collectionGroupStorageTableName,
                    new ReportedActualGroup
                    {
                        PartitionKey = collectionType,
                        RowKey = collectionReturnCode,
                        RowCount = rowKey
                    });
            }

        }

        private class AllocationDeliverablesInfo
        {
            public AllocationDeliverablesInfo(string allocationNumber, int numDeliverables)
            {
                AllocationNumber = allocationNumber;
                NumDeliverables = numDeliverables;
            }

            public string AllocationNumber { get; private set; }
             
            public int NumDeliverables { get; private set; }
        }
    }
}
