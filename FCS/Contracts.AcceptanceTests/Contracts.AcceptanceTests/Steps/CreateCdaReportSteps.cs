namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using CrossDomain.Integration.Messages.Commands;
    using CrossDomain.Integration.Messages.Dtos;
    using Infrastructure.Repositories;
    using Infrastructure.Repositories.CrmReplicaRepo;
    using Infrastructure.Services;
    using NUnit.Framework;
    using Pages;
    using TechTalk.SpecFlow;
    using Utilities;
    using Utilities.DTO;
    using System.Threading.Tasks;
    

    [Binding]
    public class CreateCdaReportSteps
    {
        private readonly CdaReportPageObject _cdaReportPageObject = new CdaReportPageObject();
        private string _generatedCdaReportFileName = string.Empty;

        public int DelayTime
        {
            get { return Convert.ToInt32(ConfigurationManager.AppSettings["DelayTime"]); }
        }

        [Given(@"[T|t]he following CDA report is run")]
        [When(@"[T|t]he following CDA report is run")]
        public void WhenTheFollowingCdaReportIsRun(Table table)
        {
            GenerateReportWithTheNewEndpoint(table);
        }

        [Given(@"a report named '(.*)' is created")]
        [Then(@"a report named '(.*)' is created")]
        public void ThenTheReportNamedIsCreated(string reportName)
        {
            _generatedCdaReportFileName = reportName;

            CheckResultPoller checkResultPoller = new CheckResultPoller(
                checkResult: () => _cdaReportPageObject.IsCdaCsvReportFileCreatedInDropLocation(reportName),
                maxNumChecks: 40,
                waitIntervalSeconds: 7);

            Assert.IsTrue(checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime(), "The report csv file {0} was not created", reportName);
        }

        [Given(@"there is no CDA report named '(.*)'")]
        public void GivenThereIsNoCdaReportNamed(string reportName)
        {
            string cdaBlobContainerName = $"fcs-report-{ConfigurationManager.AppSettings["StorageTableSuffix"].ToLower()}";
            AzureBlobStorageHelper.DeleteBlobIfExists(containerName: cdaBlobContainerName, fileName: reportName);

            SharepointDocumentRepository.DeleteFileIfExists(listName: ConfigurationManager.AppSettings["CdaReportListName"], fileName: reportName);
        }

        [Given(@"the following rows are present in the report")]
        [Then(@"the following rows are present in the report")]
        public void ThenTheFollingRowsArePresentInTheData(TransformedTable table)
        {
            string contractNumber = table.Rows.Select(r => r["ContractNumber"]).Distinct().Single();

            List<CdaReportComparisonObject> expectedReportResults = _cdaReportPageObject.GenerateCdaComparisonObjectsFromSpecflowTable(table)
                .Where(x => x.ContractNumber == contractNumber) 
                .OrderBy(x => x.MasterContractReference)
                .ThenBy(x => x.ContractNumber)
                .ThenBy(x => x.ContractAllocationNumber)
                .ThenBy(x => x.Deliverable)
                .ThenBy(x => x.DeliverableYear)
                .ThenBy(x => x.DeliverablePeriod)
                .ToList();

            //download report file to local folder
            var filePath = string.Concat(_cdaReportPageObject.CdaReportOutputFolder, _generatedCdaReportFileName);
            File.WriteAllBytes(filePath, _cdaReportPageObject.GetFile(_generatedCdaReportFileName));

            List<CdaReportComparisonObject> actualReportResults = _cdaReportPageObject.GenerateCdaComparisonObjectsFromCdaReportCsvFile(_generatedCdaReportFileName)
                .Where(x => x.ContractNumber == contractNumber) 
                .OrderBy(x => x.MasterContractReference)
                .ThenBy(x => x.ContractNumber)
                .ThenBy(x => x.ContractAllocationNumber)
                .ThenBy(x => x.Deliverable)
                .ThenBy(x => x.DeliverableYear)
                .ThenBy(x => x.DeliverablePeriod)
                .ToList();

            //_executionTimes = actualReportResults.Select(x => x.ExecutionTime).ToList();
            Dictionary<CdaReportComparisonObjectKey, CdaReportComparisonObject> actualResultsDictionary = actualReportResults.ToDictionary(r => r.GetKey());

            var expectedRowsNotInCda = expectedReportResults.Where(expected => !actualResultsDictionary.ContainsKey(expected.GetKey())).ToList();
            Assert.IsTrue(!expectedRowsNotInCda.Any(),
                $"These rows are not present - {string.Join(Environment.NewLine, expectedRowsNotInCda.Select(e => e.GetKey().ToString()))}");

            // now check that each of the property values is present
            expectedReportResults.ForEach(expected =>
            {
                CdaReportComparisonObject actual = actualResultsDictionary[expected.GetKey()];
                IReadOnlyCollection<string> mismatches = CdaReportComparisonObjectComparisonService.CompareObjects(expected, actual);
                Assert.IsTrue(!mismatches.Any(), string.Join(Environment.NewLine, mismatches));
            });
        }
        [Given(@"the following ADF Pipeline run")]
        public void GivenTheFollowingADFPipelineRun()
        {
            CallADFPipeline adfClient = new CallADFPipeline();
            adfClient.RunPipeline();
            //const int seconds = 180;
            Task.Delay(millisecondsDelay: DelayTime * 1000).Wait();
        }

        [Given(@"the following contracts are in the replicated CRM database")]
        [Then(@"the contracts are in the replicated CRM database as follows")]
        public void ThenTheContractsAreInTheReplicatedCRMDatabaseAsFollows(TransformedTable table)
        {
            CallADFPipeline adfClient = new CallADFPipeline();
            adfClient.RunPipeline();
           // const int seconds = 180;
            Task.Delay(millisecondsDelay: DelayTime * 1000).Wait();

            table.Rows.ToList().ForEach(r =>
            {
                var contractNumber = r["ContractNumber"];
                var versionNumber = int.Parse(r["ContractVersionNumber"]);
                var contractExists = false;

                var poller = new CheckResultPoller(() =>
                {
                    contractExists = CrmReplicatedRepository.ContractExists(contractNumber, versionNumber);

                    return contractExists;
                }, maxNumChecks: 60, waitIntervalSeconds: 7);

                poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                Assert.IsTrue(contractExists,
                    $"CRM Contract does not exist in the CRM replicated database. ContractNumber {contractNumber}, ContractVersionNumber {versionNumber}");
            });
        } 

        private static void GenerateReportWithTheNewEndpoint(Table table)
        {
            // Dirty wait. Caters for latent update to CDA data source (Replica CRM database)
            //CallADFPipeline c = new CallADFPipeline();
            //c.RunPipeline();
            //const int seconds = 180;
            //Task.Delay(millisecondsDelay: seconds * 1000).Wait();

            List<CreateReportFromCrmForGroupCommand> commands = table.Rows.SelectMany(r =>
            {
                string fspCodeCsv = r["FundingStreamPeriod"];

                IReadOnlyCollection<string> fspCodes = fspCodeCsv.Split(',').ToList();
                IReadOnlyCollection<CdaExtract> extracts = CdaExtractRepository.GetExtractsForFsp(fspCodes);

                return extracts.Select(extract =>
                {
                    var reportExtractGroup = new ReportExtractGroup
                    {
                        FspCodes = extract.CdaReportFundingStreamPeriods.Select(fsp => fsp.FundingStreamPeriodCode)
                            .ToList(),
                        Suffix = r["Suffix"]
                    };

                    return new CreateReportFromCrmForGroupCommand
                    {
                        ExtractGroups = new List<ReportExtractGroup> {reportExtractGroup},
                        IsLatest = r["Version"].Contains("Latest")
                    };
                });

            }).ToList();


            commands.ForEach(command =>
            {
                MessageSendingBus.Send("Operations.Cda.ReportGeneration", command);
            });
        }
    }
}