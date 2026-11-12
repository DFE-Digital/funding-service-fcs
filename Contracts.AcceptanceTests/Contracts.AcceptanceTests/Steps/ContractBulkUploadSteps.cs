namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System.IO;
    using System.Linq;
    using System.Threading;
    using NUnit.Framework;
    using Pages;
    using TechTalk.SpecFlow;
    using Utilities;
    using NUnit.Framework.Legacy;

    [Binding]
    public class ContractBulkUploadSteps
    {
        private const string SOURCE_FOLDER = @"DataFiles";

        private readonly ContractLoadPage _contractLoadStep;

        public ContractBulkUploadSteps(ContractLoadPage contractLoadPage)
        {
            _contractLoadStep = contractLoadPage;

            if (string.IsNullOrWhiteSpace(_contractLoadStep.UseAzureStorageBulkUpload))
            {
                var configuration = TestConfiguration.Configuration;
                _contractLoadStep.UseAzureStorageBulkUpload = configuration["AzureStorage:UseForBulkUpload"];
                _contractLoadStep.DropFolder = _contractLoadStep.UseAzureStorageBulkUpload == "true" ? configuration["BulkUpload:InputFolder"] : configuration["Office365BulkUpload:InputFolder"];
                _contractLoadStep.OutputFolder = _contractLoadStep.UseAzureStorageBulkUpload == "true" ? configuration["BulkUpload:OutputFolder"] : configuration["Office365BulkUpload:OutputFolder"];
            }
        }

        [AfterScenario("CreateOLASSContractAllocation", "CreateEOPContracts", "PerformAggregationBasedOnDeliverablePeriodValues", "BulkUploadNewWithTAR")]
        private void TestTeardown()
        {
            _contractLoadStep.DeleteContracts();
        }

        [Given(@"spreadsheet '(.*)' exists in the Datafiles folder and UKPRN '(.*)' is present in cell '(.*)' of the Contract tab")]
        [When(@"spreadsheet '(.*)' exists in the Datafiles folder and UKPRN '(.*)' is present in cell '(.*)' of the Contract tab")]
        public void GivenAnExcelSpreadsheetExistsForUKPRN(string fileName, string ukprn, string cellIdentfier)
        {
            _contractLoadStep.InputFilePath = Path.Combine(SOURCE_FOLDER, fileName);
            ClassicAssert.IsTrue(File.Exists(_contractLoadStep.InputFilePath), $"Input file not found in the Datafiles folder - {fileName}");

            string excelValue = ExcelHelper.GetCellValue(_contractLoadStep.InputFilePath, "Contract", cellIdentfier);
            ClassicAssert.AreEqual(ukprn, excelValue);

            _contractLoadStep.Ukprns.Add(ukprn);
        }

        [Given(@"an excel spreadsheet exists and has cell '(.*)' with a UKPRN '(.*)' and a file Name '(.*)'")]
        public void GivenAnExcelSpreadsheetExistsAndHasCellWithAUKPRNAndAFileName(string p0, string p1, string p2)
        {
            _contractLoadStep.InputFilePath = Path.Combine(SOURCE_FOLDER, p2);
            ClassicAssert.IsTrue(File.Exists(_contractLoadStep.InputFilePath), "Input file does not exist");

            string excelValue = ExcelHelper.GetCellValue(_contractLoadStep.InputFilePath, "Contract", p0);
            ClassicAssert.AreEqual(p1.ToString(), excelValue);

            _contractLoadStep.Ukprns.Add(p1.ToString());
        }

        [Given(@"an excel spreadsheet exists named '(.*)' with a UKPRN '(.*)'")]
        public void GivenAnExcelSpreadsheetExistsNamedWithAUkprn(string filename, int ukprn)
        {
            _contractLoadStep.InputFilePath = Directory.EnumerateFiles(SOURCE_FOLDER, filename).First();
            ClassicAssert.IsTrue(File.Exists(_contractLoadStep.InputFilePath), "Input file does not exist");

            string excelValue = ExcelHelper.GetCellValue(_contractLoadStep.InputFilePath, "Contract", "A2");
            ClassicAssert.AreEqual(ukprn.ToString(), excelValue);

            _contractLoadStep.Ukprns.Add(ukprn.ToString());
        }

        [Given(@"the Funding Type Code is '(.*)'")]
        public void GivenTheFundingTypeCodeIs(string p0)
        {
            string excelValue = ExcelHelper.GetCellValue(_contractLoadStep.InputFilePath, "Control Sheet", "A2");
            ClassicAssert.AreEqual(p0, excelValue);
        }

        [Given(@"the Period Type Code is '(.*)'")]
        public void GivenThePeriodTypeCodeIs(string p0)
        {
            string excelValue = ExcelHelper.GetCellValue(_contractLoadStep.InputFilePath, "Control Sheet", "B2");
            ClassicAssert.AreEqual(p0, excelValue);
        }

        [Given(@"the Period is '(.*)'")]
        public void GivenThePeriodIs(int p0)
        {
            string excelValue = ExcelHelper.GetCellValue(_contractLoadStep.InputFilePath, "Control Sheet", "C2");
            ClassicAssert.AreEqual(p0.ToString(), excelValue);
        }

        [Then(@"an error message is returned '(.*)'")]
        public void ThenAnErrorMessageIsReturned(string p0)
        {
            // this explicitly checks that the file exists, not necessarily that the contents have been written yet
            _contractLoadStep.WaitTillFileLevelErrorFileGenerated();

            // we should be checking for a certain file length or something, but for now hack a sleep here to give a chance for the file contents to be written
            Thread.Sleep(5000);

            ClassicAssert.IsTrue(_contractLoadStep.CheckFileLevelReport(p0), "Error Message not returned");
        }

        [Then(@"error message is returned '(.*)'")]
        public void ThenErrorMessageIsReturned(string p0)
        {
            _contractLoadStep.WaitTillFileLevelErrorFileGenerated();
            ClassicAssert.IsTrue(_contractLoadStep.CheckFileLevelReport(p0), "Error Message not returned");
        }

        [Then(@"the file is not processed")]
        public void ThenTheFileIsNotProcessed()
        {
            ClassicAssert.AreEqual(_contractLoadStep.GetCreatedEntities().Count, 0);
        }

        [When(@"the file is copied from the source location to the '(.*)'")]
        public void WhenTheFileIsCopiedFromTheSourceLocationToThe(string p0)
        {
            //_contractLoadStep.Initialize( _contractLoadStep.Ukprns);
            _contractLoadStep.CopyFile();
        }

        [When(@"the contract request service has finished processing")]
        public void WhenTheContractRequestServiceHasFinishedProcessing()
        {
            //_contractLoadStep.StartPolling(delegate { });
            //_contractLoadStep.WaitTillFileLoaded();
        }

        [Then(@"a pdf has been generated by Doc Gen in Azure in '(.*)'")]
        public void ThenAPdfHasBeenGeneratedByDocGenInAzureIn(string location)
        {
            _contractLoadStep.WaitTillPdfFileGeneratedInAzure(location);

            ClassicAssert.IsTrue(_contractLoadStep.IsPdfFileInStorage);
        }

        [Then(@"the Organisation in CRM has a UPIN associated with UKPRN '(.*)'")]
        public void ThenTheOrganisationInCRMHasAUPINAssociatedWithUKPRN(int ukprn)
        {
            string upinInCrm = _contractLoadStep.GetUpinForCrmOrganisationWithUkprn(ukprn.ToString());
            string upinInOrgService = _contractLoadStep.GetUpinForOrgServiceProviderWithUkprn(ukprn).ToString();

            if (string.IsNullOrEmpty(upinInCrm))
            {
                ClassicAssert.Fail($"No UPIN was found in CRM for Organisation with UKPRN {ukprn}");
            }
            if (string.IsNullOrEmpty(upinInOrgService))
            {
                ClassicAssert.Fail($"No UPIN was found in org service for provider with UKPRN {ukprn}");
            }

            ClassicAssert.AreEqual(upinInOrgService, upinInCrm,
                $"UPIN in CRM did not match expected UPIN from Org Service associated with UKPRN {ukprn}");
        }
    }
}