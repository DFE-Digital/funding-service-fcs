namespace SFA.FCT.Operations.Integrity.IntegrityCheckers
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Linq;
    using DTOs;
    using Framework.Logging.Interfaces;
    using MoreLinq;
    using Repositories;
    using Services;
    using Utils;
    using PaymentValueDifferenceItem = Entities.PaymentValueDifferenceItem;

    public class PaasToCrmDeliverablePaymentChecker : IIntegrityChecker
    {
        private readonly ICrmDeliverablePaymentRepository _crmDeliverablePaymentRepository;
        private readonly ILogger _logger;
        private readonly PaasDeliverablePaymentLazyRepository _paasDeliverablePaymentLazyRepository;
        private readonly IChangeTrackerService _changeTrackerService;
        private readonly long? _changeTrackingCurrentVersionOverride;

        public PaasToCrmDeliverablePaymentChecker(
            ICrmDeliverablePaymentRepository crmDeliverablePaymentRepository,
            ILogger logger,
            PaasDeliverablePaymentLazyRepository paasDeliverablePaymentLazyRepository,
            IChangeTrackerService changeTrackerService,
            long? changeTrackingCurrentVersionOverride)
        {
            _crmDeliverablePaymentRepository = crmDeliverablePaymentRepository;
            _logger = logger;
            _paasDeliverablePaymentLazyRepository = paasDeliverablePaymentLazyRepository;
            _changeTrackerService = changeTrackerService;
            _changeTrackingCurrentVersionOverride = changeTrackingCurrentVersionOverride;
        }

        public IntegrityCheckResult CheckValues()
        {
            try
            {
                var allPaymentValueDifferenceItems = new ConcurrentBag<List<PaymentValueDifferenceItem>>();

                // get set of deliverable payment pks that have changed
                _logger.LogInformation(IntegrityLoggingIds.CrmDeliverablePaymentDataAboutToGetChanges, "PaaS to CRM Deliverable Payment Integrity Check - about to get changes");
                ChangeTrackedDeliverablePayments deliverablePaymentChanges = _changeTrackerService.GetDeliverablePaymentChanges(_changeTrackingCurrentVersionOverride);
                _logger.LogInformation(IntegrityLoggingIds.CrmDeliverablePaymentDataGotChanges, $"PaaS to CRM Deliverable Payment Integrity Check - got changes: {deliverablePaymentChanges.DeliverablePaymentKeys.Count}");

                var fspsThatHaveChanged = deliverablePaymentChanges.DeliverablePaymentKeys.Select(k => k.Fsp).Distinct().ToList();
                
                _logger.LogInformation(IntegrityLoggingIds.GettingCrmDeliverablePaymentData, $"PaaS to CRM Deliverable Payment Integrity Check - fsps that have changed: {string.Join(",", fspsThatHaveChanged)}");
                var csvOfDifferences = string.Empty;
                int numOfRowsCheckedInPaas = 0;

                if (fspsThatHaveChanged.Any())
                {
                    _logger.LogInformation(IntegrityLoggingIds.GettingCrmDeliverablePaymentData, "PaaS to CRM Deliverable Payment Integrity Check - getting crm data");
                    var crmDeliverablePaymentRows = _crmDeliverablePaymentRepository.GetApprovedRowsByFsps(fspsThatHaveChanged);

                    _logger.LogInformation(IntegrityLoggingIds.GotCrmDeliverablePaymentData, $"PaaS to CRM Deliverable Payment Integrity Check - got crm data, num rows {crmDeliverablePaymentRows.Count}");

                    var crmDeliverablePaymentDictionary = crmDeliverablePaymentRows.GroupBy(r => r.Key)
                        .ToDictionary(grp => grp.Key, grp => grp.ToList());
                    _logger.LogInformation(IntegrityLoggingIds.CrmDeliverablePaymentDataDictionaryCreated, "PaaS to CRM Deliverable Payment Integrity Check - crm data dictionary created");

                    _logger.LogInformation(IntegrityLoggingIds.CrmDeliverablePaymentDataDictionaryCreated, "PaaS to CRM Deliverable Payment Integrity Check - getting Anita data for Fsps that have changed");
                    var deliverablePaymentsFromPaaSGroupedOnFsp =
                        _paasDeliverablePaymentLazyRepository
                            .GetDeliverablePaymentsForFsps(fspsThatHaveChanged)
                            .GroupBy(dp => dp.FundingStreamPeriodCode)
                            .ToDictionary(grp => grp.Key, grp => grp.ToList());

                    _logger.LogInformation(IntegrityLoggingIds.CrmDeliverablePaymentDataDictionaryCreated, "PaaS to CRM Deliverable Payment Integrity Check - got Anita data for Fsps that have changed");
                    
                    var dictionaryOfKeyChanges = deliverablePaymentChanges.DeliverablePaymentKeys.
                        ToDictionary(dpk => dpk.Key);

                    bool HasPaymentChanged(DeliverablePaymentWithFsp payment)
                    {
                        var paymentKey = $"{payment.AllocationNumber}_{payment.VersionNumber}_{payment.DeliverableCode}_{payment.YearPeriod}";

                        return dictionaryOfKeyChanges.ContainsKey(paymentKey);
                    }

                    const int numTasks = 2;
                    fspsThatHaveChanged.AsParallel()
                        .WithDegreeOfParallelism(numTasks).ForEach(fsp =>
                        {
                            List<PaymentValueDifferenceItem> paymentValueDifferenceItemsForFsp = new List<PaymentValueDifferenceItem>();

                            var sqlPaymentsForFsp = deliverablePaymentsFromPaaSGroupedOnFsp[fsp];
                            sqlPaymentsForFsp = sqlPaymentsForFsp.Where(HasPaymentChanged).ToList();

                            var processor = new DeliverablePaymentGroupToCrmChecker(sqlPaymentsForFsp,
                            crmDeliverablePaymentDictionary, _crmDeliverablePaymentRepository);

                            processor.Process(paymentValueDifferenceItemsForFsp);

                            allPaymentValueDifferenceItems.Add(paymentValueDifferenceItemsForFsp);

                            numOfRowsCheckedInPaas += sqlPaymentsForFsp.Count;
                        });

                    var listOfDifferences = allPaymentValueDifferenceItems.SelectMany(itemsForFsp => itemsForFsp).ToList();
                    
                    _logger.LogInformation(IntegrityLoggingIds.CrmDeliverablePaymentDataDictionaryCreated, $"PaaS to CRM Deliverable Payment Integrity Check - comparison done, issues: {listOfDifferences.Count}");
                    if (listOfDifferences.Any())
                    {
                        var csvWriter = new CsvWriter<PaymentValueDifferenceItem>();
                        csvOfDifferences = csvWriter.CreateCsv(listOfDifferences);
                    }
                }
                
                _logger.LogInformation(IntegrityLoggingIds.CheckerFinished,$"Finished PaaS to CRM Deliverable Payment Integrity Check, number of rows in PaaS {numOfRowsCheckedInPaas}");

                return new IntegrityCheckResult(csvOfDifferences != string.Empty, csvOfDifferences, changeTrackingCurrentVersion:deliverablePaymentChanges.CurrentVersion);
            }
            catch (AggregateException aggregateEx)
            {
                _logger.LogInformation(IntegrityLoggingIds.Error,
                    $"An Aggregate Exception occurred: {string.Join(Environment.NewLine, aggregateEx.InnerExceptions.Select(e => e.Message))}");
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogInformation(IntegrityLoggingIds.Error,
                    $"An Exception of type {ex.GetType().FullName} occurred: {ex.Message}");
                throw;
            }
        }
    }
}