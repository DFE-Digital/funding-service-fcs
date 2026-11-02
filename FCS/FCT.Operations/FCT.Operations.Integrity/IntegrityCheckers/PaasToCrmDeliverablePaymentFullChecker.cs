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

    public class PaasToCrmDeliverablePaymentFullChecker : IIntegrityChecker
    {
        private readonly ICrmDeliverablePaymentRepository _crmDeliverablePaymentRepository;
        private readonly ILogger _logger;
        private readonly PaasDeliverablePaymentLazyRepository _paasDeliverablePaymentLazyRepository;
        private readonly PaasFundingStreamPeriodRepository _paasFundingStreamPeriodRepository;

        public PaasToCrmDeliverablePaymentFullChecker(
            ICrmDeliverablePaymentRepository crmDeliverablePaymentRepository,
            ILogger logger,
            PaasDeliverablePaymentLazyRepository paasDeliverablePaymentLazyRepository,
            PaasFundingStreamPeriodRepository paasFundingStreamPeriodRepository)
        {
            _crmDeliverablePaymentRepository = crmDeliverablePaymentRepository;
            _logger = logger;
            _paasDeliverablePaymentLazyRepository = paasDeliverablePaymentLazyRepository;
            _paasFundingStreamPeriodRepository = paasFundingStreamPeriodRepository;
        }

        public IntegrityCheckResult CheckValues()
        {
            try
            {
                var allPaymentValueDifferenceItems = new ConcurrentBag<List<PaymentValueDifferenceItem>>();

                var activeFsps =
                    _paasFundingStreamPeriodRepository.GetFundingStreamPeriodCodesThatAreActive(DateTime.UtcNow);

                _logger.LogInformation(IntegrityLoggingIds.GettingCrmDeliverablePaymentData, "PaaS to CRM Deliverable Payment Integrity Full Check - getting crm data");
                var crmDeliverablePaymentRows = _crmDeliverablePaymentRepository.GetApprovedRowsByFsps(activeFsps);

                _logger.LogInformation(IntegrityLoggingIds.GotCrmDeliverablePaymentData, $"PaaS to CRM Deliverable Payment Integrity Full Check - got crm data, num rows {crmDeliverablePaymentRows.Count}");
                
                var crmDeliverablePaymentDictionary = crmDeliverablePaymentRows.GroupBy(r => r.Key)
                    .ToDictionary(grp => grp.Key, grp => grp.ToList());
                _logger.LogInformation(IntegrityLoggingIds.CrmDeliverablePaymentDataDictionaryCreated, "PaaS to CRM Deliverable Payment Integrity Full Check - crm data dictionary created");

                // make sure the Anita Extract is executed before we enter the parallel loop
                GetDeliverablePayments(activeFsps.First());

                int numPaas = 0;
                const int numTasks = 2;
                activeFsps.AsParallel()
                    .WithDegreeOfParallelism(numTasks).ForEach(fsp =>
                {
                    List<PaymentValueDifferenceItem> paymentValueDifferenceItemsForFsp = new List<PaymentValueDifferenceItem>();

                    var sqlPayments = GetDeliverablePayments(fsp);

                    var processor = new DeliverablePaymentGroupToCrmChecker(sqlPayments,
                        crmDeliverablePaymentDictionary, _crmDeliverablePaymentRepository);

                    processor.Process(paymentValueDifferenceItemsForFsp);

                    allPaymentValueDifferenceItems.Add(paymentValueDifferenceItemsForFsp);

                    numPaas += sqlPayments.Count;
                });
                
                var listOfDifferences = allPaymentValueDifferenceItems.SelectMany(itemsForFsp => itemsForFsp).ToList();
                var csvOfDifferences = string.Empty;
                _logger.LogInformation(IntegrityLoggingIds.CrmDeliverablePaymentDataDictionaryCreated, $"PaaS to CRM Deliverable Payment Integrity Full Check - comparison done, issues: {listOfDifferences.Count}");
                if (listOfDifferences.Any())
                {
                    var csvWriter = new CsvWriter<PaymentValueDifferenceItem>();
                    csvOfDifferences = csvWriter.CreateCsv(listOfDifferences);
                }

                _logger.LogInformation(IntegrityLoggingIds.CheckerFinished,$"Finished PaaS to CRM Deliverable Payment Integrity Full Check number of rows in PaaS {numPaas}");

                return new IntegrityCheckResult(csvOfDifferences != string.Empty, csvOfDifferences);
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

        private IReadOnlyCollection<DeliverablePaymentWithFsp> GetDeliverablePayments(string fspCode)
        {
            return _paasDeliverablePaymentLazyRepository.GetDeliverablePaymentsForFsp(fspCode);
        }
    }
}