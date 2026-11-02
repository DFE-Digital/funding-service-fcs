namespace SFA.FCT.Operations.Integrity.IntegrityCheckers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDeliveryDomain.Common.Storage;
    using AllocationDeliveryDomain.Endpoint.BusinessLogic.Validator;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Entities.Data;
    using DTOs;
    using Extensions;
    using Framework.Logging;
    using Framework.Logging.Interfaces;
    using global::AllocationDeliveryDomain.Endpoint.Services;
    using global::AllocationDeliveryDomain.Endpoint.BusinessLogic;
    using Repositories;
    using Services;
    using Utils;
    using SummarisedActualRepository = Repositories.SummarisedActualRepository;
    using ClosedCollectionRepository = Repositories.ClosedCollectionRepository;
    using System.Data.Common;
    using AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using global::AllocationDeliveryDomain.Endpoint.Repositories;

    public abstract class SummarisedActualsToDeliverablePaymentActualChecker<TDifferenceItem> : IIntegrityChecker
        where TDifferenceItem : SummarisedActualsToDeliverablePaymentActualChecker<TDifferenceItem>.DifferenceItem, new()
    {
        private readonly SummarisedActualRepository _summarisedActualRepository;
        private readonly ClosedCollectionRepository _closedCollectionRepository;
        private readonly ILogger _logger;
        private readonly IMonitoringDeliverablesRepository _monitoringDeliverablesRepository;
        private readonly IPaasFundingStreamPeriodRepository _fundingStreamPeriodRepository;
        private readonly DbConnection _connection;
        private readonly IAllocationsUnderTerminationQueryRepository _allocationsesUnderTerminationQueryRepository;
        private readonly IFundingStreamConfigurationStore _fundingStreamConfigurationStore;

        protected SummarisedActualsToDeliverablePaymentActualChecker(
            SummarisedActualRepository summarisedActualRepository, 
            ClosedCollectionRepository closedCollectionRepository,
            ILogger logger, IMonitoringDeliverablesRepository monitoringDeliverablesRepository,
            IPaasFundingStreamPeriodRepository fundingStreamPeriodRepository,
            DbConnection connection,
            IAllocationsUnderTerminationQueryRepository allocationsesUnderTerminationQueryRepository,
            IFundingStreamConfigurationStore fundingStreamConfigurationStore)
        {
            _summarisedActualRepository = summarisedActualRepository;
            _closedCollectionRepository = closedCollectionRepository;
            _logger = logger;
            _monitoringDeliverablesRepository = monitoringDeliverablesRepository;
            _fundingStreamPeriodRepository = fundingStreamPeriodRepository;
            _connection = connection;
            _allocationsesUnderTerminationQueryRepository = allocationsesUnderTerminationQueryRepository;
            _fundingStreamConfigurationStore = fundingStreamConfigurationStore;
        }

        protected abstract IEnumerable<string> CollectionTypesToValidate { get; }

        public IntegrityCheckResult CheckValues()
        {
            IReadOnlyCollection<TDifferenceItem> differenceItems =
                CollectionTypesToValidate
                    .Where(ct => _closedCollectionRepository.HasCollectionBeenPulledWithinDuration(ct, TimeSpan.FromHours(12)))
                    .SelectMany(GetDifferenceItemsForCollectionType)
                .ToList();

            return new IntegrityCheckResult(differenceItems.Any(), CreateCsv(differenceItems));
        }

        private IReadOnlyCollection<TDifferenceItem> GetDifferenceItemsForCollectionType(string collectionType)
        {
            _logger.LogInformation(1, $"SummarisedActualsToDeliverablePaymentActualChecker - collection type {collectionType}");
            var differenceItems = new List<TDifferenceItem>();

            var latestCollectionReturnCode = _closedCollectionRepository.GetLatestCollectionCodeForCollectionType(collectionType);

            if (latestCollectionReturnCode != null)
            {
                var lastCollectionClosedTime = _closedCollectionRepository.GetLastClosedTime(collectionType);

                var organisationActualsByOrganisation = 
                    GetActualsForCollectionReturnGroupedByOrganisation(collectionType, latestCollectionReturnCode);

                foreach (var organisationActuals in organisationActualsByOrganisation)
                {
                    if (AreAllDependentCollectionReturnsPresent(organisationActuals))
                    {
                        GetOrganisationalActualsForMultiCollectionFsps(organisationActuals);

                        EnrichReportedActuals(organisationActuals);
                        RemoveInvalidEnrichedActuals(organisationActuals, lastCollectionClosedTime);

                        if (organisationActuals.EnrichedReportedActuals.Any())
                        {
                            var allocationActuals = SplitOrganisationActualsByAllocation(organisationActuals);

                            IReadOnlyCollection<AllocationActualsPaas> checkableAllocationActuals =
                                allocationActuals
                                    .Where(AreActualsReceivedForFundingStreamPeriod)
                                    .ToList();

                            foreach (var allocation in checkableAllocationActuals)
                            {
                                if (!string.IsNullOrEmpty(allocation.AllocationNumber))
                                {
                                    var differences = GetDifferencesItemsForAllocation(allocation);
                                    differenceItems.AddRange(differences);
                                }
                                else
                                {
                                    differenceItems.Add(new TDifferenceItem
                                    {
                                        Key = allocation.Key.ToString(),
                                        AllocationNumber = allocation.AllocationNumber,
                                        VersionNumber = allocation.VersionNumber,
                                        ReportedActualValue = allocation.GetTotalActualValue(),
                                        ReportedActualVolume = allocation.GetTotalActualVolume(),
                                        Message = "Allocation exists in SummarisedActuals but not in PaaS"
                                    });
                                }
                            }
                        }
                    }
                }
            }

            return differenceItems;
        }

        protected abstract IReadOnlyCollection<TDifferenceItem> GetDifferencesItemsForAllocation(AllocationActualsPaas allocationActuals);

        private bool AreAllDependentCollectionReturnsPresent(OrganisationActualsPaas organisationActuals)
        {
            var fundingStreamPeriodCode = organisationActuals.Key.FundingStreamPeriodCode;
            var collectionType = organisationActuals.Key.CollectionType;
            var collectionReturnCode = organisationActuals.Key.CollectionReturnCode;

            var dependentCollectionReturns = GetDependentCollectionReturns(fundingStreamPeriodCode, collectionType, collectionReturnCode);

            return dependentCollectionReturns.All(IsCollectionReturnPresent);
        }

        private void GetOrganisationalActualsForMultiCollectionFsps(OrganisationActualsPaas organisationActuals)
        {
            var fundingStreamPeriodCode = organisationActuals.Key.FundingStreamPeriodCode;
            var collectionType = organisationActuals.Key.CollectionType;
            var collectionReturnCode = organisationActuals.Key.CollectionReturnCode;
            var organisationId = organisationActuals.Key.OrganisationId;
            var uopCode = organisationActuals.Key.UopCode;

            var dependentCollectionReturns = GetDependentCollectionReturns(fundingStreamPeriodCode, collectionType, collectionReturnCode);

            if (dependentCollectionReturns.Any())
            {
                var reportedActualsFromDependentCollectionReturns =
                    dependentCollectionReturns.SelectMany(cr => _summarisedActualRepository.GetSummarisedActuals(
                            new SummarisedActualOrgFspGroupKey(
                                cr.CollectionType,
                                cr.CollectionReturnCode,
                                organisationId,
                                fundingStreamPeriodCode,
                                uopCode)))
                        .Select(SummarisedActualTransformer.ToReportedActual)
                        .ToList();

                var newCombinedReportedActualsCollection = new List<ReportedActual>(organisationActuals.ReportedActuals);
                newCombinedReportedActualsCollection.AddRange(reportedActualsFromDependentCollectionReturns);

                organisationActuals.ReportedActuals = newCombinedReportedActualsCollection;
            }
        }

        private bool IsCollectionReturnPresent(CollectionReturn collectionReturn)
        {
            return _closedCollectionRepository.IsCollectionReturnPresent(collectionReturn.CollectionType, collectionReturn.CollectionReturnCode);
        }

        private IReadOnlyCollection<CollectionReturn> GetDependentCollectionReturns(
            string fundingStreamPeriodCode, string collectionType, string collectionReturnCode)
        {
            var heldCollectionConfigOption = _monitoringDeliverablesRepository.GetMultipleCollectionGroupId(
                    fundingStreamPeriodCode,
                    collectionType,
                    collectionReturnCode);

            return heldCollectionConfigOption.Match(
                Some: id => _monitoringDeliverablesRepository.GetCollectionReturns(id, collectionType,
                    collectionReturnCode),
                None: () => Enumerable.Empty<CollectionReturn>().ToList());
        }

        private static string CreateCsv(IReadOnlyCollection<TDifferenceItem> differenceItems)
        {
            return differenceItems.Any() ? new CsvWriter<TDifferenceItem>().CreateCsv(differenceItems) : null;
        }

        private void EnrichReportedActuals(OrganisationActualsPaas organisationActuals)
        {
            ILogger logger = new SimpleConsoleLogger();

            var enricher = new ActualEnricher(new OperationsMonitoringDeliverableStore(logger), logger);
            organisationActuals.EnrichedReportedActuals = (List<EnrichedReportedActual>) enricher.Enrich(
                organisationActuals.ReportedActuals,
                ConnectionInfo.CreateFrom(_connection));
        }

        private void RemoveInvalidEnrichedActuals(OrganisationActualsPaas organisationActuals, DateTime lastCollectionClosedTime)
        {
            var validator = new ActualValidator
            {
                Store = _fundingStreamConfigurationStore,
                Logger = new SimpleConsoleLogger(),
                Date = new DateProvider(lastCollectionClosedTime),
                AllocationsUnderTerminationQueryRepository = _allocationsesUnderTerminationQueryRepository
            };

            organisationActuals.EnrichedReportedActuals = validator.GetValidActuals(organisationActuals.EnrichedReportedActuals.ToList(), _connection.ToConnectionInfo());
        }

        private static IReadOnlyCollection<AllocationActualsPaas> SplitOrganisationActualsByAllocation(OrganisationActualsPaas organisationActuals)
        {
            return organisationActuals.EnrichedReportedActuals
                .GroupBy(era => era.ContractAllocationNumber)
                .Select(grp => new AllocationActualsPaas(
                    key: organisationActuals.Key,
                    contractNumber: grp.First().ContractNumber,
                    allocationNumber: grp.Key,
                    versionNumber: grp.First().ContractVersion,
                    enrichedReportedActuals: grp.ToList()))
                .ToList();
        }

        private bool AreActualsReceivedForFundingStreamPeriod(AllocationActualsPaas allocationActuals)
        {
            EnrichedReportedActual firstActual = allocationActuals.EnrichedReportedActuals.FirstOrDefault();

            if (firstActual != null)
            {
                var isPayOnInstruction = _fundingStreamPeriodRepository.IsFundingStreamPeriodPayOnInstruction(firstActual.FundingStreamPeriodCode);

                return !isPayOnInstruction;
            }

            throw new ArgumentException($"Could not retrieve Funding Stream Period configuration for allocation {allocationActuals.AllocationNumber}.");
        }

        private IReadOnlyCollection<OrganisationActualsPaas> GetActualsForCollectionReturnGroupedByOrganisation(string collectionType, string collectionReturnCode)
        {
            var groupKeys = _summarisedActualRepository.GetSummarisedActualOrgFspGroupKeys(collectionType, collectionReturnCode);

            var groupedReportedActuals = new List<OrganisationActualsPaas>();

            foreach (var key in groupKeys)
            {
                var summarisedActuals = _summarisedActualRepository.GetSummarisedActuals(key);

                var reportedActuals = summarisedActuals
                    .Select(SummarisedActualTransformer.ToReportedActual)
                    .ToList();

                groupedReportedActuals.Add(new OrganisationActualsPaas(key, reportedActuals));
            }

            return groupedReportedActuals;
        }

        public abstract class DifferenceItem
        {
            [Order(1)] // ordinals spaced to allow derived types to insert columns
            public string ContractNumber { get; set; }

            [Order(10)]
            public string AllocationNumber { get; set; }

            [Order(20)]
            public int VersionNumber { get; set; }

            [Order(30)]
            public decimal ReportedActualValue { get; set; }

            [Order(40)]
            public long ReportedActualVolume { get; set; }

            [Order(50)]
            public decimal PaasActualValue { get; set; }

            [Order(60)]
            public int PaasActualVolume { get; set; }

            [Order(70)]
            public string Message { get; set; }

            [Order(80)]
            public string Key { get; set; }
        }

        private class DateProvider : IDate
        {
            private readonly DateTime _date;

            public DateProvider(DateTime date)
            {
                _date = date;
            }

            public DateTime GetCalculationDate()
            {
                return _date;
            }

            public DateTime GetCalculationDateWithKey(string key)
            {
                return _date;
            }
        }
    }
}