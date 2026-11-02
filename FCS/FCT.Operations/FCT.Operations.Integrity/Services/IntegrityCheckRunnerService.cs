namespace SFA.FCT.Operations.Integrity.Services
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Threading.Tasks;
    using AllocationDeliveryDomain.Common.DataStore;
    using CrossDomain.Integration.Messages.Commands;
    using Exceptions;
    using FCS.Worker.Common;
    using Framework.Logging.Interfaces;
    using IntegrityCheckers;
    using Microsoft.ApplicationInsights;
    using MoreLinq;
    using Repositories;
    using Storage;
    using ClosedCollectionRepository = Repositories.ClosedCollectionRepository;

    public class IntegrityCheckRunnerService : IIntegrityCheckRunnerService
    {
        private readonly IDictionary<string, IIntegrityCheckerRunner> _integrityCheckerRunners = new Dictionary<string, IIntegrityCheckerRunner>();
        private readonly ICheckerDocumentStoreWriter _checkerDocumentStoreWriter;
        private readonly TelemetryClient _telemetryClient;
        private readonly ILogger _logger;
        private readonly IFcsConfiguration _configurationRoot;

        public IntegrityCheckRunnerService(ICheckerDocumentStoreWriter checkerDocumentStoreWriter, TelemetryClient telemetryClient, ILogger logger, IFcsConfiguration configurationRoot)
        {
            _checkerDocumentStoreWriter = checkerDocumentStoreWriter;
            _telemetryClient = telemetryClient;
            _logger = logger;
            _configurationRoot = configurationRoot;
        }
        
        private void CreateIntegrityCheckers(long? changeTrackingCurrentVersionOverride)
        {
            SubnominalAggregationChecker.ClearCache();
            SqlConnection GetReplicatConnection() => new SqlConnection(_configurationRoot["ConnectionStrings:MonitoringDeliverablesDbContext"]);
            var paasDeliverablePaymentLazyRepository = new PaasDeliverablePaymentLazyRepository(GetReplicatConnection(), _logger);
            var paasSubnominalAggregationRepository = new PaasSubnominalAggregationRepository(GetReplicatConnection());
            var integrityCheckChangeTrackingRepository = new IntegrityCheckChangeTrackingRepository(_configurationRoot);

            _integrityCheckerRunners.Add(
                "ALLOC_LEVEL_ACTUALS_SUMACTUAL_TO_DELIVPAYT_ACTUALS",
                new IntegrityCheckerRunner(
                    new AllocationLevelSummarisedActualsToDeliverablePaymentActualChecker(
                        paasDeliverablePaymentLazyRepository,
                        new ActualAuditRepository(GetReplicatConnection()),
                        new SummarisedActualRepository(_configurationRoot),
                        new ClosedCollectionRepository(_configurationRoot),
                        _logger,
                        new MonitoringDeliverablesRepository(GetReplicatConnection()),
                        new PaasFundingStreamPeriodRepository(GetReplicatConnection()),
                        GetReplicatConnection(),
                        new OperationsAllocationsUnderTerminationQueryRepository(GetReplicatConnection()),
                        new PaasFundingStreamPeriodRepository(GetReplicatConnection())),
                    _checkerDocumentStoreWriter,
                    _telemetryClient,
                    _logger,
                    integrityCheckChangeTrackingRepository,
                    _configurationRoot));

            _integrityCheckerRunners.Add(
                "ANITA_PAAS_EXTRACT",
                new IntegrityCheckerRunner(new AnitaPaasExtract(paasDeliverablePaymentLazyRepository), _checkerDocumentStoreWriter, _telemetryClient, _logger, integrityCheckChangeTrackingRepository,
                    _configurationRoot));

            _integrityCheckerRunners.Add(
                "CRM_TO_PAAS_CHECK_SUBNOMINAL_AGGREGATION",
                new IntegrityCheckerRunner(
                    new CrmToPaasSubnominalAggregationChecker(paasSubnominalAggregationRepository, new PaasFundingStreamPeriodRepository(GetReplicatConnection()), _configurationRoot), 
                    _checkerDocumentStoreWriter,
                    _telemetryClient,
                    _logger,
                    integrityCheckChangeTrackingRepository,
                    _configurationRoot));

            _integrityCheckerRunners.Add(
                ChangeTrackerService.PaasToCrmDeliverablePayment,
                new IntegrityCheckerRunner(
                    new PaasToCrmDeliverablePaymentChecker(
                        new CrmDeliverablePaymentRepository(_configurationRoot),
                        _logger,
                        paasDeliverablePaymentLazyRepository,
                        new ChangeTrackerService(new IntegrityCheckChangeTrackingRepository(_configurationRoot), _logger, _configurationRoot),
                        changeTrackingCurrentVersionOverride),
                    _checkerDocumentStoreWriter,
                    _telemetryClient,
                    _logger,
                    integrityCheckChangeTrackingRepository,
                    _configurationRoot));

            _integrityCheckerRunners.Add(
                "PAAS_TO_CRM_CHECK_DELIVERABLE_PAYMENT_FULL",
                new IntegrityCheckerRunner(
                    new PaasToCrmDeliverablePaymentFullChecker(new CrmDeliverablePaymentRepository(_configurationRoot), _logger, paasDeliverablePaymentLazyRepository, new PaasFundingStreamPeriodRepository(GetReplicatConnection())),
                    _checkerDocumentStoreWriter,
                    _telemetryClient,
                    _logger,
                    integrityCheckChangeTrackingRepository,
                    _configurationRoot));

            _integrityCheckerRunners.Add(
                "PAAS_TO_CRM_CHECK_SUBNOMINAL_AGGREGATION",
                new IntegrityCheckerRunner(
                    new PaasToCrmSubnominalAggregationChecker(paasSubnominalAggregationRepository, new PaasFundingStreamPeriodRepository(GetReplicatConnection()), _configurationRoot),
                    _checkerDocumentStoreWriter,
                    _telemetryClient,
                    _logger,
                    integrityCheckChangeTrackingRepository,
                    _configurationRoot));

            _integrityCheckerRunners.Add(
                "PAYCALC_VS_PAYGEN_CHECK",
                new IntegrityCheckerRunner(
                    new PayCalcVsPayGenChecker(paasDeliverablePaymentLazyRepository, paasSubnominalAggregationRepository, new PaasFundingStreamPeriodRepository(GetReplicatConnection())), 
                    _checkerDocumentStoreWriter,
                    _telemetryClient,
                    _logger,
                    integrityCheckChangeTrackingRepository,
                    _configurationRoot));

            _integrityCheckerRunners.Add(
                "PAYMENT_INSTRUCTIONS_SUMACTUAL_TO_DELIV_PAYMENTS",
                new IntegrityCheckerRunner(
                    new ReportedPaymentInstructionSummarisedActualsToDeliverablePaymentChecker(
                        paasDeliverablePaymentLazyRepository,
                        new ReportedPaymentEnricher(new AllocationDeliverablePeriodRepository(GetReplicatConnection())),
                        new SummarisedActualRepository(_configurationRoot), 
                        new ClosedCollectionRepository(_configurationRoot),
                        new PaasFundingStreamPeriodRepository(GetReplicatConnection())),
                    _checkerDocumentStoreWriter,
                    _telemetryClient,
                    _logger,
                    integrityCheckChangeTrackingRepository,
                    _configurationRoot));

            _integrityCheckerRunners.Add(
                "PAYMENT_INSTRUCTIONS_SUMACTUAL_TO_DELIV_PAYMENTS_FORCE",
                new IntegrityCheckerRunner(
                    new ReportedPaymentInstructionSummarisedActualsToDeliverablePaymentChecker(
                        paasDeliverablePaymentLazyRepository,
                        new ReportedPaymentEnricher(new AllocationDeliverablePeriodRepository(GetReplicatConnection())),
                        new SummarisedActualRepository(_configurationRoot),
                        new ClosedCollectionRepository(_configurationRoot), 
                        new PaasFundingStreamPeriodRepository(GetReplicatConnection()),
                        forceCheck: true),
                    _checkerDocumentStoreWriter,
                    _telemetryClient,
                    _logger,
                    integrityCheckChangeTrackingRepository,
                    _configurationRoot));


            _integrityCheckerRunners.Add(
                "PERIOD_LEVEL_ACTUALS_SUMACTUAL_TO_DELIVPAYT_ACTUAL",
                new IntegrityCheckerRunner(
                    new PeriodLevelSummarisedActualsToDeliverablePaymentActualChecker(
                        new MonitoringDeliverablesDbContext(),
                        paasDeliverablePaymentLazyRepository, 
                        new SummarisedActualRepository(_configurationRoot), 
                        new ClosedCollectionRepository(_configurationRoot),
                        _logger,
                        new MonitoringDeliverablesRepository(GetReplicatConnection())),
                    _checkerDocumentStoreWriter,
                    _telemetryClient,
                    _logger,
                    integrityCheckChangeTrackingRepository,
                    _configurationRoot));

            _integrityCheckerRunners.Add(
                "DELIVERABLE_PAYMENT_POSITIVE_CAP_CHECKER",
                new IntegrityCheckerRunner(new DeliverablePaymentPositiveCapChecker(paasDeliverablePaymentLazyRepository),
                _checkerDocumentStoreWriter,
                _telemetryClient,
                _logger,
                integrityCheckChangeTrackingRepository,
                _configurationRoot));
        }

        public void RunChecks(InitiateCheckersCommand initiateCheckersCommand)
        {
            CreateIntegrityCheckers(initiateCheckersCommand.ChangeTrackingCurrentVersionOverride);

            try
            {
                DateTime runStartDate = DateTime.Now;

                initiateCheckersCommand.ChecksToRun.ForEach(ctr =>
                {
                    _logger.LogInformation(IntegrityLoggingIds.StartInitiateCheckersCommand, "Calling - " + ctr);
                    if (!_integrityCheckerRunners.ContainsKey(ctr))
                    {
                        string errorMessage = $"Incorrect name passed in {ctr}";
                        _logger.LogError(IntegrityLoggingIds.Error, errorMessage);
                        throw new InvalidIntegrityCheckException(errorMessage);
                    }
                });

                List<string> checksToRun = initiateCheckersCommand.ChecksToRun.ToList();
                StartChecksAsync(checksToRun, runStartDate);
            }
            catch (Exception e)
            {
                _logger.LogError(IntegrityLoggingIds.Error, "RunChecks failed - " + e.Message + Environment.NewLine + e.StackTrace);
            }
        }

        private async Task StartChecksAsync(IList<string> checksToRun, DateTime runStartDate)
        {
            Task singleTask = null;
            try
            {
                var tasks = checksToRun.Select(
                    ctr =>
                        Task.Factory.StartNew(() => { _integrityCheckerRunners[ctr].Run(ctr, runStartDate); },
                            TaskCreationOptions.LongRunning)).ToArray();

                singleTask = Task.WhenAll(tasks);
                await singleTask;
            }
            catch
            {
                _logger.LogError(IntegrityLoggingIds.Error, "StartChecksAsync failed");
                AggregateException ae = singleTask?.Exception;
                ae?.InnerExceptions.ForEach(ie => _telemetryClient?.TrackException(ie));
                ae?.InnerExceptions.ForEach(ie =>
                {
                    _logger.LogError(IntegrityLoggingIds.Error, "StartChecksAsync: " + ie.Message + Environment.NewLine + ie.StackTrace + Environment.NewLine + ie.InnerException?.Message);
                });
            }
        }
    }
}
