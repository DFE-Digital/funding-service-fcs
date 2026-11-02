namespace SFA.FCT.Operations.Integrity.Services
{
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Microsoft.ApplicationInsights;
    using Storage;
    using System;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Text;
    using FCS.Worker.Common;
    using Framework.Logging.Interfaces;
    using Repositories;
    using Utils;
    using SFA.FCT.CrossDomain.Integration.Common.Slack;
    using Newtonsoft.Json;
    using System.Net.Http.Headers;
    using System.Net.Http;

    public class IntegrityCheckerRunner : IIntegrityCheckerRunner
    {
        private readonly IIntegrityChecker _integrityChecker;
        private readonly ICheckerDocumentStoreWriter _checkerDocumentStoreWriter;
        private readonly TelemetryClient _telemetryClient;
        private readonly ILogger _logger;
        private readonly IIntegrityCheckChangeTrackingRepository _integrityCheckChangeTrackingRepository;
        private readonly IFcsConfiguration _configuration;

        public IntegrityCheckerRunner(
            IIntegrityChecker integrityChecker,
            ICheckerDocumentStoreWriter checkerDocumentStoreWriter,
            TelemetryClient telemetryClient,
            ILogger logger,
            IIntegrityCheckChangeTrackingRepository integrityCheckChangeTrackingRepository,
            IFcsConfiguration configuration)
        {
            _integrityChecker = integrityChecker;
            _checkerDocumentStoreWriter = checkerDocumentStoreWriter;
            _telemetryClient = telemetryClient;
            _logger = logger;
            _integrityCheckChangeTrackingRepository = integrityCheckChangeTrackingRepository;
            _configuration = configuration;
        }

        public void Run(string checkName, DateTime runStartDate)
        {
            IntegrityCheck integrityCheck = CreateIntegrityCheckRow(checkName, runStartDate);

            try
            {

                ActionRetrier.RetryWhenExceptionThrown(action: () =>
                {
                    _logger.LogInformation(IntegrityLoggingIds.CheckerStarted, $"Starting {checkName}");

                    IntegrityCheckResult result = _integrityChecker.CheckValues();

                    integrityCheck.Status = IntegrityCheck.StatusOptions.Completed;
                    integrityCheck.FinishDate = DateTime.UtcNow;
                    integrityCheck.Outcome = result.FoundIssues ? IntegrityCheck.OutcomeOptions.Failed : IntegrityCheck.OutcomeOptions.Success;

                    if (!string.IsNullOrEmpty(result.IssuesCsv))
                    {
                        integrityCheck.Link = SaveResultToStorage(result.IssuesCsv, checkName, runStartDate);
                    }

                    if (result.IsChangeTrackingUsedAndNoIssues)
                    {
                        UpdateChangeTrackingCurrentVersion(checkName, result.ChangeTrackingCurrentVersion.Value);
                    }

                    UpdateIntegrityCheckRow(integrityCheck);

                    _logger.LogInformation(IntegrityLoggingIds.CheckerFinished, $"Finished {checkName}");
                    if (integrityCheck.Outcome == IntegrityCheck.OutcomeOptions.Failed)
                    {
                        _logger.LogInformation("Send Alert for Integrity - ", $"{integrityCheck.Outcome}");
                        SlackNotifier.SendMessage("[" + GetEnvironmentName() + "] : " + checkName + " Integrity check failed", _logger);
                        SendAlertOnhook(checkName);
                    }
                },
                numRetries: 3,
                numSecondsToWaitBetweenRetries: 10);
            }
            catch (Exception e)
            {
                string errorMsg = e.Message + Environment.NewLine + e.StackTrace;

                if (e is AggregateException)
                {
                    var firstEx = (e as AggregateException).InnerExceptions.FirstOrDefault();
                    errorMsg = $"{firstEx?.Message}{Environment.NewLine}{firstEx?.StackTrace}";
                }

                integrityCheck.FinishDate = DateTime.Now;
                integrityCheck.Status = IntegrityCheck.StatusOptions.Error;

                integrityCheck.Link = errorMsg.Substring(0, 250);
                UpdateIntegrityCheckRow(integrityCheck);

                _telemetryClient?.TrackException(e);
                _logger.LogError(IntegrityLoggingIds.Error, $"Error running {checkName}: {errorMsg}");
                //Send alert for failed messages

                _logger.LogInformation("Send Error Alert  for Integrity - ", $"{integrityCheck.Outcome}");
                // Notifier.SendMessage(checkName + " Integrity check failed", _logger);
                SendAlertOnhook(checkName);

            }
        }

        private string GetEnvironmentName()
        {
            string environmentName = "Dev";
            var webSiteName = Environment.GetEnvironmentVariable("WEBSITE_SITE_NAME");
            if (!string.IsNullOrEmpty(webSiteName))
            {
                // Split the string by "-"
                string[] parts = webSiteName.Split('-');

                // Get the desired part
                if (parts[2] != null)
                    environmentName = parts[2];
            }
            return environmentName.ToUpper();
        }

        private void SendAlertOnhook(string checkName)
        {
            var shouldSendTowebhook = _configuration["SlackError:ShouldSend"];
            _logger.LogInformation("shouldSendTowebhook -", $"check {shouldSendTowebhook}");

            using (var httpClient = new HttpClient())
            {
                httpClient.DefaultRequestHeaders.Accept.Add(
                    new MediaTypeWithQualityHeaderValue("application/json"));

                var ErrorWebhookUrl = _configuration["ErrorWebhook:Url"];
                _logger.LogInformation("ErrorWebhook URL : ", $" {ErrorWebhookUrl}");
                var jsonMessage = JsonConvert.SerializeObject(new SlackMessage("[" + GetEnvironmentName() + "] : " + checkName + ": Integrity check failed"));

                var stringContent = new StringContent(jsonMessage, Encoding.UTF8, "application/json");

                httpClient.PostAsync(ErrorWebhookUrl, stringContent).Wait();
            }
        }

        private string SaveResultToStorage(string issuesCsv, string checkName, DateTime runStartDate)
        {
            string filename = $"{runStartDate.ToString("yyyyMMdd_HHmmss")}_{checkName}_Results.csv";

            _checkerDocumentStoreWriter.WriteCheckerResult(Encoding.UTF8.GetBytes(issuesCsv), filename);

            return filename;
        }

        private IntegrityCheck CreateIntegrityCheckRow(string checkName, DateTime runStartDate)
        {
            IntegrityCheck integrityCheck;
            using (var connection = new SqlConnection(_configuration["ConnectionStrings:NServiceBus/Persistence"]))
            {
                IntegrityCheckRepository repository = new IntegrityCheckRepository(connection);

                integrityCheck = repository.Add(IntegrityCheck.CreateIntegrityCheck(checkName, IntegrityCheck.StatusOptions.Running, runStartDate));
            }

            return integrityCheck;
        }

        private void UpdateChangeTrackingCurrentVersion(string checkName, long currentVersion)
        {
            _integrityCheckChangeTrackingRepository.Update(checkName, currentVersion);
        }

        private void UpdateIntegrityCheckRow(IntegrityCheck integrityCheck)
        {
            using (var connection = new SqlConnection(_configuration["ConnectionStrings:NServiceBus/Persistence"]))
            {
                IntegrityCheckRepository repository = new IntegrityCheckRepository(connection);

                repository.Update(integrityCheck);
            }
        }
    }
}
