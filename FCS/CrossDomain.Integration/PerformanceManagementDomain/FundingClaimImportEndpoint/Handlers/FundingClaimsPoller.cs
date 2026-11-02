namespace SFA.FCT.PerformanceManagementDomain.FundingClaimImportEndpoint.Handlers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Common.Serializers;
    using CrossDomain.Integration.Messages.Commands;
    using DataStore.Models;
    using DataStore.Repositories;
    using Framework.Logging.Interfaces;
    using NServiceBus;
    using Services;
    using CorporateSchema = CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.CorporateSchema._3_0;
    using Common.Commands;
    using Common.Logging;

    public class FundingClaimsPoller :
        IHandleMessages<InitiateFundingClaimImportCommand>,
        IHandleMessages<ClosedFundingClaimCollectionCommand>,
        IHandleMessages<FundingClaimPagedRequestCommand>
    {
        private readonly IFundingClaimDedsService _fundingClaimDedsService;
        private readonly ILogger _logger;
        private readonly IFundingClaimRepository _fundingClaimRepository;
        private readonly int _pageSize;
        private readonly IFundingClaimCollectionImportInfoRepository _fundingClaimCollectionImportInfoRepository;
        private readonly IClaimReconciliationBehaviourRepository _claimReconciliationBehaviourRepository;
        private readonly IDate _date;
        private readonly IFundingClaimAllocationFilter _fundingClaimAllocationFilter;

        public FundingClaimsPoller(
            ILogger logger,
            IFundingClaimRepository fundingClaimRepository,
            IFundingClaimDedsService fundingClaimDedsService,
            IFundingClaimCollectionImportInfoRepository fundingClaimCollectionImportInfoRepository,
            IClaimReconciliationBehaviourRepository claimReconciliationBehaviourRepository,
            IDate date,
            IFundingClaimAllocationFilter fundingClaimAllocationFilter)
        {
            _logger = logger;
            _fundingClaimRepository = fundingClaimRepository;
            _fundingClaimDedsService = fundingClaimDedsService;
            _fundingClaimCollectionImportInfoRepository = fundingClaimCollectionImportInfoRepository;
            _claimReconciliationBehaviourRepository = claimReconciliationBehaviourRepository;
            _date = date;
            _fundingClaimAllocationFilter = fundingClaimAllocationFilter;
            _pageSize = 100;
        }

        public async Task Handle(InitiateFundingClaimImportCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                PerformanceManagementLoggingId.FundingClaimPollingPollClosedCollectionsCommandArrived,
                $"Funding Claims Import {nameof(InitiateFundingClaimImportCommand)} arrived," +
                $" starting DEDS import process with values DcfsFundingClaimsRetrievalPageSize: {_pageSize}");

            DateTime lastClosedCollectionTime = GetLastClosedCollectionTime();

            _logger.LogInformation(
                PerformanceManagementLoggingId.FundingClaimPollingUsingLastClosedCollectionTime,
                $"Determined last closed collection time of {lastClosedCollectionTime}");

            Guid dataSetVersionId = _fundingClaimDedsService.GetLatestPublishedDataSetVersionId();

            IEnumerable<string> closedFundingClaimCollections = _fundingClaimDedsService.GetFundingClaimCompletedCollections(dataSetVersionId, lastClosedCollectionTime.AddSeconds(1));

            foreach (var claimCollectionKey in closedFundingClaimCollections)
            {
                await SendClosedFundingClaimCollectionCommand(dataSetVersionId, claimCollectionKey, context);
            }
        }

        public async Task Handle(ClosedFundingClaimCollectionCommand message, IMessageHandlerContext context)
        {
            Guid dataSetVersionId = message.DatasetVersionId;
            string closedCollectionKey = message.ClaimTypePeriodKey;

            _logger.LogInformation(
                PerformanceManagementLoggingId.FundingClaimPollingPollClosedCollectionsCommandArrived,
                $"{nameof(ClosedFundingClaimCollectionCommand)} arrived for dataset version id {dataSetVersionId}," +
                $" collection key {closedCollectionKey}");

            int totalFundingClaimsForCollection = _fundingClaimDedsService.GetFundingClaimsThatAreCompletedCount(dataSetVersionId, closedCollectionKey);

            if (IsClaimCollectionValid(closedCollectionKey) && totalFundingClaimsForCollection > 0)
            {
                _fundingClaimCollectionImportInfoRepository.AddRowOrUpdate(new FundingClaimCollectionImportInfo(closedCollectionKey) {
                    TotalRowsToImport = totalFundingClaimsForCollection
                });

                _logger.LogVerbose(
                    PerformanceManagementLoggingId.FundingClaimPollingRetrievedCountForCollection,
                    $"Retrieved row count for dataset version id {dataSetVersionId}, collection key {closedCollectionKey}");

                await SendFundingClaimsPageRequestCommands(dataSetVersionId, closedCollectionKey, totalFundingClaimsForCollection, context);
            }
        }

        public async Task Handle(FundingClaimPagedRequestCommand message, IMessageHandlerContext context)
        {
            Guid datasetVersionId = message.DatasetVersionId;
            string closedCollectionKey = message.ClosedCollectionKey;
            int pageNumber = message.PageNumber;

            _logger.LogVerbose(
                PerformanceManagementLoggingId.FundingClaimPollingFundingClaimPageRequestCommandArrived,
                $"Funding Claims Import {nameof(FundingClaimPagedRequestCommand)} arrived for dataset version id {datasetVersionId}," +
                $" closed collection key {closedCollectionKey}, page {pageNumber}");

            List<string> fundingClaims = _fundingClaimDedsService
                .GetFundingClaimsThatAreCompleted(datasetVersionId, closedCollectionKey, _pageSize, pageNumber)
                .ToList();

            _logger.LogVerbose(
                PerformanceManagementLoggingId.FundingClaimPollingRetrievedFundingClaims,
                $"{fundingClaims.Count} funding claims retrieved for dataset version id {datasetVersionId}," +
                $" closedCollectionKey {closedCollectionKey}, page {pageNumber}");

            List<DataStore.Models.FundingClaim> dataStoreFundingClaims =
                fundingClaims
                    .Select(DeserializeCorporateSchemaFundingClaim)
                    .Select(ToFundingClaimWithValidAllocations)
                    .Select(FundingClaimTransformer.CorpSchemaFundingClaimToDataStoreFundingClaim)
                    .ToList();

            if (dataStoreFundingClaims.Any())
            {
                string period = dataStoreFundingClaims.First().Period;
                string claimTypeName = dataStoreFundingClaims.First().ClaimTypeName;

                _fundingClaimRepository.AddFundingClaims(dataStoreFundingClaims);

                FundingClaimCollectionImportInfo
                    collectionInfo = GetClaimCollectionImportInfoTable(closedCollectionKey);

                int numberOfRowsImported =
                    _fundingClaimRepository.GetCountOfFundingClaimsForCollection(period, claimTypeName);

                if (numberOfRowsImported <= collectionInfo.TotalRowsToImport)
                {
                    if (IsLastPage(collectionInfo, numberOfRowsImported))
                    {
                        collectionInfo.ImportCompletedDate = _date.GetCalculationDate();
                        _fundingClaimCollectionImportInfoRepository.AddRowOrUpdate(collectionInfo);

                        await context.Send(new ProcessFundingClaimsCommand(period, claimTypeName))
                            .ConfigureAwait(false);

                        _logger.LogInformation(
                            PerformanceManagementLoggingId.FundingClaimPollingLastPageStoredForCollection,
                            $"Last page of FundingClaims has been stored for dataset version id {datasetVersionId}," +
                            $" period: {period}, claimTypeName {claimTypeName}, pageNumber: {pageNumber}");
                    }
                }
                else
                {
                    _logger.LogError(PerformanceManagementLoggingId.TotalFundingClaimsExpectedIsLessThanRowsInTable,
                        $"The number of rows imported - {numberOfRowsImported}" +
                        $" is greater than the total expected {collectionInfo.TotalRowsToImport}");
                }
            }
        }

        private CorporateSchema.FundingClaim ToFundingClaimWithValidAllocations(CorporateSchema.FundingClaim fundingClaim)
        {
            _fundingClaimAllocationFilter.RemoveInvalidAllocations(fundingClaim);

            return fundingClaim;
        }

        private FundingClaimCollectionImportInfo GetClaimCollectionImportInfoTable(string periodClaimType)
        {
            FundingClaimCollectionImportInfo collectionImportInfo = _fundingClaimCollectionImportInfoRepository.Find(periodClaimType);
           
            return collectionImportInfo;
        }

        private async Task SendClosedFundingClaimCollectionCommand(Guid dataSetVersionId, string claimCollectionKey, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                PerformanceManagementLoggingId.ClosedFundingClaimCollectionRetrievedFromDeds,
                $"Closed collections retrieved from DEDS. Dataset version id {dataSetVersionId}, collection key {claimCollectionKey}");

            await context.Send(new ClosedFundingClaimCollectionCommand(dataSetVersionId, claimCollectionKey))
                .ConfigureAwait(false);
        }

        private async Task SendFundingClaimsPageRequestCommands(Guid dataSetVersionId, string closedCollectionKey, int totalFundingClaimsForCollection, IMessageHandlerContext context)
        {
            int numRowsRequested = 0;
            int pageNumber = 1;

            while (numRowsRequested < totalFundingClaimsForCollection)
            {
                await context.Send(new FundingClaimPagedRequestCommand(dataSetVersionId, closedCollectionKey, pageNumber++))
                    .ConfigureAwait(false);
                numRowsRequested += _pageSize;
            }
        }

        private bool IsLastPage(FundingClaimCollectionImportInfo collectionInfo, int numberOfRowsImported)
        {
            return collectionInfo.TotalRowsToImport == numberOfRowsImported;
        }

        private DateTime GetLastClosedCollectionTime()
        {
            return _fundingClaimCollectionImportInfoRepository.GetLastCompletedImportDate() 
                ?? DateTime.MinValue;
        }

        private bool IsClaimCollectionValid(string closedCollectionKey)
        {
            return _claimReconciliationBehaviourRepository.DoesClaimCollectionCodeExist(closedCollectionKey);
        }

        private CorporateSchema.FundingClaim DeserializeCorporateSchemaFundingClaim(string serializedFundingClaim)
        {
            return serializedFundingClaim.DeserializeXml<CorporateSchema.FundingClaim>();
        }
    }
}
